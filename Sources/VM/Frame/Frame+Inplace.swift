import Bytecode

extension Frame {

  // MARK: - Arithmetic

  /// Implements in-place TOS = TOS1 ** TOS.
  internal func inplacePower() -> InstructionResult {
    return .unimplemented
  }

  /// Implements in-place TOS = TOS1 * TOS.
  internal func inplaceMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.mulInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 @ TOS.
  internal func inplaceMatrixMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.matmulInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 // TOS.
  internal func inplaceFloorDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.builtins.floordivInPlace(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 / TOS.
  internal func inplaceTrueDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.builtins.truedivInPlace(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 % TOS.
  internal func inplaceModulo() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.builtins.modInPlace(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 + TOS.
  internal func inplaceAdd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.addInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 - TOS.
  internal func inplaceSubtract() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.subInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  // MARK: - Shifts

  /// Implements in-place TOS = TOS1 << TOS.
  internal func inplaceLShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.lshiftInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 >> TOS.
  internal func inplaceRShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.rshiftInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  // MARK: - Binary

  /// Implements in-place TOS = TOS1 & TOS.
  internal func inplaceAnd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.andInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 ^ TOS.
  internal func inplaceXor() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.xorInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements in-place TOS = TOS1 | TOS.
  internal func inplaceOr() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.orInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }
}
