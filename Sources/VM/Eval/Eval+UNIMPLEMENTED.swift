import VioletCore
import VioletBytecode
import VioletObjects

extension Eval {

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

  /// PyObject *format_spec
  /// PyObject_Format(PyObject *obj, PyObject *)
  internal func format(object: PyObject, format: PyObject?) -> PyResultGen<PyString> {
    // Move this to 'self.py.format' after we finish the whole implementation.
    switch self.parseFormat(format: format) {
    case .nil,
        .empty:
      return self.py.str(object)
    case .string:
      self.unimplemented()
    case .error(let e):
      return .error(e)
    }
  }

  private enum ParseFormatResult {
    case `nil`
    case empty
    case string(PyString, String)
    case error(PyBaseException)
  }

  private func parseFormat(format: PyObject?) -> ParseFormatResult {
    guard let format = format else {
      return .nil
    }

    guard let pyString = self.py.cast.asString(format) else {
      let message = "Format specifier must be a string, not \(format.typeName)"
      let error = self.newTypeError(message: message)
      return .error(error)
    }

    let string: String
    switch self.py.strString(format) {
    case let .value(s): string = s
    case let .error(e): return .error(e)
    }

    if string.isEmpty {
      return .empty
    }

    return .string(pyString, string)
  }

  // MARK: - Unimplemented

  private func unimplemented(fn: StaticString = #function) -> Never {
    trap("NOT IMPLEMENTED: '\(fn)'")
  }
}
