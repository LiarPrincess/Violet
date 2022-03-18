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
    name = get_property_name(python_type_name)

    if name == 'super':
        return '`super`'

    return name

def get_static_methods_property_name(swift_type_name: str) -> str:
    "Camel cased 'swift_type_name' without 'Py'."

    assert swift_type_name.startswith('Py'), swift_type_name
    type_prefix = swift_type_name[2:]
    type_prefix = type_prefix[0].lower() + type_prefix[1:]
    return type_prefix + 'StaticMethods'
