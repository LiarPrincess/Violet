import Bytecode

extension Frame {

  // MARK: - Arithmetic

  /// Implements in-place TOS = TOS1 ** TOS.
  internal func inplacePower() throws {
    let exponent = self.pop()
    let value = self.top
    let result = try self.context.powInPlace(value: value, exponent: exponent)
    self.setTop(result)
  }

  /// Implements in-place TOS = TOS1 * TOS.
  internal func inplaceMultiply() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.mulInPlace(left: left, right: right)
    self.setTop(result)
  }

  /// Implements in-place TOS = TOS1 @ TOS.
  internal func inplaceMatrixMultiply() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.matrixMulInPlace(left: left, right: right)
    self.setTop(result)
  }

  /// Implements in-place TOS = TOS1 // TOS.
  internal func inplaceFloorDivide() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = try self.context.divFloorInPlace(left: dividend, right: divisor)
    self.setTop(quotient)
  }

  /// Implements in-place TOS = TOS1 / TOS.
  internal func inplaceTrueDivide() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = try self.context.divInPlace(left: dividend, right: divisor)
    self.setTop(quotient)
  }

  /// Implements in-place TOS = TOS1 % TOS.
  internal func inplaceModulo() throws {
    let divisor = self.pop()
    let dividend = self.top
    let quotient = try self.context.remainderInPlace(left: dividend, right: divisor)
    self.setTop(quotient)
  }

  /// Implements in-place TOS = TOS1 + TOS.
  internal func inplaceAdd() throws {
    let right = self.pop()
    let left = self.top

    // TODO: ceval.c -> sum = unicode_concatenate(left, right, f, next_instr);
    let isConcat = self.context.unicode.checkExact(left)
                && self.context.unicode.checkExact(right)

    let result = isConcat ?
      self.context.unicode.unicode_concatenate(left: left, right: right) :
      try self.context.addInPlace(left: left, right: right)

    self.setTop(result)
  }

  /// Implements in-place TOS = TOS1 - TOS.
  internal func inplaceSubtract() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.subInPlace(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Shifts

  /// Implements in-place TOS = TOS1 << TOS.
  internal func inplaceLShift() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.lShiftInPlace(left: left, right: right)
    self.setTop(result)
  }

  /// Implements in-place TOS = TOS1 >> TOS.
  internal func inplaceRShift() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.rShiftInPlace(left: left, right: right)
    self.setTop(result)
  }

  // MARK: - Binary

  /// Implements in-place TOS = TOS1 & TOS.
  internal func inplaceAnd() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.andInPlace(left: left, right: right)
    self.setTop(result)
  }

  /// Implements in-place TOS = TOS1 ^ TOS.
  internal func inplaceXor() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.xorInPlace(left: left, right: right)
    self.setTop(result)
  }

  /// Implements in-place TOS = TOS1 | TOS.
  internal func inplaceOr() throws {
    let right = self.pop()
    let left = self.top
    let result = try self.context.orInPlace(left: left, right: right)
    self.setTop(result)
  }
}
