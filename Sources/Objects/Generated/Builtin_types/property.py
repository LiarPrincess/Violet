from Sourcery import TypeInfo, PyFunctionInfo


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
