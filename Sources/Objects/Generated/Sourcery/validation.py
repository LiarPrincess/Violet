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

from typing import List

from Sourcery.entities import TypeInfo, FieldInfo, PyPropertyInfo, PyFunctionInfo


# -------------------
# Overridden pymethod
# -------------------

class OverriddenPyMethod:
    '''
    Swift field.
    '''

    def __init__(self,
                 type: TypeInfo,
                 method: PyFunctionInfo,
                 also_defined_in: List[TypeInfo]):
        assert also_defined_in
        self.type = type
        self.method = method
        self.also_defined_in = also_defined_in


def check_for_overridden_pymethod(types: List[TypeInfo]) -> bool:
    types_by_name = {}
    for t in types:
        types_by_name[t.swift_type] = t

    overridden_pymethods = []
    for t in types:
        swift_type = t.swift_type

        # 'Object' is at the top - it can't override anything
        if swift_type == 'PyObject':
            continue

        # Get all base types - we will look for 'duplicate' definition of every method
        base_types = []
        base_type_name = t.swift_base_type
        while base_type_name:
            base = types_by_name[base_type_name]
            base.all_methods = [] if base_type_name == 'PyObject' else base.methods + base.static_functions + base.class_functions
            base_types.append(base)
            base_type_name = base.swift_base_type

        # Look in bases for method with the same selector
        def add_override_if_needed(m: PyFunctionInfo):
            also_defined_in = []

            for base_type in base_types:
                for base_method in base_type.all_methods:
                    if base_method.swift_selector == m.swift_selector:
                        also_defined_in.append(base_type)

            if also_defined_in:
                override = OverriddenPyMethod(t, m, also_defined_in)
                overridden_pymethods.append(override)

        for m in t.methods:
            add_override_if_needed(m)
        for m in t.static_functions:
            add_override_if_needed(m)
        for m in t.class_functions:
            add_override_if_needed(m)

    # Print result
    if overridden_pymethods:
        print('''\
!!! Error !!!
Following methods were found to be both 'pymethod' and Swift method overrides
(function with 'override' keyword):\
''')

        for override in overridden_pymethods:
            swift_type = override.type.swift_type
            swift_method = override.method.swift_name
            also_defined_in = ', '.join(map(lambda t: t.swift_type, override.also_defined_in))

            print(f'- {swift_type}.{swift_method} is override of similar method in {also_defined_in}')

        print('!!! Error !!!')
        return False

    return True


# ----
# Run
# ----

def run(types: List[TypeInfo]) -> bool:
    is_valid = True
    is_valid = check_for_overridden_pymethod(types) and is_valid
    return is_valid
