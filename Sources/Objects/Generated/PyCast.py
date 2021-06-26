from Sourcery import get_types
from Common.strings import generated_warning
from Common.builtin_types import get_property_name_escaped as get_builtin_type_property_name


def get_indefinite_article(word: str) -> str:
    if not word:
        return False

    # Not perfect, but close enough
    first_upper = word[0].upper()
    is_first_vowel = first_upper in ('A', 'E', 'I', 'O', 'U', 'Y')
    return 'an' if is_first_vowel else 'a'


if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

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
        swift_type_name = t.swift_type_name
        swift_type_without_py = swift_type_name[2:]

        # We don't need to cast 'Object' -> 'Object'
        if swift_type_name == 'PyObject':
            continue

        python_type = t.python_type_name
        builtin_types = 'Py.errorTypes' if t.is_error else 'Py.types'
        builtin_property = get_builtin_type_property_name(python_type)

        article = get_indefinite_article(python_type)

        print(f'''
  // MARK: - {swift_type_without_py}

  /// Is this object {article} `{python_type}` (or its subclass)?
  public static func is{swift_type_without_py}(_ object: PyObject) -> Bool {{
    return self.isInstance(object, of: {builtin_types}.{builtin_property})
  }}

  /// Is this object {article} `{python_type}` (but not its subclass)?
  public static func isExactly{swift_type_without_py}(_ object: PyObject) -> Bool {{
    return self.isExactlyInstance(object, of: {builtin_types}.{builtin_property})
  }}

  /// Cast this object to `{swift_type_name}` if it is {article} `{python_type}` (or its subclass).
  public static func as{swift_type_without_py}(_ object: PyObject) -> {swift_type_name}? {{
    return Self.is{swift_type_without_py}(object) ? (object as! {swift_type_name}) : nil
  }}

  /// Cast this object to `{swift_type_name}` if it is {article} `{python_type}` (but not its subclass).
  public static func asExactly{swift_type_without_py}(_ object: PyObject) -> {swift_type_name}? {{
    return Self.isExactly{swift_type_without_py}(object) ? (object as! {swift_type_name}) : nil
  }}\
''')

    print('}')
