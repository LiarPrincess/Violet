import Objects

/// In CPython part of `PyThreadState`.
internal struct ExceptionStack {

  /// Exception currently being handled.
  ///
  /// CPython: `_PyErr_StackItem *exc_info`
  internal var current: PyBaseException?

/*
  /// Exceptions currently being handled.
  ///
  /// CPython: `_PyErr_StackItem *exc_info`
  private var elements = [PyBaseException]()

  /// Exception currently being handled.
  ///
  /// ```py
  /// _PyErr_StackItem *
  /// _PyErr_GetTopmostException(PyThreadState *tstate)
  /// ```
  internal var current: PyBaseException? {
    return self.elements.last
  }

  // MARK: - Push

  /// void
  /// PyErr_SetObject(PyObject *exception, PyObject *value)
  internal mutating func push(type typeObject: PyObject,
                              value valueObject: PyObject?) -> PyResult<()> {
    // Handle type
    guard let type = typeObject as? PyType, type.isException else {
      let msg = "exception '\(typeObject.typeName)' not a BaseException subclass"
      return .systemError(msg)
    }

    // No value -> no problem
    guard let valueObject = valueObject else {
      return Py.newException(type: type, value: nil)
        .flatMap { self.push(type: type, value: $0) }
    }

    // Is it already exception -> pass it
    if let e = valueObject as? PyBaseException {
      assert(e.type.isSubtype(of: type))
      return self.push(type: type, value: e)
    }

    // Not exception -> wrap
    return Py.newException(type: type, value: valueObject)
      .flatMap { self.push(type: type, value: $0) }
  }

  /// void
  /// PyErr_SetObject(PyObject *exception, PyObject *value)
  private mutating func push(value: PyBaseException) {
    // If we already have an exception then set it as a 'context' to the new
    // exception. CPython calls is 'Implicit exception chaining'.
    if let current = self.current, current !== value {
      // When we want to set new exception as the 'current' exception,
      // we have to check if this exception is already in exception stack.
      // Otherwise we would create a cycle.
      // (And yes, it is possible to raise the same exception multiple times)
      self.avoidCycleInContexts(current: current, value: value)

      // Set the context of new exception to old exception.
      value.setContext(current)
    }

    self.elements.push(value)
  }

  /// See comment in `setObject(value: PyBaseException?)`.
  private func avoidCycleInContexts(current: PyBaseException,
                                    value: PyBaseException) {
    guard current !== value else {
      return
    }

    var o = current

    // Traverse contexts down looking for 'value'.
    while let context = o.getContext() {
      if context === value {
        // Clear context
        // We can finish iteration, because when setting 'context' exception
        // we also ran 'avoidCycleInContext'.
        o.delContext()
        return
      }

      o = context
    }
  }
*/
}
