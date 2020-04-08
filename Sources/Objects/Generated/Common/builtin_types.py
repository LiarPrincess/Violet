def get_property_name(python_type):
  if python_type == 'NoneType':
    return 'none'

  if python_type == 'NotImplementedType':
    return 'notImplemented'

  if python_type == 'types.SimpleNamespace':
    return 'simpleNamespace'

  if python_type == 'TextFile':
    return 'textFile'

  return python_type

def get_property_name_escaped(python_type):
  property_name = get_property_name(python_type)

  if property_name == 'super':
    return '`super`'

  return property_name
