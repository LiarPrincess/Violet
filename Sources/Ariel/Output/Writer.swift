import Foundation

/// Walk the declarations -> filter -> format -> write to output.
class Writer {

  private let filter: Filter
  private let formatter: Formatter
  private let output: Output
  private var indent = ""

  init(filter: Filter, formatter: Formatter, output: Output) {
    self.filter = filter
    self.formatter = formatter
    self.output = output
  }

  func write(file: ListDirRec.Element, topLevelScope: DeclarationScope) {
    assert(self.indent.isEmpty, "Indent from previous file?")

    self.filter.walk(scope: topLevelScope)

    let isAnyDeclarationAccepted = topLevelScope.all.contains {
      self.filter.isAccepted(declaration: $0)
    }

    guard isAnyDeclarationAccepted else {
      return
    }

    let filename = file.relativePath
    let separator = String(repeating: "=", count: filename.count + 4 + 4)
    self.print(separator)
    self.print("=== \(filename) ===")
    self.print(separator)
    self.print()

    self.write(scope: topLevelScope)
  }

  private func write(scope: DeclarationScope) {
    func _write(_ declarations: [Declaration]) {
      if declarations.hasAny {
        for node in declarations {
          self.write(declaration: node)
        }

        self.print()
      }
    }

    _write(scope.variables)

    _write(scope.typealiases)
    _write(scope.enumerations)
    _write(scope.structures)
    _write(scope.classes)
    _write(scope.protocols)
    _write(scope.extensions)
    _write(scope.associatedTypes)

    _write(scope.initializers)
    _write(scope.subscripts)
    _write(scope.functions)
    _write(scope.operators)
  }

  private func write(declaration: Declaration) {
    let isAccepted = self.filter.isAccepted(declaration: declaration)
    guard isAccepted else {
      return
    }

    let string = self.formatter.format(declaration)
    self.printIndented(string)

    if let scopedDeclaration = declaration as? DeclarationWithScope {
      let indentBefore = self.indent
      self.indent = indentBefore + "  "
      self.write(scope: scopedDeclaration.childScope)
      self.indent = indentBefore
    }
  }

  private func print(_ string: String = "") {
    self.output.write(string)
  }

  private func printIndented(_ string: String) {
    let fixedString = string.replacingOccurrences(of: "\n", with: "\n" + self.indent)
    self.output.write(self.indent + fixedString)
  }
}
