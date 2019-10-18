import Bytecode

extension Frame {

  // MARK: - Arithmetic

  /// Implements in-place TOS = TOS1 ** TOS.
  internal func inplacePower() throws {
    let exponent = self.stack.pop()
    let value = self.stack.top
    let result = try self.context.powInPlace(value: value, exponent: exponent)
    self.stack.top = result
  }

  /// Implements in-place TOS = TOS1 * TOS.
  internal func inplaceMultiply() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.mulInPlace(left: left, right: right)
    self.stack.top = result
  }

  /// Implements in-place TOS = TOS1 @ TOS.
  internal func inplaceMatrixMultiply() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.matrixMulInPlace(left: left, right: right)
    self.stack.top = result
  }

  /// Implements in-place TOS = TOS1 // TOS.
  internal func inplaceFloorDivide() throws {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = try self.context.divFloorInPlace(left: dividend, right: divisor)
    self.stack.top = quotient
  }

  /// Implements in-place TOS = TOS1 / TOS.
  internal func inplaceTrueDivide() throws {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = try self.context.divInPlace(left: dividend, right: divisor)
    self.stack.top = quotient
  }

  /// Implements in-place TOS = TOS1 % TOS.
  internal func inplaceModulo() throws {
    let divisor = self.stack.pop()
    let dividend = self.stack.top
    let quotient = try self.context.remainderInPlace(left: dividend, right: divisor)
    self.stack.top = quotient
  }

  /// Implements in-place TOS = TOS1 + TOS.
  internal func inplaceAdd() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.addInPlace(left: left, right: right)
    self.stack.top = result
  }

  /// Implements in-place TOS = TOS1 - TOS.
  internal func inplaceSubtract() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.subInPlace(left: left, right: right)
    self.stack.top = result
  }

  // MARK: - Shifts

  /// Implements in-place TOS = TOS1 << TOS.
  internal func inplaceLShift() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.lShiftInPlace(left: left, right: right)
    self.stack.top = result
  }

  /// Implements in-place TOS = TOS1 >> TOS.
  internal func inplaceRShift() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.rShiftInPlace(left: left, right: right)
    self.stack.top = result
  }

  // MARK: - Binary

  /// Implements in-place TOS = TOS1 & TOS.
  internal func inplaceAnd() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.andInPlace(left: left, right: right)
    self.stack.top = result
  }

  /// Implements in-place TOS = TOS1 ^ TOS.
  internal func inplaceXor() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.xorInPlace(left: left, right: right)
    self.stack.top = result
  }

  /// Implements in-place TOS = TOS1 | TOS.
  internal func inplaceOr() throws {
    let right = self.stack.pop()
    let left = self.stack.top
    let result = try self.context.orInPlace(left: left, right: right)
    self.stack.top = result
  }
}
