import Bytecode
import Objects

extension Eval {

  // MARK: - Add

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.add(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Sub

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.sub(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Mul

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.mul(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.matmul(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() -> InstructionResult {
    let exp = self.stack.pop()
    let base = self.stack.top

    switch Py.pow(base: base, exp: exp, mod: Py.none) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Div

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch Py.floordiv(left: dividend, right: divisor) {
    case let .value(quotient):
      self.stack.top = quotient
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch Py.truediv(left: dividend, right: divisor) {
    case let .value(quotient):
      self.stack.top = quotient
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch Py.mod(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Shift

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.lshift(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.rshift(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  // MARK: - Binary

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.and(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.xor(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch Py.or(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .unwind(.exception(e))
    }
  }
}
