import Foundation
import Core

extension CodeObjectBuilder {

  /// Append a `loadConst(True)` instruction to this code object.
  public func appendTrue() throws {
    if let index = self.cachedIndices.true {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.true)
      self.cachedIndices.true = index
    }
  }

  /// Append a `loadConst(False)` instruction to this code object.
  public func appendFalse() throws {
    if let index = self.cachedIndices.false {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.false)
      self.cachedIndices.false = index
    }
  }

  /// Append a `loadConst(None)` instruction to this code object.
  public func appendNone() throws {
    if let index = self.cachedIndices.none {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.none)
      self.cachedIndices.none = index
    }
  }

  /// Append a `loadConst(Ellipsis)` instruction to this code object.
  public func appendEllipsis() throws {
    if let index = self.cachedIndices.ellipsis {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.ellipsis)
      self.cachedIndices.ellipsis = index
    }
  }

  /// Append a `loadConst(Integer)` instruction to this code object.
  public func appendInteger(_ value: BigInt) throws {
    if value.isZero {
      if let index = self.cachedIndices.zero {
        try self.appendExistingConstant(index: index)
      } else {
        let index = try self.appendNewConstant(.integer(value))
        self.cachedIndices.zero = index
      }
    } else if value.isOne {
      if let index = self.cachedIndices.one {
        try self.appendExistingConstant(index: index)
      } else {
        let index = try self.appendNewConstant(.integer(value))
        self.cachedIndices.one = index
      }
    } else {
      _ = try self.appendNewConstant(.integer(value))
    }
  }

  /// Append a `loadConst(Float)` instruction to this code object.
  public func appendFloat(_ value: Double) throws {
    _ = try self.appendNewConstant(.float(value))
  }

  /// Append a `loadConst(Complex)` instruction to this code object.
  public func appendComplex(real: Double, imag: Double) throws {
    _ = try self.appendNewConstant(.complex(real: real, imag: imag))
  }

  /// Append a `loadConst(String)` instruction to this code object.
  public func appendString<S: ConstantString>(_ value: S) throws {

    let s = value.constant

    if let index = self.cachedIndices.strings[s] {
      try self.appendExistingConstant(index: index)
    } else {
      let index = try self.appendNewConstant(.string(s))
      self.cachedIndices.strings[s] = index
    }
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendBytes(_ value: Data) throws {
    _ = try self.appendNewConstant(.bytes(value))
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendTuple(_ value: [Constant]) throws {
    _ = try self.appendNewConstant(.tuple(value))
  }

  /// Append a `loadConst` instruction to this code object.
  public func appendCode(_ value: CodeObject) throws {
    _ = try self.appendNewConstant(.code(value))
  }

  // MARK: - Helpers

  private func appendNewConstant(_ constant: Constant) throws -> Int {
    let index = self.codeObject.constants.endIndex
    self.codeObject.constants.append(constant)

    try self.appendExistingConstant(index: index)
    return index
  }

  private func appendExistingConstant(index: Int) throws {
    let arg = try self.appendExtendedArgIfNeeded(index)
    try self.append(.loadConst(index: arg))
  }
}
