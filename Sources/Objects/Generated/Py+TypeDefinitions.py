from typing import List
from Sourcery import get_types
from Helpers import generated_warning, PyTypeDefinition

if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

import BigInt
import VioletCore

// swiftlint:disable function_parameter_count
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable closure_body_length
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
// When all of the types are initialized we can finally fill dictionaries.
''')

    print('extension Py {')
    print()
    print('  public final class Types {')
    print()

    all_types = get_types()

    types: List[PyTypeDefinition] = []
    for t in all_types:
        if not t.is_error:
            types.append(PyTypeDefinition(t))

    # ==================
    # === Properties ===
    # ==================

    print('    // MARK: - Properties')
    print()

    for t in types:
        t.print_property()

    print()

    # ============
    # === Init ===
    # ============

    print('    // MARK: - Stage 1 - init')
    print()

    # We have to do some work to init types in the correct order.
    # 'object' and 'type' first, 'bool' last (because it depends on 'int')
    object_type: PyTypeDefinition = None
    type_type: PyTypeDefinition = None
    bool_type: PyTypeDefinition = None
    for t in types:
        if t.python_type_name == 'object':
            object_type = t
        if t.python_type_name == 'type':
            type_type = t
        if t.python_type_name == 'bool':
            bool_type = t

    print(f'''\
    /// Init that will only initialize properties.
    /// (see comment at the top of this file)
    internal init(_ py: Py) {{
      let memory = py.memory

      // Requirements for 'self.object' and 'self.type':
      // 1. 'type' inherits from 'object'
      // 2. both 'type' and 'object' are instances of 'type'
      let pair = memory.newTypeAndObjectTypes(py)
      self.{object_type.property_name} = pair.objectType
      self.{type_type.property_name} = pair.typeType
''')

    print("      // Btw. 'self.bool' has to be last because it uses 'self.int' as base!")
    print()

    for t in types:
        python_type_name = t.python_type_name
        if python_type_name not in ('object', 'type', 'bool'):
            t.print_set_property()
            print()

    print("      // And now we can set 'bool' (because we have 'self.int').")
    bool_type.print_set_property()
    print('    }')
    print()

    # ====================
    # === fill__dict__ ===
    # ====================

    print('    // MARK: - Stage 2 - fill __dict__')
    print()

    print('''\
    /// This function finalizes init of all of the stored types.
    /// (see comment at the top of this file)
    ///
    /// For example it will:
    /// - add `__doc__`
    /// - fill `__dict__`
    internal func fill__dict__(_ py: Py) {\
''')

    for t in types:
        python_type_name = t.python_type_name
        fill_function = t.fill_function_name
        print(f'      self.{fill_function}(py)')

    print('    }')
    print()

    # ============================
    # === fill__dict__ methods ===
    # ============================

    PyTypeDefinition.print_fill_helpers()

    for t in types:
        t.print_mark()
        t.print_fill_function()
        t.print_static_methods()
        print()

    print('  }')
    print('}')
