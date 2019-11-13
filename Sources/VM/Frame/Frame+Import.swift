import Bytecode

extension Frame {

  /// Loads all symbols not starting with '_' directly from the module TOS
  /// to the local namespace.
  ///
  /// The module is popped after loading all names.
  /// This opcode implements `from module import *`.
  internal func importStar() -> InstructionResult {
    return .unimplemented
  }

  /// Imports the module `name`.
  ///
  /// TOS and TOS1 are popped and provide the `fromlist` and `level` arguments of `Import()`.
  /// The module object is pushed onto the stack.
  /// The current namespace is not affected: for a proper import statement,
  /// a subsequent StoreFast instruction modifies the namespace.
  internal func importName(nameIndex: Int) -> InstructionResult {
    return .unimplemented
  }

  /// Loads the attribute `name` from the module found in TOS.
  ///
  /// The resulting object is pushed onto the stack,
  /// to be subsequently stored by a `StoreFast` instruction.
  internal func importFrom(nameIndex: Int) -> InstructionResult {
    return .unimplemented
  }
}
