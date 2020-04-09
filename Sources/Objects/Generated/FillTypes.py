from Data.types import get_types
from Common.strings import generated_warning
from TypeLayout import get_layout_name

types = get_types()

def get_function_name(t):
  swift_type_without_py = swift_type.replace('Py', '')
  return swift_type_without_py[0].lower() + swift_type_without_py[1:]

if __name__ == '__main__':
  print(f'''\
// swiftlint:disable vertical_whitespace
// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable line_length
// swiftlint:disable file_length
// swiftlint:disable function_body_length

{generated_warning}

// Do all of boring stuff to finish 'PyType':
// - set type flags
// - add `__doc__`
// - fill `__dict__`
''')

  print('''\
import Core

private func insert(type: PyType, name: String, value: PyObject) {
  let dict = type.getDict()
  let interned = Py.intern(name)

  switch dict.set(key: interned, to: value) {
  case .ok:
    break
  case .error(let e):
    trap("Error when inserting '\(name)' to '\(type.getName())' type: \(e)")
  }
}
''')

  print('internal enum FillTypes {')
  print()

  for t in types:
    python_type = t.python_type
    static_doc_property = t.swift_static_doc_property
    is_error_type = t.is_error_type
    sourcery_flags = t.sourcery_flags

    # For 'object': 'PyObject' holds data, but 'PyObjectType' holds methods, doc etc.
    swift_type = t.swift_type
    swift_type = 'PyObjectType' if swift_type == 'PyObject' else swift_type
    castSelf = f'Cast.as{swift_type}'

    print(f'  // MARK: - {python_type}')
    print()

    function_name = get_function_name(t)
    print(f'  internal static func {function_name}(_ type: PyType) {{')

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

  print('}')
  print()
