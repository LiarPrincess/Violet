import Objects
import Bytecode

extension Eval {

  /// Pushes `builtins.BuildClass()` onto the stack.
  /// It is later called by `CallFunction` to construct a class.
  internal func loadBuildClass() -> InstructionResult {
    switch Py.get__build_class__() {
    case let .value(fn):
      self.stack.push(fn)
      return .ok
    case let .error(e):
      return .exception(e)
    }
  }
}
