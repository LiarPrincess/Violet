from typing import List, Optional
from Helpers import NewTypeArguments, generated_warning
from Sourcery import TypeInfo, SwiftStoredProperty, SwiftInitializerInfo, get_types

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
    let typeTypePtr = self.allocateObject(size: layout.size, alignment: layout.alignment)
    let objectTypePtr = self.allocateObject(size: layout.size, alignment: layout.alignment)

    let typeType = PyType(ptr: typeTypePtr)
    let objectType = PyType(ptr: objectTypePtr)

    PyType.initialize(
      typeType: typeType,
      typeTypeFlags: [{type_flags}],
      objectType: objectType,
      objectTypeFlags: [{object_flags}]
    )

    return (objectType, typeType)
  }}
}}\
''')

# ===================
# === Single type ===
# ===================

class PropertyInLayout:
    def __init__(self, type: TypeInfo, prop: SwiftStoredProperty):
        self.declared_in_type = type
        self.swift_name = prop.swift_name
        self.swift_type = prop.swift_type
        self.has_setter = prop.has_setter
        self.is_visible_only_on_object = prop.is_visible_only_on_object
        self.pointer_property_name = self.swift_name + 'Ptr'
        self.layout_offset_property_name = self.swift_name + 'Offset'

def print_type_extension(t: TypeInfo):
    python_type_name = t.python_type_name
    swift_type_name = t.swift_type_name
    swift_type_name_without_py = swift_type_name[2:]

    properties_t: List[PropertyInLayout] = []
    for p in t.swift_properties:
        properties_t.append(PropertyInLayout(t, p))

    current_base = t.base_type_info
    properties_base: List[PropertyInLayout] = []
    while current_base != None:
        current_base_properties: List[PropertyInLayout] = []
        for p in current_base.swift_properties:
            current_base_properties.append(PropertyInLayout(current_base, p))

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

    # ==============
    # === Layout ===
    # ==============

    print(f'  /// Arrangement of fields in memory.')
    print(f'  ///')

    if not properties_t:
        assert t.base_type_info is not None, 'Expected PyObject to have \'some\' properties'
        swift_base_type_name = t.base_type_info.swift_type_name

        print(f'  /// `{swift_type_name}` does not have any properties with `sourcery: storedProperty` annotation,')
        print(f'  /// so we will use the same layout as `{swift_base_type_name}`.')
        print(f'  internal typealias Layout = {swift_base_type_name}.Layout')
    else:
        print(f'  /// This type was automatically generated based on `{swift_type_name}` properties')
        print(f'  /// with `sourcery: storedProperty` annotation.')
        print(f'  internal struct Layout {{')

        for p in properties_t:
            print(f'    internal let {p.layout_offset_property_name}: Int')

        print(f'    internal let size: Int')
        print(f'    internal let alignment: Int')
        print()

        if t.base_type_info is None:
            assert t.python_type_name == 'object'
            initial_offset = '0'
            initial_alignment = '0'
        else:
            base_swift_type_name = t.base_type_info.swift_type_name
            initial_offset = base_swift_type_name + '.layout.size'
            initial_alignment = base_swift_type_name + '.layout.alignment'

        print(f'    internal init() {{')
        print(f'      assert(MemoryLayout<{swift_type_name}>.size == MemoryLayout<RawPtr>.size, "Only \'RawPtr\' should be stored.")')
        print(f'      let layout = GenericLayout(')
        print(f'        initialOffset: {initial_offset},')
        print(f'        initialAlignment: {initial_alignment},')
        print('        fields: [')

        for index, p in enumerate(properties_t):
            is_last = index == len(properties_t) - 1
            comma = '' if is_last else ','
            declared_in = '' if p.declared_in_type is None else p.declared_in_type.swift_type_name + '.'
            print(f'          GenericLayout.Field({p.swift_type}.self){comma} // {declared_in}{p.swift_name}')

        print('        ]')
        print('      )')

        print()
        print(f'      assert(layout.offsets.count == {len(properties_t)})')

        for index, p in enumerate(properties_t):
            print(f'      self.{p.layout_offset_property_name} = layout.offsets[{index}]')

        print('      self.size = layout.size')
        print('      self.alignment = layout.alignment')
        print('    }')
        print('  }')

    print()
    print('  /// Arrangement of fields in memory.')
    print('  internal static let layout = Layout()')
    print()

    # ==========================
    # === Pointer properties ===
    # ==========================

    for p in properties_base:
        if p.is_visible_only_on_object:
            continue

        swift_owner_type_name = p.declared_in_type.swift_type_name
        print(f'  /// Property from base class: `{swift_owner_type_name}.{p.swift_name}`.')
        print(f'  internal var {p.pointer_property_name}: Ptr<{p.swift_type}> {{ Ptr(self.ptr, offset: {swift_owner_type_name}.layout.{p.layout_offset_property_name}) }}')

    for p in properties_t:
        swift_owner_type_name = p.declared_in_type.swift_type_name
        print(f'  /// Property: `{swift_owner_type_name}.{p.swift_name}`.')
        print(f'  internal var {p.pointer_property_name}: Ptr<{p.swift_type}> {{ Ptr(self.ptr, offset: Self.layout.{p.layout_offset_property_name}) }}')

    print()

    # ==================
    # === Properties ===
    # ==================

    for p in properties_base:
        if p.is_visible_only_on_object:
            continue

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

    print(f'  internal static func deinitialize(_ py: Py, ptr: RawPtr) {{')
    print(f'    let zelf = {swift_type_name}(ptr: ptr)')
    print(f'    zelf.beforeDeinitialize(py)')

    if properties_t:
        print()
        print(f'    // Call \'deinitialize\' on all of our own properties.')

        for p in properties_t:
            print(f'    zelf.{p.pointer_property_name}.deinitialize()')

    if t.base_type_info is not None:
        print()
        base_swift_type_name = t.base_type_info.swift_type_name
        print(f'    // Call \'deinitialize\' on base type.')
        print(f'    // This will also call base type \'beforeDeinitialize\'.')
        print(f'    {base_swift_type_name}.deinitialize(py, ptr: ptr)')

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
        print(f'  internal static func invalidZelfArgument(_ py: Py,')
        print(f'                                           _ object: PyObject,')
        print(f'                                           _ fnName: String) -> PyResult {{')
        print(f'    let error = py.newInvalidSelfArgumentError(object: object,')
        print(f'                                               expectedType: Self.pythonTypeName,')
        print(f'                                               fnName: fnName)')
        print()
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

        arguments: List[str] = []
        call_arguments: List[str] = []
        for index, arg in enumerate(init_arguments):
            if index == 0:
                # Do not include 'Py' in arguments
                assert arg.typ == 'Py'
                call_arguments.append('self.py')
                continue

            label = '' if arg.label is None else arg.label + ' '
            default_value =  '' if arg.default_value is None else ' = ' + arg.default_value
            arguments.append(f'{label}{arg.name}: {arg.typ}{default_value}')

            if arg.label == '_':
                call_label = ''
            elif arg.label:
                call_label = arg.label + ': '
            else:
                call_label = arg.name + ': '

            call_arguments.append(f'{call_label}{arg.name}')

        print()
        print(f'  /// Allocate a new instance of `{python_type_name}` type.')
        print(f'  public func new{swift_type_name_without_py}(', end='')

        is_single_line = len(arguments) <= 3

        for index, arg in enumerate(arguments):
            is_first = index == 0
            is_last = index == len(arguments) - 1
            comma = '' if is_last else ','

            if is_single_line:
                indent = ''
                end = '' if is_last else f' '
            else:
                indent = '' if is_first else ((18 + len(swift_type_name_without_py)) * ' ')
                end = '' if is_last else '\n'

            print(f'{indent}{arg}{comma}', end=end)

        print(f') -> {swift_type_name} {{')
        print(f'    let typeLayout = {swift_type_name}.layout')
        print(f'    let ptr = self.allocateObject(size: typeLayout.size, alignment: typeLayout.alignment)')
        print()
        print(f'    let result = {swift_type_name}(ptr: ptr)')
        print(f'    result.initialize(', end='')

        for index, arg in enumerate(call_arguments):
            is_first = index == 0
            is_last = index == len(call_arguments) - 1
            comma = '' if is_last else ','

            if is_single_line:
                indent = ''
                end = '' if is_last else f' '
            else:
                indent = '' if is_first else (22 * ' ')
                end = '' if is_last else f'\n'

            print(f'{indent}{arg}{comma}', end=end)

        print(')')
        print()
        print('    return result')
        print('  }')

    print('}')


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

// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable function_parameter_count
// swiftlint:disable file_length

// This file contains:
// - PyMemory.newTypeAndObjectTypes - because they have recursive dependency
// - Then for each type:
//   - static let pythonTypeName - name of the type in Python
//   - static let layout - field offsets for memory layout
//   - var xxxPtr - pointer to property (with offset from layout)
//   - var xxx - property from base class
//   - func initializeBase(...) - call base initializer
//   - static func deinitialize(ptr: RawPtr) - to deinitialize this object before deletion
//   - static func downcast(py: Py, object: PyObject) -> [TYPE_NAME]?
//   - static func invalidZelfArgument<T>(py: Py, object: PyObject, fnName: String) -> PyResult<T>
//   - PyMemory.new[TYPE_NAME] - to create new object of this type
''')

    all_types = get_types()
    print_type_and_object_types_init(all_types)

    for t in all_types:
        print()
        print_type_extension(t)

if __name__ == '__main__':
    main()
