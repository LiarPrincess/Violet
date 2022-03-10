from Sourcery import get_types
from Common.strings import generated_warning
from Builtin_types import (
    get_property_name_escaped, print_property, print_set_property,
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

    # We have to do some work to init types in the correct order.
    # 'object' and 'type' first, 'bool' last (because it depends on 'int')
    object_type = None
    type_type = None
    bool_type = None
    for t in types:
        if t.python_type_name == 'object':
            object_type = t
        if t.python_type_name == 'type':
            type_type = t
        if t.python_type_name == 'bool':
            bool_type = t

    print('''\
  /// Init that will only initialize properties.
  /// (see comment at the top of this file)
  internal init() {
    // Requirements for 'self.object' and 'self.type':
    // 1. 'type' inherits from 'object'
    // 2. both 'type' and 'object' are instances of 'type'
    // To do this we will skip setting the 'type' property and fill it later.\
''')

    print_set_property(object_type, types)
    print()
    print_set_property(type_type, types)
    print()

    print('''\
    // And now we can set type on 'object' and 'type' types
    // (to create circular references).
    self.object.setType(to: self.type)
    self.type.setType(to: self.type)

    // 'self.bool' has to be last because it uses 'self.int' as base!\
''')

    for t in types:
        python_type_name = t.python_type_name
        if python_type_name not in ('object', 'type', 'bool'):
            print_set_property(t, types)
            print()

    print("    // And now we can set 'bool' (because we have 'self.int').")
    print_set_property(bool_type, types)
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
