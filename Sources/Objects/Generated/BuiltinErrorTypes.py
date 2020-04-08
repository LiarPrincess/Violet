from Data.errors import data
from Common.strings import generated_warning
from Common.errors import where_to_find_it_in_cpython, get_builtins_type_property_name

if __name__ == '__main__':
  print(f'''\
// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable trailing_comma

{generated_warning}

{where_to_find_it_in_cpython}
''')

  print('public final class BuiltinErrorTypes {')

  for e in data:
    property_name = get_builtins_type_property_name(e.class_name)
    print(f'  public let {property_name}: PyType')

  print()
  print('  /// Init that will only initialize properties.')
  print('  internal init() {')
  print('    let types = Py.types')

  for e in data:
    class_name = e.class_name
    property_name = get_builtins_type_property_name(class_name)

    if class_name == 'BaseException':
      base_name = 'types.object'
    else:
      base_name = 'self.' + get_builtins_type_property_name(e.base_class)

    print(f'    self.{property_name} = PyType.initBuiltinType(name: "{class_name}", type: types.type, base: {base_name})')
  print('  }')
  print()

  print('/// This function finalizes init of all of the stored types.')
  print('/// (see comment at the top of this file)')
  print('///')
  print('/// For example it will:')
  print('/// - set type flags')
  print('/// - add `__doc__`')
  print('/// - fill `__dict__`')
  print('  internal func fill__dict__() {')
  for e in data:
    name = e.class_name
    property_name = get_builtins_type_property_name(name)
    method_name = get_builtins_type_property_name(name)
    print(f'    FillTypes.{method_name}(self.{property_name})')
  print('  }')
  print()

  print('  internal var all: [PyType] {')
  print('    return [')
  for e in data:
    name = e.class_name
    property_name = get_builtins_type_property_name(name)
    print(f'      self.{property_name},')
  print('    ]')
  print('  }')

  print('}')
