import Core

// swiftlint:disable trailing_closure

extension PyProperty {

  // MARK: - Wrap read only property

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyProperty {
    return PyProperty(
      get: wrapGetter(get: get, castSelf: castSelf),
      set: nil,
      del: nil
    )
  }

  // MARK: - Wrap property

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyProperty {
    return PyProperty(
      get: wrapGetter(get: get, castSelf: castSelf),
      set: wrapSetter(set: set, castSelf: castSelf),
      del: nil
    )
  }

  // MARK: - Wrap getter

  private static func wrapGetter<Zelf, R: PyFunctionResultConvertible>(
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyBuiltinFunction {
    return PyBuiltinFunction.wrap(
      name: "__get__",
      doc: nil,
      fn: get,
      castSelf: castSelf
    )
  }

  // MARK: - Wrap setter

  private static func wrapSetter<Zelf>(
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyBuiltinFunction {
    let name = "__set__"
    return PyBuiltinFunction.wrap(
      name: name,
      doc: nil,
      fn: { zelf, value -> PyResult<PyObject> in
        castSelf(zelf, name)
          .map { set($0)(value) }
          .map { _ in Py.none }
      }
    )
  }
}
