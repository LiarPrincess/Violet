import Core
import Bytecode
import Objects

extension Eval {

  // MARK: - General

  /// Checks whether Annotations is defined in locals(),
  /// if not it is set up to an empty dict.
  /// This opcode is only emitted if a class or module body contains variable
  /// annotations statically.
  internal func setupAnnotations() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Coroutines

  /// Implements `TOS = GetAwaitable(TOS)`.
  ///
  /// `GetAwaitable(o)` returns:
  /// - `o` if `o` is a coroutine object
  /// - generator object with the `CoIterableCoroutine` flag
  /// - `o.Await`
  internal func getAwaitable() -> InstructionResult {
    return self.unimplemented()
  }

  /// Implements `TOS = TOS.AIter()`.
  internal func getAIter() -> InstructionResult {
    return self.unimplemented()
  }

  /// Implements `Push(GetAwaitable(TOS.ANext()))`.
  /// See `GetAwaitable` for details.
  internal func getANext() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Generators

  /// Pops TOS and yields it from a generator.
  internal func yieldValue() -> InstructionResult {
    return self.unimplemented()
  }

  /// Pops TOS and delegates to it as a subiterator from a generator.
  internal func yieldFrom() -> InstructionResult {
    return self.unimplemented()
  }

  /// If TOS is a generator iterator or coroutine object then it is left as is.
  /// Otherwise, implements `TOS = iter(TOS)`.
  internal func getYieldFromIter() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Import

  /// Loads all symbols not starting with '_' directly from the module TOS
  /// to the local namespace.
  ///
  /// The module is popped after loading all names.
  /// This opcode implements `from module import *`.
  internal func importStar() -> InstructionResult {
    return self.unimplemented()
  }

  /// Loads the attribute `name` from the module found in TOS.
  ///
  /// The resulting object is pushed onto the stack,
  /// to be subsequently stored by a `StoreFast` instruction.
  internal func importFrom(nameIndex: Int) -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - With

  /// Resolves `AEnter` and `AExit` from the object on top of the stack.
  /// Pushes `AExit` and result of `AEnter()` to the stack.
  internal func beforeAsyncWith() -> InstructionResult {
    return self.unimplemented()
  }

  /// Creates a new frame object.
  internal func setupAsyncWith() -> InstructionResult {
    return self.unimplemented()
  }

  // MARK: - Unimplemented

  private func unimplemented(fn: StaticString = #function) -> InstructionResult {
    trap("NOT IMPLEMENTED: '\(fn)'")
  }
}
