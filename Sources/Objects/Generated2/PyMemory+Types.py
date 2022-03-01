from typing import List
from Sourcery import get_types, TypeInfo
from Helpers import generated_warning, NewTypeArguments

def print_type_and_object_types_init(all_types: List[TypeInfo]):
    object_type = None
    type_type = None
    for t in all_types:
        if t.swift_type_name == 'PyObject':
            object_type = t
        elif t.swift_type_name == 'PyType':
            type_type = t

    object_args = NewTypeArguments(object_type, all_types)
    type_args = NewTypeArguments(type_type, all_types)

    object_flags = ', '.join(object_args.flags)
    type_flags = ', '.join(type_args.flags)

    print(f'''\
// MARK: - Type/object types init

extension PyMemory {{

  /// Those types require a special treatment because:
  /// - `object` type has `type` type
  /// - `type` type has `type` type (self reference) and `object` type as base
  public func newTypeAndObjectTypes() -> (typeType: PyType, objectType: PyType) {{
    let layout = PyType.layout
    let typeTypePtr = self.allocate(size: layout.size, alignment: layout.alignment)
    let objectTypePtr = self.allocate(size: layout.size, alignment: layout.alignment)

    let typeType = PyType(ptr: typeTypePtr)
    let objectType = PyType(ptr: objectTypePtr)

    objectType.initialize(type: typeType,
                          name: "{object_args.name}",
                          qualname: "{object_args.qualname}",
                          flags: [{object_flags}],
                          base: nil,
                          bases: [],
                          mroWithoutSelf: [],
                          subclasses: [],
                          layout: {object_args.layout_property},
                          staticMethods: {object_args.static_methods_property},
                          debugFn: {object_args.debugFn},
                          deinitialize: {object_args.deinitialize})

    typeType.initialize(type: typeType,
                        name: "{type_args.name}",
                        qualname: "{type_args.qualname}",
                        flags: [{type_flags}],
                        base: objectType,
                        bases: [objectType],
                        mroWithoutSelf: [objectType],
                        subclasses: [],
                        layout: {type_args.layout_property},
                        staticMethods: {type_args.static_methods_property},
                        debugFn: {type_args.debugFn},
                        deinitialize: {type_args.deinitialize})

   return (typeType, objectType)
  }}
}}
''')

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

    # ===========
    # === New ===
    # ===========


    for init in t.swift_initializers:
        init_arguments = init.arguments

        print()
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
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable function_parameter_count
// swiftlint:disable file_length

// This file contains:
// - PyMemory.newTypeAndObjectTypes - because they have recursive dependency
// - then for each type:
//   - PyMemory.[TYPE_NAME]Layout - mainly field offsets
//   - PyMemory.new[TYPE_NAME] - to create new object of this type
//   - [TYPE_NAME].deinitialize(ptr:) - to deinitialize this object before deletion
''')

    all_types = get_types()
    print_type_and_object_types_init(all_types)

    for t in all_types:
        print_type_things(t)

if __name__ == '__main__':
    main()
