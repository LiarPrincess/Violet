from typing import List
from Sourcery import TypeInfo
from Helpers.NewTypeArguments import NewTypeArguments
from Helpers.static_methods import STATIC_METHODS
from Helpers.PyTypeDefinition_helpers import (
    get_property_name,
    get_property_name_escaped,
    get_static_methods_property_name,
    get_layout_property_name
)

STATIC_METHOD_NAMES = map(lambda m: m.name, STATIC_METHODS)
STATIC_METHOD_NAMES = set(STATIC_METHOD_NAMES)

class PyTypeDefinition:

    def __init__(self, t: TypeInfo, all_types: List[TypeInfo]) -> None:
        self.t = t
        self.python_type_name = t.python_type_name
        self.new_type_args = NewTypeArguments(self.t, all_types)

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

    /// Adds value to `type.__dict__`.
    private func add<T: PyObjectMixin>(_ py: Py, type: PyType, name: String, value: T) {
      let __dict__ = type.header.__dict__
      let interned = py.intern(string: name)

      switch __dict__.set(key: interned, to: value.asObject) {
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

        print(f'    private func {self.fill_function_name}(_ py: Py) {{')
        print(f'      let type = self.{self.property_name}')

        # ===========
        # === Doc ===
        # ===========

        doc_property = self.t.swift_static_doc_property
        if doc_property:
            print(f'      type.setBuiltinTypeDoc(py, value: {swift_type_name}.{doc_property})')
        else:
            print(f'      type.setBuiltinTypeDoc(py, value: nil)')

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
