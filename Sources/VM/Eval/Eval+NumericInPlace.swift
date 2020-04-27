import VioletObjects
import VioletBytecode

extension Eval {

  // MARK: - Add

  /// Implements in-place TOS = TOS1 + TOS.
  internal func inplaceAdd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.addInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Sub

  /// Implements in-place TOS = TOS1 - TOS.
  internal func inplaceSubtract() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.subInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Mul

  /// Implements in-place TOS = TOS1 * TOS.
  internal func inplaceMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.mulInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements in-place TOS = TOS1 @ TOS.
  internal func inplaceMatrixMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.matmulInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements in-place TOS = TOS1 ** TOS.
  internal func inplacePower() -> InstructionResult {
    let exp = self.stack.pop()
    let base = self.stack.top

    switch Py.powInPlace(base: base, exp: exp, mod: Py.none) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Div

  /// Implements in-place TOS = TOS1 // TOS.
  internal func inplaceFloorDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch Py.floordivInPlace(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements in-place TOS = TOS1 / TOS.
  internal func inplaceTrueDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch Py.truedivInPlace(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements in-place TOS = TOS1 % TOS.
  internal func inplaceModulo() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch Py.modInPlace(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Shift

  /// Implements in-place TOS = TOS1 << TOS.
  internal func inplaceLShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.lshiftInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements in-place TOS = TOS1 >> TOS.
  internal func inplaceRShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.rshiftInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Binary

  /// Implements in-place TOS = TOS1 & TOS.
  internal func inplaceAnd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.andInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements in-place TOS = TOS1 ^ TOS.
  internal func inplaceXor() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.xorInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements in-place TOS = TOS1 | TOS.
  internal func inplaceOr() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.orInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
