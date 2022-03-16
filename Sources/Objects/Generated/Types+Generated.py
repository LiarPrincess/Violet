from typing import List, Optional
from Helpers import NewTypeArguments, generated_warning
from Sourcery import (
    ErrorHeader, get_error_header,
    TypeInfo, SwiftInitializerInfo, get_types
)

# ===============
# === Helpers ===
# ===============

class PropertyInLayout:
    def __init__(self, swift_name: str, swift_type: str, declared_in_type: Optional[TypeInfo] = None):
        self.swift_name = swift_name
        self.swift_type = swift_type
        self.declared_in_type = declared_in_type
        self.pointer_property_name = swift_name + 'Ptr'
        self.layout_offset_property_name = swift_name + 'Offset'

def print_layout(swift_type_name: str,
                 initial_offset: str,
                 initial_alignment: str,
                 fields: List[PropertyInLayout]):
    print(f'  /// Arrangement of fields in memory.')
    print(f'  ///')
    print(f'  /// This type was automatically generated based on `{swift_type_name}` fields')
    print(f'  /// with `sourcery: storedProperty` annotation.')
    print(f'  internal struct Layout {{')

    for p in fields:
        print(f'    internal let {p.layout_offset_property_name}: Int')

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
            declared_in = '' if p.declared_in_type is None else p.declared_in_type.swift_type_name + '.'
            print(f'          PyMemory.FieldLayout(from: {p.swift_type}.self){comma} // {declared_in}{p.swift_name}')

        print('        ]')

    print('      )')
    print()

    print(f'      assert(layout.offsets.count == {len(fields)})')

    for index, p in enumerate(fields):
        print(f'      self.{p.layout_offset_property_name} = layout.offsets[{index}]')

    print('      self.size = layout.size')
    print('      self.alignment = layout.alignment')
    print('    }')
    print('  }')
    print()
    print(f'  /// Arrangement of fields in memory.')
    print('  internal static let layout = Layout()')

def print_pointer_properties(properties_base: List[PropertyInLayout], properties_type: List[PropertyInLayout]):
    for p in properties_base:
        swift_type_name = p.declared_in_type.swift_type_name
        print(f'  /// Property from base class: `{swift_type_name}.{p.swift_name}`.')
        print(f'  internal var {p.pointer_property_name}: Ptr<{p.swift_type}> {{ Ptr(self.ptr, offset: {swift_type_name}.layout.{p.layout_offset_property_name}) }}')

    for p in properties_type:
        if p.declared_in_type:
            swift_type_name = p.declared_in_type.swift_type_name
            print(f'  /// Property: `{swift_type_name}.{p.swift_name}`.')
        print(f'  internal var {p.pointer_property_name}: Ptr<{p.swift_type}> {{ Ptr(self.ptr, offset: Self.layout.{p.layout_offset_property_name}) }}')

def print_base_types_properties(properties_base: List[PropertyInLayout]):
    for p in properties_base:
        name = p.swift_name
        typ = p.swift_type
        pointer_property_name = p.pointer_property_name

        swift_owner_type_name = p.declared_in_type.swift_type_name
        print(f'  /// Property from base class: `{swift_owner_type_name}.{name}`.')

        if name in ('__dict__', 'flags'):
            print(f'  internal var {name}: {typ} {{')
            print(f'    get {{ self.{pointer_property_name}.pointee }}')
            print(f'    nonmutating set {{ self.{pointer_property_name}.pointee = newValue }}')
            print(f'  }}')
        else:
            print(f'  internal var {name}: {typ} {{ self.{pointer_property_name}.pointee }}')

# ===========================
# === Object/error header ===
# ===========================

def print_error_header_extension(h: ErrorHeader):
    fields: List[PropertyInLayout] = []
    for f in h.fields:
        fields.append(PropertyInLayout(f.swift_name, f.swift_type))


    HEADER_OFFSET = 'PyObject.layout.size'
    HEADER_ALIGNMENT = 'PyObject.layout.alignment'

    print('// MARK: - PyErrorHeader')
    print()
    print('extension PyErrorHeader {')
    print()
    print_layout('PyErrorHeader', HEADER_OFFSET, HEADER_ALIGNMENT, fields)
    print()
    print_pointer_properties([], fields)
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

    assert object_type is not None
    assert type_type is not None
    object_args = NewTypeArguments(object_type)
    type_args = NewTypeArguments(type_type)

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

