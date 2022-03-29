import Foundation
import SwiftSyntax
import LibAriel
import FileSystem

let arguments = Arguments.parseOrExit()

func printVerbose(_ msg: String) {
  if arguments.verbose {
    print(msg)
  }
}

// MARK: - Input

struct Input {

  enum Kind {
    case singleFile
    case directory
  }

  let kind: Kind
  let path: Path
}

let input: Input = {
  let path = Path(string: arguments.inputPath)

  let stat: Stat
  switch fileSystem.stat(path: path) {
  case .value(let s):
    stat = s
  case .enoent:
    printErrorAndExit("No such file or directory: \(path)")
  case .error(errno: let err):
    let msg = String(errno: err) ?? "Unknown error"
    printErrorAndExit("\(msg): \(path)")
  }

  switch stat.type {
  case .regularFile:
    printVerbose("Input: single file: \(path)")
    return Input(kind: .singleFile, path: path)
  case .directory:
    printVerbose("Input: directory: \(path)")
    return Input(kind: .directory, path: path)
  default:
    print("Input path should be a file or a directory, not a \(stat.type).")
    exit(1)
  }
}()

// MARK: - Output

let outputEncoding = String.Encoding.utf8

let output: Output = {
  guard let outputPathArg = arguments.outputPath else {
    printVerbose("No output path specified, using stdout.")
    return FileOutput.stdout
  }

  let outputPath = Path(string: outputPathArg)

  let ext = fileSystem.extname(path: outputPath)
  let isFile = !ext.isEmpty

  if isFile {
    printVerbose("Output file specified: \(outputPath)")
    return FileOutput(path: outputPath, encoding: outputEncoding)
  }

  printVerbose("Output directory specified: \(outputPath)")
  let inputName = fileSystem.basenameWithoutExt(path: input.path)
  let outputName = fileSystem.addExt(filename: inputName, ext: ".swift")
  let path = fileSystem.join(path: outputPath, element: outputName)
  return FileOutput(path: path, encoding: outputEncoding)
}()

defer { output.close() }

// MARK: - Main

func writeDeclarations(printedPath: String, swiftFilePath: Path) throws {
  printVerbose("Processing: \(printedPath)")

  let fileContent = try String(contentsOfFile: swiftFilePath.string)
  let ast = try SyntaxParser.parse(source: fileContent)

  let astVisitor = ASTVisitor()
  astVisitor.walk(ast)

  let topLevel = astVisitor.topLevelDeclarations
  writer.write(printedPath: printedPath, declarations: topLevel)
}

let formatter = Formatter(newLineAfterAttribute: true,
                          maxInitializerLength: 100)

let filter = Filter(minAccessModifier: arguments.minAccessLevel)
let writer = Writer(filter: filter, formatter: formatter, output: output)

switch input.kind {
case .singleFile:
  let p = input.path
  try writeDeclarations(printedPath: p.string, swiftFilePath: p)

case .directory:
  let dir = input.path

  var entries: ReaddirRec
  switch fileSystem.readdirRec(path: dir) {
  case let .value(e):
    entries = e
  case let .unableToStat(path, errno: e):
    let msg = String(errno: e) ?? "Unable to stat"
    printErrorAndExit("\(msg): \(path)")
  case let .unableToListContents(path, errno: e):
    let msg = String(errno: e) ?? "Unable to list contents of"
    printErrorAndExit("\(msg): \(path)")
  }

  entries.sort(by: \.relativePath)

  for entry in entries {
    let type = entry.stat.type
    let ext = fileSystem.extname(filename: entry.name)
    let isSwiftFile = type == .regularFile && ext == ".swift"

    if isSwiftFile {
      let relativePath = entry.relativePath
      let path = fileSystem.join(path: dir, element: relativePath)
      try writeDeclarations(printedPath: relativePath.string, swiftFilePath: path)
    }
  }
}
