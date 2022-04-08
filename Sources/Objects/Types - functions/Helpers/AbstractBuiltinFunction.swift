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
    if Self.downcast(py, zelf) == nil {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__eq__)
    }

    return .notImplemented
  }

  internal static func abstract__ne__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    if Self.downcast(py, zelf) == nil {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__ne__)
    }

    return .notImplemented
  }

  internal static func abstract__lt__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    if Self.downcast(py, zelf) == nil {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__lt__)
    }

    return .notImplemented
  }

  internal static func abstract__le__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    if Self.downcast(py, zelf) == nil {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__le__)
    }

    return .notImplemented
  }

  internal static func abstract__gt__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    if Self.downcast(py, zelf) == nil {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__gt__)
    }

    return .notImplemented
  }

  internal static func abstract__ge__(_ py: Py,
                                      zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    if Self.downcast(py, zelf) == nil {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, .__ge__)
    }

    return .notImplemented
  }

  // MARK: - Attributes

  internal static func abstract__getattribute__(_ py: Py,
                                                zelf _zelf: PyObject,
                                                name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Properties

  internal static func abstract__name__(_ py: Py,
                                        zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__name__")
    }

    let result = zelf.getName(py)
    return PyResult(result)
  }

  internal func getName(_ py: Py) -> PyString {
    let result = self.name
    return py.intern(string: result)
  }

  internal static func abstract__doc__(_ py: Py,
                                       zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__doc__")
    }

    guard let doc = zelf.doc else {
      return .none(py)
    }

    let result = DocHelper.getDocWithoutSignature(doc)
    return PyResult(py, interned: result)
  }

  internal static func abstract__text_signature__(_ py: Py,
                                                  zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__text_signature__")
    }

    guard let doc = zelf.doc,
          let result = DocHelper.getSignature(doc) else {
            return .none(py)
          }

    return PyResult(py, interned: result)
  }

  internal static func abstract__module__(_ py: Py,
                                          zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__module__")
    }

    guard let moduleObject = zelf.module else {
      return PyResult(py.emptyString)
    }

    guard let module = py.cast.asModule(moduleObject) else {
      let result = py.str(moduleObject)
      return PyResult(result)
    }

    return module.getName(py)
  }

  // MARK: - Helpers

  private static func invalidZelfArgument(_ py: Py,
                                          _ object: PyObject,
                                          _ fnName: String) -> PyResult {
    let error = py.newInvalidSelfArgumentError(object: object,
                                               expectedType: Self.pythonTypeName,
                                               fnName: fnName)

    return .error(error.asBaseException)
  }
}
