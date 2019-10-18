import Bytecode
import Objects

extension Frame {

  /// Implements `TOS = +TOS`.
  internal func unaryPositive() throws {
    let value = self.stack.top
    let result = try self.context.positive(value)
    self.stack.top = result
  }

  /// Implements `TOS = -TOS`.
  internal func unaryNegative() throws {
    let value = self.stack.top
    let result = try self.context.negative(value)
    self.stack.top = result
  }

  /// Implements `TOS = not TOS`.
  internal func unaryNot() throws {
    let value = self.stack.top
    let boolValue = try self.context.isTrue(value: value)

    switch boolValue {
    case true:
      self.stack.top = self.context.false
    case false:
      self.stack.top = self.context.true
    }
  }

  /// Implements `TOS = ~TOS`.
  internal func unaryInvert() throws {
    let value = self.stack.top
    let result = try self.context.invert(value)
    self.stack.top = result
  }
}
