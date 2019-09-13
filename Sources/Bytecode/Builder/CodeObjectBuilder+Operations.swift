import Core

extension CodeObjectBuilder {

  // MARK: - Unary

  /// Append an `unaryPositive` instruction to this code object.
  public func appendUnaryPositive() {
    self.append(.unaryPositive)
  }

  /// Append an `unaryNegative` instruction to this code object.
  public func appendUnaryNegative() {
    self.append(.unaryNegative)
  }

  /// Append an `unaryNot` instruction to this code object.
  public func appendUnaryNot() {
    self.append(.unaryNot)
  }

  /// Append an `unaryInvert` instruction to this code object.
  public func appendUnaryInvert() {
    self.append(.unaryInvert)
  }

  // MARK: - Binary

  /// Append a `binaryPower` instruction to this code object.
  public func appendBinaryPower() {
    self.append(.binaryPower)
  }

  /// Append a `binaryMultiply` instruction to this code object.
  public func appendBinaryMultiply() {
    self.append(.binaryMultiply)
  }

  /// Append a `binaryMatrixMultiply` instruction to this code object.
  public func appendBinaryMatrixMultiply() {
    self.append(.binaryMatrixMultiply)
  }

  /// Append a `binaryFloorDivide` instruction to this code object.
  public func appendBinaryFloorDivide() {
    self.append(.binaryFloorDivide)
  }

  /// Append a `binaryTrueDivide` instruction to this code object.
  public func appendBinaryTrueDivide() {
    self.append(.binaryTrueDivide)
  }

  /// Append a `binaryModulo` instruction to this code object.
  public func appendBinaryModulo() {
    self.append(.binaryModulo)
  }

  /// Append a `binaryAdd` instruction to this code object.
  public func appendBinaryAdd() {
    self.append(.binaryAdd)
  }

  /// Append a `binarySubtract` instruction to this code object.
  public func appendBinarySubtract() {
    self.append(.binarySubtract)
  }

  /// Append a `binaryLShift` instruction to this code object.
  public func appendBinaryLShift() {
    self.append(.binaryLShift)
  }

  /// Append a `binaryRShift` instruction to this code object.
  public func appendBinaryRShift() {
    self.append(.binaryRShift)
  }

  /// Append a `binaryAnd` instruction to this code object.
  public func appendBinaryAnd() {
    self.append(.binaryAnd)
  }

  /// Append a `binaryXor` instruction to this code object.
  public func appendBinaryXor() {
    self.append(.binaryXor)
  }

  /// Append a `binaryOr` instruction to this code object.
  public func appendBinaryOr() {
    self.append(.binaryOr)
  }

  // MARK: - In-place

  /// Append an `inplacePower` instruction to this code object.
  public func appendInplacePower() {
    self.append(.inplacePower)
  }

  /// Append an `inplaceMultiply` instruction to this code object.
  public func appendInplaceMultiply() {
    self.append(.inplaceMultiply)
  }

  /// Append an `inplaceMatrixMultiply` instruction to this code object.
  public func appendInplaceMatrixMultiply() {
    self.append(.inplaceMatrixMultiply)
  }

  /// Append an `inplaceFloorDivide` instruction to this code object.
  public func appendInplaceFloorDivide() {
    self.append(.inplaceFloorDivide)
  }

  /// Append an `inplaceTrueDivide` instruction to this code object.
  public func appendInplaceTrueDivide() {
    self.append(.inplaceTrueDivide)
  }

  /// Append an `inplaceModulo` instruction to this code object.
  public func appendInplaceModulo() {
    self.append(.inplaceModulo)
  }

  /// Append an `inplaceAdd` instruction to this code object.
  public func appendInplaceAdd() {
    self.append(.inplaceAdd)
  }

  /// Append an `inplaceSubtract` instruction to this code object.
  public func appendInplaceSubtract() {
    self.append(.inplaceSubtract)
  }

  /// Append an `inplaceLShift` instruction to this code object.
  public func appendInplaceLShift() {
    self.append(.inplaceLShift)
  }

  /// Append an `inplaceRShift` instruction to this code object.
  public func appendInplaceRShift() {
    self.append(.inplaceRShift)
  }

  /// Append an `inplaceAnd` instruction to this code object.
  public func appendInplaceAnd() {
    self.append(.inplaceAnd)
  }

  /// Append an `inplaceXor` instruction to this code object.
  public func appendInplaceXor() {
    self.append(.inplaceXor)
  }

  /// Append an `inplaceOr` instruction to this code object.
  public func appendInplaceOr() {
    self.append(.inplaceOr)
  }

  // MARK: - Comparison

  /// Append a `compareOp` instruction to this code object.
  public func appendCompareOp(_ op: ComparisonOpcode) {
    self.append(.compareOp(op))
  }
}
