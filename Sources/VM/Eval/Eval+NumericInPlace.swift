import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Add

  /// Implements in-place TOS = TOS1 + TOS.
  internal func inPlaceAdd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.addInPlace(left: left, right: right) {
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

    switch self.py.subInPlace(left: left, right: right) {
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

    switch self.py.mulInPlace(left: left, right: right) {
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

    switch self.py.matmulInPlace(left: left, right: right) {
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
    let none = self.py.none.asObject

    switch self.py.powInPlace(base: base, exp: exp, mod: none) {
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

    switch self.py.floorDivInPlace(left: dividend, right: divisor) {
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

    switch self.py.trueDivInPlace(left: dividend, right: divisor) {
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

    switch self.py.modInPlace(left: dividend, right: divisor) {
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

    switch self.py.lshiftInPlace(left: left, right: right) {
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

    switch self.py.rshiftInPlace(left: left, right: right) {
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

    switch self.py.andInPlace(left: left, right: right) {
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

    switch self.py.xorInPlace(left: left, right: right) {
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

    switch self.py.orInPlace(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
