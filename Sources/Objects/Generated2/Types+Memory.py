from typing import List
from Sourcery import ObjectHeader, get_object_header, ErrorHeader, get_error_header, TypeInfo, get_types
from Helpers import NewTypeArguments, generated_warning

HEADER_OFFSET = 'PyObjectHeader.layout.size'
HEADER_ALIGNMENT = 'PyObjectHeader.layout.alignment'
ERROR_HEADER_OFFSET = 'PyErrorHeader.layout.size'
ERROR_HEADER_ALIGNMENT = 'PyErrorHeader.layout.alignment'

# =====================
# === Object header ===
# =====================

class PointerField:
    def __init__(self, swift_name: str, swift_type: str):
        self.swift_name = swift_name
        self.swift_type = swift_type
        self.pointer_name = swift_name + 'Ptr'

        self.swift_pointed_type = swift_type
        if self.swift_pointed_type.startswith('Ptr<'):
            self.swift_pointed_type = self.swift_pointed_type[4:-1]

        offset_name_base = swift_name
        if offset_name_base.endswith('Ptr'):
            offset_name_base = offset_name_base[:-3]

        self.offset_property_name = offset_name_base + 'Offset'

def print_object_header_things(h: ObjectHeader):
    pointer_fields: List[PointerField] = []
    for f in h.fields:
        pointer_fields.append(PointerField(f.swift_name, f.swift_type))

    print('// MARK: - PyObjectHeader')
    print()
    print('extension PyObjectHeader {')
    print()
    print_layout('PyObjectHeader', '0', '0', pointer_fields)
    print()
    print_pointer_properties(pointer_fields)
    print('}')
    print()

def print_layout(swift_type_name: str,
                 initial_offset: str,
                 initial_alignment: str,
                 fields: List[PointerField]):

    print(f'  /// This type was automatically generated based on `{swift_type_name}` fields')
    print(f'  /// with `sourcery: includeInLayout` annotation.')
    print(f'  internal struct Layout {{')

    for p in fields:
        print(f'    internal let {p.offset_property_name}: Int')

    print(f'    internal let size: Int')
    print(f'    internal let alignment: Int')
    print()
    print(f'    internal init() {{')
    print(f'      let layout = PyMemory.GenericLayout(')
    print(f'        initialOffset: {initial_offset},')
    print(f'        initialAlignment: {initial_alignment},')

    if len(fields) == 0:
        print('        fields: []')
    else:
        print('        fields: [')

        for index, p in enumerate(fields):
            is_last = index == len(fields) - 1
            comma = '' if is_last else ','
            print(f'          PyMemory.FieldLayout(from: {p.swift_pointed_type}.self){comma} // {p.swift_name}')

        print('        ]')

    print('      )')
    print()

    print(f'      assert(layout.offsets.count == {len(fields)})')

    for index, p in enumerate(fields):
        print(f'      self.{p.offset_property_name} = layout.offsets[{index}]')

    print('      self.size = layout.size')
    print('      self.alignment = layout.alignment')
    print('    }')
    print('  }')
    print()
    print('  internal static let layout = Layout()')

def print_pointer_properties(fields: List[PointerField]):
    for f in fields:
        print(f'  internal var {f.pointer_name}: Ptr<{f.swift_type}> {{ Ptr(self.ptr, offset: Self.layout.{f.offset_property_name}) }}')

# ====================
# === Error header ===
# ====================

def print_error_header_things(h: ErrorHeader):
    pointer_fields: List[PointerField] = []
    for f in h.fields:
        pointer_fields.append(PointerField(f.swift_name, f.swift_type))

    print('// MARK: - PyErrorHeader')
    print()
    print('extension PyErrorHeader {')
    print()
    print_layout('PyErrorHeader', HEADER_OFFSET, HEADER_ALIGNMENT, pointer_fields)
    print()
    print_pointer_properties(pointer_fields)
    print('}')
    print()

