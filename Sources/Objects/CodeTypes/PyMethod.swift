import Bytecode

// In CPython:
// Objects -> classobject.c

// TODO: Method
// {"__func__", T_OBJECT, MO_OFF(im_func), READONLY|RESTRICTED, ... }
// {"__self__", T_OBJECT, MO_OFF(im_self), READONLY|RESTRICTED, ... }

// TODO: InstanceMethod
// {"__func__", T_OBJECT, IMO_OFF(func), READONLY|RESTRICTED, ... },

// MARK: - Method

// sourcery: pytype = method
internal final class PyMethod: PyObject {

  internal static let doc: String = """
    method(function, instance)

    Create a bound instance method object.
    """

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

  internal func repr() -> String {
    let funcNameObject = self._func._dict?["__qualname__"] ??
                         self._func._dict?["__name__"]

    var funcName = ""
    if let str = funcNameObject as? PyString {
      funcName = str.value
    }

    let ptr = self._self.ptrString
    let type = self._self.type.name
    return "<bound method \(funcName) of \(type) object at \(ptr)>"
  }

  // MARK: - Call

  internal func call() -> PyResult<PyObject> {
    fatalError()
  }
}

// MARK: - InstanceMethod
/*
// sourcery: pytype = instancemethod
internal final class PyInstanceMethod: PyObject {

  internal static let doc: String = """
    instancemethod(function)

    Bind a function to a class.
    """

  /// The callable object implementing the method
  internal let _func: PyFunction

  internal init(_ context: PyContext, func: PyFunction) {
    self._func = `func`
    #warning("Add to PyContext")
    super.init()
  }

  // MARK: - String

  internal func repr() -> String {
    let funcNameObject = self._func._dict?["__name__"]

    var funcName = ""
    if let str = funcNameObject as? PyString {
      funcName = str.value
    }

    return "<instancemethod \(funcName) at \(self.ptrString)>"
  }

  // MARK: - Call

  internal func call() -> PyResult<PyObject> {
    // instancemethod_call(PyObject *self, PyObject *arg, PyObject *kw)
    fatalError()
  }
}
*/
