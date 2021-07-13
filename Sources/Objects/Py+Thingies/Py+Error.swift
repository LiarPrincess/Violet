import Foundation

// In CPython:
// Objects -> exceptions.c
// Python -> errors.c
// https://docs.python.org/3.7/library/exceptions.html

extension PyInstance {

  // MARK: - Exception matches

  /// Check if a given `exception` is an instance of `expectedType`.
  ///
  /// CPython:
  /// ```py
  /// int
  /// PyErr_GivenExceptionMatches(PyObject *err, PyObject *exc)
  /// ```
  ///
  /// - Parameters:
  ///   - exception: Exception instance/type.
  ///   - expectedType: Exception type to check against (tuples are also allowed).
  public func exceptionMatches(exception: PyObject,
                               expectedType: PyObject) -> Bool {
    if let tuple = PyCast.asTuple(expectedType) {
      return tuple.elements.contains {
        self.exceptionMatches(exception: exception, expectedType: $0)
      }
    }

    if let type = PyCast.asType(expectedType) {
      return self.exceptionMatches(exception: exception, expectedType: type)
    }

    return false
  }

  private func exceptionMatches(exception: PyObject,
                                expectedType: PyType) -> Bool {
    // 'error' is a type
    if let type = PyCast.asType(exception) {
      return self.exceptionMatches(type: type, expectedType: expectedType)
    }

    // 'error' is an error instance, so check its class
    return self.exceptionMatches(type: exception.type, expectedType: expectedType)
  }

  /// Final version of `exceptionMatches` where we compare types.
  private func exceptionMatches(type: PyType,
                                expectedType: PyType) -> Bool {
    guard type.isException else {
      return false
    }

    guard expectedType.isException else {
      return false
    }

    return type.isSubtype(of: expectedType)
  }

  // MARK: - Args

  public func getArgs(exception: PyBaseException) -> PyTuple {
    return exception.getArgs()
  }

  public func setArgs(exception: PyBaseException, args: PyTuple) {
    exception.setArgs(args)
  }

  // MARK: - Cause

  public func getCause(exception: PyBaseException) -> PyBaseException? {
    return exception.getCause()
  }

  public func setCause(exception: PyBaseException, cause: PyBaseException) {
    exception.setCause(cause)
  }

  // MARK: - Context

  /// Context - another exception during whose handling this exception was raised.
  public func getContext(exception: PyBaseException) -> PyBaseException? {
    return exception.getContext()
  }

  /// Context - another exception during whose handling this exception was raised.
  public func setContextUsingCurrentlyHandledExceptionFromDelegate(
    on exception: PyBaseException,
    overrideCurrent: Bool
  ) {
    // No current -> nothing to do
    guard let current = self.delegate.currentlyHandledException else {
      return
    }

    let hasEmptyContext = exception.getContext()?.isNone ?? true
    guard hasEmptyContext || overrideCurrent else {
      return
    }

    exception.setContext(current, checkAndPossiblyBreakCycle: true)
  }

  // MARK: - Traceback

  public func newTraceback(frame: PyFrame,
                           exception: PyBaseException?) -> PyTraceback {
    let traceback = exception?.getTraceback()
    return self.newTraceback(frame: frame, next: traceback)
  }

  public func newTraceback(frame: PyFrame,
                           next: PyTraceback?) -> PyTraceback {
    let instruction = self.newInt(frame.currentInstructionIndex ?? 0)
    let line = self.newInt(frame.currentInstructionLine)

    return PyTraceback(next: next,
                       frame: frame,
                       lastInstruction: instruction,
                       lineNo: line)
  }

  public func getTraceback(exception: PyBaseException) -> PyTraceback? {
    return exception.getTraceback()
  }

  /// Add traceback to given `error` using given `frame`.
  public func addTraceback(to exception: PyBaseException, frame: PyFrame) {
    let current = exception.getTraceback()
    let new = self.newTraceback(frame: frame, next: current)
    exception.setTraceback(traceback: new)
  }

  public func getFrame(traceback: PyTraceback) -> PyFrame {
    return traceback.getFrame()
  }
}
