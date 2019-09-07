import Core

extension CodeObject {

  // MARK: - Unary

  /// Append an `unaryPositive` instruction to code object.
  public func emitUnaryPositive(location: SourceLocation) throws {
    try self.emit(.unaryPositive, location: location)
  }

  /// Append an `unaryNegative` instruction to code object.
  public func emitUnaryNegative(location: SourceLocation) throws {
    try self.emit(.unaryNegative, location: location)
  }

  /// Append an `unaryNot` instruction to code object.
  public func emitUnaryNot(location: SourceLocation) throws {
    try self.emit(.unaryNot, location: location)
  }

  /// Append an `unaryInvert` instruction to code object.
  public func emitUnaryInvert(location: SourceLocation) throws {
    try self.emit(.unaryInvert, location: location)
  }

  // MARK: - Binary

  /// Append a `binaryPower` instruction to code object.
  public func emitBinaryPower(location: SourceLocation) throws {
    try self.emit(.binaryPower, location: location)
  }

  /// Append a `binaryMultiply` instruction to code object.
  public func emitBinaryMultiply(location: SourceLocation) throws {
    try self.emit(.binaryMultiply, location: location)
  }

  /// Append a `binaryMatrixMultiply` instruction to code object.
  public func emitBinaryMatrixMultiply(location: SourceLocation) throws {
    try self.emit(.binaryMatrixMultiply, location: location)
  }

  /// Append a `binaryFloorDivide` instruction to code object.
  public func emitBinaryFloorDivide(location: SourceLocation) throws {
    try self.emit(.binaryFloorDivide, location: location)
  }

  /// Append a `binaryTrueDivide` instruction to code object.
  public func emitBinaryTrueDivide(location: SourceLocation) throws {
    try self.emit(.binaryTrueDivide, location: location)
  }

  /// Append a `binaryModulo` instruction to code object.
  public func emitBinaryModulo(location: SourceLocation) throws {
    try self.emit(.binaryModulo, location: location)
  }

  /// Append a `binaryAdd` instruction to code object.
  public func emitBinaryAdd(location: SourceLocation) throws {
    try self.emit(.binaryAdd, location: location)
  }

  /// Append a `binarySubtract` instruction to code object.
  public func emitBinarySubtract(location: SourceLocation) throws {
    try self.emit(.binarySubtract, location: location)
  }

  /// Append a `binaryLShift` instruction to code object.
  public func emitBinaryLShift(location: SourceLocation) throws {
    try self.emit(.binaryLShift, location: location)
  }

  /// Append a `binaryRShift` instruction to code object.
  public func emitBinaryRShift(location: SourceLocation) throws {
    try self.emit(.binaryRShift, location: location)
  }

  /// Append a `binaryAnd` instruction to code object.
  public func emitBinaryAnd(location: SourceLocation) throws {
    try self.emit(.binaryAnd, location: location)
  }

  /// Append a `binaryXor` instruction to code object.
  public func emitBinaryXor(location: SourceLocation) throws {
    try self.emit(.binaryXor, location: location)
  }

  /// Append a `binaryOr` instruction to code object.
  public func emitBinaryOr(location: SourceLocation) throws {
    try self.emit(.binaryOr, location: location)
  }

  // MARK: - In-place

  /// Append an `inplacePower` instruction to code object.
  public func emitInplacePower(location: SourceLocation) throws {
    try self.emit(.inplacePower, location: location)
  }

  /// Append an `inplaceMultiply` instruction to code object.
  public func emitInplaceMultiply(location: SourceLocation) throws {
    try self.emit(.inplaceMultiply, location: location)
  }

  /// Append an `inplaceMatrixMultiply` instruction to code object.
  public func emitInplaceMatrixMultiply(location: SourceLocation) throws {
    try self.emit(.inplaceMatrixMultiply, location: location)
  }

  /// Append an `inplaceFloorDivide` instruction to code object.
  public func emitInplaceFloorDivide(location: SourceLocation) throws {
    try self.emit(.inplaceFloorDivide, location: location)
  }

  /// Append an `inplaceTrueDivide` instruction to code object.
  public func emitInplaceTrueDivide(location: SourceLocation) throws {
    try self.emit(.inplaceTrueDivide, location: location)
  }

  /// Append an `inplaceModulo` instruction to code object.
  public func emitInplaceModulo(location: SourceLocation) throws {
    try self.emit(.inplaceModulo, location: location)
  }

  /// Append an `inplaceAdd` instruction to code object.
  public func emitInplaceAdd(location: SourceLocation) throws {
    try self.emit(.inplaceAdd, location: location)
  }

  /// Append an `inplaceSubtract` instruction to code object.
  public func emitInplaceSubtract(location: SourceLocation) throws {
    try self.emit(.inplaceSubtract, location: location)
  }

  /// Append an `inplaceLShift` instruction to code object.
  public func emitInplaceLShift(location: SourceLocation) throws {
    try self.emit(.inplaceLShift, location: location)
  }

  /// Append an `inplaceRShift` instruction to code object.
  public func emitInplaceRShift(location: SourceLocation) throws {
    try self.emit(.inplaceRShift, location: location)
  }

  /// Append an `inplaceAnd` instruction to code object.
  public func emitInplaceAnd(location: SourceLocation) throws {
    try self.emit(.inplaceAnd, location: location)
  }

  /// Append an `inplaceXor` instruction to code object.
  public func emitInplaceXor(location: SourceLocation) throws {
    try self.emit(.inplaceXor, location: location)
  }

  /// Append an `inplaceOr` instruction to code object.
  public func emitInplaceOr(location: SourceLocation) throws {
    try self.emit(.inplaceOr, location: location)
  }

  // MARK: - Comparison

  /// Append a `compareOp` instruction to code object.
  public func emitCompareOp(_ op: ComparisonOpcode,
                            location: SourceLocation) throws {
    try self.emit(.compareOp(op), location: location)
  }
}
