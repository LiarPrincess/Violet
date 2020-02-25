/// Shared methods for `PyBuiltinFunction` and `PyBuiltinMethod`.
///
/// Note that `CPython` uses the same implementation for `PyBuiltinFunction`
/// and `PyBuiltinMethod`, but we will separate them.
internal protocol PyBuiltinFunctionShared {

  /// The Swift function that will be called.
  var function: FunctionWrapper { get }
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

  // MARK: - Equatable

  internal func isEqualShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  internal func isNotEqualShared(_ other: PyObject) -> CompareResult {
    return self.isEqualShared(other).not
  }

  // MARK: - Comparable

  internal func isLessShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  internal func isLessEqualShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  internal func isGreaterShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  internal func isGreaterEqualShared(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  internal func hashShared() -> HashResult {
    return .notImplemented
  }

  // MARK: - Attributes

  internal func getAttributeShared(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - TextSignature

  internal func getTextSignatureShared() -> String? {
    return self.doc.flatMap(DocHelper.getSignature)
  }

  // MARK: - Module

  internal func getModuleShared() -> PyResult<String> {
    guard let moduleObject = self.module else {
      return .value("")
    }

    if let module = moduleObject as? PyModule {
      return module.name
    }

    return Py.strValue(moduleObject)
  }
}
