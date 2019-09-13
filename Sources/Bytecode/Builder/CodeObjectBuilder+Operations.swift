import Core

extension CodeObjectBuilder {

  // MARK: - Unary

  /// Append an `unaryPositive` instruction to this code object.
  public func appendUnaryPositive() throws {
    try self.append(.unaryPositive)
  }

  /// Append an `unaryNegative` instruction to this code object.
  public func appendUnaryNegative() throws {
    try self.append(.unaryNegative)
  }

  /// Append an `unaryNot` instruction to this code object.
  public func appendUnaryNot() throws {
    try self.append(.unaryNot)
  }

  /// Append an `unaryInvert` instruction to this code object.
  public func appendUnaryInvert() throws {
    try self.append(.unaryInvert)
  }

  // MARK: - Binary

  /// Append a `binaryPower` instruction to this code object.
  public func appendBinaryPower() throws {
    try self.append(.binaryPower)
  }

  /// Append a `binaryMultiply` instruction to this code object.
  public func appendBinaryMultiply() throws {
    try self.append(.binaryMultiply)
  }

  /// Append a `binaryMatrixMultiply` instruction to this code object.
  public func appendBinaryMatrixMultiply() throws {
    try self.append(.binaryMatrixMultiply)
  }

  /// Append a `binaryFloorDivide` instruction to this code object.
  public func appendBinaryFloorDivide() throws {
    try self.append(.binaryFloorDivide)
  }

  /// Append a `binaryTrueDivide` instruction to this code object.
  public func appendBinaryTrueDivide() throws {
    try self.append(.binaryTrueDivide)
  }

  /// Append a `binaryModulo` instruction to this code object.
  public func appendBinaryModulo() throws {
    try self.append(.binaryModulo)
  }

  /// Append a `binaryAdd` instruction to this code object.
  public func appendBinaryAdd() throws {
    try self.append(.binaryAdd)
  }

  /// Append a `binarySubtract` instruction to this code object.
  public func appendBinarySubtract() throws {
    try self.append(.binarySubtract)
  }

  /// Append a `binaryLShift` instruction to this code object.
  public func appendBinaryLShift() throws {
    try self.append(.binaryLShift)
  }

  /// Append a `binaryRShift` instruction to this code object.
  public func appendBinaryRShift() throws {
    try self.append(.binaryRShift)
  }

  /// Append a `binaryAnd` instruction to this code object.
  public func appendBinaryAnd() throws {
    try self.append(.binaryAnd)
  }

  /// Append a `binaryXor` instruction to this code object.
  public func appendBinaryXor() throws {
    try self.append(.binaryXor)
  }

  /// Append a `binaryOr` instruction to this code object.
  public func appendBinaryOr() throws {
    try self.append(.binaryOr)
  }

  // MARK: - In-place

  /// Append an `inplacePower` instruction to this code object.
  public func appendInplacePower() throws {
    try self.append(.inplacePower)
  }

  /// Append an `inplaceMultiply` instruction to this code object.
  public func appendInplaceMultiply() throws {
    try self.append(.inplaceMultiply)
  }

  /// Append an `inplaceMatrixMultiply` instruction to this code object.
  public func appendInplaceMatrixMultiply() throws {
    try self.append(.inplaceMatrixMultiply)
  }

  /// Append an `inplaceFloorDivide` instruction to this code object.
  public func appendInplaceFloorDivide() throws {
    try self.append(.inplaceFloorDivide)
  }

  /// Append an `inplaceTrueDivide` instruction to this code object.
  public func appendInplaceTrueDivide() throws {
    try self.append(.inplaceTrueDivide)
  }

  /// Append an `inplaceModulo` instruction to this code object.
  public func appendInplaceModulo() throws {
    try self.append(.inplaceModulo)
  }

  /// Append an `inplaceAdd` instruction to this code object.
  public func appendInplaceAdd() throws {
    try self.append(.inplaceAdd)
  }

  /// Append an `inplaceSubtract` instruction to this code object.
  public func appendInplaceSubtract() throws {
    try self.append(.inplaceSubtract)
  }

  /// Append an `inplaceLShift` instruction to this code object.
  public func appendInplaceLShift() throws {
    try self.append(.inplaceLShift)
  }

  /// Append an `inplaceRShift` instruction to this code object.
  public func appendInplaceRShift() throws {
    try self.append(.inplaceRShift)
  }

  /// Append an `inplaceAnd` instruction to this code object.
  public func appendInplaceAnd() throws {
    try self.append(.inplaceAnd)
  }

  /// Append an `inplaceXor` instruction to this code object.
  public func appendInplaceXor() throws {
    try self.append(.inplaceXor)
  }

  /// Append an `inplaceOr` instruction to this code object.
  public func appendInplaceOr() throws {
    try self.append(.inplaceOr)
  }

  // MARK: - Comparison

  /// Append a `compareOp` instruction to this code object.
  public func appendCompareOp(_ op: ComparisonOpcode) throws {
    try self.append(.compareOp(op))
  }
}
