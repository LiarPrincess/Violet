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
      try self.codeObject.emitInteger(BigInt(0), location: location)
      try self.codeObject.emitNone(location: location)
      try self.codeObject.emitImportName(name: alias.name, location: location)

      if let asName = alias.asName {
        try self.emitImportAs(name: alias.name,
                              asName: asName,
                              location: location)
      } else {
        var name = alias.name
        if let dotIndex = alias.name.firstIndex(of: ".") {
          name = String(alias.name.prefix(upTo: dotIndex))
        }

        try self.codeObject.emitStoreName(name, location: location)
      }
    }
  }

  /// compiler_from_import(struct compiler *c, stmt_ty s)
  internal func visitImportFrom(module:   String?,
                                aliases:  NonEmptyArray<Alias>,
                                level:    UInt8,
                                location: SourceLocation) throws {

    let futureModule = SpecialIdentifiers.__future__
    if module == futureModule && location.line > self.future.lastLine {
      throw self.error(.lateFuture, location: location)
    }

    try self.codeObject.emitInteger(BigInt(level), location: location)

    let nameTuple = aliases.map { Constant.string($0.name) }
    try self.codeObject.emitTuple(nameTuple, location: location)

    let importName = module ?? ""
    try self.codeObject.emitImportName(name: importName, location: location)

    if aliases.count == 1 && aliases[0].name == "*" {
      try self.codeObject.emitImportStar(location: location)
    } else {
      for alias in aliases {
        if alias.name == "*" {
          throw self.error(.unexpectedStarImport, location: location)
        }

        let storeName = alias.asName ?? alias.name
        try self.codeObject.emitImportFrom(name: alias.name, location: location)
        try self.codeObject.emitStoreName(storeName, location: location)
      }
    }

    // Remove imported module
    try self.codeObject.emitPopTop(location: location)
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
      try self.codeObject.emitStoreName(asName, location: location)
      return
    }

    // for example: import frozen.elsa as queen ('elsa' is an attribute)
    let attributes = slices[1...]
    for (index, attr) in attributes.enumerated() {
      try self.codeObject.emitImportFrom(name: String(attr), location: location)

      let isLast = index == attributes.count - 1
      if !isLast {
        try self.codeObject.emitRotTwo(location: location)
        try self.codeObject.emitPopTop(location: location)
      }
    }

    // final store using 'asName'
    try self.codeObject.emitStoreName(asName, location: location)
    try self.codeObject.emitPopTop(location: location)
  }
}
