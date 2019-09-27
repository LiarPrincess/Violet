// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// TODO: PyStopIterationType
// {"value", T_OBJECT, offsetof(PyStopIterationObject, value), 0, PyDoc_STR("... ")},
// StopIteration_init(PyStopIterationObject *self, PyObject *args, PyObject *kwds)

internal final class PyStopIteration: PyBaseException {

  internal var value: PyObject

  fileprivate init(type: PySystemExitType,
                   args: PyTuple,
                   traceback: PyObject,
                   context: PyObject,
                   cause:   PyObject,
                   suppressContext: Bool,
                   value: PyObject) {
    self.value = value
    super.init(type: type,
               args: args,
               traceback: traceback,
               context: context,
               cause: cause,
               suppressContext: suppressContext)
  }
}

internal class PyStopIterationType: PyExceptionType {
  override internal var name: String { return "StopIteration" }
  override internal var base: PyType? { return self.exceptionType }
  override internal var doc: String? {
    return "Signal the end from iterator.__next__()."
  }

  override internal func clear(value: PyObject) throws {
    let e = try self.matchStopIteration(value)
    try self.context.Py_CLEAR(value: e.value)
    try super.clear(value: value)
  }

  internal func matchStopIteration(_ object: PyObject) throws -> PyStopIteration {
    if let e = object as? PyStopIteration {
      return e
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}

internal class PyStopAsyncIterationType: PyExceptionType {
  override internal var name: String { return "StopAsyncIteration" }
  override internal var base: PyType? { return self.exceptionType }
  override internal var doc: String? {
    return "Signal the end from iterator.__anext__()."
  }
}
