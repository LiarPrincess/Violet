from Data.modules import get_modules
from Common.strings import generated_warning

# ----
# Main
# ----

if __name__ == '__main__':
  print(f'''\
// swiftlint:disable file_length
// swiftlint:disable line_length
// swiftlint:disable function_body_length

{generated_warning}

// ModuleFactory is based on pre-specialization (partial application)
// of function to module object and then wrapping remaining function.
//
// So, for example:
//   Builtins.add :: (self: Builtins) -> (left: PyObject, right: PyObject) -> Result
// would be specialized to 'Builtins' instance giving us:
//   add :: (left: PyObject, right: PyObject) -> Result
// which would be wrapped and exposed to Python runtime.
//
// So when you are working on Python 'builtins' you are actually working on
// (Scooby-Doo reveal incomming...)
// 'Py.builtins' object (which gives us stateful modules).
// (and we would have gotten away with it without you meddling kids!)
// https://www.youtube.com/watch?v=b4JLLv1lE7A
''')

  print('''\
import Core

private func createModule(name: String,
                          doc: String?,
                          dict: PyDict) -> PyModule {
  let n = Py.intern(name)
  let d = doc.map(Py.intern(_:))
  return PyModule(name: n, doc: d, dict: dict)
}

private func insert(module: PyModule, name: String, value: PyObject) {
  let dict = module.getDict()
  let interned = Py.intern(name)

  switch dict.set(key: interned, to: value) {
  case .ok:
    break
  case .error(let e):
    trap("Error when inserting '\(name)' to '\(module)': \(e)")
  }
}
''')

  print('internal enum ModuleFactory {')
  for mod in get_modules():
    python_type = mod.python_type
    swift_type = mod.swift_type

    static_doc_property = mod.swift_static_doc_property
    doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

    print()
    print(f'  // MARK: - {swift_type}')
    print()

    print(f'  internal static func create{swift_type}(from object: {swift_type}) -> PyModule {{')
    print(f'    let module = createModule(name: "{python_type}", doc: {doc}, dict: object.__dict__)')
    print()

    for prop in mod.properties:
      python_name = prop.python_name
      swift_property = prop.swift_property_name
      swift_setter_fn = prop.swift_setter_fn
      doc_property = prop.swift_static_doc_property
      print(f'    insert(module: module, name: "{python_name}", value: object.{swift_property})')

    if mod.properties:
      print()

    for fn in mod.functions:
      python_name = fn.python_name
      swift_function_name = fn.swift_function_name
      swift_selector = fn.swift_selector

      static_doc_property = fn.swift_static_doc_property
      doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

      print(f'    insert(module: module, name: "{python_name}", value: PyBuiltinFunction.wrap(name: "{python_name}", doc: {doc}, fn: object.{swift_selector}, module: module))')

    if mod.functions:
      print()

    print('    return module')
    print('  }')

  print('}')
