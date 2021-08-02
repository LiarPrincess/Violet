from Sourcery import get_types
from Common.strings import generated_warning
from TypeMemoryLayout import get_layout_name
from StaticMethodsForBuiltinTypes import get_property_name as get_static_methods_property_name
from Builtin_types import (
    get_property_name_escaped, print_property,
    print_type_mark,
    get_fill_function_name, print_fill_function, print_fill_helpers,
    print_castSelf_functions
)


if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

import BigInt
import VioletCore

// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable trailing_comma
// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

// Type initialization order:
//
// Stage 1: Create all type objects ('init()' function)
// Just instantiate all of the 'PyType' properties.
// At this point we can't fill '__dict__', because for this we would need other
// types to be already initialized (which would be circular).
// For example we can't insert '__doc__' because for this we would need 'str' type,
// which may not yet exist.
//
// Stage 2: Fill type objects ('fill__dict__()' method)
// When all of the types are initalized we can finally fill dictionaries.
''')

    print('public final class BuiltinTypes {')
    print()

    # ==================
    # === Properties ===
    # ==================

    print('  // MARK: - Properties')
    print()

    all_types = get_types()
    types = list(filter(lambda t: not t.is_error, all_types))

    for t in types:
        print_property(t)

    print()

    # ============
    # === Init ===
    # ============

    print('  // MARK: - Stage 1 - init')
    print()

    print('''\
  /// Init that will only initialize properties.
  /// (see comment at the top of this file)
  internal init() {
    // Requirements (for 'self.object' and 'self.type'):
    // 1. 'type' inherits from 'object'
    // 2. both 'type' and 'object' are instances of 'type'
    self.object = PyType.initObjectType()
    self.type = PyType.initTypeType(objectType: self.object)

    // 'has__dict__' flag is copied from type to instance, and because
    // 'self.type' has not yet been filled it is not set! This means that
    // all of the instances initialized in this method will not get it.
    //
    // Example why this is needed:
    // When filling 'type' type we will need to access its '__dict__'.
    // If the 'has__dict__' flag is not set then we don't have a '__dict__'!
    self.type.typeFlags.instancesHave__dict__ = true

    // And now we can fill type.
    self.object.setType(to: self.type)
    self.type.setType(to: self.type)

    // 'self.bool' has to be last because it uses 'self.int' as base!\
''')

    for t in types:
        python_type_name = t.python_type_name

        # 'self.object' and 'self.type' are already initialized
        if python_type_name == 'object' or python_type_name == 'type':
            continue

        # 'self.bool' has to be last because it uses 'self.int' as base!
        if python_type_name == 'bool':
            continue

        layout = get_layout_name(t)
        property_name_escaped = get_property_name_escaped(python_type_name)
        static_methods = get_static_methods_property_name(t.swift_type_name)
        print(f'    self.{property_name_escaped} = PyType.initBuiltinType(name: "{python_type_name}", type: self.type, base: self.object, staticMethods: StaticMethodsForBuiltinTypes.{static_methods}, layout: .{layout})')

    # And now add 'bool'
    print('    self.bool = PyType.initBuiltinType(name: "bool", type: self.type, base: self.int, staticMethods: StaticMethodsForBuiltinTypes.bool, layout: .PyBool)')
    print('  }')
    print()

    # ====================
    # === fill__dict__ ===
    # ====================

    print('  // MARK: - Stage 2 - fill __dict__')
    print()

    print('''\
  /// This function finalizes init of all of the stored types.
  /// (see comment at the top of this file)
  ///
  /// For example it will:
  /// - set type flags
  /// - add `__doc__`
  /// - fill `__dict__`
  internal func fill__dict__() {\
''')

    for t in types:
        python_type_name = t.python_type_name
        fill_function = get_fill_function_name(t)
        print(f'    self.{fill_function}()')

    print('  }')
    print()

    # ===========
    # === all ===
    # ===========

    print('  // MARK: - All')
    print()

    print('''\
  internal var all: [PyType] {
    return [\
''')

    for t in types:
        python_type_name = t.python_type_name
        property_name_escaped = get_property_name_escaped(python_type_name)
        print(f'      self.{property_name_escaped},')

    print('    ]')
    print('  }')
    print()

    # ============================
    # === fill__dict__ methods ===
    # ============================

    print_fill_helpers()

    for t in types:
        print_type_mark(t)
        print_fill_function(t)
        print_castSelf_functions(t)

    print('}')
