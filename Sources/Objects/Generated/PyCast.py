from Sourcery import get_types
from Common.strings import generated_warning
from Common.builtin_types import get_property_name_escaped as get_builtin_type_property_name

if __name__ == '__main__':
    print(f'''\
{generated_warning}

// swiftlint:disable force_cast
// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable line_length
// swiftlint:disable file_length

/// Helper type used to safely downcast Python objects to specific Swift type.
///
/// For example:
/// On the `VM` stack we hold `PyObject`, at some point we may want to convert
/// it to `PyInt`:
///
/// ```Swift
/// if let int = PyCast.asInt(object) {{
///   things…
/// }}
/// ```
public enum PyCast {{

  private static func isInstance(_ object: PyObject, of type: PyType) -> Bool {{
    return object.type.isSubtype(of: type)
  }}

  private static func isExactlyInstance(_ object: PyObject, of type: PyType) -> Bool {{
    return object.type === type
  }}\
''')

    for t in get_types():
        swift_type = t.swift_type
        swift_type_without_py = swift_type[2:]

        # We don't need to cast 'Object' -> 'Object'
        if swift_type == 'PyObject':
            continue

        python_type = t.python_type
        builtin_property = get_builtin_type_property_name(python_type)

        builtin_types = 'Py.errorTypes' if t.is_error else 'Py.types'

        print(f'''
  // MARK: - {swift_type_without_py}

  /// Is this object an instance of python `{python_type}` type (or its subclass)?
  public static func is{swift_type_without_py}(_ object: PyObject) -> Bool {{
    return self.isInstance(object, of: {builtin_types}.{builtin_property})
  }}

  /// Is this object an instance of a python `{python_type}` type?
  /// Subclasses will return `false`.
  public static func isExactly{swift_type_without_py}(_ object: PyObject) -> Bool {{
    return self.isExactlyInstance(object, of: {builtin_types}.{builtin_property})
  }}

  /// Cast this object to `{swift_type}` if it is an instance of python `{python_type}` type
  /// (or its subclass).
  public static func as{swift_type_without_py}(_ object: PyObject) -> {swift_type}? {{
    return Self.is{swift_type_without_py}(object) ? (object as! {swift_type}) : nil
  }}

  /// Cast this object to `{swift_type}` if it is an instance of python `{python_type}` type.
  /// Subclasses will return `nil`.
  public static func asExactly{swift_type_without_py}(_ object: PyObject) -> {swift_type}? {{
    return Self.isExactly{swift_type_without_py}(object) ? (object as! {swift_type}) : nil
  }}\
''')

    print('}')
