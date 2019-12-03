import Core

// swiftlint:disable trailing_closure

extension TypeFactory {

  internal static func createProperty<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyProperty {

    return PyProperty(
      context,
      getter: wrapGetter(context, get: get, castSelf: castSelf),
      setter: nil,
      deleter: nil
    )
  }

  // swiftlint:disable:next function_parameter_count
  internal static func createProperty<Zelf, R: FunctionResultConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject) -> Zelf) -> PyProperty {

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
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return wrapMethod(
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
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return wrapMethod(
      context,
      name: "__set__",
      doc: nil,
      fn: { arg0, arg1 -> PyResult<PyObject> in
        let zelf = castSelf(arg0)
        let result = set(zelf)(arg1)
        return result.map { _ in arg0.builtins.none }
      }
    )
  }
}
