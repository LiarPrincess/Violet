// Basically the same as 'PyBuiltinFunction+Wrap' but for 'classmethod'.
// See 'PyBuiltinFunction+Wrap.swift' for details.

// MARK: - 1st argument is type

private func asType(name: String, object: PyObject) -> PyResult<PyType> {
  if let type = object as? PyType {
    return .value(type)
  }

  let t = object.typeName
  let msg = "descriptor '\(name)' requires a type but received a '\(t)'"
  return .typeError(msg)
}

// MARK: - Wrap

extension PyClassMethod {

  // MARK: - Args kwargs function

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping ([PyObject], PyDict?) -> R,
    module: PyString? = nil
  ) -> PyClassMethod {

    let wrapped = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      module: module
    )

    return PyClassMethod(callable: wrapped)
  }

  // MARK: - Positional binary

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping (PyType, PyObject) -> R,
    module: PyString? = nil
  ) -> PyClassMethod {

    let wrapped = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: { (arg0: PyObject, arg1: PyObject) -> PyFunctionResult in
        let type = asType(name: name, object: arg0)
        let result = type.map { fn($0, arg1) }
        return result.asFunctionResult
      },
      module: module
    )

    return PyClassMethod(callable: wrapped)
  }
}
