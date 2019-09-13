import Foundation
import Core
import Parser
import Bytecode

// In CPython:
// Python -> compile.c

extension Compiler {

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
  internal func visitImport(aliases: NonEmptyArray<Alias>) throws {
    for alias in aliases {
      self.setAppendLocation(alias)

      // The Import node stores a module name like a.b.c as a single string.
      try self.builder.appendInteger(BigInt(0))
      try self.builder.appendNone()
      try self.builder.appendImportName(name: alias.name)

      if let asName = alias.asName {
        try self.emitImportAs(name: alias.name, asName: asName)
      } else {
        var name = alias.name
        if let dotIndex = alias.name.firstIndex(of: ".") {
          name = String(alias.name.prefix(upTo: dotIndex))
        }

        try self.builder.appendStoreName(name)
      }
    }
  }

  /// compiler_from_import(struct compiler *c, stmt_ty s)
  ///
  /// from Tangled import *
  /// additional_block <-- so that we don't get returns at the end
  ///
  ///  0 LOAD_CONST               0 (0)
  ///  2 LOAD_CONST               1 (('*',))
  ///  4 IMPORT_NAME              0 (Tangled)
  ///  6 IMPORT_STAR
  ///  8 LOAD_NAME                1 (additional_block)
  /// 10 POP_TOP
  /// 12 LOAD_CONST               2 (None)
  /// 14 RETURN_VALUE
  internal func visitImportFromStar(module: String?,
                                    level: UInt8,
                                    location: SourceLocation) throws {
    try self.checkLateFuture(module: module, location: location)
    try self.appendImportFromProlog(module: module, names: ["*"], level: level)
    try self.builder.appendImportStar()
    try self.builder.appendPopTop()
  }

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
  internal func visitImportFrom(module:  String?,
                                aliases: NonEmptyArray<Alias>,
                                level:   UInt8,
                                location: SourceLocation) throws {

    try self.checkLateFuture(module: module, location: location)
    try self.appendImportFromProlog(module: module,
                                    names: aliases.map { $0.name },
                                    level: level)

    for alias in aliases {
      if alias.name == "*" {
        throw self.error(.unexpectedStarImport)
      }

      let storeName = alias.asName ?? alias.name
      self.setAppendLocation(alias)
      try self.builder.appendImportFrom(name: alias.name)
      try self.builder.appendStoreName(storeName)
    }

    try self.builder.appendPopTop()
  }

  /// Common code for 'visitImportFromStar' and 'visitImportFrom'
  private func appendImportFromProlog(module: String?,
                                      names: [String],
                                      level: UInt8) throws {
    let importName = module ?? ""
    let nameTuple = names.map { Constant.string($0) }

    try self.builder.appendInteger(BigInt(level))
    try self.builder.appendTuple(nameTuple)
    try self.builder.appendImportName(name: importName)
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
      try self.builder.appendStoreName(asName)
      return
    }

    // for example: import frozen.elsa as queen ('elsa' is an attribute)
    let attributes = slices[1...]
    for (index, attr) in attributes.enumerated() {
      try self.builder.appendImportFrom(name: String(attr))

      let isLast = index == attributes.count - 1
      if !isLast {
        try self.builder.appendRotTwo()
        try self.builder.appendPopTop()
      }
    }

    // final store using 'asName'
    try self.builder.appendStoreName(asName)
    try self.builder.appendPopTop()
  }
}
