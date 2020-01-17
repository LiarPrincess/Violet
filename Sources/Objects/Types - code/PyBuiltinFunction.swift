// In CPython:
// Objects -> methodobject.c

// sourcery: pytype = builtinFunction, default, hasGC
/// This is about the type `builtin_function_or_method`,
/// not Python methods in user-defined classes.
public class PyBuiltinFunction: PyObject {

  /// The Swift function that will be called.
  internal let function: FunctionWrapper
  /// **Optional** instance it is bound to.
  internal let object: PyObject?
  /// The `__doc__` attribute, or `nil`.
  internal let doc: String?

  /// The name of the built-in function/method.
  internal var name: String {
    return self.function.name
  }

  override public var description: String {
    return "PyBuiltinFunction(name: \(self.name))"
  }

  // MARK: - Init

  internal init(fn: FunctionWrapper,
                object: PyObject? = nil,
                doc: String? = nil) {
    self.function = fn
    self.object = object
    self.doc = doc
    super.init(type: Py.types.builtinFunction)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .notImplemented
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    guard let object = self.object else {
      return .value("<built-in function \(self.name)>")
    }

    if object is PyModule {
      return .value("<built-in function \(self.name)>")
    }

    let ptr = object.ptrString
    let type = object.typeName
    return .value("<built-in method \(self.name) of \(type) object at \(ptr)>")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Properties

  // sourcery: pyproperty = __name__
  internal func getName() -> String {
    return self.name
  }

  // sourcery: pyproperty = __qualname__
  internal func getQualname() -> String {
    // If __self__ is a module or NULL, return m.__name__
    // (e.g. len.__qualname__ == 'len')
    guard let object = self.object else {
      return self.name
    }

    if object is PyModule {
      return self.name
    }

    // If __self__ is a type, return m.__self__.__qualname__ + '.' + m.__name__
    // (e.g. dict.fromkeys.__qualname__ == 'dict.fromkeys')
    var type = object.type
    if let ifObjectIsTypeThenUseItAsType = object as? PyType {
      type = ifObjectIsTypeThenUseItAsType
    }

    // Return type(m.__self__).__qualname__ + '.' + m.__name__
    // (e.g. [].append.__qualname__ == 'list.append')
    let typeQualname = type.getQualname()
    return typeQualname + "." + self.name
  }

  // sourcery: pyproperty = __text_signature__
  internal func getTextSignature() -> String? {
    return self.doc.flatMap(DocHelper.getSignature)
  }

  // sourcery: pyproperty = __module__
  internal func getModule() -> PyResult<String> {
    return .value("builtins")
  }

  // sourcery: pyproperty = __self__
  internal func getSelf() -> PyObject {
    return self.object ?? Py.none
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
    let realArgs = self.prependSelfIfNeeded(args: args)
    return self.function.call(args: realArgs, kwargs: kwargs)
  }

  /// PyObject *
  /// _PyObject_Call_Prepend(PyObject *callable,
  ///                        PyObject *obj, PyObject *args, PyObject *kwargs)
  private func prependSelfIfNeeded(args: [PyObject]) -> [PyObject] {
    if let object = self.object {
      return [object] + args
    }

    return args
  }
}
