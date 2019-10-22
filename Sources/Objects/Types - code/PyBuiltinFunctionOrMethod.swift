// In CPython:
// Objects -> methodobject.c

//static PyGetSetDef meth_getsets [] = {
//  {"__doc__",  (getter)meth_get__doc__,  NULL, NULL},
//  {"__name__", (getter)meth_get__name__, NULL, NULL},
//  {"__qualname__", (getter)meth_get__qualname__, NULL, NULL},
//  {"__self__", (getter)meth_get__self__, NULL, NULL},
//  {"__text_signature__", (getter)meth_get__text_signature__, NULL, NULL},
//static PyMemberDef meth_members[] = {
//{"__module__",    T_OBJECT,     OFF(m_module), PY_WRITE_RESTRICTED},

// sourcery: pytype = builtinFunction
internal final class PyBuiltinFunctionOrMethod: PyObject {

  /// The callable object implementing the method
  internal let _func: PyFunction
  /// The instance it is bound to
  internal let _self: PyObject

  internal init(_ context: PyContext, func: PyFunction, self _self: PyObject) {
    self._func = `func`
    self._self = _self
    #warning("Add to PyContext")
    super.init()
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    let name = self._func.getName()

    if self._self is PyModule {
      return "<built-in function \(name)>"
    }

    let ptr = self._self.ptrString
    let type = self._self.typeName
    return "<built-in method \(name) of \(type) object at \(ptr)>"
  }
}
