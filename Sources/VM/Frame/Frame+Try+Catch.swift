import Objects
import Bytecode

extension Frame {

  // MARK: - Setup

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `delta` points to the first except block.
  internal func setupExcept(firstExceptLabelIndex: Int) -> InstructionResult {
    let label = self.getLabel(index: firstExceptLabelIndex)
    let block = Block(type: .setupExcept, handler: label, level: self.stackLevel)
    self.pushBlock(block: block)
    return .ok
  }

  /// Pushes a try block from a try-except clause onto the block stack.
  /// `delta` points to the finally block.
  internal func setupFinally(finallyStartLabelIndex: Int) -> InstructionResult {
    let label = self.getLabel(index: finallyStartLabelIndex)
    let block = Block(type: .setupFinally, handler: label, level: self.stackLevel)
    self.pushBlock(block: block)
    return .ok
  }

  // MARK: - Pop

  /// Removes one block from the block stack.
  /// The popped block must be an exception handler block,
  /// as implicitly created when entering an except handler.
  /// In addition to popping extraneous values from the frame stack,
  /// the last three popped values are used to restore the exception state.
  internal func popExcept() -> InstructionResult {
    let block = self.popBlockInner()

    if block.type != .exceptHandler {
      let msg = "popped block is not an except handler"
      return .error(Py.newSystemError(msg: msg))
    }

    self.unwindExceptHandler(block: block)
    return .ok
  }

  // MARK: - Raise

  /// Raises an exception using one of the 3 forms of the raise statement,
  /// depending on the value of argc:
  /// - 0: raise (re-raise previous exception)
  /// - 1: raise TOS (raise exception instance or type at TOS)
  /// - 2: raise TOS1 from TOS (raise exception instance or type at TOS1
  ///      with Cause set to TOS)
  internal func raiseVarargs(arg: RaiseArg) -> InstructionResult {
    /*
    var cause: PyObject?
    var exception: PyObject?

    switch arg {
    case .exceptionAndCause: // CPython 2
      cause = self.stack.pop()
      fallthrough // swiftlint:disable:this fallthrough
    case .exceptionOnly: // CPython 1
      exception = self.stack.pop()
      fallthrough // swiftlint:disable:this fallthrough
    case .reRaise: // CPython 0
      self.raise(exception: exception, cause: cause)
      // return .unwind(.exception(PyObject))
      fatalError()
    }
 */
    return .ok
  }

  /*
  private enum RaiseResult {
    case raise
    case error(PyErrorEnum)
  }

  /// static int
  /// do_raise(PyObject *exc, PyObject *cause)
  private func raise(exception: PyObject?, cause: PyObject?) -> RaiseResult {
    guard let exception = exception else {
      // _PyErr_StackItem *exc_info = _PyErr_GetTopmostException(tstate)
      fatalError()
    }

    var valueOrNil: PyBaseException?
    var typeOrNil: PyType?
    if let exceptionType = exception as? PyType, exceptionType.isException {
      typeOrNil = exceptionType
      switch self.createInstance(exceptionType: exceptionType) {
      case let .value(v): valueOrNil = v
      case let .error(e): return .error(e)
      }
    } else if let exceptionInstance = exception as? PyBaseException {
      valueOrNil = exceptionInstance
      typeOrNil = exceptionInstance.type
    }

    guard let value = valueOrNil, let type = typeOrNil else {
      return .error(.typeError("exceptions must derive from BaseException"))
    }

    switch self.parseCause(from: cause) {
    case .none: break
    case .object(let o): break // TODO: PyException_SetCause(value, fixed_cause);
    case .error(let e): return .error(e)
    }

    fatalError()
  }

  private enum CauseResult {
    case none
    case object(PyObject)
    case error(PyErrorEnum)
  }

  private func parseCause(from cause: PyObject?) -> CauseResult {
    guard let cause = cause else {
      return .none
    }

    if cause is PyNone {
      return .none
    }

    if let exceptionType = cause as? PyType, exceptionType.isException {
      switch self.createInstance(exceptionType: exceptionType) {
      case let .value(o): return .object(o)
      case let .error(e): return .error(e)
      }
    }

    if let exceptionInstance = cause as? PyBaseException {
      return .object(exceptionInstance)
    }

    return .error(.typeError("exception causes must derive from BaseException"))
  }

  private func createInstance(exceptionType: PyType) -> PyResult<PyBaseException> {
    assert(exceptionType.isException)

    switch self.builtins.call(callable: exceptionType, args: []) {
    case .value(let o):
      guard let exception = o as? PyBaseException else {
        let msg = "calling '\(exceptionType.getName())' should have returned " +
                  "an instance of BaseException, not \(o.typeName)"
        return .typeError(msg)
      }

      return .value(exception)

    case .notImplemented, .notCallable:
      let msg = "calling '\(exceptionType.getName())' should have returned " +
                "an instance of BaseException"
      return .typeError(msg)

    case .error(let e):
      return .error(e)
    }
  }
*/
}
