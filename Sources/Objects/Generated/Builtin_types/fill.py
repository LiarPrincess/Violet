from Sourcery import TypeInfo, PyFunctionInfo
from Builtin_types.property import get_property_name
from Builtin_types.cast import (get_castSelf_function_name, get_castSelfOptional_function_name)


def print_fill_helpers():
    print('''\
  // MARK: - Helpers

  /// Insert value to type '__dict__'.
  private func insert(type: PyType, name: String, value: PyObject) {
    let dict = type.getDict()
    let interned = Py.intern(string: name)

    switch dict.set(key: interned, to: value) {
    case .ok:
      break
    case .error(let e):
      let typeName = type.getNameString()
      trap("Error when inserting '\(name)' to '\(typeName)' type: \(e)")
    }
  }
''')


def get_fill_function_name(t: TypeInfo):
    swift_type = t.swift_type_name
    swift_type_without_py = swift_type.replace('Py', '')
    return 'fill' + swift_type_without_py


def print_fill_function(t: TypeInfo):
    # For 'object': 'PyObject' holds data, but 'PyObjectType' holds methods, doc etc.
    swift_type_name = t.swift_type_name
    if swift_type_name == 'PyObject':
        swift_type_name = 'PyObjectType'

    function_name = get_fill_function_name(t)
    print(f'  private func {function_name}() {{')
    print(f'    let type = self.{get_property_name(t.python_type_name)}')

    sourcery_flags = t.sourcery_flags
    for flag in sourcery_flags:
        print(f'    type.flags.set(PyType.{flag}Flag)')

    static_doc_property = t.swift_static_doc_property
    if static_doc_property:
        print(f'    type.setBuiltinTypeDoc({swift_type_name}.{static_doc_property})')
    else:
        print(f'    type.setBuiltinTypeDoc(nil)')

    # ==================
    # === Properties ===
    # ==================

    is_first = True
    castSelf = 'Self.' + get_castSelf_function_name(t)
    castSelfOptional = 'Self.' + get_castSelfOptional_function_name(t)

    for prop in t.python_properties:
        python_name = prop.python_name
        swift_getter_fn = prop.swift_getter_fn
        swift_setter_fn = prop.swift_setter_fn

        static_doc_property = prop.swift_static_doc_property
        doc = f'{swift_type_name}.{static_doc_property}' if static_doc_property else 'nil'

        if is_first:
            is_first = False
            print()

        if not swift_setter_fn:
            print(
                f'    self.insert(type: type, name: "{python_name}", value: PyProperty.wrap(doc: {doc}, get: {swift_type_name}.{swift_getter_fn}, castSelf: {castSelf}))')
        else:
            print(
                f'    self.insert(type: type, name: "{python_name}", value: PyProperty.wrap(doc: {doc}, get: {swift_type_name}.{swift_getter_fn}, set: {swift_type_name}.{swift_setter_fn}, castSelf: {castSelf}))')

    # ================
    # === New/init ===
    # ================

    is_first = True

    # __new__
    for meth in t.python_static_functions:
        python_name = meth.python_name
        swift_selector = meth.swift_selector

        static_doc_property = meth.swift_static_doc_property
        doc = f'{swift_type_name}.{static_doc_property}' if static_doc_property else 'nil'

        if not python_name == '__new__':
            continue

        if is_first:
            is_first = False
            print()

        print(f'    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: {doc}, fn: {swift_type_name}.{swift_selector}))')

    # __init__
    for meth in t.python_methods:
        python_name = meth.python_name
        swift_selector = meth.swift_selector

        static_doc_property = meth.swift_static_doc_property
        doc = f'{swift_type_name}.{static_doc_property}' if static_doc_property else 'nil'

        if not python_name == '__init__':
            continue

        if is_first:
            is_first = False
            print()

        print(
            f'    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: {doc}, fn: {swift_type_name}.{swift_selector}, castSelf: {castSelfOptional}))')

    # ==============================
    # === Static/class functions ===
    # ==============================

    is_first = True

    def is_new_or_init(name: str):
        return name == '__new__' or name == '__init__'

    def print_static_class_method(factory_type: str, fn: PyFunctionInfo):
        python_name = fn.python_name
        swift_selector = fn.swift_selector

        static_doc_property = fn.swift_static_doc_property
        doc = f'{swift_type_name}.{static_doc_property}' if static_doc_property else 'nil'

        if is_new_or_init(python_name):
            return

        nonlocal is_first
        if is_first:
            is_first = False
            print()

        print(
            f'    self.insert(type: type, name: "{python_name}", value: {factory_type}.wrap(name: "{python_name}", doc: {doc}, fn: {swift_type_name}.{swift_selector}))')

    for fn in t.python_static_functions:
        print_static_class_method('PyStaticMethod', fn)

    for fn in t.python_class_functions:
        print_static_class_method('PyClassMethod', fn)

    # ===============
    # === Methods ===
    # ===============

    is_first = True

    for meth in t.python_methods:
        python_name = meth.python_name
        swift_selector = meth.swift_selector

        static_doc_property = meth.swift_static_doc_property
        doc = f'{swift_type_name}.{static_doc_property}' if static_doc_property else 'nil'

        if is_new_or_init(python_name):
            continue

        if is_first:
            is_first = False
            print()

        if t.python_type_name == 'object':
            print(
                f'    self.insert(type: type, name: "{python_name}", value: PyBuiltinFunction.wrap(name: "{python_name}", doc: {doc}, fn: {swift_type_name}.{swift_selector}))')
        else:
            print(
                f'    self.insert(type: type, name: "{python_name}", value: PyBuiltinFunction.wrap(name: "{python_name}", doc: {doc}, fn: {swift_type_name}.{swift_selector}, castSelf: {castSelf}))')

    print('  }')
    print()
