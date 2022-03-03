from typing import List
from Sourcery.TypeInfo import TypeInfo, PyFunctionInfo

def validateSwiftFunctionNames(all_types: List[TypeInfo]):
    invalid_functions = []

    def validate(t: TypeInfo, fns: List[PyFunctionInfo]):
        nonlocal invalid_functions

        for fn in fns:
            if fn.python_name != fn.swift_name:
                pair = t, fn
                invalid_functions.append(pair)

    for t in all_types:
        validate(t, t.python_methods)
        validate(t, t.python_static_functions)
        validate(t, t.python_class_functions)

    if not invalid_functions:
        return

    print('''
=== ERROR: validateSwiftFunctionNames ==========================================
Some functions do not have the same name in Python and Swift.
This is important since we use Swift function name to generate message
for invalid \'self\' argument:
func invalidSelfArgument(..., swiftFnName: StaticString = #function)
''')

    for t, fn in invalid_functions:
        print(f"[{t.swift_type_name}] '{fn.python_name} vs {fn.swift_name}")

    print('''
================================================================================
''')
