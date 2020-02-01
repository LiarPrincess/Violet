// In CPython:
// Objects -> methodobject.c

// sourcery: pytype = builtinFunction, default, hasGC
/// This is about the type `builtin_function_or_method`,
/// not Python methods in user-defined classes.
public class PyBuiltinFunction: PyObject, PyBuiltinFunctionShared {

  /// The Swift function that will be called.
  internal let function: FunctionWrapper
  /// **Optional** instance it is bound to (`__self__`).
  internal var object: PyObject? { return nil }
  /// The `__module__` attribute, can be anything
  internal let module: PyObject?
  /// The `__doc__` attribute, or `nil`.
  internal let doc: String?

  override public var description: String {
    return self.descriptionShared(type: "Function")
  }

  // MARK: - Init

  internal init(fn: FunctionWrapper,
                module: PyObject? = nil,
                doc: String? = nil) {
    self.function = fn
    self.module = module
    self.doc = doc
    super.init(type: Py.types.builtinFunction)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self.isEqualShared(other)
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isNotEqualShared(other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self.isLessShared(other)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.isLessEqualShared(other)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self.isGreaterShared(other)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.isGreaterEqualShared(other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return self.hashShared()
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    return self.reprShared(type: "function")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return self.getAttributeShared(name: name)
  }

  internal func getAttribute(name: String) -> PyResult<PyObject> {
    return self.getAttributeShared(name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__
  internal func getName() -> String {
    return self.getNameShared()
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__
  internal func getQualname() -> String {
    return self.getQualnameShared()
  }

  // MARK: - TextSignature

  // sourcery: pyproperty = __text_signature__
  internal func getTextSignature() -> String? {
    return self.getTextSignatureShared()
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__
  internal func getModule() -> PyResult<String> {
    return self.getModuleShared()
  }

  // MARK: - Self

  // sourcery: pyproperty = __self__
  internal func getSelf() -> PyObject {
    return self.getSelfShared()
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  internal func get(object: PyObject, type: PyObject) -> PyResult<PyObject> {
    if object is PyNone {
      return .value(self)
    }

    let result = PyBuiltinMethod(fn: self.function,
                                 object: object,
                                 module: self.module,
                                 doc: self.doc)

    return .value(result)
  }

  // MARK: - Call

  // sourcery: pymethod = __call__
  /// PyObject *
  /// PyCFunction_Call(PyObject *func, PyObject *args, PyObject *kwargs)
  /// _PyMethodDef_RawFastCallDict(PyMethodDef *method,
  ///                              PyObject *self,
  ///                              PyObject *const *args, Py_ssize_t nargs,
  ///                              PyObject *kwargs)
  /// static PyObject *
  /// slot_tp_call(PyObject *self, PyObject *args, PyObject *kwds)
  internal func call(args: [PyObject],
                     kwargs: PyDictData?) -> PyResult<PyObject> {
    return self.callShared(args: args, kwargs: kwargs)
  }
}
