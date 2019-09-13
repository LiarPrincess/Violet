import Foundation
import Core

extension CodeObjectBuilder {

  /// Append a `loadConst(True)` instruction to this code object.
  public func appendTrue(at location: SourceLocation) throws {
    if let index = self.cachedIndices.true {
      try self.appendExistingConstant(index: index, at: location)
    } else {
      let index = try self.appendNewConstant(.true, at: location)
      self.cachedIndices.true = index
    }
  }

  /// Append a `loadConst(False)` instruction to this code object.
  public func appendFalse(at location: SourceLocation) throws {
    if let index = self.cachedIndices.false {
      try self.appendExistingConstant(index: index, at: location)
    } else {
      let index = try self.appendNewConstant(.false, at: location)
      self.cachedIndices.false = index
    }
  }

  /// Append a `loadConst(None)` instruction to this code object.
  public func appendNone(at location: SourceLocation) throws {
    if let index = self.cachedIndices.none {
      try self.appendExistingConstant(index: index, at: location)
    } else {
      let index = try self.appendNewConstant(.none, at: location)
      self.cachedIndices.none = index
    }
  }

  /// Append a `loadConst(Ellipsis)` instruction to this code object.
  public func appendEllipsis(at location: SourceLocation) throws {
    if let index = self.cachedIndices.ellipsis {
      try self.appendExistingConstant(index: index, at: location)
    } else {
      let index = try self.appendNewConstant(.ellipsis, at: location)
      self.cachedIndices.ellipsis = index
    }
  }

  /// Append a `loadConst(Integer)` instruction to this code object.
  public func appendInteger(_ value: BigInt, at location: SourceLocation) throws {
    if value.isZero {
      if let index = self.cachedIndices.zero {
        try self.appendExistingConstant(index: index, at: location)
      } else {
        let index = try self.appendNewConstant(.integer(value), at: location)
        self.cachedIndices.zero = index
      }
    } else if value.isOne {
      if let index = self.cachedIndices.one {
        try self.appendExistingConstant(index: index, at: location)
      } else {
        let index = try self.appendNewConstant(.integer(value), at: location)
        self.cachedIndices.one = index
      }
    } else {
      _ = try self.appendNewConstant(.integer(value), at: location)
    }
  }

  /// Append a `loadConst(Float)` instruction to this code object.
  public func appendFloat(_ value: Double, at location: SourceLocation) throws {
    _ = try self.appendNewConstant(.float(value), at: location)
  }

  /// Append a `loadConst(Complex)` instruction to this code object.
  public func appendComplex(real: Double,
                            imag: Double,
                            at location: SourceLocation) throws {
    _ = try self.appendNewConstant(.complex(real: real, imag: imag), at: location)
  }

  /// Append a `loadConst(String)` instruction to this code object.
  public func appendString<S: ConstantString>(_ value: S,
                                              at location: SourceLocation) throws {

    let s = value.constant

    if let index = self.cachedIndices.strings[s] {
      try self.appendExistingConstant(index: index, at: location)
    } else {
      let index = try self.appendNewConstant(.string(s), at: location)
      self.cachedIndices.strings[s] = index
    }
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendBytes(_ value: Data, at location: SourceLocation) throws {
    _ = try self.appendNewConstant(.bytes(value), at: location)
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendTuple(_ value: [Constant], at location: SourceLocation) throws {
    _ = try self.appendNewConstant(.tuple(value), at: location)
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendCode(_ value: CodeObject, at location: SourceLocation) throws {
    _ = try self.appendNewConstant(.code(value), at: location)
  }

  // MARK: - Helpers

  private func appendNewConstant(_ constant: Constant,
                                 at location: SourceLocation) throws -> Int {
    let index = self.codeObject.constants.endIndex
    self.codeObject.constants.append(constant)

    try self.appendExistingConstant(index: index, at: location)
    return index
  }

  private func appendExistingConstant(index: Int,
                                      at location: SourceLocation) throws {
    let arg = try self.appendExtendedArgIfNeeded(index, at: location)
    try self.append(.loadConst(index: arg), at: location)
  }
}
