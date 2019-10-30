import Core

// swiftlint:disable force_cast
// swiftlint:disable trailing_closure

extension PyType {

  // MARK: - Properties

  internal static func createProperty<Zelf, R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyProperty {

    return PyProperty(
      context,
      getter: PyType.wrapGetter(context, get: get, castSelf: castSelf),
      setter: nil,
      deleter: nil
    )
  }

  // swiftlint:disable:next function_parameter_count
  internal static func createProperty<Zelf, R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject) -> Zelf) -> PyProperty {

    return PyProperty(
      context,
      getter: PyType.wrapGetter(context, get: get, castSelf: castSelf),
      setter: PyType.wrapSetter(context, set: set, castSelf: castSelf),
      deleter: nil
    )
  }

  private static func wrapGetter<Zelf, R: PyObjectConvertible>(
    _ context: PyContext,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyType.wrapMethod(
      context,
      name: "__get__",
      doc: nil,
      func: get,
      castSelf: castSelf
    )
  }

  private static func wrapSetter<Zelf>(
    _ context: PyContext,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<()>,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return PyType.wrapMethod(
      context,
      name: "__set__",
      doc: nil,
      func: { arg0, arg1 -> PyResult<PyObject> in
        let zelf = castSelf(arg0)
        let result = set(zelf)(arg1)
        return result.map { _ in arg0.context.none }
      }
    )
  }

  // MARK: - Unary methods

  internal static func wrapMethod<Zelf, R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    func fn: @escaping (Zelf) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return wrapMethod(
      context,
      name: name,
      doc: doc,
      func: { arg0 in fn(castSelf(arg0)) }
    )
  }

  internal static func wrapMethod<Zelf, R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    func fn: @escaping (Zelf) -> () -> R, // Read-only property disquised as method
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return wrapMethod(
      context,
      name: name,
      doc: doc,
      func: { arg0 in fn(castSelf(arg0))() }
    )
  }

  internal static func wrapMethod<R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    func fn: @escaping (PyObject) -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      name: name,
      doc: doc,
      func: { arg0 in fn(arg0).toPyObject(in: arg0.context) },
      zelf: nil
    )
  }

  // MARK: - Binary methods

  internal static func wrapMethod<Zelf, R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    func fn: @escaping (Zelf) -> (PyObject) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return wrapMethod(
      context,
      name: name,
      doc: doc,
      func: { arg0, arg1 in fn(castSelf(arg0))(arg1) }
    )
  }

  internal static func wrapMethod<R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    func fn: @escaping (PyObject, PyObject) -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      name: name,
      doc: doc,
      func: { arg0, arg1 in fn(arg0, arg1).toPyObject(in: arg0.context) },
      zelf: nil
    )
  }

  // MARK: - Ternary methods

  internal static func wrapMethod<Zelf, R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    func fn: @escaping (Zelf) -> (PyObject, PyObject) -> R,
    castSelf: @escaping (PyObject) -> Zelf) -> PyBuiltinFunction {

    return wrapMethod(
      context,
      name: name,
      doc: doc,
      func: { arg0, arg1, arg2 in fn(castSelf(arg0))(arg1, arg2) }
    )
  }

  internal static func wrapMethod<R: PyObjectConvertible>(
    _ context: PyContext,
    name: String,
    doc: String?,
    func fn: @escaping (PyObject, PyObject, PyObject) -> R) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      context,
      name: name,
      doc: doc,
      func: { arg0, arg1, arg2 in fn(arg0, arg1, arg2).toPyObject(in: arg0.context) },
      zelf: nil)
  }
}
