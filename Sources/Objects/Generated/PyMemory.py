from typing import List, Union
from Sourcery import get_types, TypeInfo, SwiftInitInfo
from Common.strings import generated_warning
from Common.builtin_types import get_property_name_escaped as get_builtin_type_property_name

# Types for which we want to generate 'new' function
implemented_types = (
    'PyNone',
    'PyEllipsis',
    'PyNamespace',
    'PyNotImplemented',
    'PyBool',
    'PyInt',
    'PyFloat',
    'PyComplex'
)


def get_init(types_by_name: dict, t: TypeInfo) -> SwiftInitInfo:
    current_type = t
    while current_type:
        if current_type.swift_init:
            return current_type.swift_init

        base_type_name = current_type.swift_base_type_name
        if base_type_name:
            current_type = types_by_name[base_type_name]
        else:
            current_type = None

    assert False, 'Unable to find init for:' + t.swift_type_name


def print_new_function(t: TypeInfo, i: SwiftInitInfo):
    swift_type = t.swift_type_name
    swift_type_without_py = swift_type[2:]
    python_type = t.python_type_name

    print(f'  /// Allocate new instance of `{python_type}` type.')
    print(f'  public static func new{swift_type_without_py}(')

    for index, arg in enumerate(i.arguments):
        is_last = index == len(i.arguments) - 1
        comma = '' if is_last else ','
        print(f'    {arg.name}: {arg.typ}{comma}')

    print(f'  ) -> {swift_type} {{')
    print(f'    return {swift_type}(')

    for index, arg in enumerate(i.arguments):
        is_last = index == len(i.arguments) - 1
        comma = '' if is_last else ','
        print(f'      {arg.name}: {arg.name}{comma}')

    print(f'    )')  # Init end
    print('  }')  # Function end
    print()


if __name__ == '__main__':
    all_types = get_types()

    types_by_name = {}
    for t in all_types:
        name = t.swift_type_name
        types_by_name[name] = t

    print(f'''\
{generated_warning}

import BigInt
import VioletCore
import VioletBytecode
import VioletCompiler

/// Helper type for allocating new object instances.
///
/// Please note that with every call of `new` method a new Python object will be
/// allocated! It will not reuse existing instances or do any fancy checks.
/// This is basically the same thing as calling `init` on Swift type.
public enum PyMemory {{
''')

    for t in all_types:
        if t.swift_type_name not in implemented_types:
            continue

        swift_type = t.swift_type_name
        swift_type_without_py = swift_type[2:]

        print(f'  // MARK: - {swift_type_without_py}')
        print()

        for i in t.swift_initializers:
            print_new_function(t, i)

    print('}')  # Type end
