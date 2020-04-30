import sys
from Data.types import get_types
from Common.strings import generated_warning
from Common.SignatureInfo import SignatureInfo

# All of the operations for which protocols will be generated
# (Feel free to add new ones)
generated_protocols = set([
  "__abs__",
  "__add__",
  "__and__",
  "__bool__",
  "__call__",
  "__contains__",
  "__del__",
  "__delitem__",
  "__dir__",
  "__divmod__",
  "__eq__",
  "__float__",
  "__floordiv__",
  "__ge__",
  "__getattr__",
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
# Helpers
# ------

def getter_protocol_name(name):
  name = name if name.startswith('__') else name.title()
  return f'{name}Owner'

def setter_protocol_name(name):
  name = name if name.startswith('__') else name.title()
  return f'{name}SetterOwner'

def func_protocol_name(name):
  return f'{name}Owner'

types = get_types()

# ----
# Main
# ----

if __name__ == '__main__':
  print(f'''\
import VioletCore

// swiftlint:disable line_length
// swiftlint:disable opening_brace
// swiftlint:disable trailing_newline
// swiftlint:disable discouraged_optional_boolean
// swiftlint:disable file_length

{generated_warning}

// == What is this? ==
// Sometimes instead of doing slow Python dispatch we will use Swift protocols.
// For example: when user has an 'list' and ask for '__len__' we could lookup
// this method in MRO, create bound object and dispatch it.
// But this is a lot of work.
// We can also: check if this method was overriden ('list' can be subclassed),
// if not then we can go directly to our Swift implementation.
// We could do this for all of the common magic methods.

// == Why? ==
// REASON 1: Debugging (trust me, you don't want to debug raw Python dispatch)
//
// Even for simple 'len([])' will have:
// 1. Check if 'list' implements '__len__'
// 2. Create bound method that will wrap 'list.__len__' function
// 3. Call this method - it will (eventually) call 'PyList.__len__' in Swift
// Now imagine going through this in lldb.
//
// That's a lot of work for such a simple operation.
//
// With protocol dispatch we will:
// 1. Check if 'list' implements '__len__Owner'
// 2. Check user has not overriden '__len__'
// 3. Directly call 'PyList.__len__' in Swift
// In lldb this is: n (check protocol), n (check override), s (step into Swift method).
//
// REASON 2: Static calls during 'Py.initialize'
// This also allows us to call Python methods during 'Py.initialize',
// when not all of the types are yet fully initialized.
// For example when we have not yet added '__hash__' to 'str.__dict__'
// we can still call this method because:
// - 'str' confrms to '__hash__Owner' protocol
// - it does not override builtin 'str.__hash__' method

// == Is this bullet-proof? ==
// Not really.
// If you remove one of the builtin methods from a type, then static protocol
// conformance will still remain.
//
// But most of the time you can't do this:
// >>> del list.__len__
// Traceback (most recent call last):
//   File "<stdin>", line 1, in <module>
// TypeError: can't set attributes of built-in/extension type 'list'

// === Table of contents ===
// 1. Owner protocol definitions - protocols for each operation
// 2. func hasOverridenBuiltinMethod
// 3. Fast enum - try to call given function with protocol dispatch
// 4. Owner protocol conformance - this type supports given operation/protocol
''')

  # =================
  # === Protocols ===
  # =================

  print(f'''\
// MARK: - Owner protocols

// This is the only protocol marked as 'internal'.
/// Special protocol to get '__dict__' property.
internal protocol __dict__Owner {{
  func getDict() -> PyDict
}}
''')

  class ProtocolEntry:
    def __init__(self, python_name, swift_protocol_name, swift_signature):
      self.python_name = python_name
      self.swift_protocol_name = swift_protocol_name
      self.swift_signature = swift_signature

  protocols_by_name = { }
  def add_protocol(python_name, swift_protocol_name, swift_function, swift_return_type):
    if swift_protocol_name not in protocols_by_name:
      signature = SignatureInfo(swift_function, swift_return_type)
      protocol = ProtocolEntry(python_name, swift_protocol_name, signature)
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
      swift_name_full = meth.swift_name_full
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
  add_protocol('__ilshift__',   '__ilshift__Owner',   'ilshift(_ other: PyObject)',   'PyResult<PyObject>')
  add_protocol('__irshift__',   '__irshift__Owner',   'irshift(_ other: PyObject)',   'PyResult<PyObject>')
  add_protocol('__iand__',      '__iand__Owner',      'iand(_ other: PyObject)',      'PyResult<PyObject>')
  add_protocol('__ixor__',      '__ixor__Owner',      'ixor(_ other: PyObject)',      'PyResult<PyObject>')
  add_protocol('__ior__',       '__ior__Owner',       'ior(_ other: PyObject)',       'PyResult<PyObject>')
  add_protocol('__ipow__',      '__ipow__Owner',      'ipow(_ base: PyObject, mod: PyObject)', 'PyResult<PyObject>')
  add_protocol('__idivmod__',   '__idivmod__Owner',   'idivmod(_ other: PyObject)',   'PyResult<PyObject>')
  add_protocol('__complex__',   '__complex__Owner',   'asComplex()',                  'PyObject')
  add_protocol('__getattr__',   '__getattr__Owner',   'getAttribute(name: PyObject)', 'PyResult<PyObject>')

  for protocol_name in sorted(protocols_by_name):
    protocol = protocols_by_name[protocol_name]
    python_name = protocol.python_name
    protocol_name = protocol.swift_protocol_name
    signature = protocol.swift_signature
    print(f'private protocol {protocol_name} {{ func {signature.value} }}')
  print()

  # =====================
  # === Has overriden ===
  # =====================

  print('''\
// MARK: - Has overriden

/// Check if the user has overriden given method.
private func hasOverridenBuiltinMethod(
  object: PyObject,
  selector: IdString
) -> Bool {
  // Soo... we could actually check if if the user has overriden builtin method:
  // 1. Get method from MRO: let lookup = type.lookupWithType(name: selector)
  // 2. Check if type is builtin/heap type: lookup.type.isHeapType
  //    - If builtin: user has not overriden
  //    - If heap: user has overriden
  //
  // Or we can just assume that all heap types override.
  // In most of the cases it will not be true (how ofter do you see '__len__'
  // overriden on a list subclass?), but it does not matter.
  //
  // Just a reminder: heap type - type created by user with 'class' statement.

  let type = object.type
  let isHeapType = type.isHeapType
  return isHeapType
}
''')

  # ============
  # === Fast ===
  # ============

  print('// MARK: - Fast')
  print()
  print('internal enum Fast {')

  for protocol_name in sorted(protocols_by_name):
    protocol = protocols_by_name[protocol_name]
    python_name = protocol.python_name
    protocol_name = protocol.swift_protocol_name

    signature = protocol.swift_signature
    swift_function_name = signature.function_name

    fn_arguments = '' # technically those are called 'parameters'
    call_arguments = ''
    for index, arg in enumerate(signature.arguments):
      label = arg.label # str | None
      name = arg.name
      typ = arg.typ

      is_last = index == len(signature.arguments) - 1

      fn_label = label + ' ' if label else ''
      fn_arguments += f', {fn_label}{name}: {typ}'

      if label is None:
        call_label = name + ': '
      elif label == '_':
        call_label = ''
      else:
        call_label = label + ': '

      call_comma = '' if is_last else ', '
      call_arguments += f'{call_label}{name}{call_comma}'

    print(f'''
  internal static func {python_name}(_ zelf: PyObject{fn_arguments}) -> {signature.return_type}? {{
    if let owner = zelf as? {protocol_name},
       !hasOverridenBuiltinMethod(object: zelf, selector: .{python_name}) {{
      return owner.{swift_function_name}({call_arguments})
    }}

    return nil
  }}\
''')

  print('}')
  print()

  # ===================
  # === Conformance ===
  # ===================

  print('// MARK: - Conformance')
  print()

  class ConformanceEntry:
    def __init__(self, swift_type, swift_base_type):
      self.swift_type = swift_type
      self.swift_base_type = swift_base_type
      self.protocols = []

  # swift_type name pointing to ConformanceEntry
  entries_by_swift_type = { }

  for t in types:
    python_name = t.python_type
    swift_type = t.swift_type
    swift_base_type = t.swift_base_type

    # We will not generate conformances for 'object'
    if t.swift_type == 'PyObject':
      continue

    entry = entries_by_swift_type.get(swift_type)
    if not entry:
      entry = ConformanceEntry(swift_type, swift_base_type)
      entries_by_swift_type[swift_type] = entry

    def add_protocol_conformance(protocol_name):
      # 'protocols_by_name' - all generated protocols
      # And special case for '__dict__'
      protocol_exists = protocol_name in protocols_by_name or protocol_name == '__dict__Owner'
      if protocol_exists:
        entry.protocols.append(protocol_name)

    for prop in t.properties:
      python_name = prop.python_name
      protocol_name = getter_protocol_name(python_name)
      add_protocol_conformance(protocol_name)

    for meth in t.methods:
      python_name = meth.python_name
      protocol_name = func_protocol_name(python_name)
      add_protocol_conformance(protocol_name)

  for entry in entries_by_swift_type.values():
    swift_type = entry.swift_type
    swift_base_type = entry.swift_base_type
    self_protocols = entry.protocols

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
