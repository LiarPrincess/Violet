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
    let top = self.stack.top
    let boolValue = self.builtins.isTrueBool(top)
    self.stack.top = self.builtins.newBool(boolValue)
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
