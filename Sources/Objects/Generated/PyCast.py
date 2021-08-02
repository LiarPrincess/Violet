from Sourcery import get_types
from Common.strings import generated_warning
from Builtin_types import get_property_name_escaped as get_builtin_type_property_name


def _get_indefinite_article(word: str) -> str:
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
        swift_type = t.swift_type_name
        swift_type_without_py = swift_type[2:]

        # We don't need to cast 'Object' -> 'Object'
        if swift_type == 'PyObject':
            continue

        python_type = t.python_type_name
        python_type_article = _get_indefinite_article(python_type)

        builtin_type_name = 'Py.errorTypes' if t.is_error else 'Py.types'
        builtin_property = get_builtin_type_property_name(python_type)
        builtin_type = builtin_type_name + '.' + builtin_property

        is_base_type = 'baseType' in t.sourcery_flags

        print()
        print(f'  // MARK: - {swift_type_without_py}')

        if not is_base_type:
            print()
            print(f"  // '{python_type}' does not allow subclassing, so we do not need 'exactly' methods.")

        # =============
        # === isInt ===
        # =============

        doc = f'/// Is this object an instance of `{python_type}`?'
        if is_base_type:
            doc = f'/// Is this object an instance of `{python_type}` (or its subclass)?'

        print(f'''
  {doc}
  public static func is{swift_type_without_py}(_ object: PyObject) -> Bool {{
    return PyCast.isInstance(object, of: {builtin_type})
  }}\
''')

        # ====================
        # === isExactlyInt ===
        # ====================

        if is_base_type:
            print(f'''
  /// Is this object an instance of `{python_type}` (but not its subclass)?
  public static func isExactly{swift_type_without_py}(_ object: PyObject) -> Bool {{
    return PyCast.isExactlyInstance(object, of: {builtin_type})
  }}\
''')

        # =============
        # === asInt ===
        # =============

        doc = f'/// Cast this object to `{swift_type}` if it is {python_type_article} `{python_type}`.'
        if is_base_type:
            doc = f'/// Cast this object to `{swift_type}` if it is {python_type_article} `{python_type}` (or its subclass).'

        print(f'''
  {doc}
  public static func as{swift_type_without_py}(_ object: PyObject) -> {swift_type}? {{
    return PyCast.is{swift_type_without_py}(object) ? (object as! {swift_type}) : nil
  }}\
''')

        # ====================
        # === asExactlyInt ===
        # ====================

        if is_base_type:
            print(f'''
  /// Cast this object to `{swift_type}` if it is {python_type_article} `{python_type}` (but not its subclass).
  public static func asExactly{swift_type_without_py}(_ object: PyObject) -> {swift_type}? {{
    return PyCast.isExactly{swift_type_without_py}(object) ? (object as! {swift_type}) : nil
  }}\
''')

        # ===============
        # === Special ===
        # ===============

        is_none = t.python_type_name == 'NoneType'
        if is_none:
            print(f'''
  /// Is this object Swift `nil` or an instance of `NoneType`?
  public static func isNilOrNone(_ object: PyObject?) -> Bool {{
    guard let object = object else {{
      return true
    }}

    return PyCast.isNone(object)
  }}\
''')

    print('}')  # end 'PyCast'
