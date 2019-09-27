import Core

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html

// TODO: PyBaseExceptionType:
// PyObject_GenericGetAttr,    /*tp_getattro*/
// PyObject_GenericSetAttr,    /*tp_setattro*/
// (traverseproc)BaseException_traverse, /* tp_traverse */
// {"__suppress_context__", T_BOOL, offsetof(PyBaseExceptionObject, ...)},
// {"__reduce__", (PyCFunction)BaseException_reduce, METH_NOARGS },
// {"__setstate__", (PyCFunction)BaseException_setstate, METH_O },
// {"with_traceback", (PyCFunction)BaseException_with_traceback, METH_O, ...},
// {"__dict__", PyObject_GenericGetDict, PyObject_GenericSetDict},
// {"args", (getter)BaseException_get_args, (setter)BaseException_set_args},
// {"__traceback__", (getter)BaseException_get_tb, (setter)BaseException_set_tb},
// {"__context__", BaseException_get_context, BaseException_set_context, ...},
// {"__cause__", BaseException_get_cause, BaseException_set_cause, ...},

internal class PyBaseException: PyObject {

  internal var args: PyTuple
  internal var traceback: PyObject
  internal var context: PyObject
  internal var cause: PyObject
  internal var suppressContext: Bool

  internal init(type: PyBaseExceptionType,
                args: PyTuple,
                traceback: PyObject,
                context: PyObject,
                cause:   PyObject,
                suppressContext: Bool) {
    self.args = args
    self.traceback = traceback
    self.context = context
    self.cause = cause
    self.suppressContext = suppressContext
    super.init(type: type)
  }
}

internal class PyBaseExceptionType: PyType,
ReprTypeClass, StrTypeClass, ClearTypeClass {

  internal var name: String { return "BaseException" }
  internal var base: PyType? { return nil }
  internal var doc: String? { return "Common base class for all exceptions" }

  internal var tupleType: PyTupleType {
    return self.context.types.tuple
  }

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }

  internal func repr(value: PyObject) throws -> String {
    let e = try self.matchBaseException(value)
    let size = try self.tupleType.lengthInt(value: e.args)
    let name = self.context._PyType_Name(value: value.type)

    switch size {
    case 1:
      let item = try tupleType.item(owner: e.args, at: 0)
      return self.context.PyUnicode_FromFormat(format: "%s(%R)", args: name, item)
    default:
      return self.context.PyUnicode_FromFormat(format: "%s%R", args: name, e.args)
    }
  }

  internal func str(value: PyObject) throws -> String {
    let e = try self.matchBaseException(value)
    let size = try self.tupleType.lengthInt(value: e.args)

    switch size {
    case 0:
      return ""
    case 1:
      let item = try tupleType.item(owner: e.args, at: 0)
      return try self.context.PyObject_Str(value: item)
    default:
      return try self.context.PyObject_Str(value: e.args)
    }
  }

  internal func clear(value: PyObject) throws {
    let e = try self.matchBaseException(value)
    try self.context.Py_CLEAR(value: e.args)
    try self.context.Py_CLEAR(value: e.traceback)
    try self.context.Py_CLEAR(value: e.cause)
    try self.context.Py_CLEAR(value: e.context)
  }

  internal func matchBaseException(_ object: PyObject) throws -> PyBaseException {
    if let e = object as? PyBaseException {
      return e
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
