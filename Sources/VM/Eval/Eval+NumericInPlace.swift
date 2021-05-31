import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Add

  /// Implements in-place TOS = TOS1 + TOS.
  internal func inPlaceAdd() -> InstructionResult {
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
  internal func inPlaceSubtract() -> InstructionResult {
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
  internal func inPlaceMultiply() -> InstructionResult {
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
  internal func inPlaceMatrixMultiply() -> InstructionResult {
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
  internal func inPlacePower() -> InstructionResult {
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
  internal func inPlaceFloorDivide() -> InstructionResult {
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
  internal func inPlaceTrueDivide() -> InstructionResult {
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
  internal func inPlaceModulo() -> InstructionResult {
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
  internal func inPlaceLShift() -> InstructionResult {
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
  internal func inPlaceRShift() -> InstructionResult {
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
  internal func inPlaceAnd() -> InstructionResult {
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
  internal func inPlaceXor() -> InstructionResult {
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
  internal func inPlaceOr() -> InstructionResult {
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
