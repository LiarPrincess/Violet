import Bytecode
import Objects

extension Frame {

  /// Implements `TOS = +TOS`.
  internal func unaryPositive() -> InstructionResult {
    let value = self.stack.top
    let result = self.context.positive(value)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = -TOS`.
  internal func unaryNegative() -> InstructionResult {
    let value = self.stack.top
    let result = self.context.negative(value)
    self.stack.top = result
    return .ok
  }

  /// Implements `TOS = not TOS`.
  internal func unaryNot() -> InstructionResult {
    let value = self.stack.top
    let boolValue = self.context.isTrue(value: value)

    switch boolValue {
    case true:
      self.stack.top = self.context.false
    case false:
      self.stack.top = self.context.true
    }

    return .ok
  }

  /// Implements `TOS = ~TOS`.
  internal func unaryInvert() -> InstructionResult {
    let value = self.stack.top
    let result = self.context.invert(value)
    self.stack.top = result
    return .ok
  }
}
