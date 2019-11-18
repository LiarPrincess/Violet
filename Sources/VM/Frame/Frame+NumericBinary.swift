import Bytecode
import Objects

extension Frame {

  // MARK: - Pow

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() -> InstructionResult {
    return .unimplemented
  }

  // MARK: - Mul

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.mul(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() -> InstructionResult {
    return .unimplemented
  }

  // MARK: - Div

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.builtins.floordiv(left: dividend, right: divisor) {
    case let .value(quotient):
      self.stack.top = quotient
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.builtins.truediv(left: dividend, right: divisor) {
    case let .value(quotient):
      self.stack.top = quotient
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top

    switch self.builtins.mod(left: dividend, right: divisor) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  // MARK: - Add

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.add(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  // MARK: - Sub

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.sub(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  // MARK: - Shift

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.lshift(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.rshift(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  // MARK: - Binary

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.and(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.xor(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.builtins.or(left: left, right: right) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  // MARK: - Compare

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.compare(left: left, right: right, comparison: comparison) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  private func compare(left: PyObject,
                       right: PyObject,
                       comparison: ComparisonOpcode) -> PyResult<PyObject> {
    switch comparison {
    case .equal:
      return self.builtins.isEqual(left: left, right: right)
    case .notEqual:
      return self.builtins.isNotEqual(left: left, right: right)
    case .less:
      return self.builtins.isLess(left: left, right: right)
    case .lessEqual:
      return self.builtins.isLessEqual(left: left, right: right)
    case .greater:
      return self.builtins.isGreater(left: left, right: right)
    case .greaterEqual:
      return self.builtins.isGreaterEqual(left: left, right: right)
    case .is:
      let result = self.builtins.is(left: left, right: right)
      return .value(self.builtins.newBool(result))
    case .isNot:
      let result = self.builtins.is(left: left, right: right)
      return .value(self.builtins.newBool(!result))
    case .in:
      let result = self.builtins.contains(left, element: right)
      return result.map(self.builtins.newBool)
    case .notIn:
      let result = self.builtins.contains(left, element: right)
      return result.map { !$0 } .map(self.builtins.newBool)
    case .exceptionMatch:
      // ceval.c -> case PyCmp_EXC_MATCH:
      fatalError()
    }
  }
}
