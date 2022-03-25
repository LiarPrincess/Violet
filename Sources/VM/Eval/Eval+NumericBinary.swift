import VioletObjects

extension Eval {

  // MARK: - Add

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.add(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Sub

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.sub(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Mul

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.mul(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.matmul(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() -> InstructionResult {
    let exp = self.stack.pop()
    let base = self.stack.top
    let none = self.py.none.asObject

    switch self.py.pow(base: base, exp: exp, mod: none) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Div

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.py.floorDiv(left: dividend, right: divisor) {
    case let .value(quotient):
      self.stack.top = quotient
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.py.trueDiv(left: dividend, right: divisor) {
    case let .value(quotient):
      self.stack.top = quotient
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.py.mod(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Shift

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.lshift(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.rshift(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Binary

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.and(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.xor(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.py.or(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
