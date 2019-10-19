import Core
/*
// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// TODO: PySystemExit
// SystemExit_init(PySystemExitObject *self, PyObject *args, PyObject *kwds)
// SystemExit_traverse(PySystemExitObject *self, visitproc visit, void *arg)
// {"code", T_OBJECT, offsetof(PySystemExitObject, code), 0,

internal final class PySystemExit: PyBaseException {

  internal var code: PyObject

  fileprivate init(type: PySystemExitType,
                   args: PyTuple,
                   traceback: PyObject,
                   context: PyObject,
                   cause:   PyObject,
                   suppressContext: Bool,
                   code: PyObject) {
    self.code = code
    super.init(type: type,
               args: args,
               traceback: traceback,
               context: context,
               cause: cause,
               suppressContext: suppressContext)
  }
}

internal final class PySystemExitType: PyBaseExceptionType {
  override internal var name: String { return "SystemExit" }
  override internal var base: PyType? { return self.errorTypes.base }
  override internal var doc: String? {
    return "Request to exit from the interpreter."
  }

  override internal func clear(value: PyObject) throws {
    let e = try self.matchSystemExit(value)
    try self.context.Py_CLEAR(value: e.code)
    try super.clear(value: value)
  }

  internal func matchSystemExit(_ object: PyObject) throws -> PySystemExit {
    if let e = object as? PySystemExit {
      return e
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
*/
