from Data.types import get_types
from Common.builtin_types import get_property_name, get_property_name_escaped

exposed_builtin_type_names = set([
  "bool",
  "bytearray",
  "bytes",
  "classmethod",
  "complex",
  "dict",
  "enumerate",
  "filter",
  "float",
  "frozenset",
  "int",
  "list",
  "map",
  "memoryview",
  "property",
  "range",
  "reversed",
  "set",
  "slice",
  "staticmethod",
  "str",
  "super",
  "tuple",
  "type",
  "zip",
])

def is_exposed(t):
  # We expose all errors
  if t.is_error_type:
    return True

  if t.python_type in exposed_builtin_type_names:
    return True

  return False

all_types = get_types()
types = filter(is_exposed, all_types)

if __name__ == '__main__':
  print('''\
// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace

// Please note that this file was automatically generated. DO NOT EDIT!
// The same goes for other files in 'Generated' directory.

// This file will add type properties to 'Builtins', so that they are exposed
// to Python runtime.
// Later 'ModuleFactory' script will pick those properties and add them to module
// '__dict__' as 'PyProperty'.
//
// Btw. Not all of those types should be exposed from builtins module.
// Some should require 'import types', but sice we don't have 'types' module,
// we will expose them from builtins.
''')

  # TODO: Object
  print('''\
extension Builtins {

  // MARK: - Types

  // sourcery: pyproperty = object
  internal var type_object: PyType {
    return Py.types.object
  }

''')

  for t in types:
    python_type = t.python_type
    swift_type = t.swift_type
    property_name = get_property_name(python_type)

    print(f'''\
  // sourcery: pyproperty = {python_type}
  internal var type_{property_name}: PyType {{
    return Py.types.{property_name}
  }}
''')

  print('}')
