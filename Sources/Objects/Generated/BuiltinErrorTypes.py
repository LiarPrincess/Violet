from Data.errors import data
from Data.types import get_types
from Common.strings import generated_warning
from Common.errors import where_to_find_it_in_cpython
from Common.builtin_types import (
  get_property_name_escaped,
  get_fill_function_name, print_fill_type_method,
  print_fill_helpers, get_downcast_function_name, print_downcast_function
)

all_types = get_types()
def get_type(e):
  python_type = e.class_name
  for t in all_types:
    if t.python_type == python_type:
      return t

  assert False, f"Type not found: '{python_type}'"

# Errors in 'data' are in the correct order (parent is before its subclasses).
types = list(map(get_type, data))

def get_base_type(t):
  swift_base_type = t.swift_base_type
  for other in all_types:
    if other.swift_type == swift_base_type:
      return other

  assert False, f"Unable to find base type of: '{t.swift_type}'"

if __name__ == '__main__':
  print(f'''\
import Core

// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable trailing_comma
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable file_length

{generated_warning}

{where_to_find_it_in_cpython}

// Just like 'BuiltinTypes' this will be 2 phase init.
// See 'BuiltinTypes' for reasoning.\
''')

  print('public final class BuiltinErrorTypes {')
  print()

  # ==================
  # === Properties ===
  # ==================

  print('  // MARK: - Properties')
  print()

  for t in types:
    python_type = t.python_type
    property_name = get_property_name_escaped(python_type)
    print(f'  public let {property_name}: PyType')

  print()

  # ============
  # === Init ===
  # ============

  print('  // MARK: - Stage 1 - init')
  print()

  print('  /// Init that will only initialize properties.')
  print('  internal init() {')
  print('    let types = Py.types')

  for t in types:
    python_type = t.python_type
    property_name = get_property_name_escaped(python_type)

    if python_type == 'BaseException':
      base_property = 'types.object'
    else:
      base_type = get_base_type(t)
      base_property = 'self.' + get_property_name_escaped(base_type.python_type)

    print(f'    self.{property_name} = PyType.initBuiltinType(name: "{python_type}", type: types.type, base: {base_property})')
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
    python_type = t.python_type
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
    python_type = t.python_type
    property_name_escaped = get_property_name_escaped(python_type)
    print(f'      self.{property_name_escaped},')

  print('    ]')
  print('  }')
  print()

  # ============================
  # === fill__dict__ methods ===
  # ============================

  print_fill_helpers()

  for t in types:
    print_fill_type_method(t)
    print_downcast_function(t)

  print('}')
