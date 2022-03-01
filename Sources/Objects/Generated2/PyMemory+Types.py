from Sourcery import get_types, TypeInfo
from Common.strings import generated_warning

class PointerProperty:
    def __init__(self, swift_name: str, swift_type: str):
        self.swift_name = swift_name
        self.swift_type = swift_type
        self.swift_pointed_type = swift_type[4:-1] # Without 'Ptr' and '<>'

        offset_name_base = swift_name
        if offset_name_base.endswith('Ptr'):
            offset_name_base = offset_name_base[:-3]

        self.offset_property_name = offset_name_base + 'Offset'

def print_type_things(t: TypeInfo):
    swift_type = t.swift_type_name
    swift_type_without_py = swift_type[2:]
    python_type = t.python_type_name

    print(f'// MARK: - {swift_type}')
    print()

    print('extension PyMemory {')
    print()

    pointer_properties = []
    for p in t.swift_properties:
        p_name = p.swift_name
        p_type = p.swift_type

        if p_type.startswith('Ptr<'):
            p = PointerProperty(p_name, p_type)
            pointer_properties.append(p)

    # ==============
    # === Layout ===
    # ==============

    print(f'  /// This type was automatically generated based on `{swift_type}` fields.')
    print(f'  internal struct {swift_type}Layout {{')

    for p in pointer_properties:
        print(f'    internal let {p.offset_property_name}: Int')

    print('    internal let size: Int')
    print('    internal let alignment: Int')
    print()
    print('    internal init() {')
    print('      let layout = PyMemory.GenericLayout(')
    print('        initialOffset: PyObjectHeader.Layout.size,')
    print('        initialAlignment: PyObjectHeader.Layout.alignment,')

    if len(pointer_properties) == 0:
        print('        fields: []')
    else:
        print('        fields: [')

        for index, p in enumerate(pointer_properties):
            is_last = index == len(pointer_properties) - 1
            comma = '' if is_last else ','
            print(f'          FieldLayout(from: {p.swift_pointed_type}.self){comma}')

        print('        ]')

    print('      )')
    print()

    print(f'      assert(layout.offsets.count == {len(pointer_properties)})')

    for index, p in enumerate(pointer_properties):
        print(f'      self.{p.offset_property_name} = layout.offsets[{index}]')

    print('      self.size = layout.size')
    print('      self.alignment = layout.alignment')
    print('    }')
    print('  }')
    print()

    # ===========
    # === New ===
    # ===========

    init_arguments = t.swift_initializer.arguments

    print(f'  /// Allocate a new instance of `{python_type}` type.')
    print(f'  public func new{swift_type_without_py}(')

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
    print(f'    let typeLayout = {swift_type}.layout')
    print(f'    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)')
    print(f'    let result = {swift_type}(ptr: ptr)')
    print()

    print(f'    result.initialize(')

    for index, arg in enumerate(init_arguments):
        is_last = index == len(init_arguments) - 1
        comma = '' if is_last else ','
        label = arg.label or arg.name
        print(f'      {label}: {arg.name}{comma}')

    print('    )')
    print()
    print('    return result')
    print('  }')
    print('}')
    print()

    # ====================
    # === Deinitialize ===
    # ====================

    print(f'extension {swift_type} {{')

    print(f'  internal static func deinitialize(ptr: RawPtr) {{')
    print(f'    let zelf = {swift_type}(ptr: ptr)')
    print(f'    zelf.beforeDeinitialize()')

    if len(pointer_properties):
        print()

    print('    zelf.header.deinitialize()')

    for p in pointer_properties:
        print(f'    zelf.{p.swift_name}.deinitialize()')

    print('  }')
    print('}')
    print()

def main():
    print(f'''\
{generated_warning(__file__)}

import Foundation
import BigInt
import VioletCore
import VioletBytecode
import VioletCompiler

// swiftlint:disable empty_count
// swiftlint:disable function_parameter_count
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length
''')

    all_types = get_types()

    for t in all_types:
        swift_name = t.swift_type_name

        is_printed = False
        is_printed = is_printed or swift_name in ('PyObject', 'PyType')
        is_printed = is_printed or swift_name in ('PyNone', 'PyNotImplemented', 'PyEllipsis', 'PyNamespace')
        is_printed = is_printed or swift_name in ('PyInt', 'PyBool', 'PyFloat', 'PyComplex')

        if is_printed:
            print_type_things(t)

if __name__ == '__main__':
    main()
