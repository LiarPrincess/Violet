// Basically the same as 'PyBuiltinFunction+Wrap' but for 'classmethod'.
// See 'PyBuiltinFunction+Wrap.swift' for details.

private func asType(fnName: String, object: PyObject) -> PyResult<PyType> {
  if let type = PyCast.asType(object) {
    return .value(type)
  }

  let t = object.typeName
  let msg = "descriptor '\(fnName)' requires a type but received a '\(t)'"
  return .typeError(msg)
}

extension PyClassMethod {

  // MARK: - Args, kwargs

  // Args kwargs static method
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping ([PyObject], PyDict?) -> R,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(name: name,
                                                 doc: doc,
                                                 fn: fn,
                                                 module: module)

    return PyClassMethod(callable: builtinFunction)
  }

  // MARK: - With type as 1st arg

  // Positional binary
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyType, PyObject) -> R,
    module: PyString? = nil
  ) -> PyClassMethod {
    // We do not have overload for 'PyType' as 1st arg,
    // so we have to modify the 'fn' a bit.
    let objectAs1stArg = { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
      let type: PyType
      switch asType(fnName: name, object: arg0) {
      case let .value(t): type = t
      case let .error(e): return .error(e)
      }

      let result = fn(type, arg1)
      return result.asFunctionResult
    }

    let builtinFunction = PyBuiltinFunction.wrap(name: name,
                                                 doc: doc,
                                                 fn: objectAs1stArg,
                                                 module: module)

    return PyClassMethod(callable: builtinFunction)
  }

  // Positional ternary with last argument optional
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyType, PyObject, PyObject?) -> R,
    module: PyString? = nil
  ) -> PyClassMethod {
    // We do not have overload for 'PyType' as 1st arg,
    // so we have to modify the 'fn' a bit.
    let objectAs1stArg = { (arg0: PyObject, arg1: PyObject, arg2: PyObject?) -> PyFunctionResult in
      let type: PyType
      switch asType(fnName: name, object: arg0) {
      case let .value(t): type = t
      case let .error(e): return .error(e)
      }

      let result = fn(type, arg1, arg2)
      return result.asFunctionResult
    }

    let builtinFunction = PyBuiltinFunction.wrap(name: name,
                                                 doc: doc,
                                                 fn: objectAs1stArg,
                                                 module: module)

    return PyClassMethod(callable: builtinFunction)
  }
}
