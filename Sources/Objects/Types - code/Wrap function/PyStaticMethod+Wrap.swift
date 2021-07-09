// Basically the same as 'PyBuiltinFunction+Wrap' but for 'staticmethod'.
// See 'PyBuiltinFunction+Wrap.swift' for details.

extension PyStaticMethod {

  internal static func wrapNew<Zelf: PyObject>(
    type: PyType,
    doc: String?,
    fn: @escaping FunctionWrapper.NewFn<Zelf>,
    module: PyString? = nil
  ) -> PyStaticMethod {
    let builtinFunction = PyBuiltinFunction.wrapNew(
      type: type,
      doc: doc,
      fn: fn,
      module: module
    )

    return PyStaticMethod(callable: builtinFunction)
  }
}
