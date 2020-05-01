// Basically the same as 'PyBuiltinFunction+Wrap' but for 'classmethod'.
// See 'PyBuiltinFunction+Wrap.swift' for details.

extension PyClassMethod {

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping ([PyObject], PyDict?) -> R,
    module: PyString? = nil
  ) -> PyClassMethod {

    let wrappedFn = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      module: module
    )

    return PyClassMethod(callable: wrappedFn)
  }
}
