import Bytecode

extension Frame {

  /// Pushes `builtins.BuildClass()` onto the stack.
  /// It is later called by `CallFunction` to construct a class.
  internal func loadBuildClass() throws {
    self.unimplemented()
  }

  /// Loads a method named `name` from TOS object.
  ///
  /// TOS is popped and method and TOS are pushed when interpreter can call unbound method directly.
  /// TOS will be used as the first argument (self) by `CallMethod`.
  /// Otherwise, NULL and method is pushed (method is bound method or something else).
  internal func loadMethod(nameIndex: Int) throws {
    self.unimplemented()
  }

  /// Calls a method.
  /// `argc` is number of positional arguments.
  /// Keyword arguments are not supported.
  ///
  /// This opcode is designed to be used with `LoadMethod`.
  /// Positional arguments are on top of the stack.
  /// Below them, two items described in `LoadMethod` on the stack.
  /// All of them are popped and return value is pushed.
  internal func callMethod(argumentCount: Int) throws {
    self.unimplemented()
  }
}
