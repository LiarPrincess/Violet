from TypeLayout import get_layout_name

# =============
# Property name
# =============

def get_property_name(python_type):
  if python_type == 'NoneType':
    return 'none'

  if python_type == 'NotImplementedType':
    return 'notImplemented'

  if python_type == 'types.SimpleNamespace':
    return 'simpleNamespace'

  if python_type == 'TextFile':
    return 'textFile'

  if python_type == 'EOFError':
    return 'eofError'

  if python_type == 'OSError':
    return 'osError'

  result = python_type[0].lower() + python_type[1:]
  return result

def get_property_name_escaped(python_type):
  property_name = get_property_name(python_type)

  if property_name == 'super':
    return '`super`'

  return property_name

# ====
# Fill
# ====

def get_fill_function_name(t):
  swift_type = t.swift_type
  swift_type_without_py = swift_type.replace('Py', '')
  return 'fill' + swift_type_without_py

def print_fill_type_method(t):
  static_doc_property = t.swift_static_doc_property
  sourcery_flags = t.sourcery_flags

  # For 'object': 'PyObject' holds data, but 'PyObjectType' holds methods, doc etc.
  swift_type = t.swift_type
  swift_type = 'PyObjectType' if swift_type == 'PyObject' else swift_type
  castSelf = f'Cast.as{swift_type}'

  print(f'  // MARK: - {t.swift_type.replace("Py", "")}')
  print()

  function_name = get_fill_function_name(t)
  print(f'  func {function_name}() {{')
  print(f'    let type = self.{get_property_name(t.python_type)}')

  if static_doc_property:
    print(f'    type.setBuiltinTypeDoc({swift_type}.{static_doc_property})')
  else:
    print(f'    type.setBuiltinTypeDoc(nil)')

  for flag in sourcery_flags:
    print(f'    type.setFlag(.{flag})')

  layout = get_layout_name(t)
  print(f'    type.setLayout(.{layout})')
  print()

  # ==================
  # === Properties ===
  # ==================

  for prop in t.properties:
    python_name = prop.python_name
    swift_getter_fn = prop.swift_getter_fn
    swift_setter_fn = prop.swift_setter_fn

    static_doc_property = prop.swift_static_doc_property
    doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

    if not swift_setter_fn:
      print(f'    insert(type: type, name: "{python_name}", value: PyProperty.wrap(name: "{python_name}", doc: {doc}, get: {swift_type}.{swift_getter_fn}, castSelf: {castSelf}))')
    else:
      print(f'    insert(type: type, name: "{python_name}", value: PyProperty.wrap(name: "{python_name}", doc: {doc}, get: {swift_type}.{swift_getter_fn}, set: {swift_type}.{swift_setter_fn}, castSelf: {castSelf}))')

  if t.properties and t.static_functions:
    print()

  # ========================
  # === Static functions ===
  # ========================

  for fn in t.static_functions:
    python_name = fn.python_name
    swift_name = fn.swift_name
    swift_selector = fn.swift_selector

    static_doc_property = fn.swift_static_doc_property
    doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

    if python_name == '__new__':
      print(f'    insert(type: type, name: "__new__", value: PyBuiltinFunction.wrapNew(type: type, doc: {doc}, fn: {swift_type}.{swift_selector}))')
    elif python_name == '__init__':
      print(f'    insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: {doc}, fn: {swift_type}.{swift_selector}))')
    else:
      print(f'    insert(type: type, name: "{python_name}", value: PyBuiltinFunction.wrap(name: "{python_name}", doc: {doc}, fn: {swift_type}.{swift_selector}))')

  if t.static_functions and t.methods:
    print()

  # ===============
  # === Methods ===
  # ===============

  for meth in t.methods:
    python_name = meth.python_name
    swift_name = meth.swift_name
    swift_selector = meth.swift_selector

    static_doc_property = meth.swift_static_doc_property
    doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

    print(f'    insert(type: type, name: "{python_name}", value: PyBuiltinFunction.wrap(name: "{python_name}", doc: {doc}, fn: {swift_type}.{swift_selector}, castSelf: {castSelf}))')

  print('  }')
  print()
