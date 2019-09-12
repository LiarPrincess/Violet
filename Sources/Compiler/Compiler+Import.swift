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
  internal func visitImport(aliases:  NonEmptyArray<Alias>,
                            location: SourceLocation) throws {
    // The Import node stores a module name like a.b.c as a single string.

    for alias in aliases {
      try self.codeObject.appendInteger(BigInt(0), at: location)
      try self.codeObject.appendNone(at: location)
      try self.codeObject.appendImportName(name: alias.name, at: location)

      if let asName = alias.asName {
        try self.emitImportAs(name: alias.name,
                              asName: asName,
                              location: location)
      } else {
        var name = alias.name
        if let dotIndex = alias.name.firstIndex(of: ".") {
          name = String(alias.name.prefix(upTo: dotIndex))
        }

        try self.codeObject.appendStoreName(name, at: location)
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
  internal func visitImportFromStar(module:   String?,
                                    level:    UInt8,
                                    location: SourceLocation) throws {

    try self.checkLateFuture(module: module, location: location)
    try self.appendImportFromProlog(module: module,
                                    names: ["*"],
                                    level: level,
                                    location: location)
    try self.codeObject.appendImportStar(at: location)
    try self.codeObject.appendPopTop(at: location)
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
  internal func visitImportFrom(module:   String?,
                                aliases:  NonEmptyArray<Alias>,
                                level:    UInt8,
                                location: SourceLocation) throws {

    try self.checkLateFuture(module: module, location: location)
    try self.appendImportFromProlog(module: module,
                                    names: aliases.map { $0.name },
                                    level: level,
                                    location: location)

    for alias in aliases {
      if alias.name == "*" {
        throw self.error(.unexpectedStarImport, location: location)
      }

      let storeName = alias.asName ?? alias.name
      try self.codeObject.appendImportFrom(name: alias.name, at: location)
      try self.codeObject.appendStoreName(storeName, at: location)
    }

    try self.codeObject.appendPopTop(at: location)
  }

  /// Common code for 'visitImportFromStar' and 'visitImportFrom'
  private func appendImportFromProlog(module: String?,
                                      names:  [String],
                                      level:  UInt8,
                                      location: SourceLocation) throws {
    let importName = module ?? ""
    let nameTuple = names.map { Constant.string($0) }

    try self.codeObject.appendInteger(BigInt(level), at: location)
    try self.codeObject.appendTuple(nameTuple, at: location)
    try self.codeObject.appendImportName(name: importName, at: location)
  }

  private func checkLateFuture(module: String?, location: SourceLocation) throws {
    let futureModule = SpecialIdentifiers.__future__
    if module == futureModule && location.line > self.future.lastLine {
      throw self.error(.lateFuture, location: location)
    }
  }

  /// compiler_import_as(struct compiler *c, identifier name, identifier asname)
  private func emitImportAs(name:     String,
                            asName:   String,
                            location: SourceLocation) throws {
    // The IMPORT_NAME opcode was already generated.
    // This function merely needs to bind the result to a name.

    // If there is a dot in name, we need to split it and emit a
    // IMPORT_FROM for each name.

    let slices = name.split(separator: ".")

    let hasAttributes = slices.count > 1
    guard hasAttributes else {
      // for example: import elsa as queen
      try self.codeObject.appendStoreName(asName, at: location)
      return
    }

    // for example: import frozen.elsa as queen ('elsa' is an attribute)
    let attributes = slices[1...]
    for (index, attr) in attributes.enumerated() {
      try self.codeObject.appendImportFrom(name: String(attr), at: location)

      let isLast = index == attributes.count - 1
      if !isLast {
        try self.codeObject.appendRotTwo(at: location)
        try self.codeObject.appendPopTop(at: location)
      }
    }

    // final store using 'asName'
    try self.codeObject.appendStoreName(asName, at: location)
    try self.codeObject.appendPopTop(at: location)
  }
}
