/* MARKER
import VioletCore

extension PyProperty {

  // MARK: - Wrap get property

  /// Getter is an instance method.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>
  ) -> PyProperty {
    let fget = self.wrapGetter(get: get, castSelf: castSelf)
    return PyMemory.newProperty(get: fget, set: nil, del: nil)
  }

  /// Getter is a static method.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (Zelf) -> R,
    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>
  ) -> PyProperty {
    let fget = self.wrapGetter(get: get, castSelf: castSelf)
    return PyMemory.newProperty(get: fget, set: nil, del: nil)
  }

  // MARK: - Wrap get/set property

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<Void>,
    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>
  ) -> PyProperty {
    let fget = self.wrapGetter(get: get, castSelf: castSelf)
    let fset = self.wrapSetter(set: set, castSelf: castSelf)
    return PyMemory.newProperty(get: fget, set: fset, del: nil)
  }

  // MARK: - Wrap get/set/del property

  internal static func wrap<R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (PyObject) -> R,
    set: @escaping (PyObject, PyObject) -> PyResult<PyNone>,
    del: @escaping (PyObject) -> PyResult<PyNone>
  ) -> PyProperty {
    let fget = PyBuiltinFunction.wrap(name: "__get__",
                                      doc: nil,
                                      fn: get)

    let fset = PyBuiltinFunction.wrap(name: "__set__",
                                      doc: nil,
                                      fn: set)

    let fdel = PyBuiltinFunction.wrap(name: "__del__",
                                      doc: nil,
                                      fn: del)

    return PyMemory.newProperty(get: fget, set: fset, del: fdel)
  }

  // MARK: - Wrap getter

  private static func wrapGetter<Zelf, R: PyFunctionResultConvertible>(
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>
  ) -> PyBuiltinFunction {
    return PyBuiltinFunction.wrap(name: "__get__",
                                  doc: nil,
                                  fn: get,
                                  castSelf: castSelf)
  }

  private static func wrapGetter<Zelf, R: PyFunctionResultConvertible>(
    get: @escaping (Zelf) -> R,
    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>
  ) -> PyBuiltinFunction {
    return PyBuiltinFunction.wrap(name: "__get__",
                                  doc: nil,
                                  fn: get,
                                  castSelf: castSelf)
  }

  // MARK: - Wrap setter

  private static func wrapSetter<Zelf>(
    set: @escaping (Zelf) -> (PyObject) -> PyResult<Void>,
    castSelf: @escaping FunctionWrapper.CastSelf<Zelf>
  ) -> PyBuiltinFunction {
    return PyBuiltinFunction.wrap(name: "__set__",
                                  doc: doc,
                                  fn: set,
                                  castSelf: castSelf)
  }
}

*/