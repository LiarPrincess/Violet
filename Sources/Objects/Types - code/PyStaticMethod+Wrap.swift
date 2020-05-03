// Basically the same as 'PyBuiltinFunction+Wrap' but for 'classmethod'.
// See 'PyBuiltinFunction+Wrap.swift' for details.

extension PyStaticMethod {

  internal static func wrapNew<Zelf: PyObject>(
    type: PyType,
    doc: String?,
    fn: @escaping NewFunction<Zelf>,
    module: PyString? = nil
  ) -> PyBuiltinFunction {

    return PyBuiltinFunction(
      fn: NewFunctionWrapper(type: type, fn: fn),
      module: module,
      doc: doc
    )
  }
}
