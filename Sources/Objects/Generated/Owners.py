import os
import sys

# We will not generate protocols for following methods:
ignored_methods = [
  'pop',
  'strip',
  'lstrip',
  'rstrip',
  'center',
  'ljust',
  'rjust',
  'split',
  'rsplit',
  'splitlines',
  'expandtabs',
  'replace',
  'zfill',
  'capitalize',
  'lower',
  'swapcase',
  'title',
  'upper',
  'casefold',
  'join',
  'update'
]

manually_written_protocols = [
  '__init__',
  '__new__'
]

# ----
# File
# ----

class Line:
  def __init__(self, type_name, base_type_name, operation, python_name, swift_signature):
    self.type_name = type_name
    self.base_type_name = base_type_name
    self.operation = operation
    self.python_name = python_name
    self.swift_signature = clean_signature(swift_signature)

def read_input_file() -> [Line]:
  dir_path = os.path.dirname(__file__)
  input_file = os.path.join(dir_path, 'Owners.tmp')

  result = []
  with open(input_file, 'r') as reader:
    for line in reader:
      line = line.strip()

      if not line or line.startswith('#'):
        continue

      line_split = line.split('|')
      assert len(line_split) == 5

      type_name = line_split[0]
      base_type_name = line_split[1]
      operation = line_split[2]
      python_name = line_split[3]
      swift_signature = line_split[4]

      if python_name not in ignored_methods:
        entry = Line(type_name, base_type_name, operation, python_name, swift_signature)
        result.append(entry)

  return result

def clean_signature(sig):
  ''' If signature spans multiple lines then Sourcery will ignore new lines, but
  preserve indentation, so we end up with:
  protocol findOwner { func find(_ value: PyObject,                     start: PyObject?,                     end: PyObject?) -> PyResult<Int> }
  '''

  while '  ' in sig:
    sig = sig.replace('  ', ' ')

  return sig

# --------------
# Protocol names
# --------------

def getter_protocol_name(name):
  name = name if name.startswith('__') else name.title()
  return f'{name}GetterOwner'

def setter_protocol_name(name):
  name = name if name.startswith('__') else name.title()
  return f'{name}SetterOwner'

def func_protocol_name(name):
  return f'{name}Owner'

def ranged_func_protocol_name(name):
  return f'{name}RangedOwner'

def is_ranged_function(signature):
  return 'start: PyObject?, end: PyObject?' in signature

# ---------
# Protocols
# ---------

def print_protocols():
  lines = read_input_file()

  protocols = set()
  for line in lines:
    python_name = line.python_name
    signature = line.swift_signature

    if line.operation == 'get':
      protocol_name = getter_protocol_name(python_name)
      protocols.add(f'protocol {protocol_name} {{ func {signature} }}')

    elif line.operation == 'set':
      protocol_name = setter_protocol_name(python_name)
      protocols.add(f'protocol {protocol_name} {{ func {signature} }}')

    elif line.operation == 'func' or line.operation == 'static_func':
      static = 'static ' if line.operation == 'static_func' else ''

      if python_name in manually_written_protocols:
        pass
      elif is_ranged_function(signature):
        # Special case for 'str' methods with 'start' and 'end' args
        # We will also have version without range.
        protocol_name = func_protocol_name(python_name)
        signature_no_range = signature.replace(', start: PyObject?, end: PyObject?', '')
        protocols.add(f'protocol {protocol_name} {{ {static}func {signature_no_range} }}')

        ranged_protocol_name = ranged_func_protocol_name(python_name)
        protocols.add(f'protocol {ranged_protocol_name} {{ {static}func {signature} }}')
      else:
        protocol_name = func_protocol_name(python_name)
        protocols.add(f'protocol {protocol_name} {{ {static}func {signature} }}')

    else:
      assert False

  # Additional protocols (none of the builtin types implement them)
  protocols.add('protocol __matmul__Owner { func matmul(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __rmatmul__Owner { func rmatmul(_ other: PyObject) -> PyResult<PyObject> }')

  protocols.add('protocol __isub__Owner { func isub(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __imul__Owner { func imul(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __imatmul__Owner { func imatmul(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __itruediv__Owner { func itruediv(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __ifloordiv__Owner { func ifloordiv(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __imod__Owner { func imod(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __ipow__Owner { func ipow(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __ilshift__Owner { func ilshift(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __irshift__Owner { func irshift(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __iand__Owner { func iand(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __ixor__Owner { func ixor(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __ior__Owner { func ior(_ other: PyObject) -> PyResult<PyObject> }')
  protocols.add('protocol __complex__Owner { func asComplex() -> PyObject }')

  # We will manually create '__new__Owner' and '__init__Owner'
  print('''\
import Core

// swiftlint:disable line_length

protocol __new__Owner {
  static func pyNew(type: PyType, args: [PyObject], kwargs: PyDictData?) -> PyResult<PyObject>
}

protocol __init__Owner {
  associatedtype Zelf: PyObject
  static func pyInit(zelf: Zelf, args: [PyObject], kwargs: PyDictData?) -> PyResult<PyNone>
}
''')

  for line in sorted(protocols):
    print(line)

