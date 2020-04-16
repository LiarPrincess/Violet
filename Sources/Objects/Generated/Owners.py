import sys
from Data.types import get_types
from Common.strings import generated_warning
from Common.SignatureInfo import SignatureInfo

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

def get_properties(t):
  return filter(lambda prop: prop.python_name in generated_protocols, t.properties)

def get_methods(t):
  return filter(lambda prop: prop.python_name in generated_protocols, t.methods)

# ------
# Shared
# ------

def clean_signature(sig):
  ''' If signature spans multiple lines then Sourcery will ignore new lines, but
  preserve indentation, so we end up with:
  protocol findOwner { func find(_ value: PyObject,                     start: PyObject?,                     end: PyObject?) -> PyResult<Int> }

  This function will remove those '   '.
  '''

  while '  ' in sig:
    sig = sig.replace('  ', ' ')

  return sig

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

types = get_types()

# ---------
# Protocols
# ---------

class ProtocolInfo:
  def __init__(self, python_name, swift_protocol_name, swift_function, swift_return_type):
    self.python_name = python_name
    self.swift_protocol_name = swift_protocol_name
    self.swift_function = swift_function
    self.swift_return_type = swift_return_type

def print_protocols():
  print(f'''\
// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable discouraged_optional_boolean

{generated_warning}

import Core

{doc}

// This protocol is here only to check if we have consistent '__new__' signatures.
// It will not be used in 'Fast' dispatch.
protocol __new__Owner {{
  static func pyNew(type: PyType, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>
}}

// This protocol is here only to check if we have consistent '__init__' signatures.
// It will not be used in 'Fast' dispatch.
protocol __init__Owner {{
  associatedtype Zelf: PyObject
  static func pyInit(zelf: Zelf, args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone>
}}
''')

  protocols_by_name = { }
  def add_protocol(python_name, swift_protocol_name, swift_function, swift_return_type):
      if swift_protocol_name not in protocols_by_name:
        protocol = ProtocolInfo(python_name, swift_protocol_name, swift_function, swift_return_type)
        protocols_by_name[swift_protocol_name] = protocol

  for t in types:
    for prop in get_properties(t):
      python_name = prop.python_name
      swift_getter_fn = prop.swift_getter_fn + '()'
      swift_return_type = prop.swift_type
      protocol_name = getter_protocol_name(python_name)
      add_protocol(python_name, protocol_name, swift_getter_fn, swift_return_type)

      # Setters are not supported

    for meth in get_methods(t):
      python_name = meth.python_name
      swift_name_full = clean_signature(meth.swift_name_full)
      swift_return_type = meth.swift_return_type
      protocol_name = func_protocol_name(python_name)
      add_protocol(python_name, protocol_name, swift_name_full, swift_return_type)

    # From static methods we have hand-written '__new__' and '__init__'.
    # We ignore other.

  # Additional protocols (none of the builtin types implement them)
  #            python_name,     swift_protocol_name,  swift_function,                 swift_return_type
  add_protocol('__matmul__',    '__matmul__Owner',    'matmul(_ other: PyObject)',    'PyResult<PyObject>')
  add_protocol('__rmatmul__',   '__rmatmul__Owner',   'rmatmul(_ other: PyObject)',   'PyResult<PyObject>')
  add_protocol('__isub__',      '__isub__Owner',      'isub(_ other: PyObject)',      'PyResult<PyObject>')
  add_protocol('__imul__',      '__imul__Owner',      'imul(_ other: PyObject)',      'PyResult<PyObject>')
  add_protocol('__imatmul__',   '__imatmul__Owner',   'imatmul(_ other: PyObject)',   'PyResult<PyObject>')
  add_protocol('__itruediv__',  '__itruediv__Owner',  'itruediv(_ other: PyObject)',  'PyResult<PyObject>')
  add_protocol('__ifloordiv__', '__ifloordiv__Owner', 'ifloordiv(_ other: PyObject)', 'PyResult<PyObject>')
  add_protocol('__imod__',      '__imod__Owner',      'imod(_ other: PyObject)',      'PyResult<PyObject>')
  add_protocol('__ipow__',      '__ipow__Owner',      'ipow(_ other: PyObject)',      'PyResult<PyObject>')
  add_protocol('__ilshift__',   '__ilshift__Owner',   'ilshift(_ other: PyObject)',   'PyResult<PyObject>')
  add_protocol('__irshift__',   '__irshift__Owner',   'irshift(_ other: PyObject)',   'PyResult<PyObject>')
  add_protocol('__iand__',      '__iand__Owner',      'iand(_ other: PyObject)',      'PyResult<PyObject>')
  add_protocol('__ixor__',      '__ixor__Owner',      'ixor(_ other: PyObject)',      'PyResult<PyObject>')
  add_protocol('__ior__',       '__ior__Owner',       'ior(_ other: PyObject)',       'PyResult<PyObject>')
  add_protocol('__complex__',   '__complex__Owner',   'asComplex()',                  'PyObject')

  for protocol_name in sorted(protocols_by_name):
    protocol = protocols_by_name[protocol_name]
    protocol_name = protocol.swift_protocol_name
    fn = protocol.swift_function
    return_type = protocol.swift_return_type

    print(f'protocol {protocol_name} {{ func {fn} -> {return_type} }}')
  print()

  print('internal enum Fast {')
  for protocol_name in sorted(protocols_by_name):
    protocol = protocols_by_name[protocol_name]
    python_name = protocol.python_name
    protocol_name = protocol.swift_protocol_name

    sig = SignatureInfo(protocol.swift_function, protocol.swift_return_type)
    swift_function_name = sig.function_name

    fn_arguments = ''
    call_arguments = ''
    for index, arg in enumerate(sig.arguments):
      label = arg.label # str | None
      name = arg.name
      typ = arg.typ

      is_last = index == len(sig.arguments) - 1

      fn_label = label + ' ' if label else ''
      fn_arguments += f', {fn_label}{name}: {typ}'

      # print(f'// label: {label}, name: {name}, needs_call_label: {needs_call_label}')
      if label is None:
        call_label = name + ': '
      elif label == '_':
        call_label = ''
      else:
        call_label = label + ': '

      call_comma = '' if is_last else ', '
      call_arguments += f'{call_label}{name}{call_comma}'

    print(f'''
  internal static func {python_name}(_ zelf: PyObject{fn_arguments}) -> {sig.return_type}? {{
    if let owner = zelf as? {protocol_name}, !zelf.hasOverriden(selector: "{python_name}") {{
      return owner.{swift_function_name}({call_arguments})
    }}

    return nil
  }}\
''')

  print('}')