# =========================================
# === PyMemory + type/object types init ===
# =========================================

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
  public func newTypeAndObjectTypes(_ py: Py) -> (objectType: PyType, typeType: PyType) {{
    let layout = PyType.layout
    let objectTypePtr = self.allocate(size: layout.size, alignment: layout.alignment)
    let typeTypePtr = self.allocate(size: layout.size, alignment: layout.alignment)

    let objectType = PyType(ptr: objectTypePtr)
    let typeType = PyType(ptr: typeTypePtr)

    objectType.initialize(py,
                          type: typeType,
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

    typeType.initialize(py,
                        type: typeType,
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

   return (objectType, typeType)
  }}
}}
''')

# ===================
# === Single type ===
# ===================

def print_type_things(t: TypeInfo):
    swift_type_name = t.swift_type_name

    pointer_fields: List[PointerField] = []
    for f in t.swift_fields:
        pointer_fields.append(PointerField(f.swift_name, f.swift_type))

    print(f'// MARK: - {swift_type_name}')
    print()

    print(f'extension {swift_type_name} {{')
    print()

    (initial_offset, initial_alignment) = (ERROR_HEADER_OFFSET, ERROR_HEADER_ALIGNMENT) \
        if t.is_error else (HEADER_OFFSET, HEADER_ALIGNMENT)

    print_layout(swift_type_name, initial_offset, initial_alignment, pointer_fields)
    print()
    print_pointer_properties(pointer_fields)
    print()

    # ====================
    # === Deinitialize ===
    # ====================

    print(f'  internal static func deinitialize(ptr: RawPtr) {{')
    print(f'    let zelf = {swift_type_name}(ptr: ptr)')
    print(f'    zelf.beforeDeinitialize()')

    if len(pointer_fields):
        print()

    print('    zelf.header.deinitialize()')

    for p in pointer_fields:
        print(f'    zelf.{p.pointer_name}.deinitialize()')

    print('  }')
    print('}') # type extension
    print()

    # ======================
    # === PyMemory + new ===
    # ======================

    python_type = t.python_type_name
    swift_type_name_without_py = swift_type_name[2:]

    print('extension PyMemory {')

    for init in t.swift_initializers:
        init_arguments = init.arguments

        print()
        print(f'  /// Allocate a new instance of `{python_type}` type.')
        print(f'  public func new{swift_type_name_without_py}(')

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

        print(f'  ) -> {swift_type_name} {{')
        print(f'    let typeLayout = {swift_type_name}.layout')
        print(f'    let ptr = self.allocate(size: typeLayout.size, alignment: typeLayout.alignment)')
        print(f'    let result = {swift_type_name}(ptr: ptr)')
        print()

        print(f'    result.initialize(')

        for index, arg in enumerate(init_arguments):
            label = arg.label or arg.name
            label_colon = label + ': '

            # Special case '_' label
            if label_colon == '_: ':
                label_colon = ''

            is_last = index == len(init_arguments) - 1
            comma = '' if is_last else ','
            print(f'      {label_colon}{arg.name}{comma}')

        print('    )')
        print()
        print('    return result')
        print('  }')

    print('}')
    print()


# ============
# === Main ===
# ============

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
// - For 'PyObjectHeader':
//   - PyObjectHeader.Layout - mainly field offsets
//   - PyObjectHeader.xxxPtr - pointer properties to fields
// - For 'PyErrorHeader':
//   - PyErrorHeader.Layout - mainly field offsets
//   - PyErrorHeader.xxxPtr - pointer properties to fields
// - PyMemory.newTypeAndObjectTypes - because they have recursive dependency
// - Then for each type:
//   - [TYPE_NAME].Layout - mainly field offsets
//   - [TYPE_NAME].deinitialize(ptr:) - to deinitialize this object before deletion
//   - PyMemory.new[TYPE_NAME] - to create new object of this type
''')

    header = get_object_header()
    print_object_header_things(header)

    error_header = get_error_header()
    print_error_header_things(error_header)

    all_types = get_types()
    print_type_and_object_types_init(all_types)

    for t in all_types:
        print_type_things(t)

if __name__ == '__main__':
    main()
