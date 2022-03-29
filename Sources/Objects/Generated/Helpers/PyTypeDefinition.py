from typing import List, Dict

from Sourcery import TypeInfo, PyFunctionInfo
from Helpers.NewTypeArguments import NewTypeArguments
from Helpers.StaticMethod import ALL_STATIC_METHODS
from Helpers.PyTypeDefinition_helpers import (
    get_property_name,
    get_property_name_escaped,
    get_static_methods_property_name
)

STATIC_METHOD_NAMES = map(lambda m: m.name, ALL_STATIC_METHODS)
STATIC_METHOD_NAMES = set(STATIC_METHOD_NAMES)

class PyTypeDefinition:

    def __init__(self, t: TypeInfo) -> None:
        self.t = t
        self.python_type_name = t.python_type_name
        self.new_type_args = NewTypeArguments(self.t)

    # ================
    # === Property ===
    # ================

    @property
    def property_name(self) -> str:
        return get_property_name(self.python_type_name)

    @property
    def property_name_escaped(self) -> str:
        return get_property_name_escaped(self.python_type_name)

    def print_property(self):
        name = self.property_name_escaped
        print(f'    public let {name}: PyType')

    def print_set_property(self):
        args = self.new_type_args
        flags = ', '.join(args.flags)

        type = 'self.type'
        base = 'self.' + get_property_name(args.base.python_type_name)

        mro_names: List[str] = []
        for t in args.mro_without_self:
            property_name = get_property_name(t.python_type_name)
            mro_names.append(f'self.{property_name}')

        # When we are 'error' we get 'typeType' and 'objectType' in args
        if self.t.is_error:
            type = 'typeType'

            if base == 'self.object':
                base = 'objectType'

            for index, name in enumerate(mro_names):
                if name == 'self.object':
                    mro_names[index] = 'objectType'

        mro = '[' + ', '.join(mro_names) + ']'

        # For builtin types there is always max 1 base class:
        # >>> InterruptedError.__bases__
        # (<class 'OSError'>,)
        bases = '[' + base + ']'

        print(f'''\
      self.{self.property_name_escaped} = memory.newType(
        type: {type},
        name: "{args.name}",
        qualname: "{args.qualname}",
        flags: [{flags}],
        base: {base},
        bases: {bases},
        mroWithoutSelf: {mro},
        subclasses: [],
        instanceSizeWithoutTail: {args.size_without_tail},
        staticMethods: {args.static_methods_property},
        debugFn: {args.debugFn},
        deinitialize: {args.deinitialize}
      )\
''')

    # ============
    # === Mark ===
    # ============

    def print_mark(self):
        name_without_py = self.t.swift_type_name[2:]
        print(f'    // MARK: - {name_without_py}')
        print()

    # ============
    # === Fill ===
    # ============

    @staticmethod
    def print_fill_helpers():
        print('''\
    // MARK: - Helpers

    /// Adds `property` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, property get: FunctionWrapper, doc: String?) {
      let property = py.newProperty(get: get, set: nil, del: nil, doc: doc)
      let value = property.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `property` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, property get: FunctionWrapper, setter set: FunctionWrapper, doc: String?) {
      let property = py.newProperty(get: get, set: set, del: nil, doc: doc)
      let value = property.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `method` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, method: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: method, module: nil, doc: doc)
      let value = builtinFunction.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `classmethod` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, classMethod: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: classMethod, module: nil, doc: doc)
      let staticMethod = py.newClassMethod(callable: builtinFunction)
      let value = staticMethod.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds `staticmethod` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, staticMethod: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: staticMethod, module: nil, doc: doc)
      let staticMethod = py.newStaticMethod(callable: builtinFunction)
      let value = staticMethod.asObject
      self.add(py, type: type, name: name, value: value)
    }

    /// Adds value to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, value: PyObject) {
      let dict = type.getDict(py)
      let interned = py.intern(string: name)

      switch dict.set(py, key: interned, value: value) {
      case .ok:
        break
      case .error(let e):
        let typeName = type.getNameString()
        trap("Error when adding '\(name)' to '\(typeName)' type: \(e)")
      }
    }
''')

    @property
    def fill_function_name(self):
        swift_type = self.t.swift_type_name
        swift_type_without_py = swift_type.replace('Py', '')
        return 'fill' + swift_type_without_py

    def print_fill_function(self):
        swift_type_name = self.t.swift_type_name

        doc_property = self.t.swift_static_doc_property
        doc_to_set = f'{swift_type_name}.{doc_property}' if doc_property else 'nil'

        print(f'    private func {self.fill_function_name}(_ py: Py) {{')
        print(f'      let type = self.{self.property_name}')
        print(f'      type.setBuiltinTypeDoc(py, value: {doc_to_set})')

        # ================
        # === New/init ===
        # ================

        def is_new_or_init(fn: PyFunctionInfo):
            python_name = fn.python_name
            return python_name == '__new__' or python_name == '__init__'

        def get_doc(fn: PyFunctionInfo) -> str:
            nonlocal swift_type_name
            static_doc_property = fn.swift_static_doc_property
            return f'{swift_type_name}.{static_doc_property}' if static_doc_property else 'nil'

        # __new__
        has__new__ = False
        for fn in self.t.python_static_functions:
            if not is_new_or_init(fn):
                continue

            print()
            print(f'      let __new__ = FunctionWrapper(type: type, fn: {swift_type_name}.{fn.swift_selector})')
            print(f'      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: {get_doc(fn)})')
            has__new__ = True

        # __init__
        for fn in self.t.python_methods:
            if not is_new_or_init(fn):
                continue

            if not has__new__:
                print()

            print(f'      let __init__ = FunctionWrapper(type: type, fn: {swift_type_name}.{fn.swift_selector})')
            print(f'      self.add(py, type: type, name: "__init__", method: __init__, doc: {get_doc(fn)})')

        # ==================
        # === Properties ===
        # ==================

        for index, prop in enumerate(self.t.python_properties):
            python_name = prop.python_name
            doc = get_doc(fn)

            if index == 0:
                print()

            if prop.has_setter:
                print(f'      let {python_name}Get = FunctionWrapper(name: "__get__", fn: {swift_type_name}.{prop.selector_get})')
                print(f'      let {python_name}Set = FunctionWrapper(name: "__set__", fn: {swift_type_name}.{prop.selector_set})')
                print(f'      self.add(py, type: type, name: "{python_name}", property: {python_name}Get, setter: {python_name}Set, doc: {doc})')
            else:
                print(f'      let {python_name} = FunctionWrapper(name: "__get__", fn: {swift_type_name}.{prop.selector_get})')
                print(f'      self.add(py, type: type, name: "{python_name}", property: {python_name}, doc: {doc})')

        # =======================================
        # === Methods, static/class functions ===
        # =======================================

        is_first = True
        def print_dict_add(kind: str, fn: PyFunctionInfo):
            nonlocal swift_type_name, is_first
            python_name = fn.python_name
            selector= fn.swift_selector
            doc = get_doc(fn)

            if is_first:
                print()

            print(f'      let {python_name} = FunctionWrapper(name: "{python_name}", fn: {swift_type_name}.{selector})')
            print(f'      self.add(py, type: type, name: "{python_name}", {kind}: {python_name}, doc: {doc})')
            is_first = False

        is_first = True
        for fn in self.t.python_class_functions:
            if not is_new_or_init(fn):
                print_dict_add('classMethod', fn)

        is_first = True
        for fn in self.t.python_static_functions:
            if not is_new_or_init(fn):
                print_dict_add('staticMethod', fn)

        is_first = True
        for fn in self.t.python_methods:
            if not is_new_or_init(fn):
                print_dict_add('method', fn)

        print('    }')
        print()

    # ======================
    # === Static methods ===
    # ======================

    def print_static_methods(self):
        t = self.t
        property_name = get_static_methods_property_name(t.swift_type_name)

        python_name_to_static_method: Dict[str, PyFunctionInfo] = {}
        for m in t.python_methods:
            name = m.python_name
            if name in STATIC_METHOD_NAMES:
                python_name_to_static_method[name] = m

        has_no_static_methods = len(python_name_to_static_method) == 0
        if has_no_static_methods:
            base_type = t.base_type_info
            base_container = 'Py.ErrorTypes' if base_type.is_error else 'Py.Types'
            base_property_name = get_static_methods_property_name(base_type.swift_type_name)
            print(f"    // '{t.python_type_name}' does not add any interesting methods to '{base_type.python_type_name}'.")
            print(f'    internal static let {property_name} = {base_container}.{base_property_name}.copy()')
            return

        print(f'    internal static var {property_name}: PyStaticCall.KnownNotOverriddenMethods = {{')

        if t.base_type_info is None:
            assert t.python_type_name == 'object'
            print(f'      var result = PyStaticCall.KnownNotOverriddenMethods()')
        else:
            base_type = t.base_type_info
            base_container = 'Py.ErrorTypes' if base_type.is_error else 'Py.Types'
            base_property_name = get_static_methods_property_name(base_type.swift_type_name)
            print(f'      var result = {base_container}.{base_property_name}.copy()')

        for static_method in ALL_STATIC_METHODS:
            python_name = static_method.name
            fn = python_name_to_static_method.get(python_name)
            if fn is not None:
                print(f'      result.{python_name} = .init({t.swift_type_name}.{fn.swift_selector})')

        print('      return result')
        print('    }()')

