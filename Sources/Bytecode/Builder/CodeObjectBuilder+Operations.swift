import Core

extension CodeObjectBuilder {

  // MARK: - Unary

  /// Append an `unaryPositive` instruction to this code object.
  public func appendUnaryPositive(at location: SourceLocation) throws {
    try self.append(.unaryPositive, at: location)
  }

  /// Append an `unaryNegative` instruction to this code object.
  public func appendUnaryNegative(at location: SourceLocation) throws {
    try self.append(.unaryNegative, at: location)
  }

  /// Append an `unaryNot` instruction to this code object.
  public func appendUnaryNot(at location: SourceLocation) throws {
    try self.append(.unaryNot, at: location)
  }

  /// Append an `unaryInvert` instruction to this code object.
  public func appendUnaryInvert(at location: SourceLocation) throws {
    try self.append(.unaryInvert, at: location)
  }

  // MARK: - Binary

  /// Append a `binaryPower` instruction to this code object.
  public func appendBinaryPower(at location: SourceLocation) throws {
    try self.append(.binaryPower, at: location)
  }

  /// Append a `binaryMultiply` instruction to this code object.
  public func appendBinaryMultiply(at location: SourceLocation) throws {
    try self.append(.binaryMultiply, at: location)
  }

  /// Append a `binaryMatrixMultiply` instruction to this code object.
  public func appendBinaryMatrixMultiply(at location: SourceLocation) throws {
    try self.append(.binaryMatrixMultiply, at: location)
  }

  /// Append a `binaryFloorDivide` instruction to this code object.
  public func appendBinaryFloorDivide(at location: SourceLocation) throws {
    try self.append(.binaryFloorDivide, at: location)
  }

  /// Append a `binaryTrueDivide` instruction to this code object.
  public func appendBinaryTrueDivide(at location: SourceLocation) throws {
    try self.append(.binaryTrueDivide, at: location)
  }

  /// Append a `binaryModulo` instruction to this code object.
  public func appendBinaryModulo(at location: SourceLocation) throws {
    try self.append(.binaryModulo, at: location)
  }

  /// Append a `binaryAdd` instruction to this code object.
  public func appendBinaryAdd(at location: SourceLocation) throws {
    try self.append(.binaryAdd, at: location)
  }

  /// Append a `binarySubtract` instruction to this code object.
  public func appendBinarySubtract(at location: SourceLocation) throws {
    try self.append(.binarySubtract, at: location)
  }

  /// Append a `binaryLShift` instruction to this code object.
  public func appendBinaryLShift(at location: SourceLocation) throws {
    try self.append(.binaryLShift, at: location)
  }

  /// Append a `binaryRShift` instruction to this code object.
  public func appendBinaryRShift(at location: SourceLocation) throws {
    try self.append(.binaryRShift, at: location)
  }

  /// Append a `binaryAnd` instruction to this code object.
  public func appendBinaryAnd(at location: SourceLocation) throws {
    try self.append(.binaryAnd, at: location)
  }

  /// Append a `binaryXor` instruction to this code object.
  public func appendBinaryXor(at location: SourceLocation) throws {
    try self.append(.binaryXor, at: location)
  }

  /// Append a `binaryOr` instruction to this code object.
  public func appendBinaryOr(at location: SourceLocation) throws {
    try self.append(.binaryOr, at: location)
  }

  // MARK: - In-place

  /// Append an `inplacePower` instruction to this code object.
  public func appendInplacePower(at location: SourceLocation) throws {
    try self.append(.inplacePower, at: location)
  }

  /// Append an `inplaceMultiply` instruction to this code object.
  public func appendInplaceMultiply(at location: SourceLocation) throws {
    try self.append(.inplaceMultiply, at: location)
  }

  /// Append an `inplaceMatrixMultiply` instruction to this code object.
  public func appendInplaceMatrixMultiply(at location: SourceLocation) throws {
    try self.append(.inplaceMatrixMultiply, at: location)
  }

  /// Append an `inplaceFloorDivide` instruction to this code object.
  public func appendInplaceFloorDivide(at location: SourceLocation) throws {
    try self.append(.inplaceFloorDivide, at: location)
  }

  /// Append an `inplaceTrueDivide` instruction to this code object.
  public func appendInplaceTrueDivide(at location: SourceLocation) throws {
    try self.append(.inplaceTrueDivide, at: location)
  }

  /// Append an `inplaceModulo` instruction to this code object.
  public func appendInplaceModulo(at location: SourceLocation) throws {
    try self.append(.inplaceModulo, at: location)
  }

  /// Append an `inplaceAdd` instruction to this code object.
  public func appendInplaceAdd(at location: SourceLocation) throws {
    try self.append(.inplaceAdd, at: location)
  }

  /// Append an `inplaceSubtract` instruction to this code object.
  public func appendInplaceSubtract(at location: SourceLocation) throws {
    try self.append(.inplaceSubtract, at: location)
  }

  /// Append an `inplaceLShift` instruction to this code object.
  public func appendInplaceLShift(at location: SourceLocation) throws {
    try self.append(.inplaceLShift, at: location)
  }

  /// Append an `inplaceRShift` instruction to this code object.
  public func appendInplaceRShift(at location: SourceLocation) throws {
    try self.append(.inplaceRShift, at: location)
  }

  /// Append an `inplaceAnd` instruction to this code object.
  public func appendInplaceAnd(at location: SourceLocation) throws {
    try self.append(.inplaceAnd, at: location)
  }

  /// Append an `inplaceXor` instruction to this code object.
  public func appendInplaceXor(at location: SourceLocation) throws {
    try self.append(.inplaceXor, at: location)
  }

  /// Append an `inplaceOr` instruction to this code object.
  public func appendInplaceOr(at location: SourceLocation) throws {
    try self.append(.inplaceOr, at: location)
  }

  // MARK: - Comparison

  /// Append a `compareOp` instruction to this code object.
  public func appendCompareOp(_ op: ComparisonOpcode,
                              at location: SourceLocation) throws {
    try self.append(.compareOp(op), at: location)
  }
}
