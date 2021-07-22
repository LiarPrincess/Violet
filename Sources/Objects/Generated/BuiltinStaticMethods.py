from typing import Dict, List

from Sourcery import TypeInfo, PyFunctionInfo, get_types
from Static_methods import STATIC_METHODS
from Common.builtin_types import print_type_mark

TYPE_NAME = 'BuiltinStaticMethods'


def get_property_name(swift_type_name: str) -> str:
    "Camel cased 'swift_type_name' without 'Py'."

    assert swift_type_name.startswith('Py'), swift_type_name
    result = swift_type_name[2:]
    result = result[0].lower() + result[1:]
    return result


def get_property_name_escaped(swift_type_name: str) -> str:
    property_name = get_property_name(swift_type_name)

    if property_name == 'super':
        return '`super`'

    return property_name


static_method_names = map(lambda m: m.name, STATIC_METHODS)
static_method_names = set(static_method_names)


def print_static_methods(t: TypeInfo):
    print_type_mark(t)

    python_methods_by_name: Dict[str, PyFunctionInfo] = {}
    for m in t.python_methods:
        name = m.python_name
        if name in static_method_names:
            python_methods_by_name[name] = m

    property_name = get_property_name_escaped(t.swift_type_name)

    has_no_static_methods = len(python_methods_by_name) == 0
    if has_no_static_methods:
        base_type_name = t.swift_base_type_name
        assert base_type_name  # only 'object' has no base, and 'object' has static methods

        base_property_name = get_property_name(t.swift_base_type_name)
        print(f"  // '{t.swift_type_name}' does not any interesting methods to '{base_type_name}'.")
        print(f'  internal static let {property_name} = {TYPE_NAME}.{base_property_name}.copy()')
        print()
        return

    print(f'  internal static var {property_name}: PyType.StaticallyKnownNotOverriddenMethods = {{')

    is_object = not t.swift_base_type_name
    if is_object:
        assert t.swift_type_name == 'PyObject'
        print(f'    let result = PyType.StaticallyKnownNotOverriddenMethods()')
    else:
        base_property_name = get_property_name(t.swift_base_type_name)
        print(f'    let result = {TYPE_NAME}.{base_property_name}.copy()')

    printed_names = (
        # '__repr__', '__str__',
        # '__eq__', '__ne__', '__lt__', '__le__', '__gt__', '__ge__',
        # '__bool__', '__float__', '__int__', '__complex__', '__index__',
        # '__getattr__', '__getattribute__', '__setattr__', '__delattr__',
        # '__getitem__', '__setitem__', '__delitem__',
        # (...)
        # '__pos__', '__neg__', '__abs__', '__invert__',
        # '__trunc__', '__round__',
        # '__add__', '__and__', '__divmod__', '__floordiv__', '__lshift__', '__matmul__', '__mod__', '__mul__', '__or__', '__rshift__', '__sub__', '__truediv__', '__xor__',
        # '__radd__', '__rand__', '__rdivmod__', '__rfloordiv__', '__rlshift__', '__rmatmul__', '__rmod__', '__rmul__', '__ror__', '__rrshift__', '__rsub__', '__rtruediv__', '__rxor__',
        # '__iadd__', '__iand__', '__idivmod__', '__ifloordiv__', '__ilshift__', '__imatmul__', '__imod__', '__imul__', '__ior__', '__irshift__', '__isub__', '__itruediv__', '__ixor__',
        # '__pow__', '__rpow__', '__ipow__',
    )

    for static_method in STATIC_METHODS:
        python_name = static_method.name

        is_printed = python_name in printed_names
        is_commented = not is_printed
        c = '// ' if is_commented else ''

        python_method = python_methods_by_name.get(python_name)
        if python_method:
            print(f'    {c}result.{python_name} = .init({t.swift_type_name}.{python_method.swift_selector})')

    print('    return result')
    print('  }()')
    print()


if __name__ == '__main__':
    print(f'''\
// swiftlint:disable file_length
// swiftlint:disable vertical_whitespace_closing_braces

/// Static methods defined on builtin types.
///
/// See `PyStaticCall` documentation for more information.
internal enum {TYPE_NAME} {{
''')

    types = get_types()
    for t in types:
        print_static_methods(t)

    print('}')