def print_type_extension(t: TypeInfo):
    python_type_name = t.python_type_name
    swift_type_name = t.swift_type_name
    swift_type_name_without_py = swift_type_name[2:]

    properties_type: List[PropertyInLayout] = []
    for f in t.swift_properties:
        properties_type.append(PropertyInLayout(f.swift_name, f.swift_type, t))

    current_base = t.base_type_info
    properties_base: List[PropertyInLayout] = []
    while current_base != None:
        current_base_properties: List[PropertyInLayout] = []
        for p in current_base.swift_properties:
            current_base_properties.append(PropertyInLayout(p.swift_name, p.swift_type, current_base))

        # Sort base properties: 'object' -> 'base_base' -> 'base'
        properties_base = current_base_properties + properties_base
        current_base = current_base.base_type_info

    print(f'// MARK: - {swift_type_name}')
    print()

    print(f'extension {swift_type_name} {{')
    print()
    print(f'  /// Name of the type in Python.')
    print(f'  public static let pythonTypeName = "{t.python_type_name}"')
    print()

    if t.base_type_info is None:
        assert t.python_type_name == 'object'
        initial_offset = '0'
        initial_alignment = '0'
    else:
        base_swift_type_name = t.base_type_info.swift_type_name
        initial_offset = base_swift_type_name + '.layout.size'
        initial_alignment = base_swift_type_name + '.layout.alignment'

    print_layout(swift_type_name, initial_offset, initial_alignment, properties_type)
    print()
    print_pointer_properties(properties_base, properties_type)
    print()
    print_base_types_properties(properties_base)

    if properties_base:
        print()

    # =======================
    # === Initialize base ===
    # =======================

    base_initializers: List[SwiftInitializerInfo] = []
    if t.base_type_info is not None:
        base_initializers = t.base_type_info.swift_initializers

    for fn in base_initializers:
        print(f'  internal func initializeBase(', end='')

        arguments: List[str] = []
        call_arguments: List[str] = []
        for arg in fn.arguments:
            label = '' if arg.label is None else arg.label + ' '
            default = '' if arg.default_value is None else ' = ' + arg.default_value
            arguments.append(f'{label}{arg.name}: {arg.typ}{default}')

            if arg.label == '_':
                call_label = ''
            elif arg.label:
                call_label = arg.label + ': '
            else:
                call_label = arg.name + ': '

            call_arguments.append(f'{call_label}{arg.name}')

        is_single_line = len(arguments) <= 3
        for index, arg in enumerate(arguments):
            is_first = index == 0
            is_last = index == len(arguments) - 1

            if is_single_line:
                indent = '' if is_first else ' '
                end = ') {\n' if is_last else ','
            else:
                indent = '' if is_first else (31 * ' ')
                end = ') {\n' if is_last else ',\n'

            print(f'{indent}{arg}', end=end)

        print(f'    let base = {t.base_type_info.swift_type_name}(ptr: self.ptr)')
        print(f'    base.{fn.name}(', end='')
        for index, arg in enumerate(call_arguments):
            is_first = index == 0
            is_last = index == len(call_arguments) - 1

            if is_single_line:
                indent = '' if is_first else ' '
                end = ')\n' if is_last else ','
            else:
                indent = '' if is_first else (20 * ' ')
                end = ')\n' if is_last else ',\n'

            print(f'{indent}{arg}', end=end)

        print(f'  }}')
        print()

    # ====================
    # === Deinitialize ===
    # ====================

    print(f'  internal static func deinitialize(ptr: RawPtr) {{')
    print(f'    // Call \'beforeDeinitialize\' starting from most-specific type.')

    current_type = t
    while current_type is not None:
        print(f'    {current_type.swift_type_name}(ptr: ptr).beforeDeinitialize()')
        current_type = current_type.base_type_info

    if properties_type:
        print()
        print(f'    // Call \'deinitialize\' on all of our own properties.')
        print(f'    let zelf = {swift_type_name}(ptr: ptr)')

        for p in properties_type:
            print(f'    zelf.{p.pointer_property_name}.deinitialize()')

    if t.base_type_info is not None:
        print()
        base_swift_type_name = t.base_type_info.swift_type_name
        print(f'    // Call \'deinitialize\' on base type.')
        print(f'    {base_swift_type_name}.deinitialize(ptr: ptr)')

    print('  }')

    # ==================
    # === Functions ===
    # ==================

    if python_type_name != 'object':
        print()
        print(f'  internal static func downcast(_ py: Py, _ object: PyObject) -> {swift_type_name}? {{')
        print(f'    return py.cast.as{swift_type_name_without_py}(object)')
        print(f'  }}')
        print()
        print(f'  internal static func invalidZelfArgument<T>(_ py: Py,')
        print(f'                                              _ object: PyObject,')
        print(f'                                              _ fnName: String) -> PyResult<T> {{')
        print(f'    let error = py.newInvalidSelfArgumentError(object: object,')
        print(f'                                               expectedType: Self.pythonTypeName,')
        print(f'                                               fnName: fnName)')
        print(f'')
        print(f'    return .error(error.asBaseException)')
        print(f'  }}')


    print('}') # type extension
    print()

    # ======================
    # === PyMemory + new ===
    # ======================

    print('extension PyMemory {')

    for init in t.swift_initializers:
        init_arguments = init.arguments

        print()
        print(f'  /// Allocate a new instance of `{python_type_name}` type.')
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
// - For 'PyErrorHeader':
//   - PyErrorHeader.Layout - mainly field offsets
//   - PyErrorHeader.xxxPtr - pointer properties to fields
// - PyMemory.newTypeAndObjectTypes - because they have recursive dependency
// - Then for each type:
//   - static let pythonTypeName - name of the type in Python
//   - static let layout - mainly field offsets
//   - static func deinitialize(ptr: RawPtr) - to deinitialize this object before deletion
//   - static func downcast(py: Py, object: PyObject) -> [TYPE_NAME]?
//   - static func invalidZelfArgument<T>(py: Py, object: PyObject, fnName: String) -> PyResult<T>
//   - PyMemory.new[TYPE_NAME] - to create new object of this type
''')

    error_header = get_error_header()
    print_error_header_extension(error_header)

    all_types = get_types()
    print_type_and_object_types_init(all_types)

    for t in all_types:
        print_type_extension(t)

if __name__ == '__main__':
    main()
