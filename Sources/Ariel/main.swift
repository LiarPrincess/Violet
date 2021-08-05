import SwiftSyntax
import Foundation

private let minAccessModifier = AccessModifiers.Value.public
private let maxInitializerLength = 100

private func writeModuleInterface(moduleDirectory: ListDir.Element) throws {
  var entries = try ListDirRec(path: moduleDirectory.absolutePath)
  entries.sort(by: \.relativePath)

  let filter = DeclarationFilter(minAccessModifier: minAccessModifier)
  let formatter = Formatter(maxInitializerLength: maxInitializerLength)
  let output: Output = ConsoleOutput()
  defer { output.flush() }

  let writer = Writer(filter: filter, formatter: formatter, output: output)

  for entry in entries {
    guard entry.stat.isFile && entry.name.hasSuffix(".swift") else {
      continue
    }

    print("Processing:", entry.relativePath)

    let fileUrl = URL(fileURLWithPath: entry.absolutePath, isDirectory: false)
    let fileContent = try String(contentsOf: fileUrl)
    let ast = try SyntaxParser.parse(source: fileContent)

    let astVisitor = ASTVisitor()
    astVisitor.walk(ast)

    let topLevelScope = astVisitor.topLevelScope
    writer.write(file: entry, topLevelScope: topLevelScope)
  }
}

let sourcesDirPath = "..."
let sourcesDirContent = try ListDir(path: sourcesDirPath)

for entry in sourcesDirContent {
  if entry.name == ".DS_Store" {
    continue
  }

  let stat = Stat(existingFilePath: entry.absolutePath)
  if stat.isDirectory {
    try writeModuleInterface(moduleDirectory: entry)
  }
}

print("Finished")
