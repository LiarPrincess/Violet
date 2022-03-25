import VioletBytecode
import VioletObjects

extension Eval {

  /// Pushes `builtins.__build_class__()` onto the stack.
  /// It is later called by `CallFunction` to construct a class.
  internal func loadBuildClass() -> InstructionResult {
    switch self.py.get__build_class__() {
    case let .value(fn):
      self.stack.push(fn)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
