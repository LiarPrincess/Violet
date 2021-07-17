'''
This tool will detect 'pymethods' that are also Swift method overrides
(functions with 'override' keyword).
This is illegal because Swift always resolves virtual method
(even when calling using base type definition).
For example:

class PyInt {
  func f() -> String { return "int" }
}

class PyBool: PyInt {
  override func f() -> String { return "bool" }
}

let int = PyInt()
let bool = PyBool()

print("PyInt.f(int)()           =", PyInt.f(int)())   // 'int',  as expected
print("PyBool.f(bool)()         =", PyBool.f(bool)()) // 'bool', as expected
print("PyInt.f(bool as PyInt)() =", PyInt.f(bool as PyInt)()) // 'bool', ehh…

So we called 'PyInt.f' with 'bool' and it returned 'bool'.
In Python this would return 'int'.
'''

from typing import List, Dict,  NamedTuple

from Sourcery.entities import TypeInfo, PyFunctionInfo


class OverriddenPyMethod(NamedTuple):
    typ: TypeInfo
    method: PyFunctionInfo
    method_owner: TypeInfo


def check_for_overridden_pymethods(types: List[TypeInfo]):
    types_by_swift_name: Dict[str, TypeInfo] = {}
    for t in types:
        types_by_swift_name[t.swift_type_name] = t

    overridden_pymethods: List[OverriddenPyMethod] = []
    for t in types:
        # Get all base types - we will look for 'duplicate' definition of every method
        base_types: List[TypeInfo] = []
        swift_base_name = t.swift_base_type_name
        while swift_base_name:
            if swift_base_name == 'PyObject':
                break

            base = types_by_swift_name[swift_base_name]
            base_types.append(base)
            swift_base_name = base.swift_base_type_name

        # Look in bases for method with the same selector
        py_methods = t.python_methods + t.python_static_functions + t.python_class_functions
        for method in py_methods:
            selector = method.swift_selector
            for base in base_types:
                for base_method in base.swift_methods:
                    if base_method.swift_selector == selector:
                        overridden_pymethods.append(OverriddenPyMethod(t, method, base))

    if not overridden_pymethods:
        return

    print('''\
!!! Error !!!
Following methods were found to be both 'pymethod' and Swift method overrides
(function with 'override' keyword):\
''')

    for override in overridden_pymethods:
        typ = override.typ
        method = override.method
        owner = override.method_owner

        typ_name = typ.swift_type_name
        owner_name = owner.swift_type_name
        selector = method.swift_selector
        print(f'- {typ_name}.{selector} is override of similar method in {owner_name}')

    print('!!! Error !!!')
