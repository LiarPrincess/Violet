import Bytecode
import Objects

extension Frame {

  // MARK: - Arithmetic

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() throws {
    let exponent = self.stack.pop()
    let value = self.stack.top
    let result = try self.context.pow(value: value, exponent: exponent)
    self.stack.top = result
  }

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.mul(left: left, right: right)
    self.stack.top = result
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.matrixMul(left: left, right: right)
    self.stack.top = result
  }

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() throws {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = try self.context.divFloor(left: dividend, right: divisor)
    self.stack.top = quotient
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() throws {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = try self.context.div(left: dividend, right: divisor)
    self.stack.top = quotient
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() throws {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let result = try self.context.remainder(left: dividend, right: divisor)
    self.stack.top = result
  }

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.add(left: left, right: right)
    self.stack.top = result
  }

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.sub(left: left, right: right)
    self.stack.top = result
  }

  // MARK: - Shifts

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.lShift(left: left, right: right)
    self.stack.top = result
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.rShift(left: left, right: right)
    self.stack.top = result
  }

  // MARK: - Binary

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.and(left: left, right: right)
    self.stack.top = result
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.xor(left: left, right: right)
    self.stack.top = result
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.or(left: left, right: right)
    self.stack.top = result
  }

  // MARK: - Compare

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = self.compare(left: left, right: right, comparison: comparison)
    self.stack.top = result.toPyObject(in: self.context)
  }

  private func compare(left: PyObject,
                       right: PyObject,
                       comparison: ComparisonOpcode) -> PyResultOrNot<Bool> {
    switch comparison {
    case .equal:
      return self.context.isEqual(left: left, right: right)
    case .notEqual:
      return self.context.isNotEqual(left: left, right: right)
    case .less:
      return self.context.isLess(left: left, right: right)
    case .lessEqual:
      return self.context.isLessEqual(left: left, right: right)
    case .greater:
      return self.context.isGreater(left: left, right: right)
    case .greaterEqual:
      return self.context.isGreaterEqual(left: left, right: right)
    case .is:
      let iss = self.context.is(left: left, right: right)
      return .value(iss)
    case .isNot:
      let iss = self.context.is(left: left, right: right)
      return .value(!iss)
    case .in:
      return self.context.contains(sequence: left, value: right)
    case .notIn:
      let contains = self.context.contains(sequence: left, value: right)
      return contains.map { !$0 }
    case .exceptionMatch:
      // ceval.c -> case PyCmp_EXC_MATCH:
      fatalError()
    }
  }
}
