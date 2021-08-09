import SwiftSyntax
import Foundation
import FileSystem

// 'internal', so it is available in the whole module.
internal let fileSystem = FileSystem.default

private let arguments = Arguments.parseOrExit()

private func printVerbose(_ msg: String) {
  if arguments.verbose {
    print(msg)
  }
}

// MARK: - Input

private struct Input {

  fileprivate enum Kind {
    case singleFile
    case directory
  }

  fileprivate let kind: Kind
  fileprivate let path: Path
}

private let input: Input = {
  let path = Path(string: arguments.inputPath)
  let stat = fileSystem.statOrTrap(path: path)

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

private let output: Output = {
  guard let outputPathArg = arguments.outputPath else {
    printVerbose("No output path specified, using stdout.")
    return ConsoleOutput()
  }

  let outputPath = Path(string: outputPathArg)

  let ext = fileSystem.extname(path: outputPath)
  let isFile = !ext.isEmpty

  if isFile {
    printVerbose("Output file specified: \(outputPath)")
    return FileOutput(path: outputPath)
  }

  printVerbose("Output directory specified: \(outputPath)")
  let inputName = fileSystem.basenameWithoutExtension(path: input.path)
  let outputName = fileSystem.addExt(filename: inputName, ext: ".txt")
  let path = fileSystem.join(path: outputPath, element: outputName)
  return FileOutput(path: path)
}()

defer { output.flush() }

// MARK: - Main

private func writeDeclarations(printedPath: String, swiftFilePath: Path) throws {
  printVerbose("Processing: \(printedPath)")

  let fileContent = try String(contentsOfFile: swiftFilePath.string)
  let ast = try SyntaxParser.parse(source: fileContent)

  let astVisitor = ASTVisitor()
  astVisitor.walk(ast)

  let topLevelScope = astVisitor.topLevelScope
  writer.write(printedPath: printedPath, topLevelScope: topLevelScope)
}

let filter = Filter(minAccessModifier: arguments.minAccessLevel)
let formatter = Formatter(maxInitializerLength: 100)
let writer = Writer(filter: filter, formatter: formatter, output: output)

switch input.kind {
case .singleFile:
  let p = input.path
  try writeDeclarations(printedPath: p.string, swiftFilePath: p)

case .directory:
  let dir = input.path

  var entries = fileSystem.readdirRecOrTrap(path: dir)
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
