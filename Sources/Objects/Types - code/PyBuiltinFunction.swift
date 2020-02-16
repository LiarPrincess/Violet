// In CPython:
// Objects -> methodobject.c

// sourcery: pytype = builtinFunction, default, hasGC
/// This is about the type `builtin_function_or_method`,
/// not Python methods in user-defined classes.
public class PyBuiltinFunction: PyObject, PyBuiltinFunctionShared {

  /// The Swift function that will be called.
  internal let function: FunctionWrapper
  /// The `__module__` attribute, can be anything
  internal let module: PyObject?
  /// The `__doc__` attribute, or `nil`.
  internal let doc: String?

  override public var description: String {
    return "PyBuiltinFunction(name: \(self.name))"
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
  public func isEqual(_ other: PyObject) -> CompareResult {
    return self.isEqualShared(other)
  }

  // sourcery: pymethod = __ne__
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isNotEqualShared(other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return self.isLessShared(other)
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.isLessEqualShared(other)
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return self.isGreaterShared(other)
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.isGreaterEqualShared(other)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
    return self.hashShared()
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
    return .value("<built-in function \(self.name)>")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return self.getAttributeShared(name: name)
  }

  public func getAttribute(name: String) -> PyResult<PyObject> {
    return self.getAttributeShared(name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__
  public func getName() -> String {
    return self.name
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__
  public func getQualname() -> String {
    return self.name
  }

  // MARK: - TextSignature

  // sourcery: pyproperty = __text_signature__
  public func getTextSignature() -> String? {
    return self.getTextSignatureShared()
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__
  public func getModule() -> PyResult<String> {
    return self.getModuleShared()
  }

  // MARK: - Self

  // sourcery: pyproperty = __self__
  public func getSelf() -> PyObject {
    return Py.none
  }

  // MARK: - Get

  // sourcery: pymethod = __get__
  public func get(object: PyObject, type: PyObject) -> PyResult<PyObject> {
    if object.isDescriptorStaticMarker {
      return .value(self)
    }

    return .value(self.bind(to: object))
  }

  public func bind(to object: PyObject) -> PyBuiltinMethod {
    return PyBuiltinMethod(fn: self.function,
                           object: object,
                           module: self.module,
                           doc: self.doc)
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
  public func call(args: [PyObject],
                   kwargs: PyDictData?) -> PyResult<PyObject> {
    return self.function.call(args: args, kwargs: kwargs)
  }
}
