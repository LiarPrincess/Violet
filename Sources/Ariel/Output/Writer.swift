import Foundation
import FileSystem

/// Walk the declarations -> filter -> format -> write to output.
class Writer {

  private let filter: Filter
  private let formatter: Formatter
  private var output: Output
  private var indent = ""
  /// Avoid printing multiple empty lines in a row. It is ugly.
  private var wasLastPrintedLineEmpty = false

  init(filter: Filter, formatter: Formatter, output: Output) {
    self.filter = filter
    self.formatter = formatter
    self.output = output
  }

  func write(printedPath: String, declarations: [Declaration]) {
    assert(self.indent.isEmpty, "Indent from previous file?")

    self.filter.walk(nodes: declarations)

    guard self.isAnyAccepted(declarations: declarations) else {
      return
    }

    let separator = String(repeating: "=", count: printedPath.count + 4 + 4)
    self.print(separator)
    self.print("=== \(printedPath) ===")
    self.print(separator)
    self.print()

    self.write(declarations: declarations)
    self.print()
  }

  private func isAnyAccepted(declarations: [Declaration]) -> Bool {
    return declarations.any
      && declarations.contains(where: self.filter.isAccepted(_:))
  }

  private func write(declarations: [Declaration]) {
    for d in declarations {
      let isAccepted = self.filter.isAccepted(d)
      guard isAccepted else {
        continue
      }

      let string = self.formatter.format(d)
      self.printIndented(string)

      if let withChildren = d as? DeclarationWithScope {
        let children = withChildren.children

        if self.isAnyAccepted(declarations: children) {
          let indentBefore = self.indent
          self.indent = indentBefore + "  "
          self.write(declarations: children)
          self.indent = indentBefore
        }
      }
    }
  }

  private func print(_ string: String = "") {
    let isEmpty = string.isEmpty
    defer { self.wasLastPrintedLineEmpty = isEmpty }

    let hasMultipleEmptyInARow = self.wasLastPrintedLineEmpty && isEmpty
    if !hasMultipleEmptyInARow {
      self.output.write(string + "\n")
    }
  }

  private func printIndented(_ string: String) {
    let indent = self.indent

    let isEmpty = indent.isEmpty && string.isEmpty
    defer { self.wasLastPrintedLineEmpty = isEmpty }

    let hasMultipleEmptyInARow = self.wasLastPrintedLineEmpty && isEmpty
    if !hasMultipleEmptyInARow {
      let fixedString = string.replacingOccurrences(of: "\n", with: "\n" + indent)
      self.output.write(indent + fixedString + "\n")
    }
  }
}
