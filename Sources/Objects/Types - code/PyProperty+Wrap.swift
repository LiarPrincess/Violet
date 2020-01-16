import Core

// swiftlint:disable trailing_closure

extension PyProperty {

  // MARK: - Wrap read only property

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    get: @escaping () -> R) -> PyProperty {

    return PyProperty(
      getter: wrapGetter(get: get),
      setter: nil,
      deleter: nil
    )
  }

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyProperty {

    return PyProperty(
      getter: wrapGetter(get: get, castSelf: castSelf),
      setter: nil,
      deleter: nil
    )
  }

  // MARK: - Wrap property

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    get: @escaping () -> R,
    set: @escaping (PyObject) -> PyResult<()>) -> PyProperty {

    return PyProperty(
      getter: wrapGetter(get: get),
      setter: wrapSetter(set: set),
      deleter: nil
    )
  }

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyProperty {

    return PyProperty(
      getter: wrapGetter(get: get, castSelf: castSelf),
      setter: wrapSetter(set: set, castSelf: castSelf),
      deleter: nil
    )
  }

  // MARK: - Wrap getter

  private static func wrapGetter<R: PyFunctionResultConvertible>(
    get: @escaping () -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction.wrap(
      name: "__get__",
      doc: nil,
      fn: get
    )
  }

  private static func wrapGetter<Zelf, R: PyFunctionResultConvertible>(
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction.wrap(
      name: "__get__",
      doc: nil,
      fn: get,
      castSelf: castSelf
    )
  }

  // MARK: - Wrap setter

  private static func wrapSetter(
    set: @escaping (PyObject) -> PyResult<()>) -> PyBuiltinFunction {

    let name = "__set__"
    return PyBuiltinFunction.wrap(
      name: name,
      doc: nil,
      fn: { value -> PyResult<PyObject> in
        set(value).map { _ in value.builtins.none }
      }
    )
  }

  private static func wrapSetter<Zelf>(
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    let name = "__set__"
    return PyBuiltinFunction.wrap(
      name: name,
      doc: nil,
      fn: { zelf, value -> PyResult<PyObject> in
        castSelf(zelf, name)
          .map { set($0)(value) }
          .map { _ in zelf.builtins.none }
      }
    )
  }
}
