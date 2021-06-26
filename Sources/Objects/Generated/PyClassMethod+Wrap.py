from Common.strings import generated_warning
from Function_wrappers_data.positional_functions import get_positional_signatures

if __name__ == '__main__':
    positional_functions = get_positional_signatures()

    print(f'''\
// swiftlint:disable identifier_name
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

{generated_warning}

extension PyClassMethod {{

  // MARK: - As type

  internal static func asType(fnName: String, object: PyObject) -> PyResult<PyType> {{
    if let type = PyCast.asType(object) {{
      return .value(type)
    }}

    let t = object.typeName
    let msg = "descriptor '\(fnName)' requires a type but received a '\(t)'"
    return .typeError(msg)
  }}

  // MARK: - Wrap methods
''')

    for fn in positional_functions:
      # Class methods have 'type' as 1st argument
        if not fn.has_type_argument:
            continue

        fn_typealias_name = fn.fn_typealias_name
        generic_arguments = fn.generic_arguments
        generic_arguments_with_requirements = fn.generic_arguments_with_requirements

        print(f'''\
  internal static func wrap{generic_arguments_with_requirements}(
    name: String,
    doc: String?,
    fn: @escaping FunctionWrapper.{fn_typealias_name}{generic_arguments},
    module: PyString? = nil
  ) -> PyClassMethod {{
    let builtinFunction = PyBuiltinFunction.wrap(
      name: name,
      doc: doc,
      fn: fn,
      castType: Self.asType(fnName:object:),
      module: module
    )

    return PyClassMethod(callable: builtinFunction)
  }}
''')

    print('}')  # extension end
