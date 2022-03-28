from typing import List
from Sourcery import get_types
from Helpers import (
    generated_warning,
    where_to_find_errors_in_cpython,
    PyTypeDefinition,
    exception_hierarchy
)

if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

import VioletCore

// swiftlint:disable function_parameter_count
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

{where_to_find_errors_in_cpython}

// Just like 'Py.Types' this will be a 2 phase init.
// See 'Py.Types' for reasoning.\
''')

    print('extension Py {')
    print()
    print('  public final class ErrorTypes {')
    print()

    all_types = get_types()

    # Errors in 'data' are in the correct order (parent is before its subclasses).
    types: List[PyTypeDefinition] = []
    for e in exception_hierarchy:
        python_type = e.type_name

        p = None
        for t in all_types:
            if t.python_type_name == python_type:
                assert p is None
                p = PyTypeDefinition(t)

        assert p is not None, f"Type not found: '{python_type}'"
        types.append(p)

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
    print('    /// Init that will only initialize properties.')
    print('    internal init(_ py: Py, typeType: PyType, objectType: PyType) {')
    print('      let memory = py.memory')
    print()

    for t in types:
        python_type_name = t.python_type_name
        if python_type_name not in ('object', 'type', 'bool'):
            t.print_set_property()
            print()

    print('    }')
    print()

    # ====================
    # === fill__dict__ ===
    # ====================

    print('    // MARK: - Stage 2 - fill __dict__')
    print()

    print('''\
    /// This function finalizes init of all of the stored types.
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
