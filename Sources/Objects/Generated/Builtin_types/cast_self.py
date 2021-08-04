from Sourcery import TypeInfo


def get_castSelf_function_name(t: TypeInfo):
    swift_type = t.swift_type_name
    swift_type_without_py = swift_type.replace('Py', '')
    return f'as{swift_type_without_py}'


def get_castSelfOptional_function_name(t: TypeInfo):
    swift_type = t.swift_type_name
    swift_type_without_py = swift_type.replace('Py', '')
    return f'as{swift_type_without_py}Optional'


def print_castSelf_functions(t: TypeInfo):
    python_type = t.python_type_name
    swift_type = t.swift_type_name
    py_cast_function = 'PyCast.as' + swift_type.replace('Py', '')

    cast_fn_name = get_castSelf_function_name(t)
    castOptional_fn_name = get_castSelfOptional_function_name(t)

    # Simplified version for object
    if python_type == 'object':
        print(f'''\
  private static func {cast_fn_name}(functionName: String, object: PyObject) -> PyResult<{swift_type}> {{
    // Trivial cast: 'object' is always an 'object'
    return .value(object)
  }}

  private static func {castOptional_fn_name}(object: PyObject) -> {swift_type}? {{
    // Trivial cast: 'object' is always an 'object'
    return object
  }}
''')
        return

    print(f'''\
  private static func {cast_fn_name}(functionName: String, object: PyObject) -> PyResult<{swift_type}> {{
    switch {py_cast_function}(object) {{
    case .some(let o):
        return .value(o)
    case .none:
      return .typeError(
        "descriptor '\(functionName)' requires a '{python_type}' object " +
        "but received a '\(object.typeName)'"
      )
    }}
  }}

  private static func {castOptional_fn_name}(object: PyObject) -> {swift_type}? {{
    return {py_cast_function}(object)
  }}
''')
