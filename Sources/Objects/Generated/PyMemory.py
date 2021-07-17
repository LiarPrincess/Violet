from typing import Dict, Optional

from Common.strings import generated_warning
from Sourcery import get_types, TypeInfo, SwiftFunctionInfo

# If you want to grep missing calls:
#
# OPTIONS="-R --line-number --exclude PyMemory.swift --exclude *.pyc"
# DIR="./Sources/Objects/"
#
# grep ${OPTIONS} " PyNone(" ${DIR}
# grep ${OPTIONS} " PyEllipsis(" ${DIR}
# grep ${OPTIONS} " PyNamespace(" ${DIR}
# grep ${OPTIONS} " PyNotImplemented(" ${DIR}


def get_initializers(types_by_swift_name: Dict[str, TypeInfo], t: TypeInfo) -> SwiftFunctionInfo:
    "If we do not have any 'initializers' then try parent"

    current_type: Optional[TypeInfo] = t
    while current_type:
        if current_type.swift_initializers:
            return current_type.swift_initializers

        base_type_name = current_type.swift_base_type_name
        if base_type_name:
            current_type = types_by_swift_name[base_type_name]
        else:
            current_type = None

    assert False, 'Unable to find init for: ' + t.swift_type_name


def print_new_function(t: TypeInfo, i: SwiftFunctionInfo):
    if not i.is_open_public_internal:
        return

    swift_type = t.swift_type_name
    swift_type_without_py = swift_type[2:]
    python_type = t.python_type_name
    init_arguments = i.arguments

    additional_docs = ''

    is_object_init_without_arguments = python_type == 'object' and not init_arguments
    has_metatype_arg = any(map(lambda a: a.name == 'metatype', init_arguments))
    is_type_init_without_type_argument = python_type == 'type' and not has_metatype_arg

    if is_object_init_without_arguments or is_type_init_without_type_argument:
        additional_docs = '''\
  ///
  /// Unsafe `new` without `type` property filled.
  /// Reserved for `objectType` and `typeType` to create mutual recursion.\
'''

    print(f'  /// Allocate new instance of `{python_type}` type.')
    if additional_docs:
        print(additional_docs)

    print(f'  {i.access_modifier} static func new{swift_type_without_py}(')

    for index, arg in enumerate(init_arguments):
        is_last = index == len(init_arguments) - 1
        comma = '' if is_last else ','

        label = ''
        if arg.label:
            label = arg.label + ' '

        default_value = ''
        if arg.default_value:
            default_value = ' = ' + arg.default_value

        print(f'    {label}{arg.name}: {arg.typ}{default_value}{comma}')

    print(f'  ) -> {swift_type} {{')
    print(f'    return {swift_type}(')

    for index, arg in enumerate(init_arguments):
        is_last = index == len(init_arguments) - 1
        comma = '' if is_last else ','
        label = arg.label or arg.name
        print(f'      {label}: {arg.name}{comma}')

    print(f'    )')  # Init end
    print('  }')  # Function end
    print()


def main():
    all_types = get_types()

    types_by_swift_name = {}
    for t in all_types:
        name = t.swift_type_name
        types_by_swift_name[name] = t

    print(f'''\
{generated_warning(__file__)}

import Foundation
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
internal enum PyMemory {{
''')

    for t in all_types:
        swift_type = t.swift_type_name
        swift_type_without_py = swift_type[2:]

        print(f'  // MARK: - {swift_type_without_py}')
        print()

        initializers = get_initializers(types_by_swift_name, t)
        for i in initializers:
            print_new_function(t, i)

    print('}')  # Type end


if __name__ == '__main__':
    main()
