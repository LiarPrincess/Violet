import Bytecode
import Objects

extension Frame {

  // MARK: - Arithmetic

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() -> InstructionResult {
    let exponent = self.stack.pop()
    let value = self.stack.top
    let result = self.context.pow(value: value, exponent: exponent)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.mul(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.matrixMul(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = self.context.divFloor(left: dividend, right: divisor)
    self.stack.top = quotient
    return .ok
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = self.context.div(left: dividend, right: divisor)
    self.stack.top = quotient
    return .ok
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() -> InstructionResult {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let result = self.context.remainder(left: dividend, right: divisor)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.add(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.sub(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  // MARK: - Shifts

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.lShift(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.rShift(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  // MARK: - Binary

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.and(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.xor(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.context.or(left: left, right: right)
    self.stack.top = result
    return .ok
  }

  // MARK: - Compare

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.compare(left: left, right: right, comparison: comparison)
    self.stack.top = result.toPyObject(in: self.context)
    return .ok
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
      let result = self.context.contains(sequence: left, value: right)
      return result.map(self.builtins.newBool)
    case .notIn:
      let result = self.context.contains(sequence: left, value: right)
      return result.map { !$0 } .map(self.builtins.newBool)
    case .exceptionMatch:
      // ceval.c -> case PyCmp_EXC_MATCH:
      fatalError()
    }
  }
}
