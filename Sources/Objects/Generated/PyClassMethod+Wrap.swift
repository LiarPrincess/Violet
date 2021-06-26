// ===============================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyClassMethod+Wrap.py
// DO NOT EDIT!
// ===============================================================================

// swiftlint:disable identifier_name
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

extension PyClassMethod {

  // MARK: - As type

  internal static func asType(fnName: String, object: PyObject) -> PyResult<PyType> {
    if let type = PyCast.asType(object) {
      return .value(type)
    }

    let t = object.typeName
    let msg = "descriptor '\(fnName)' requires a type but received a '\(t)'"
    return .typeError(msg)
  }

  // MARK: - Wrap methods

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_ObjectOpt_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_ObjectOpt_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_Object_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_Object_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_ObjectOpt_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_ObjectOpt_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_ObjectOpt_ObjectOpt_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_ObjectOpt_ObjectOpt_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_Object_Object_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_Object_Object_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_Object_ObjectOpt_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_Object_ObjectOpt_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_ObjectOpt_ObjectOpt_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_Object_ObjectOpt_ObjectOpt_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap<R: PyFunctionResultConvertible>(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Result_Fn<R>,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

  internal static func wrap(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.Type_ObjectOpt_ObjectOpt_ObjectOpt_to_Void_Fn,
    module: PyString? = nil
  ) -> PyClassMethod {
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }

}
