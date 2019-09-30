// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// TODO: PyImportErrorType
// {"msg", T_OBJECT, offsetof(PyImportErrorObject, msg), 0, PyDoc_STR ...},
// {"name", T_OBJECT, offsetof(PyImportErrorObject, name), 0, PyDoc_STR ...},
// {"path", T_OBJECT, offsetof(PyImportErrorObject, path), 0, PyDoc_STR ...},
// {"__reduce__", (PyCFunction)ImportError_reduce, METH_NOARGS},

internal final class PyImportError: PyBaseException {
  internal var msg: PyObject
  internal var name: PyObject
  internal var path: PyObject

  fileprivate init(type: PySystemExitType,
                   args: PyTuple,
                   traceback: PyObject,
                   context: PyObject,
                   cause:   PyObject,
                   suppressContext: Bool,
                   msg: PyObject,
                   name: PyObject,
                   path: PyObject) {
    self.msg = msg
    self.name = name
    self.path = path
    super.init(type: type,
               args: args,
               traceback: traceback,
               context: context,
               cause: cause,
               suppressContext: suppressContext)
  }
}

internal class PyImportErrorType: PyExceptionType {

  override internal var name: String { return "ImportError" }
  override internal var base: PyType? { return self.context.errorTypes.exception }
  override internal var doc: String? {
    return "Import can't find module, or can't find name in module"
  }

  override internal func clear(value: PyObject) throws {
    let e = try self.matchImportError(value)
    try self.context.Py_CLEAR(value: e.msg)
    try self.context.Py_CLEAR(value: e.name)
    try self.context.Py_CLEAR(value: e.path)
    try super.clear(value: value)
  }

  override internal func str(value: PyObject) throws -> String {
    let e = try self.matchImportError(value)

    if let msg = self.context.types.unicode.extract(value: e.msg) {
      return msg
    }

    return try super.str(value: value)
  }

  internal func matchImportError(_ object: PyObject) throws -> PyImportError {
    if let e = object as? PyImportError {
      return e
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}

internal final class PyModuleNotFoundErrorType: PyImportErrorType {
  override internal var name: String { return "ModuleNotFoundError" }
  override internal var base: PyType? { return self.context.errorTypes.import }
  override internal var doc: String? {
    return "Module not found."
  }
}
