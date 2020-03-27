import os
import sys

# All of the operations for which protocols will be generated
# (Feel free to add new ones.)
generated_protocols = set([
  "__abs__",
  "__add__",
  "__and__",
  "__bool__",
  "__call__",
  "__contains__",
  "__del__",
  "__delitem__",
  "__dict__",
  "__dir__",
  "__divmod__",
  "__eq__",
  "__float__",
  "__floordiv__",
  "__ge__",
  "__getattribute__",
  "__getitem__",
  "__gt__",
  "__hash__",
  "__iadd__",
  "__index__",
  "__init__",
  "__instancecheck__",
  "__invert__",
  "__isabstractmethod__",
  "__iter__",
  "__le__",
  "__len__",
  "__lshift__",
  "__lt__",
  "__mod__",
  "__mul__",
  "__ne__",
  "__neg__",
  "__next__",
  "__or__",
  "__pos__",
  "__pow__",
  "__radd__",
  "__rand__",
  "__rdivmod__",
  "__repr__",
  "__reversed__",
  "__rfloordiv__",
  "__rlshift__",
  "__rmod__",
  "__rmul__",
  "__ror__",
  "__round__",
  "__rpow__",
  "__rrshift__",
  "__rshift__",
  "__rsub__",
  "__rtruediv__",
  "__rxor__",
  "__setattr__",
  "__setitem__",
  "__str__",
  "__sub__",
  "__subclasscheck__",
  "__truediv__",
  "__trunc__",
  "__xor__",
  "keys",
])

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

      if python_name in generated_protocols:
        entry = Line(type_name, base_type_name, operation, python_name, swift_signature)
        result.append(entry)

  return result

def clean_signature(sig):
  ''' If signature spans multiple lines then Sourcery will ignore new lines, but
  preserve indentation, so we end up with:
  protocol findOwner { func find(_ value: PyObject,                     start: PyObject?,                     end: PyObject?) -> PyResult<Int> }

  This function will remove those '   '.
  '''

  while '  ' in sig:
    sig = sig.replace('  ', ' ')

  return sig

# ------
# Shared
# ------

def getter_protocol_name(name):
  name = name if name.startswith('__') else name.title()
  return f'{name}GetterOwner'

def setter_protocol_name(name):
  name = name if name.startswith('__') else name.title()
  return f'{name}SetterOwner'

def func_protocol_name(name):
  return f'{name}Owner'

doc = '''\
// Sometimes instead of doing slow Python dispatch we will use Swift protocols.
// Feel free to add new protocols if you need them (just modify the script
// responsible for generating the code).\
'''

# ---------
# Protocols
# ---------

def print_protocols():
  lines = read_input_file()

  print(f'''\
import Core

{doc}

// swiftlint:disable line_length

protocol __new__Owner {{
  static func pyNew(type: PyType, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>
}}

protocol __init__Owner {{
  associatedtype Zelf: PyObject
  static func pyInit(zelf: Zelf, args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone>
}}
''')

  protocols = set()
  for line in lines:
    python_name = line.python_name
    signature = line.swift_signature

    # We hand-written '__new__' and '__init__'.
    if python_name in ['__new__', '__init__']:
      continue

    elif line.operation == 'get':
      protocol_name = getter_protocol_name(python_name)
      protocols.add(f'protocol {protocol_name} {{ func {signature} }}')

    elif line.operation == 'set':
      protocol_name = setter_protocol_name(python_name)
      protocols.add(f'protocol {protocol_name} {{ func {signature} }}')

    elif line.operation == 'func' or line.operation == 'static_func':
      static = 'static ' if line.operation == 'static_func' else ''

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

  print(f'''\
{doc}

// swiftlint:disable file_length
// swiftlint:disable opening_brace
// swiftlint:disable trailing_newline

// MARK: - BaseObject

// PyObjectType does not own anything.
extension PyObjectType {{ }}
''')

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
      protocols.append(func_protocol_name(python_name))
    else:
      assert False

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
