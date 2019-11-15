import Bytecode
import Objects

extension Frame {

  /// Implements `TOS = +TOS`.
  internal func unaryPositive() -> InstructionResult {
    let value = self.stack.top
    switch self.builtins.pos(value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  /// Implements `TOS = -TOS`.
  internal func unaryNegative() -> InstructionResult {
    let value = self.stack.top
    switch self.builtins.neg(value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
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
    switch self.builtins.invert(value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }
}
