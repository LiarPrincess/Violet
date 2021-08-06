import SwiftSyntax
import Foundation
import FileSystem

private let minAccessModifier = AccessModifier.public
private let maxInitializerLength = 100

private let fileSystem = FileSystem.default

private func writeModuleInterface(moduleDirectory: Path) throws {
  var entries = fileSystem.readdirRecOrTrap(path: moduleDirectory)
  entries.sort(by: \.relativePath)

  let filter = Filter(minAccessModifier: minAccessModifier)
  let formatter = Formatter(maxInitializerLength: maxInitializerLength)
  let output: Output = ConsoleOutput()
  defer { output.flush() }

  let writer = Writer(filter: filter, formatter: formatter, output: output)

  for entry in entries {
    let filename = entry.name
    let relativePath = entry.relativePath

    let isFile = entry.stat.type == .regularFile
    let isSwiftFile = isFile && filename.hasSuffix(".swift")
    guard isSwiftFile else {
      continue
    }

    print("Processing:", relativePath)

    let path = fileSystem.join(path: moduleDirectory, element: relativePath)
    let fileUrl = URL(path: path, isDirectory: false)
    let fileContent = try String(contentsOf: fileUrl)
    let ast = try SyntaxParser.parse(source: fileContent)

    let astVisitor = ASTVisitor()
    astVisitor.walk(ast)

    let topLevelScope = astVisitor.topLevelScope
    writer.write(filename: filename, topLevelScope: topLevelScope)
  }
}

let sourcesDirPath = Path(string: "/Users/michal/Documents/Xcode/Violet/Sources")
let sourcesDirContent = fileSystem.readdirOrTrap(path: sourcesDirPath)

for filename in sourcesDirContent {
  if filename == ".DS_Store" {
    continue
  }

  let path = fileSystem.join(path: sourcesDirPath, element: filename)
  let stat = fileSystem.statOrTrap(path: path)
  if stat.type == .directory {
    try writeModuleInterface(moduleDirectory: path)
  }
}

print("Finished")
