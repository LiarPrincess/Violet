from typing import List, Union
from Sourcery import get_types, TypeInfo, SwiftInitInfo
from Common.strings import generated_warning
from Common.builtin_types import get_property_name_escaped as get_builtin_type_property_name

# Types for which we want to generate 'new' function
implemented_types = (
    'PyNone',  # Basic
    'PyEllipsis',
    'PyNamespace',
    'PyNotImplemented',
    'PyBool',
    'PyInt',
    'PyFloat',
    'PyComplex',
    'PyType',  # Type and object
    'PyObject',
    'PyList',  # List
    'PyListIterator',
    'PyListReverseIterator',
    'PyTuple',  # Tuple
    'PyTupleIterator',
    'PyDict',  # Dict
    'PyDictItemIterator',
    'PyDictItems',
    'PyDictKeyIterator',
    'PyDictKeys',
    'PyDictValueIterator',
    'PyDictValues',
    'PyFrozenSet',  # Set
    'PySet',
    'PySetIterator'
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
    if not i.is_open_public_internal:
        return

    swift_type = t.swift_type_name
    swift_type_without_py = swift_type[2:]
    python_type = t.python_type_name
    init_arguments = i.arguments

    access_modifier = 'public'
    additional_docs = ''

    if python_type == 'object' and not init_arguments:
        access_modifier = 'internal'
        additional_docs = '''\
  ///
  /// Unsafe `new` without `type` property filled.
  /// Reserved for `objectType` and `typeType` to create mutual recursion.\
'''

    has_metatype_arg = any(map(lambda a: a.name == 'metatype', init_arguments))
    if python_type == 'type' and not has_metatype_arg:
        access_modifier = 'internal'
        additional_docs = '''\
  ///
  /// Unsafe `new` without `type` property filled.
  /// Reserved for `objectType` and `typeType` to create mutual recursion.\
'''

    print(f'  /// Allocate new instance of `{python_type}` type.')
    if additional_docs:
        print(additional_docs)

    print(f'  {access_modifier} static func new{swift_type_without_py}(')

    for index, arg in enumerate(init_arguments):
        is_last = index == len(init_arguments) - 1
        comma = '' if is_last else ','
        print(f'    {arg.name}: {arg.typ}{comma}')

    print(f'  ) -> {swift_type} {{')
    print(f'    return {swift_type}(')

    for index, arg in enumerate(init_arguments):
        is_last = index == len(init_arguments) - 1
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
{generated_warning(__file__)}

import BigInt
import VioletCore
import VioletBytecode
import VioletCompiler

// swiftlint:disable function_parameter_count
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

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
