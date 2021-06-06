import VioletCore

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

  /// Append an `inPlacePower` instruction to this code object.
  public func appendInPlacePower() {
    self.append(.inPlacePower)
  }

  /// Append an `inPlaceMultiply` instruction to this code object.
  public func appendInPlaceMultiply() {
    self.append(.inPlaceMultiply)
  }

  /// Append an `inPlaceMatrixMultiply` instruction to this code object.
  public func appendInPlaceMatrixMultiply() {
    self.append(.inPlaceMatrixMultiply)
  }

  /// Append an `inPlaceFloorDivide` instruction to this code object.
  public func appendInPlaceFloorDivide() {
    self.append(.inPlaceFloorDivide)
  }

  /// Append an `inPlaceTrueDivide` instruction to this code object.
  public func appendInPlaceTrueDivide() {
    self.append(.inPlaceTrueDivide)
  }

  /// Append an `inPlaceModulo` instruction to this code object.
  public func appendInPlaceModulo() {
    self.append(.inPlaceModulo)
  }

  /// Append an `inPlaceAdd` instruction to this code object.
  public func appendInPlaceAdd() {
    self.append(.inPlaceAdd)
  }

  /// Append an `inPlaceSubtract` instruction to this code object.
  public func appendInPlaceSubtract() {
    self.append(.inPlaceSubtract)
  }

  /// Append an `inPlaceLShift` instruction to this code object.
  public func appendInPlaceLShift() {
    self.append(.inPlaceLShift)
  }

  /// Append an `inPlaceRShift` instruction to this code object.
  public func appendInPlaceRShift() {
    self.append(.inPlaceRShift)
  }

  /// Append an `inPlaceAnd` instruction to this code object.
  public func appendInPlaceAnd() {
    self.append(.inPlaceAnd)
  }

  /// Append an `inPlaceXor` instruction to this code object.
  public func appendInPlaceXor() {
    self.append(.inPlaceXor)
  }

  /// Append an `inPlaceOr` instruction to this code object.
  public func appendInPlaceOr() {
    self.append(.inPlaceOr)
  }

  // MARK: - Comparison

  /// Append a `compareOp` instruction to this code object.
  public func appendCompareOp(type: Instruction.CompareType) {
    self.append(.compareOp(type: type))
  }
}
