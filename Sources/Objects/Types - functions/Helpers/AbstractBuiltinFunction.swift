/// Shared methods for `PyBuiltinFunction` and `PyBuiltinMethod`.
///
/// Note that `CPython` uses the same implementation for `PyBuiltinFunction`
/// and `PyBuiltinMethod`, but we will separate them.
internal protocol AbstractBuiltinFunction: PyObjectMixin {

  static var pythonTypeName: String { get }

  /// The Swift function that will be called.
  var function: FunctionWrapper { get }
  /// The `__module__` attribute, can be anything
  var module: PyObject? { get }
  /// The `__doc__` attribute, or `nil`.
  var doc: String? { get }

  static func downcast(_ py: Py, _ object: PyObject) -> Self?
  static func invalidZelfArgument<T>(_ py: Py,
                                     _ object: PyObject,
                                     _ fnName: String) -> PyResult<T>
}

extension AbstractBuiltinFunction {

  // MARK: - Name

  /// The name of the built-in function/method.
  internal var name: String {
    return self.function.name
  }

  // MARK: - Equatable, comparable

  internal static func abstract__eq__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__eq__)
  }

  internal static func abstract__ne__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__ne__)
  }

  internal static func abstract__lt__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__lt__)
  }

  internal static func abstract__le__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__le__)
  }

  internal static func abstract__gt__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__gt__)
  }

  internal static func abstract__ge__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__ge__)
  }

  private static func compare(_ py: Py,
                              zelf: PyObject,
                              operation: CompareResult.Operation) -> CompareResult {
    if Self.downcast(py, zelf) == nil {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, operation)
    }

    return .notImplemented
  }

  // MARK: - Attributes

  internal static func abstract__getattribute__(_ py: Py,
                                                zelf: PyObject,
                                                name: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Properties

  internal static func abstract__name__(_ py: Py,
                                       zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__name__")
    }

    let result = zelf.name
    return PyResult(py, interned: result)
  }

  internal static func abstract__doc__(_ py: Py,
                                       zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__doc__")
    }

    guard let doc = zelf.doc else {
      return .none(py)
    }

    let result = DocHelper.getDocWithoutSignature(doc)
    return PyResult(py, interned: result)
  }

  internal static func abstract__text_signature__(_ py: Py,
                                                  zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__text_signature__")
    }

    guard let doc = zelf.doc,
          let result = DocHelper.getSignature(doc) else {
            return .none(py)
          }

    return PyResult(py, interned: result)
  }

  internal static func abstract__module__(_ py: Py,
                                          zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__module__")
    }

    guard let moduleObject = zelf.module else {
      return PyResult(py.emptyString)
    }

    guard let module = py.cast.asModule(moduleObject) else {
      let result = py.str(object: moduleObject)
      return PyResult(result)
    }

    return module.getName(py)
  }
}
