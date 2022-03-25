import VioletBytecode
import VioletObjects

extension Eval {

  // MARK: - Positive

  /// Implements `TOS = +TOS`.
  internal func unaryPositive() -> InstructionResult {
    let value = self.stack.top
    switch self.py.positive(object: value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Negative

  /// Implements `TOS = -TOS`.
  internal func unaryNegative() -> InstructionResult {
    let value = self.stack.top
    switch self.py.negative(object: value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Not

  /// Implements `TOS = not TOS`.
  internal func unaryNot() -> InstructionResult {
    let top = self.stack.top

    switch self.py.not(object: top) {
    case let .value(not):
      self.stack.top = not.asObject
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }

  // MARK: - Invert

  /// Implements `TOS = ~TOS`.
  internal func unaryInvert() -> InstructionResult {
    let value = self.stack.top
    switch self.py.invert(object: value) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
