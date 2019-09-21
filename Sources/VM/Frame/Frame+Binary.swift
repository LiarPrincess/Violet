import Bytecode

extension Frame {

  // MARK: - Binary

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() throws {
    self.unimplemented()
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() throws {
    self.unimplemented()
  }

  // MARK: - In-place

  /// Implements in-place TOS = TOS1 ** TOS.
  internal func inplacePower() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 * TOS.
  internal func inplaceMultiply() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 @ TOS.
  internal func inplaceMatrixMultiply() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 // TOS.
  internal func inplaceFloorDivide() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 / TOS.
  internal func inplaceTrueDivide() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 % TOS.
  internal func inplaceModulo() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 + TOS.
  internal func inplaceAdd() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 - TOS.
  internal func inplaceSubtract() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 << TOS.
  internal func inplaceLShift() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 >> TOS.
  internal func inplaceRShift() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 & TOS.
  internal func inplaceAnd() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 ^ TOS.
  internal func inplaceXor() throws {
    self.unimplemented()
  }

  /// Implements in-place TOS = TOS1 | TOS.
  internal func inplaceOr() throws {
    self.unimplemented()
  }

  // MARK: - Compare

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) throws {
    self.unimplemented()
  }
}
