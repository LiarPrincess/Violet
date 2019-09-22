import Bytecode
import Objects

extension Frame {

  // MARK: - Arithmetic

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() throws {
    let exp = self.pop()
    let base = self.top
    let result = self.numberType.power(base: base, exp: exp, z: self.Py_None)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() throws {
    let right = self.pop()
    let left = self.top
    let result = self.numberType.multiply(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() throws {
    let right = self.pop()
    let left = self.top
    let result = self.numberType.matrixMultiply(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = self.numberType.floorDivide(dividend: dividend, divisor: divisor)
    self.setTop(quotient)
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = self.numberType.trueDivide(dividend: dividend, divisor: divisor)
    self.setTop(quotient)
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() throws {
    let divisor = self.pop()
    let dividend = self.top

    let isStringFormat = self.unicodeType.checkExact(dividend)
      && (self.unicodeType.check(divisor) || self.unicodeType.checkExact(divisor))

    let result = isStringFormat ?
      self.unicodeType.format(dividend: dividend, divisor: divisor) :
      self.numberType.remainder(dividend: dividend, divisor: divisor)

    self.setTop(result)
  }

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() throws {
    let right = self.pop()
    let left = self.top

    let isConcat = self.unicodeType.checkExact(left) && self.unicodeType.checkExact(right)
    let result = isConcat ?
      self.unicodeType.unicode_concatenate(left: left, right: right) :
      self.numberType.add(left: left, right: right)

    self.setTop(result)
  }

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() throws {
    let right = self.pop()
    let left = self.top
    let result = self.numberType.subtract(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Shifts

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() throws {
    let right = self.pop()
    let left = self.top
    let result = self.numberType.lShift(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() throws {
    let right = self.pop()
    let left = self.top
    let result = self.numberType.rShift(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Binary

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() throws {
    let right = self.pop()
    let left = self.top
    let result = self.numberType.and(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() throws {
    let right = self.pop()
    let left = self.top
    let result = self.numberType.xor(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() throws {
    let right = self.pop()
    let left = self.top
    let result = self.numberType.or(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Compare

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) throws {
    let right = self.pop()
    let left = self.top
    let result = self.cmp_outcome(comparison: comparison, left: left, right: right)
    self.setTop(result)
  }
}
