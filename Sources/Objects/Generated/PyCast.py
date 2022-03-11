from typing import Optional
from Sourcery import get_types
from Helpers import generated_warning, get_py_types_property_name


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

import VioletCore

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
/// if let int = py.cast.asInt(object) {{
///   things…
/// }}
/// ```
public struct PyCast {{

  private let types: Py.Types
  private let errorTypes: Py.ErrorTypes

  internal init(types: Py.Types, errorTypes: Py.ErrorTypes) {{
    self.types = types
    self.errorTypes = errorTypes
  }}

  private func isInstance(_ object: PyObject, of type: PyType) -> Bool {{
    return object.type.isSubtype(of: type)
  }}

  private func isExactlyInstance(_ object: PyObject, of type: PyType) -> Bool {{
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

        py_type_type = 'self.errorTypes' if t.is_error else 'self.types'
        py_type_property = get_py_types_property_name(python_type)
        py_type_path = py_type_type + '.' + py_type_property

        is_base_type = t.sourcery_flags.is_base_type

        print()
        print(f'  // MARK: - {swift_type_without_py}')

        if not is_base_type:
            print()
            print(f"  // '{python_type}' does not allow subclassing, so we do not need 'exactly' methods.")

        # =============
        # === isInt ===
        # =============

        print()
        if is_base_type:
            print(f'  /// Is this object an instance of `{python_type}` (or its subclass)?')
        else:
            print(f'  /// Is this object an instance of `{python_type}`?')

        print(f'  public func is{swift_type_without_py}(_ object: PyObject) -> Bool {{')

        # For some types we have a dedicated flag on type
        flag_to_check_on_type: Optional[str] = None
        if python_type == 'int':
            flag_to_check_on_type = 'isLongSubclass'
        elif python_type == 'list':
            flag_to_check_on_type = 'isListSubclass'
        elif python_type == 'tuple':
            flag_to_check_on_type = 'isTupleSubclass'
        elif python_type == 'bytes':
            flag_to_check_on_type = 'isBytesSubclass'
        elif python_type == 'str':
            flag_to_check_on_type = 'isUnicodeSubclass'
        elif python_type == 'dict':
            flag_to_check_on_type = 'isDictSubclass'
        elif python_type == 'baseException':
            flag_to_check_on_type = 'isBaseExceptionSubclass'
        elif python_type == 'type':
            flag_to_check_on_type = 'isTypeSubclass'

        if flag_to_check_on_type:
            print(f"    // '{python_type}' checks are so common that we have a special flag for it.")
            print(f'    let typeFlags = object.type.typeFlags')
            print(f'    return typeFlags.{flag_to_check_on_type}')
        else:
            print(f'    return self.isInstance(object, of: {py_type_path})')

        print('  }')

        # ====================
        # === isExactlyInt ===
        # ====================

        if is_base_type:
            print(f'''
  /// Is this object an instance of `{python_type}` (but not its subclass)?
  public func isExactly{swift_type_without_py}(_ object: PyObject) -> Bool {{
    return self.isExactlyInstance(object, of: {py_type_path})
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
  public func as{swift_type_without_py}(_ object: PyObject) -> {swift_type}? {{
    return self.is{swift_type_without_py}(object) ? {swift_type}(ptr: object.ptr) : nil
  }}\
''')

        # ====================
        # === asExactlyInt ===
        # ====================

        if is_base_type:
            print(f'''
  /// Cast this object to `{swift_type}` if it is {python_type_article} `{python_type}` (but not its subclass).
  public func asExactly{swift_type_without_py}(_ object: PyObject) -> {swift_type}? {{
    return self.isExactly{swift_type_without_py}(object) ? {swift_type}(ptr: object.ptr) : nil
  }}\
''')

        # ===============
        # === Special ===
        # ===============

        is_none = t.python_type_name == 'NoneType'
        if is_none:
            print(f'''
  /// Is this object Swift `nil` or an instance of `NoneType`?
  public func isNilOrNone(_ object: PyObject?) -> Bool {{
    guard let object = object else {{
      return true
    }}

    return self.isNone(object)
  }}\
''')

    print('}')
