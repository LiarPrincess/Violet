/* MARKER
// 'Additional' because most of the wrapper methods are inside
// 'Generated/PyClassMethod+Wrap.swift'.
extension PyClassMethod {

  // MARK: - Args, kwargs

  // Args kwargs static method
  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping ([PyObject], PyDict?) -> R,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      module: module
    )

    return PyMemory.newClassMethod(callable: builtinFunction)
  }
}

*/