from printers import PrintingInfo, get_printer
from import_from_objects_generated import get_static_methods, get_types

STATIC_METHODS = get_static_methods()

static_method_names = map(lambda m: m.name, STATIC_METHODS)
static_method_names = set(static_method_names)


def print_test_case(t):
    # Can we create subclass?
    is_base_type = t.sourcery_flags.is_base_type
    if not is_base_type:
        return

    type_name = t.python_type_name

    # For some reason overriding methods on 'reversed'
    # does not work in CPython 3.7.4
    if type_name == 'reversed':
        return

    # TODO: 'super' does not work in Violet.
    if type_name == 'super':
        return

    test_type_name = type_name[0].upper() + type_name[1:]
    test_type_name = 'My' + test_type_name

    implemented_static_method_names = set()
    for m in t.python_methods:
        name = m.python_name
        if name in static_method_names:
            implemented_static_method_names.add(name)

    has_no_static_methods = len(implemented_static_method_names) == 0
    if has_no_static_methods:
        return

    equal_count = len(type_name) + 8
    equals = '=' * equal_count
    print(f'# {equals}')
    print(f'# === {type_name} ===')
    print(f'# {equals}')
    print()

    print(f'class {test_type_name}({type_name}):')
    print()

    for m in STATIC_METHODS:
        method_name = m.name
        method_kind = m.kind.name
        if method_name not in implemented_static_method_names:
            continue

        info = PrintingInfo(type_name, test_type_name, method_name, method_kind)
        printer = get_printer(info)
        printer.print_method(info)

    init_args = ''
    if type_name in ('classmethod', 'staticmethod'):
        init_args = 'lambda: None'
    if type_name in ('enumerate', 'reversed'):
        init_args = '[]'
    if type_name in ('filter', 'map'):
        init_args = 'lambda: None, []'
    if type_name == 'module':
        init_args = "'name'"
    if type_name == 'super':
        init_args = 'int, 42'
    if type_name == 'type':
        init_args = "'Name', (), {}"

    print()
    print(f'o = {test_type_name}({init_args})')

    for m in STATIC_METHODS:
        method_name = m.name
        method_kind = m.kind.name
        if method_name not in implemented_static_method_names:
            continue

        info = PrintingInfo(type_name, test_type_name, method_name, method_kind)
        printer = get_printer(info)
        printer.print_assert(info)

    print()


def generated_warning(file_path: str) -> str:
    header = f'''
# Automatically generated from: {file_path}
# DO NOT EDIT!
'''

    comment_marker = '# '
    max_line_len = max(map(lambda line: len(line), header.splitlines()))
    equal_count = max_line_len - len(comment_marker)
    separator = comment_marker + '=' * equal_count

    return separator + header + separator


if __name__ == '__main__':
    print(f"""\
{generated_warning(__file__)}

'''
We sometimes dispatch methods using 'object.type.staticMethods' instead of doing
a standard Python dispatch. But if we override given method in subtype then we
should always use dynamic dispatch. This file will test just that.

See 'PyStaticCall' documentation for more information.
'''

import sys

# Not all of the types are in 'builtins'.
if sys.implementation.name == 'Violet':
    module = type(sys)
    SimpleNamespace = type(sys.implementation)
else:
    from types import SimpleNamespace
    from types import ModuleType as module

# ===============
# === Globals ===
# ===============

# Insert value to this dictionary to indicate that the method was called.
global_values = {{}}


def set_global_value(class_name: object, method_name: str):
    global global_values
    key = class_name + '.' + method_name
    global_values[key] = True


def is_global_value_set(class_name: object, method_name: str):
    global global_values
    key = class_name + '.' + method_name
    return global_values.get(key)


# Commonly used values.
attribute_name = 'attribute_name'
index_value = 1234
hash_value = 42
dir_value = ['__dir__']
""")

    types = get_types()
    for t in types:
        print_test_case(t)
