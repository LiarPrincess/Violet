import Core

// swiftlint:disable force_cast
// swiftlint:disable trailing_closure

// TODO: Better selfAsXXX methods

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

  // MARK: - Cast self

  internal static func selfAsPyBool(_ value: PyObject) -> PyBool {
    return value as! PyBool
  }

  internal static func selfAsPyBuiltinFunction(_ value: PyObject) -> PyBuiltinFunction {
    return value as! PyBuiltinFunction
  }

  internal static func selfAsPyCode(_ value: PyObject) -> PyCode {
    return value as! PyCode
  }

  internal static func selfAsPyComplex(_ value: PyObject) -> PyComplex {
    return value as! PyComplex
  }

  internal static func selfAsPyEllipsis(_ value: PyObject) -> PyEllipsis {
    return value as! PyEllipsis
  }

  internal static func selfAsPyFloat(_ value: PyObject) -> PyFloat {
    return value as! PyFloat
  }

  internal static func selfAsPyFunction(_ value: PyObject) -> PyFunction {
    return value as! PyFunction
  }

  internal static func selfAsPyInt(_ value: PyObject) -> PyInt {
    return value as! PyInt
  }

  internal static func selfAsPyList(_ value: PyObject) -> PyList {
    return value as! PyList
  }

  internal static func selfAsPyMethod(_ value: PyObject) -> PyMethod {
    return value as! PyMethod
  }

  internal static func selfAsPyModule(_ value: PyObject) -> PyModule {
    return value as! PyModule
  }

  internal static func selfAsPyNamespace(_ value: PyObject) -> PyNamespace {
    return value as! PyNamespace
  }

  internal static func selfAsPyNone(_ value: PyObject) -> PyNone {
    return value as! PyNone
  }

  internal static func selfAsPyNotImplemented(_ value: PyObject) -> PyNotImplemented {
    return value as! PyNotImplemented
  }

  internal static func selfAsPyProperty(_ value: PyObject) -> PyProperty {
    return value as! PyProperty
  }

  internal static func selfAsPyRange(_ value: PyObject) -> PyRange {
    return value as! PyRange
  }

  internal static func selfAsPySlice(_ value: PyObject) -> PySlice {
    return value as! PySlice
  }

  internal static func selfAsPyType(_ value: PyObject) -> PyType {
    return value as! PyType
  }

  internal static func selfAsPyTuple(_ value: PyObject) -> PyTuple {
    return value as! PyTuple
  }
}
