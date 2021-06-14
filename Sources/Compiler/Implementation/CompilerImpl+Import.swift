import Foundation
import BigInt
import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Python -> compile.c

// cSpell:ignore asname

extension CompilerImpl {

  // MARK: - Import

  /// compiler_import(struct compiler *c, stmt_ty s)
  ///
  /// `dis.dis('import a.b')` gives us:
  /// ```c
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (None)
  ///  4 IMPORT_NAME              0 (a.b)
  ///  6 STORE_NAME               1 (a)
  ///  8 LOAD_CONST               1 (None)
  /// 10 RETURN_VALUE
  /// ```
  internal func visit(_ node: ImportStmt) throws {
    for alias in node.names {
      self.setAppendLocation(alias)

      // The Import node stores a module name like a.b.c as a single string.
      self.builder.appendInteger(BigInt(0))
      self.builder.appendNone()
      self.builder.appendImportName(name: alias.name)

      if let asName = alias.asName {
        try self.emitImportAs(name: alias.name, asName: asName)
      } else {
        var name = alias.name
        if let dotIndex = alias.name.firstIndex(of: ".") {
          name = String(alias.name.prefix(upTo: dotIndex))
        }

        self.builder.appendStoreName(name)
      }
    }
  }

  // MARK: - Import from star

  /// compiler_from_import(struct compiler *c, stmt_ty s)
  ///
  /// from Tangled import *
  /// additional_block <-- so that we don't get returns at the end
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('*',))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_STAR
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  internal func visit(_ node: ImportFromStarStmt) throws {
    try self.checkLateFuture(module: node.moduleName, location: node.start)
    try self.appendImportFromProlog(module: node.moduleName,
                                    names: ["*"],
                                    level: node.level)

    self.builder.appendImportStar()
  }

  // MARK: - Import from

  /// compiler_from_import(struct compiler *c, stmt_ty s)
  ///
  /// from Tangled import Rapunzel
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('Rapunzel',))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_FROM              1 (Rapunzel)
  ///  8 STORE_NAME               1 (Rapunzel)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  internal func visit(_ node: ImportFromStmt) throws {
    try self.checkLateFuture(module: node.moduleName, location: node.start)
    try self.appendImportFromProlog(module: node.moduleName,
                                    names: node.names.map { $0.name },
                                    level: node.level)

    for alias in node.names {
      if alias.name == "*" {
        throw self.error(.unexpectedStarImport)
      }

      let storeName = alias.asName ?? alias.name
      self.setAppendLocation(alias)
      self.builder.appendImportFrom(name: alias.name)
      self.builder.appendStoreName(storeName)
    }

    self.builder.appendPopTop()
  }

  /// Common code for 'visitImportFromStar' and 'visitImportFrom'
  private func appendImportFromProlog(module: String?,
                                      names: [String],
                                      level: UInt8) throws {
    let importName = module ?? ""
    let nameTuple = names.map { CodeObject.Constant.string($0) }

    self.builder.appendInteger(BigInt(level))
    self.builder.appendTuple(nameTuple)
    self.builder.appendImportName(name: importName)
  }

  private func checkLateFuture(module: String?, location: SourceLocation) throws {
    let futureModule = SpecialIdentifiers.__future__
    if module == futureModule && location.line > self.future.lastLine {
      throw self.error(.lateFuture)
    }
  }

  /// compiler_import_as(struct compiler *c, identifier name, identifier asname)
  private func emitImportAs(name: String, asName: String) throws {
    // The IMPORT_NAME opcode was already generated.
    // This function merely needs to bind the result to a name.

    // If there is a dot in name, we need to split it and emit a
    // IMPORT_FROM for each name.

    let slices = name.split(separator: ".")

    let hasAttributes = slices.count > 1
    guard hasAttributes else {
      // for example: import elsa as queen
      self.builder.appendStoreName(asName)
      return
    }

    // for example: import frozen.elsa as queen ('elsa' is an attribute)
    let attributes = slices[1...]
    for (index, attr) in attributes.enumerated() {
      self.builder.appendImportFrom(name: String(attr))

      let isLast = index == attributes.count - 1
      if !isLast {
        self.builder.appendRotTwo()
        self.builder.appendPopTop()
      }
    }

    // final store using 'asName'
    self.builder.appendStoreName(asName)
    self.builder.appendPopTop()
  }
}
