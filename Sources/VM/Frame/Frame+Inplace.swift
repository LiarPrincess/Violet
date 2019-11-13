import Bytecode

extension Frame {

  // MARK: - Arithmetic

  /// Implements in-place TOS = TOS1 ** TOS.
  internal func inplacePower() -> InstructionResult {
    let exponent = self.stack.pop()
    let value = self.stack.top
    let result = self.context.powInPlace(value: value, exponent: exponent)
    self.stack.top = result
    return .ok
  }

  /// Implements in-place TOS = TOS1 * TOS.
  internal func inplaceMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.mulInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements in-place TOS = TOS1 @ TOS.
  internal func inplaceMatrixMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.matrixMulInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements in-place TOS = TOS1 // TOS.
  internal func inplaceFloorDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = self.context.divFloorInPlace(left: dividend, right: divisor)
    self.stack.top = quotient
    return .ok
  }

  /// Implements in-place TOS = TOS1 / TOS.
  internal func inplaceTrueDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = self.context.divInPlace(left: dividend, right: divisor)
    self.stack.top = quotient
    return .ok
  }

  /// Implements in-place TOS = TOS1 % TOS.
  internal func inplaceModulo() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = self.context.remainderInPlace(left: dividend, right: divisor)
    self.stack.top = quotient
    return .ok
  }

  /// Implements in-place TOS = TOS1 + TOS.
  internal func inplaceAdd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.addInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements in-place TOS = TOS1 - TOS.
  internal func inplaceSubtract() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.subInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  // MARK: - Shifts

  /// Implements in-place TOS = TOS1 << TOS.
  internal func inplaceLShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.lShiftInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements in-place TOS = TOS1 >> TOS.
  internal func inplaceRShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.rShiftInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  // MARK: - Binary

  /// Implements in-place TOS = TOS1 & TOS.
  internal func inplaceAnd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.andInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements in-place TOS = TOS1 ^ TOS.
  internal func inplaceXor() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.xorInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements in-place TOS = TOS1 | TOS.
  internal func inplaceOr() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.orInPlace(left: left, right: right)
    self.stack.top = result
    return .ok
  }
}
