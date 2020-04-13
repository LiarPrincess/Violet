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
    self.unimplemented()
  }

  // MARK: - Coroutines

  /// Implements `TOS = GetAwaitable(TOS)`.
  ///
  /// `GetAwaitable(o)` returns:
  /// - `o` if `o` is a coroutine object
  /// - generator object with the `CoIterableCoroutine` flag
  /// - `o.Await`
  internal func getAwaitable() -> InstructionResult {
    self.unimplemented()
  }

  /// Implements `TOS = TOS.AIter()`.
  internal func getAIter() -> InstructionResult {
    self.unimplemented()
  }

  /// Implements `Push(GetAwaitable(TOS.ANext()))`.
  /// See `GetAwaitable` for details.
  internal func getANext() -> InstructionResult {
    self.unimplemented()
  }

  // MARK: - Generators

  /// Pops TOS and yields it from a generator.
  internal func yieldValue() -> InstructionResult {
    self.unimplemented()
  }

  /// Pops TOS and delegates to it as a subiterator from a generator.
  internal func yieldFrom() -> InstructionResult {
    self.unimplemented()
  }

  /// If TOS is a generator iterator or coroutine object then it is left as is.
  /// Otherwise, implements `TOS = iter(TOS)`.
  internal func getYieldFromIter() -> InstructionResult {
    self.unimplemented()
  }

  // MARK: - With

  /// Resolves `AEnter` and `AExit` from the object on top of the stack.
  /// Pushes `AExit` and result of `AEnter()` to the stack.
  internal func beforeAsyncWith() -> InstructionResult {
    self.unimplemented()
  }

  /// Creates a new frame object.
  internal func setupAsyncWith() -> InstructionResult {
    self.unimplemented()
  }

  // MARK: - Format

  public func format(value: PyObject, format: PyObject?) -> PyObject {
    // Use 'Py.format' after we write this function
    self.unimplemented()
  }

  // MARK: - Unimplemented

  private func unimplemented(fn: StaticString = #function) -> Never {
    trap("NOT IMPLEMENTED: '\(fn)'")
  }
}
