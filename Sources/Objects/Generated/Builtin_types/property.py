from typing import List
from Sourcery import TypeInfo
from TypeMemoryLayout import get_layout_name
from StaticMethodsForBuiltinTypes import get_property_name as get_static_methods_property_name


def print_property(t: TypeInfo):
    python_type = t.python_type_name
    property_name_escaped = get_property_name_escaped(python_type)
    print(f'  public let {property_name_escaped}: PyType')


def get_property_name(python_type_name: str) -> str:
    if python_type_name == 'NoneType':
        return 'none'

    if python_type_name == 'NotImplementedType':
        return 'notImplemented'

    if python_type_name == 'types.SimpleNamespace':
        return 'simpleNamespace'

    if python_type_name == 'TextFile':
        return 'textFile'

    if python_type_name == 'EOFError':
        return 'eofError'

    if python_type_name == 'OSError':
        return 'osError'

    result = python_type_name[0].lower() + python_type_name[1:]
    return result


def get_property_name_escaped(python_type_name: str) -> str:
    property_name = get_property_name(python_type_name)

    if property_name == 'super':
        return '`super`'

    return property_name


def _get_base_type(t: TypeInfo, all_types: List[TypeInfo]) -> TypeInfo:
    swift_base_name = t.swift_base_type_name
    for other in all_types:
        if other.swift_type_name == swift_base_name:
            return other

    assert False, f"Unable to find base type for: '{swift_base_name}'"


def print_set_property(t: TypeInfo, all_types: List[TypeInfo]):
    python_type_name = t.python_type_name
    property_name = get_property_name_escaped(python_type_name)

    type = ''
    if t.is_error:
        type = 'Py.types.type'
    else:
        type = 'self.type'

    base = ''
    if python_type_name == 'object':
        base = 'nil'
    elif python_type_name == 'BaseException':
        # 'baseException' is defined in 'Py.errorTypes',
        # but its base type is in 'Py.types'.
        base = 'Py.types.object'
    else:
        base_type = _get_base_type(t, all_types)
        base = 'self.' + get_property_name_escaped(base_type.python_type_name)

    type_flags = ''
    for flag in t.sourcery_flags:
        if type_flags:
            type_flags += ', '

        type_flags += '.' + flag + 'Flag'

    layout_name = get_layout_name(t)
    static_methods_property = get_static_methods_property_name(t.swift_type_name)

    is_object_or_type = python_type_name == 'object' or python_type_name == 'type'
    if is_object_or_type:
        print(f'''\
    self.{property_name} = PyType.initBuiltinTypeWithoutTypeFilled(
      name: "{python_type_name}",
      base: {base},
      typeFlags: [{type_flags}],
      staticMethods: StaticMethodsForBuiltinTypes.{static_methods_property},
      layout: PyType.MemoryLayout.{layout_name}
    )\
''')
    else:
        print(f'''\
    self.{property_name} = PyType.initBuiltinType(
      name: "{python_type_name}",
      type: {type},
      base: {base},
      typeFlags: [{type_flags}],
      staticMethods: StaticMethodsForBuiltinTypes.{static_methods_property},
      layout: PyType.MemoryLayout.{layout_name}
    )\
''')
