// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// TODO: PySyntaxErrorType
// {"msg", T_OBJECT, offsetof(PySyntaxErrorObject, msg), 0, PyDoc_STR ... },
// {"filename", T_OBJECT, offsetof(PySyntaxErrorObject, filename), 0, PyDoc_STR ... },
// {"lineno", T_OBJECT, offsetof(PySyntaxErrorObject, lineno), 0, PyDoc_STR ... },
// {"offset", T_OBJECT, offsetof(PySyntaxErrorObject, offset), 0, PyDoc_STR ... },
// {"text", T_OBJECT, offsetof(PySyntaxErrorObject, text), 0, PyDoc_STR ... },
// {"print_file_and_line", T_OBJECT, offsetof(PySyntaxErrorObject, ... },
// SyntaxError_str(PySyntaxErrorObject *self)

internal final class PySyntaxError: PyBaseException {
  internal var msg: PyObject
  internal var filename: PyObject
  internal var lineno: PyObject
  internal var offset: PyObject
  internal var text: PyObject
  internal var printFileAndLine: PyObject

  fileprivate init(type: PySyntaxErrorType,
                   args: PyTuple,
                   traceback: PyObject,
                   context: PyObject,
                   cause:   PyObject,
                   suppressContext: Bool,
                   msg: PyObject,
                   filename: PyObject,
                   lineno: PyObject,
                   offset: PyObject,
                   text: PyObject,
                   printFileAndLine: PyObject) {
    self.msg = msg
    self.filename = filename
    self.lineno = lineno
    self.offset = offset
    self.text = text
    self.printFileAndLine = printFileAndLine
    super.init(type: type,
               args: args,
               traceback: traceback,
               context: context,
               cause: cause,
               suppressContext: suppressContext)
  }
}

internal class PySyntaxErrorType: PyExceptionType {
  override internal var name: String { return "SyntaxError" }
  override internal var base: PyType? { return self.context.errorTypes.exception }
  override internal var doc: String? {
    return "Invalid syntax."
  }

  override internal func clear(value: PyObject) throws {
    let e = try self.matchSyntaxError(value)
    try self.context.Py_CLEAR(value: e.msg)
    try self.context.Py_CLEAR(value: e.filename)
    try self.context.Py_CLEAR(value: e.lineno)
    try self.context.Py_CLEAR(value: e.offset)
    try self.context.Py_CLEAR(value: e.text)
    try self.context.Py_CLEAR(value: e.printFileAndLine)
    try super.clear(value: value)
  }

  internal func matchSyntaxError(_ object: PyObject) throws -> PySyntaxError {
    if let e = object as? PySyntaxError {
      return e
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}

internal class PyIndentationErrorType: PySyntaxErrorType {
  override internal var name: String { return "IndentationError" }
  override internal var base: PyType? { return self.context.errorTypes.syntax }
  override internal var doc: String? {
    return "Improper indentation."
  }
}

internal class PyTabErrorType: PySyntaxErrorType {
  override internal var name: String { return "TabError" }
  override internal var base: PyType? { return self.context.errorTypes.syntax }
  override internal var doc: String? {
    return "Improper mixture of spaces and tabs."
  }
}
