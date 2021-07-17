from Sourcery import get_types, TypeInfo
from Common.strings import generated_warning


def get_heap_type_name(t: TypeInfo):
    swift_type_name = t.swift_type_name
    if swift_type_name == 'PyObjectType':
        swift_type_name = 'PyObject'

    return f'{swift_type_name}Heap'


if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable file_length
// swiftlint:disable trailing_newline

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
        python_type_name = t.python_type_name
        swift_type_name = t.swift_type_name
        swift_type_withot_py = swift_type_name.replace('Py', '')

        print(f'// MARK: - {swift_type_withot_py}')
        print()

        # If it is not a base type -> skip
        is_base = False
        for flag in t.sourcery_flags:
            if flag == 'baseType':
                is_base = True

        if not is_base:
            print(f'// {swift_type_name} is not a base type.')
            print()
            continue

        # If it already has '__dict__' -> skip
        has_dict = False
        for prop in t.python_properties:
            if prop.python_name == '__dict__':
                has_dict = True

        if has_dict:
            print(f'// {swift_type_name} already has everything we need.')
            print()
            continue

        type_name = get_heap_type_name(t)
        print(f'''\
/// Type used when we subclass builtin `{python_type_name}` class.
/// For example: `class Rapunzel({python_type_name}): pass`.
internal final class {type_name}: {swift_type_name}, HeapType {{ }}
''')
