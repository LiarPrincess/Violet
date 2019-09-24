import Bytecode
import Objects

extension Frame {

  // MARK: - Arithmetic

  /// Implements `TOS = TOS1 ** TOS`.
  internal func binaryPower() throws {
    let exp = self.pop()
    let base = self.top
    let result = self.types.number.power(base: base, exp: exp, z: self.context.none)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 * TOS`.
  internal func binaryMultiply() throws {
    let right = self.pop()
    let left = self.top
    let result = self.types.number.multiply(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 @ TOS`.
  internal func binaryMatrixMultiply() throws {
    let right = self.pop()
    let left = self.top
    let result = self.types.number.matrixMultiply(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 // TOS`.
  internal func binaryFloorDivide() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = self.types.number.floorDivide(dividend: dividend, divisor: divisor)
    self.setTop(quotient)
  }

  /// Implements `TOS = TOS1 / TOS`.
  internal func binaryTrueDivide() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = self.types.number.trueDivide(dividend: dividend, divisor: divisor)
    self.setTop(quotient)
  }

  /// Implements `TOS = TOS1 % TOS`.
  internal func binaryModulo() throws {
    let divisor = self.pop()
    let dividend = self.top

    let isStringFormat = self.types.unicode.checkExact(dividend)
      && (self.types.unicode.check(divisor) || self.types.unicode.checkExact(divisor))

    let result = isStringFormat ?
      self.types.unicode.format(dividend: dividend, divisor: divisor) :
      self.types.number.remainder(dividend: dividend, divisor: divisor)

    self.setTop(result)
  }

  /// Implements `TOS = TOS1 + TOS`.
  internal func binaryAdd() throws {
    let right = self.pop()
    let left = self.top

    let isConcat = self.types.unicode.checkExact(left) && self.types.unicode.checkExact(right)
    let result = isConcat ?
      self.types.unicode.unicode_concatenate(left: left, right: right) :
      self.types.number.add(left: left, right: right)

    self.setTop(result)
  }

  /// Implements `TOS = TOS1 - TOS`.
  internal func binarySubtract() throws {
    let right = self.pop()
    let left = self.top
    let result = self.types.number.subtract(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Shifts

  /// Implements `TOS = TOS1 << TOS`.
  internal func binaryLShift() throws {
    let right = self.pop()
    let left = self.top
    let result = self.types.number.lShift(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 >> TOS`.
  internal func binaryRShift() throws {
    let right = self.pop()
    let left = self.top
    let result = self.types.number.rShift(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Binary

  /// Implements `TOS = TOS1 & TOS`.
  internal func binaryAnd() throws {
    let right = self.pop()
    let left = self.top
    let result = self.types.number.and(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 ^ TOS`.
  internal func binaryXor() throws {
    let right = self.pop()
    let left = self.top
    let result = self.types.number.xor(left: left, right: right)
    self.setTop(result)
  }

  /// Implements `TOS = TOS1 | TOS`.
  internal func binaryOr() throws {
    let right = self.pop()
    let left = self.top
    let result = self.types.number.or(left: left, right: right)
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
