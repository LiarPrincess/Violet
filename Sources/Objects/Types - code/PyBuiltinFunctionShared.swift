/// Shared methods for `PyBuiltinFunction` and `PyBuiltinMethod`.
internal protocol PyBuiltinFunctionShared {

  /// The Swift function that will be called.
  var function: FunctionWrapper { get }
  /// **Optional** instance it is bound to (`__self__`).
  var object: PyObject? { get }
  /// The `__module__` attribute, can be anything
  var module: PyObject? { get }
  /// The `__doc__` attribute, or `nil`.
  var doc: String? { get }
}

extension PyBuiltinFunctionShared where Self: PyObject {

  /// The name of the built-in function/method.
  internal var name: String {
    return self.function.name
  }

  internal func descriptionShared(type: String) -> String {
    return "PyBuiltin\(type)(name: \(self.name))"
  }

  // MARK: - Equatable

  internal func isEqualShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  internal func isNotEqualShared(_ other: PyObject) -> CompareResult {
    return self.isEqualShared(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLessShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqualShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreaterShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqualShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hashShared() -> HashResult {
    return .notImplemented
  }

  // MARK: - String

  internal func reprShared(type: String) -> PyResult<String> {
    guard let object = self.object else {
      return .value("<built-in \(type) \(self.name)>")
    }

    if object is PyModule {
      return .value("<built-in \(type) \(self.name)>")
    }

    let ptr = object.ptrString
    let type = object.typeName
    return .value("<built-in \(type) \(self.name) of \(type) object at \(ptr)>")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttributeShared(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  internal func getAttributeShared(name: String) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Name

  // sourcery: pyproperty = __name__
  internal func getNameShared() -> String {
    return self.name
  }

  // MARK: - Qualname

  // sourcery: pyproperty = __qualname__
  internal func getQualnameShared() -> String {
    // If __self__ is a module or nil, return __name__, for example:
    // >>> len.__qualname__
    // 'len'
    guard let object = self.object else {
      return self.name
    }

    if object is PyModule {
      return self.name
    }

    // If __self__ is a type, return m.__self__.__qualname__ + '.' + m.__name__
    // >>> dict.fromkeys.__qualname__ # 'dict' is a type, so use it!
    // 'dict.fromkeys'
    var type = object.type
    if let ifObjectIsTypeThenUseItAsType = object as? PyType {
      type = ifObjectIsTypeThenUseItAsType
    }

    // Return type(m.__self__).__qualname__ + '.' + m.__name__
    // >>> [].append.__qualname__
    // 'list.append'
    let typeQualname = type.getQualname()
    return typeQualname + "." + self.name
  }

  // MARK: - TextSignature

  // sourcery: pyproperty = __text_signature__
  internal func getTextSignatureShared() -> String? {
    return self.doc.flatMap(DocHelper.getSignature)
  }

  // MARK: - Module

  // sourcery: pyproperty = __module__
  internal func getModuleShared() -> PyResult<String> {
    guard let moduleObject = self.module else {
      return .value("")
    }

    if let module = moduleObject as? PyModule {
      return module.name
    }

    return Py.strValue(moduleObject)
  }

  // MARK: - Self

  // sourcery: pyproperty = __self__
  internal func getSelfShared() -> PyObject {
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
  internal func callShared(args: [PyObject],
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

