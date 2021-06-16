from Data.types import get_types
from Common.strings import generated_warning


def get_heap_type_name(t):
    swift_type = t.swift_type
    if swift_type == 'PyObjectType':
        swift_type = 'PyObject'

    return f'{swift_type}Heap'


if __name__ == '__main__':
    print(f'''\
// swiftlint:disable file_length
// swiftlint:disable trailing_newline

{generated_warning}

// Types used when we subclass one of the builtin types
// (the same but in other words: type created by user with 'class' statement).
//
// Normally most builtin types (like int, float etc.) do not have '__dict__'.
// But if we subclass then then '__dict__' is now present.
//
// For example:
// >>> 1.__dict__ # Builtin int does not have '__dict__'
// SyntaxError: invalid syntax
//
// >>> class MyInt(int): pass
// >>> MyInt().__dict__ # But the subclass has
// {{ }}
''')

    print('''\
internal protocol HeapType: AnyObject, __dict__Owner {
  var __dict__: PyDict { get set }
}

extension HeapType {
  internal func getDict() -> PyDict {
    return self.__dict__
  }
}
''')

    for t in get_types():
        python_type = t.python_type
        swift_type = t.swift_type
        swift_type_withot_py = swift_type.replace('Py', '')

        print(f'// MARK: - {swift_type_withot_py}')
        print()

        # If it is not a base type -> skip
        is_base = False
        for flag in t.sourcery_flags:
            if flag == 'baseType':
                is_base = True

        if not is_base:
            print(f'// {swift_type} is not a base type.')
            print()
            continue

        # If it already has '__dict__' -> skip
        has_dict = False
        for prop in t.properties:
            if prop.python_name == '__dict__':
                has_dict = True

        if has_dict:
            print(f'// {swift_type} already has everything we need.')
            print()
            continue

        type_name = get_heap_type_name(t)
        print(f'''\
/// Type used when we subclass builtin `{python_type}` class.
/// For example: `class Rapunzel({python_type}): pass`.
internal final class {type_name}: {swift_type}, HeapType {{

  /// Python `__dict__` property.
  internal lazy var __dict__ = PyDict()
}}
''')
