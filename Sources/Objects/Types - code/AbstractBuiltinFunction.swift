/// Shared methods for `PyBuiltinFunction` and `PyBuiltinMethod`.
///
/// Note that `CPython` uses the same implementation for `PyBuiltinFunction`
/// and `PyBuiltinMethod`, but we will separate them.
internal protocol AbstractBuiltinFunction: PyObject {

  /// The Swift function that will be called.
  var function: FunctionWrapper { get }
  /// The `__module__` attribute, can be anything
  var module: PyObject? { get }
  /// The `__doc__` attribute, or `nil`.
  var doc: String? { get }
}

extension AbstractBuiltinFunction {

  // MARK: - Name

  /// The name of the built-in function/method.
  ///
  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal var name: String {
    return self.function.name
  }

  // MARK: - Equatable

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _isEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _isNotEqual(_ other: PyObject) -> CompareResult {
    return self._isEqual(other).not
  }

  // MARK: - Comparable

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _hash() -> HashResult {
    return .notImplemented
  }

  // MARK: - Attributes

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Doc

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _getDoc() -> String? {
    return self.doc.map(DocHelper.getDocWithoutSignature(_:))
  }

  // MARK: - TextSignature

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _getTextSignature() -> String? {
    return self.doc.flatMap(DocHelper.getSignature)
  }

  // MARK: - Module

  /// DO NOT USE! This is a part of `AbstractBuiltinFunction` implementation.
  internal func _getModule() -> PyResult<PyObject> {
    guard let moduleObject = self.module else {
      return .value(Py.emptyString)
    }

    guard let module = PyCast.asModule(moduleObject) else {
      let str = Py.str(object: moduleObject)
      return str.map { $0 as PyObject }
    }

    return module.getName()
  }
}
