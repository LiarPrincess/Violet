import VioletCore

// swiftlint:disable trailing_closure

extension PyProperty {

  // MARK: - Wrap read only property

  /// Getter is an instance method.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyProperty {
    return PyProperty(
      get: self.wrapGetter(get: get, castSelf: castSelf),
      set: nil,
      del: nil
    )
  }

  /// Getter is a static method.
  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (Zelf) -> R,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyProperty {
    return PyProperty(
      get: self.wrapGetter(get: get, castSelf: castSelf),
      set: nil,
      del: nil
    )
  }

  // MARK: - Wrap property

  internal static func wrap<Zelf, R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (Zelf) -> () -> R,
    set: @escaping (Zelf) -> (PyObject) -> PyResult<Void>,
    castSelf: @escaping (PyObject, String) -> PyResult<Zelf>
  ) -> PyProperty {
    return PyProperty(
      get: self.wrapGetter(get: get, castSelf: castSelf),
      set: self.wrapSetter(set: set, castSelf: castSelf),
      del: nil
    )
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    doc: String?,
    get: @escaping (PyObject) -> R,
    set: @escaping (PyObject, PyObject) -> PyResult<PyNone>,
    del: @escaping (PyObject) -> PyResult<PyNone>
  ) -> PyProperty {
    let fget = PyBuiltinFunction.wrap(
      name: "__get__",
      doc: nil,
      fn: get
    )

    let fset = PyBuiltinFunction.wrap(
      name: "__set__",
      doc: nil,
      fn: set
    )

    let fdel = PyBuiltinFunction.wrap(
      name: "__del__",
      doc: nil,
      fn: del
    )

    return PyProperty(
      get: fget,
      set: fset,
      del: fdel
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

  private static func wrapGetter<Zelf, R: PyFunctionResultConvertible>(
    get: @escaping (Zelf) -> R,
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
    set: @escaping (Zelf) -> (PyObject) -> PyResult<Void>,
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