# -----------
# Conformance
# -----------

class ConformanceEntry:
  def __init__(self, type_name, base_type_name, protocols):
    self.type_name = type_name
    self.base_type_name = base_type_name
    self.protocols = protocols

def print_conformance():
  lines = read_input_file()

  # type_name pointing to ConformanceEntry
  entries_by_type_name = { }

  for line in lines:
    type_name = line.type_name
    base_type_name = line.base_type_name
    signature = line.swift_signature
    python_name = line.python_name

    entry = entries_by_type_name.get(type_name)
    if not entry:
      entry = ConformanceEntry(type_name, base_type_name, [])
      entries_by_type_name[type_name] = entry

    protocols = entry.protocols

    if line.operation == 'get':
      protocols.append(getter_protocol_name(python_name))
    elif line.operation == 'set':
      protocols.append(setter_protocol_name(python_name))
    elif line.operation == 'func' or line.operation == 'static_func':
      if is_ranged_function(signature):
        protocols.append(func_protocol_name(python_name))
        protocols.append(ranged_func_protocol_name(python_name))
      else:
        protocols.append(func_protocol_name(python_name))
    else:
      assert False

  print('''\
// swiftlint:disable file_length
// swiftlint:disable opening_brace
// swiftlint:disable trailing_newline

// MARK: - BaseObject

// PyBaseObject does not own anything.
extension PyBaseObject { }
''')

  for entry in entries_by_type_name.values():
    type_name = entry.type_name
    base_type_name = entry.base_type_name
    self_protocols = entry.protocols

    print(f'// MARK: - {type_name.replace("Py", "")}')
    print()

    # Remove parent conformances
    base = base_type_name
    while base:
      base_entry = entries_by_type_name.get(base)
      if not base_entry:
        base = None
        continue

      for base_protocol in base_entry.protocols:
        if base_protocol in self_protocols:
          self_protocols.remove(base_protocol)

      base = base_entry.base_type_name

    # Print extension
    if not self_protocols:
      print(f'// {type_name} does not add any new protocols to {base_type_name}')
      print(f'extension {type_name} {{ }}')
    else:
      print(f'extension {type_name}:')
      for protocol in self_protocols:
        comma = '' if protocol == self_protocols[-1] else ','
        print(f'  {protocol}{comma}')
      print('{ }')

    print()

# ----
# Main
# ----

if __name__ == '__main__':
  if len(sys.argv) < 2:
    print("Usage: 'python3 Owners.py [protocols|conformance]'")
    sys.exit(1)

  mode = sys.argv[1]
  if mode == 'protocols':
    print_protocols()
  elif mode == 'conformance':
    print_conformance()
  else:
    print(f"Invalid argument '{mode}' passed to 'Owners.py'.")
