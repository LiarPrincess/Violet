from typing import Dict, List

from Sourcery import TypeInfo, PyFunctionInfo, get_types
from Static_methods import STATIC_METHODS
from Common.strings import generated_warning
from Common.builtin_types import print_type_mark

TYPE_NAME = 'StaticMethodsForBuiltinTypes'


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
        print(f'    var result = PyType.StaticallyKnownNotOverriddenMethods()')
    else:
        base_property_name = get_property_name(t.swift_base_type_name)
        print(f'    var result = {TYPE_NAME}.{base_property_name}.copy()')

    # Methods for object are defined on 'PyObjectType'
    swift_type_name = t.swift_type_name
    if is_object:
        swift_type_name = 'PyObjectType'

    for static_method in STATIC_METHODS:
        python_name = static_method.name
        python_method = python_methods_by_name.get(python_name)
        if python_method:
            print(f'    result.{python_name} = .init({swift_type_name}.{python_method.swift_selector})')

    print('    return result')
    print('  }()')
    print()


if __name__ == '__main__':
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable vertical_whitespace_closing_braces
// swiftlint:disable closure_body_length
// swiftlint:disable file_length

/// Static methods defined on builtin types.
///
/// See `PyStaticCall` documentation for more information.
internal enum {TYPE_NAME} {{
''')

    types = get_types()
    for t in types:
        print_static_methods(t)

    print('}')
