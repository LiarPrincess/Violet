import Core

// swiftlint:disable trailing_closure

extension PyProperty {

  // MARK: - Wrap read only property

  internal static func wrap<R: PyFunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    get: @escaping () -> R) -> PyProperty {

    return PyProperty(
      context,
      getter: wrapGetter(context, get: get),
      setter: nil,
      deleter: nil
    )
  }

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyProperty {

    return PyProperty(
      context,
      getter: wrapGetter(context, get: get, castSelf: castSelf),
      setter: nil,
      deleter: nil
    )
  }

  // MARK: - Wrap property

  // swiftlint:disable:next function_parameter_count
  internal static func wrap<R: PyFunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    get: @escaping () -> R,
    set: @escaping (PyObject) -> PyResult<()>) -> PyProperty {

    return PyProperty(
      context,
      getter: wrapGetter(context, get: get),
      setter: wrapSetter(context, set: set),
      deleter: nil
    )
  }

  // swiftlint:disable:next function_parameter_count
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyProperty {

    return PyProperty(
      context,
      getter: wrapGetter(context, get: get, castSelf: castSelf),
      setter: wrapSetter(context, set: set, castSelf: castSelf),
      deleter: nil
    )
  }

  // MARK: - Wrap getter

  private static func wrapGetter<R: PyFunctionResultConvertible>(
    _ context: PyContext,
    get: @escaping () -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction.wrap(
      context,
      name: "__get__",
      doc: nil,
      fn: get
    )
  }

  private static func wrapGetter<Zelf, R: PyFunctionResultConvertible>(
    _ context: PyContext,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    return PyBuiltinFunction.wrap(
      context,
      name: "__get__",
      doc: nil,
      fn: get,
      castSelf: castSelf
    )
  }

  // MARK: - Wrap setter

  private static func wrapSetter(
    _ context: PyContext,
    set: @escaping (PyObject) -> PyResult<()>) -> PyBuiltinFunction {

    let name = "__set__"
    return PyBuiltinFunction.wrap(
      context,
      name: name,
      doc: nil,
      fn: { value -> PyResult<PyObject> in
        set(value).map { _ in value.builtins.none }
      }
    )
  }

  private static func wrapSetter<Zelf>(
    _ context: PyContext,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    let name = "__set__"
    return PyBuiltinFunction.wrap(
      context,
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
