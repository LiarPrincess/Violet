/* MARKER
// 'Additional' because most of the wrapper methods are inside
// 'Generated/PyBuiltinFunction+Wrap.swift'.
extension PyBuiltinFunction {

  // MARK: - New

  /// Static `__new__` function
  internal static func wrapNew<Zelf: PyObject>(
    type: PyType,
    doc: String?,
    fn: @escaping (PyType, [PyObject], PyDict?) -> PyResult<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {
    let wrapper = FunctionWrapper(type: type, newFn: fn)
    return PyMemory.newBuiltinFunction(fn: wrapper, module: module, doc: doc)
  }

  // MARK: - Init

  internal static func wrapInit<Zelf: PyObject>(
    type: PyType,
    doc: String?,
    fn: @escaping (Zelf) -> ([PyObject], PyDict?) -> PyResult<PyNone>,
    castSelf: @escaping FunctionWrapper.CastSelfOptional<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {
    let wrapper = FunctionWrapper(type: type, initFn: fn, castSelf: castSelf)
    return PyMemory.newBuiltinFunction(fn: wrapper, module: module, doc: doc)
  }

  /// Static `__init__` function
  internal static func wrapInit<Zelf: PyObject>(
    type: PyType,
    doc: String?,
    fn: @escaping (Zelf, [PyObject], PyDict?) -> PyResult<PyNone>,
    castSelf: @escaping FunctionWrapper.CastSelfOptional<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {
    let wrapper = FunctionWrapper(type: type, initFn: fn, castSelf: castSelf)
    return PyMemory.newBuiltinFunction(fn: wrapper, module: module, doc: doc)
  }

  // MARK: - Args kwargs

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping ([PyObject], PyDict?) -> R,
    module: PyString? = nil
  ) -> PyBuiltinFunction {
    let wrapper = FunctionWrapper(name: name, fn: fn)
    return PyMemory.newBuiltinFunction(fn: wrapper, module: module, doc: doc)
  }

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> ([PyObject], PyDict?) -> R,
    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {
    let wrapper = FunctionWrapper(name: name, fn: fn, castSelf: castSelf)
    return PyMemory.newBuiltinFunction(fn: wrapper, module: module, doc: doc)
  }

  // MARK: - Setter property

  internal static func wrap<Zelf>(
    name: String,
    doc: String?,
    fn: @escaping (Zelf) -> (PyObject) -> PyResult<Void>,
    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {
    // We don't have overload returning 'PyResult<Void>'.
    // 'Void' is a weird type in Swift where you can't write an extension on it
    // (or add new protocol conformances).
    let setReturningNone = { (arg0: PyObject, arg1: PyObject) -> PyResult<PyNone> in
      let zelf: Zelf
      switch castSelf(name, arg0) {
      case let .value(z): zelf = z
      case let .error(e): return .error(e)
      }

      let result = fn(zelf)(arg1)
      return result.map { _ in Py.none }
    }

    let wrapper = FunctionWrapper(name: name, fn: setReturningNone)
    return PyMemory.newBuiltinFunction(fn: wrapper, module: module, doc: doc)
  }
}

*/