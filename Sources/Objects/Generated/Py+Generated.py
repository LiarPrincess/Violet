from typing import List
from Helpers import generated_warning
from Sourcery import get_py_info

class PropertyInLayout:
    def __init__(self, swift_name: str, swift_type: str):
        # Remove escape character '`'
        swift_name = swift_name.replace('`', '')
        self.swift_name = swift_name
        self.swift_type = swift_type
        self.pointer_property_name = swift_name + 'Ptr'
        self.layout_offset_property_name = swift_name + 'Offset'

def print_mark(name: str):
    print()
    print('  // MARK: - ' + name)
    print()

if __name__ == '__main__':
    py = get_py_info()

    print(generated_warning(__file__))
    print()
    print('import Foundation')
    print('import BigInt')
    print('import VioletCore')
    print('import VioletBytecode')
    print()

    print('// swiftlint:disable function_body_length')
    print('// swiftlint:disable line_length')
    print()
    print('extension Py {')

    # ==============
    # === Layout ===
    # ==============

    layout_properties: List[PropertyInLayout] = []
    for p in py.swift_properties:
        in_layout = PropertyInLayout(p.swift_name, p.swift_type)
        layout_properties.append(in_layout)

    print_mark('Layout')
    print(f'  /// Arrangement of fields in memory.')
    print(f'  ///')
    print(f'  /// This type was automatically generated based on `Py` properties')
    print(f'  /// with `sourcery: storedProperty` annotation.')

    print(f'  internal struct Layout {{')

    for p in layout_properties:
        print(f'    internal let {p.layout_offset_property_name}: Int')

    print()
    print(f'    internal let size: Int')
    print(f'    internal let alignment: Int')
    print()

    print(f'    internal init() {{')
    print(f'      assert(MemoryLayout<Py>.size == MemoryLayout<RawPtr>.size, "Only \'RawPtr\' should be stored.")')
    print(f'      let layout = GenericLayout(')
    print(f'        initialOffset: 0,')
    print(f'        initialAlignment: 0,')
    print('        fields: [')

    for index, p in enumerate(layout_properties):
        is_last = index == len(layout_properties) - 1
        comma = '' if is_last else ','
        print(f'          GenericLayout.Field({p.swift_type}.self){comma} // {p.swift_name}')

    print('        ]')
    print('      )')

    print()
    print(f'      assert(layout.offsets.count == {len(layout_properties)})')

    for index, p in enumerate(layout_properties):
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

    for p in layout_properties:
        print(f'  /// Property: `Py.{p.swift_name}`.')
        print(f'  internal var {p.pointer_property_name}: Ptr<{p.swift_type}> {{ Ptr(self.ptr, offset: Self.layout.{p.layout_offset_property_name}) }}')

    print()

    # ====================
    # === Deinitialize ===
    # ====================

    print(f'  internal func deinitialize() {{')

    for p in layout_properties:
        print(f'    self.{p.pointer_property_name}.deinitialize()')

    print('  }')

    # ===========
    # === End ===
    # ===========

    print('}')
