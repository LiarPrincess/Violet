from typing import List
from Sourcery import TypeInfo, PyFunctionInfo
from Helpers.NewTypeArguments import NewTypeArguments
from Helpers.StaticMethod import ALL_STATIC_METHODS
from Helpers.PyTypeDefinition_helpers import (
    get_property_name,
    get_property_name_escaped,
    get_static_methods_property_name,
    get_layout_property_name
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
        py,
        type: {type},
        name: "{args.name}",
        qualname: "{args.qualname}",
        flags: [{flags}],
        base: {base},
        bases: {bases},
        mroWithoutSelf: {mro},
        subclasses: [],
        layout: {args.layout_property},
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

    /// Adds `method` to `type.__dict__`.
    private func add(_ py: Py, type: PyType, name: String, method: FunctionWrapper, doc: String?) {
      let builtinFunction = py.newBuiltinFunction(fn: method, module: nil, doc: doc)
      let value = builtinFunction.asObject
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
      let __dict__ = type.header.__dict__
      let interned = py.intern(string: name)

      switch __dict__.set(py, key: interned, value: value) {
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

        def get_doc(fn: PyFunctionInfo) -> str:
            nonlocal swift_type_name
            static_doc_property = fn.swift_static_doc_property
            return f'{swift_type_name}.{static_doc_property}' if static_doc_property else 'nil'

        # __new__
        has__new__ = False
        for fn in self.t.python_static_functions:
            python_name = fn.python_name
            if not python_name == '__new__':
                continue

            print()
            print(f'      let __new__ = FunctionWrapper(type: type, fn: {swift_type_name}.{fn.swift_selector})')
            print(f'      self.add(py, type: type, name: "__new__", staticMethod: __new__, doc: {get_doc(fn)})')
            has__new__ = True

        # __init__
        for fn in self.t.python_methods:
            python_name = fn.python_name
            if not python_name == '__init__':
                continue

            if not has__new__:
                print()

            print(f'      let __init__ = FunctionWrapper(type: type, fn: {swift_type_name}.{fn.swift_selector})')
            print(f'      self.add(py, type: type, name: "__init__", method: __init__, doc: {get_doc(fn)})')

        # ===============
        # === Methods ===
        # ===============

        for index, fn in enumerate(self.t.python_methods):
            python_name = fn.python_name
            if python_name in ('__new__', '__init__'):
                continue

            if index == 0:
                print()

            print(f'      let {python_name} = FunctionWrapper(name: "{python_name}", fn: {swift_type_name}.{fn.swift_selector})')
            print(f'      self.add(py, type: type, name: "{python_name}", method: {python_name}, doc: {get_doc(fn)})')

        print('    }')
        print()

    # ======================
    # === Static methods ===
    # ======================

    def print_static_methods(self):
        property_name = get_static_methods_property_name(self.t.swift_type_name)
        print(f'    internal static let {property_name} = PyStaticCall.KnownNotOverriddenMethods()')

    # ==============
    # === Layout ===
    # ==============

    def print_memory_layout(self):
        property_name = get_layout_property_name(self.t.swift_type_name)
        print(f'    internal static let {property_name} = PyType.MemoryLayout()')
