import Core

// swiftlint:disable trailing_closure

extension PyProperty {

  internal static func wrap<Zelf, R: FunctionResultConvertible>(
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

  // swiftlint:disable:next function_parameter_count
  internal static func wrap<Zelf, R: FunctionResultConvertible>(
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

  private static func wrapGetter<Zelf, R: FunctionResultConvertible>(
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

  private static func wrapSetter<Zelf>(
    _ context: PyContext,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>) -> PyBuiltinFunction {

    let name = "__set__"
    return PyBuiltinFunction.wrap(
      context,
      name: name,
      doc: nil,
      fn: { arg0, arg1 -> PyResult<PyObject> in
        castSelf(arg0, name)
          .map { set($0)(arg1) }
          .map { _ in arg0.builtins.none }
      }
    )
  }
}
