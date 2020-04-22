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

  /// PyObject *format_spec
  /// PyObject_Format(PyObject *obj, PyObject *)
  public func format(value: PyObject,
                     format _format: PyObject?) -> PyResult<PyObject> {
    // Move this to 'Py.format' after we finish the whole implementation.
    let format: PyString?
    switch self.parseFormat(format: _format) {
    case .nil: format = nil
    case .string(let s): format = s
    case .error(let e): return .error(e)
    }

    // Fast path for common types
    let isFormatEmpty = format?.value.isEmpty ?? true
    if isFormatEmpty {
      if let str = value as? PyString {
        return .value(str)
      }

      if let int = value as? PyInt {
        let str = int.reprRaw()
        return .value(Py.newString(str))
      }
    }

    self.unimplemented()
  }

  private enum ParseFormatResult {
    case `nil`
    case string(PyString)
    case error(PyBaseException)
  }

  private func parseFormat(format: PyObject?) -> ParseFormatResult {
    guard let format = format else {
      return .nil
    }

    guard let str = format as? PyString else {
      let t = format.typeName
      let msg = "Format specifier must be a string, not \(t)"
      return .error(Py.newTypeError(msg: msg))
    }

    return .string(str)
  }

  // MARK: - Unimplemented

  private func unimplemented(fn: StaticString = #function) -> Never {
    trap("NOT IMPLEMENTED: '\(fn)'")
  }
}