# -----------
# Conformance
# -----------

class ConformanceEntry:
  def __init__(self, swift_type, swift_base_type):
    self.swift_type = swift_type
    self.swift_base_type = swift_base_type
    self.protocols = []

def print_conformance():
  print(f'''\
// swiftlint:disable file_length
// swiftlint:disable opening_brace
// swiftlint:disable trailing_newline

{generated_warning}

{doc}
''')

  # swift_type name pointing to ConformanceEntry
  entries_by_swift_type = { }

  for t in types:
    python_name = t.python_type
    swift_type = t.swift_type
    swift_base_type = t.swift_base_type

    if t.swift_type == 'PyObject':
      continue

    entry = entries_by_swift_type.get(swift_type)
    if not entry:
      entry = ConformanceEntry(swift_type, swift_base_type)
      entries_by_swift_type[swift_type] = entry

    for prop in get_properties(t):
      python_name = prop.python_name
      protocol_name = getter_protocol_name(python_name)
      entry.protocols.append(protocol_name)

    for meth in get_methods(t):
      python_name = meth.python_name
      protocol_name = func_protocol_name(python_name)
      entry.protocols.append(protocol_name)

    # From static funcions we have only '__new__' and '__init__'.
    for meth in t.static_functions:
      python_name = meth.python_name

      if python_name in ['__new__', '__init__']:
        protocol_name = func_protocol_name(python_name)
        entry.protocols.append(protocol_name)

  for entry in entries_by_swift_type.values():
    swift_type = entry.swift_type
    swift_base_type = entry.swift_base_type
    self_protocols = entry.protocols

    print(f'// MARK: - {swift_type.replace("Py", "")}')
    print()

    # Remove parent conformances
    base = swift_base_type
    while base:
      base_entry = entries_by_swift_type.get(base)
      if not base_entry:
        base = None
        continue

      for base_protocol in base_entry.protocols:
        if base_protocol in self_protocols:
          self_protocols.remove(base_protocol)

      base = base_entry.swift_base_type

    # Print extension
    if not self_protocols:
      print(f'// {swift_type} does not add any new protocols to {swift_base_type}')
      print(f'extension {swift_type} {{ }}')
    else:
      print(f'extension {swift_type}:')
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
