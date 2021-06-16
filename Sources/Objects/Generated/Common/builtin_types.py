from TypeMemoryLayout import get_layout_name
from Data.types import TypeInfo, PyFunctionInfo

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

# =======
# Helpers
# =======


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
      let typeName = type.getName()
      trap("Error when inserting '\(name)' to '\(typeName)' type: \(e)")
    }
  }

  /// Basically:
  /// We hold 'PyObjects' on stack.
  /// We need to call Swift method that needs specific 'self' type.
  /// This method is responsible for downcasting 'PyObject' -> specific Swift type.
  private static func cast<T>(_ object: PyObject,
                              as type: T.Type,
                              typeName: String,
                              methodName: String) -> PyResult<T> {
    if let v = object as? T {
      return .value(v)
    }

    return .typeError(
      "descriptor '\(methodName)' requires a '\(typeName)' object " +
      "but received a '\(object.typeName)'"
    )
  }
''')

# ====
# Fill
# ====


def get_fill_function_name(t):
    swift_type = t.swift_type
    swift_type_without_py = swift_type.replace('Py', '')
    return 'fill' + swift_type_without_py


def print_fill_type_method(t: TypeInfo):
    static_doc_property = t.swift_static_doc_property
    sourcery_flags = t.sourcery_flags

    # For 'object': 'PyObject' holds data, but 'PyObjectType' holds methods, doc etc.
    swift_type = t.swift_type
    swift_type = 'PyObjectType' if swift_type == 'PyObject' else swift_type

    print(f'  // MARK: - {t.swift_type.replace("Py", "")}')
    print()

    function_name = get_fill_function_name(t)
    print(f'  private func {function_name}() {{')
    print(f'    let type = self.{get_property_name(t.python_type)}')

    if static_doc_property:
        print(f'    type.setBuiltinTypeDoc({swift_type}.{static_doc_property})')
    else:
        print(f'    type.setBuiltinTypeDoc(nil)')

    for flag in sourcery_flags:
        print(f'    type.flags.set(PyType.{flag}Flag)')

    # ==================
    # === Properties ===
    # ==================

    is_first = True
    castSelf = f'Self.{get_downcast_function_name(t)}'

    for prop in t.properties:
        python_name = prop.python_name
        swift_getter_fn = prop.swift_getter_fn
        swift_setter_fn = prop.swift_setter_fn

        static_doc_property = prop.swift_static_doc_property
        doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

        if is_first:
            is_first = False
            print()

        if not swift_setter_fn:
            print(
                f'    self.insert(type: type, name: "{python_name}", value: PyProperty.wrap(doc: {doc}, get: {swift_type}.{swift_getter_fn}, castSelf: {castSelf}))')
        else:
            print(
                f'    self.insert(type: type, name: "{python_name}", value: PyProperty.wrap(doc: {doc}, get: {swift_type}.{swift_getter_fn}, set: {swift_type}.{swift_setter_fn}, castSelf: {castSelf}))')

    # ================
    # === New/init ===
    # ================

    is_first = True

    # __new__
    for meth in t.static_functions:
        python_name = meth.python_name
        swift_selector = meth.swift_selector

        static_doc_property = meth.swift_static_doc_property
        doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

        if not python_name == '__new__':
            continue

        if is_first:
            is_first = False
            print()

        print(f'    self.insert(type: type, name: "__new__", value: PyStaticMethod.wrapNew(type: type, doc: {doc}, fn: {swift_type}.{swift_selector}))')

    # __init__
    for meth in t.methods:
        python_name = meth.python_name
        swift_selector = meth.swift_selector

        static_doc_property = meth.swift_static_doc_property
        doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

        if not python_name == '__init__':
            continue

        if is_first:
            is_first = False
            print()

        print(f'    self.insert(type: type, name: "__init__", value: PyBuiltinFunction.wrapInit(type: type, doc: {doc}, fn: {swift_type}.{swift_selector}))')

    # ==============================
    # === Static/class functions ===
    # ==============================

    is_first = True

    def is_new_or_init(name):
        return name == '__new__' or name == '__init__'

    def print_static_class_method(factory_type: str, fn: PyFunctionInfo):
        python_name = fn.python_name
        swift_selector = fn.swift_selector

        static_doc_property = fn.swift_static_doc_property
        doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

        if is_new_or_init(python_name):
            return

        nonlocal is_first
        if is_first:
            is_first = False
            print()

        print(
            f'    self.insert(type: type, name: "{python_name}", value: {factory_type}.wrap(name: "{python_name}", doc: {doc}, fn: {swift_type}.{swift_selector}))')

    for fn in t.static_functions:
        print_static_class_method('PyStaticMethod', fn)

    for fn in t.class_functions:
        print_static_class_method('PyClassMethod', fn)

    # ===============
    # === Methods ===
    # ===============

    is_first = True

    for meth in t.methods:
        python_name = meth.python_name
        swift_selector = meth.swift_selector

        static_doc_property = meth.swift_static_doc_property
        doc = f'{swift_type}.{static_doc_property}' if static_doc_property else 'nil'

        if is_new_or_init(python_name):
            continue

        if is_first:
            is_first = False
            print()

        if t.python_type == 'object':
            print(
                f'    self.insert(type: type, name: "{python_name}", value: PyBuiltinFunction.wrap(name: "{python_name}", doc: {doc}, fn: {swift_type}.{swift_selector}))')
        else:
            print(
                f'    self.insert(type: type, name: "{python_name}", value: PyBuiltinFunction.wrap(name: "{python_name}", doc: {doc}, fn: {swift_type}.{swift_selector}, castSelf: {castSelf}))')

    print('  }')
    print()

# ==============
# Cast as 'type'
# ==============


def get_downcast_function_name(t):
    swift_type = t.swift_type
    swift_type_without_py = swift_type.replace('Py', '')
    return f'as{swift_type_without_py}'


def print_downcast_function(t):
    python_type = t.python_type
    swift_type = t.swift_type

    function_name = get_downcast_function_name(t)

    print(f'''\
  private static func {function_name}(_ object: PyObject, methodName: String) -> PyResult<{swift_type}> {{
    return Self.cast(
      object,
      as: {swift_type}.self,
      typeName: "{python_type}",
      methodName: methodName
    )
  }}
''')
