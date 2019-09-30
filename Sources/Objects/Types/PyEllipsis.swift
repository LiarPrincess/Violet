import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html

// TODO: Ellipsis:
// PyObject_GenericGetAttr,            /* tp_getattro */
// {"__reduce__", (PyCFunction)ellipsis_reduce, METH_NOARGS, NULL},

/// The Python Ellipsis object. This object has no methods.
/// Like Py_None it is a singleton object.
internal final class PyEllipsis: PyObject {
  fileprivate init(type: PyEllipsisType) {
    super.init(type: type)
  }
}

/// The type object for slice objects.
/// This is the same as slice in the Python layer.
internal final class PyEllipsisType: PyType, ReprTypeClass {

  override internal var name: String { return "ellipsis" }
  internal let base: PyType? = nil
  internal let doc:  String? = nil

  internal lazy var value = PyEllipsis(type: self)

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }

  internal func new() -> PyEllipsis {
    return self.value
  }

  internal func repr(value: PyObject) throws -> String {
    return "Ellipsis"
  }
}
