import Objects
import Bytecode

extension Frame {

  /// Pushes `builtins.BuildClass()` onto the stack.
  /// It is later called by `CallFunction` to construct a class.
  internal func loadBuildClass() -> InstructionResult {
    guard let buildClass = self.builtinSymbols.get(key: "__build_class__") else {
      let e = Py.newNameError(msg: "__build_class__ not found")
      return .unwind(.exception(e))
    }

    self.stack.push(buildClass)
    return .ok
  }
}
