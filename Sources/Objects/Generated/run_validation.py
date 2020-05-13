from Data.types import get_types, TypeInfo, PyFunctionInfo

# -------------------
# Overridden pymethod
# -------------------

class OverriddenPyMethod:
  '''
  Swift field.
  '''
  def __init__(self, type: TypeInfo, method: PyFunctionInfo, also_defined_in: [TypeInfo]):
    assert also_defined_in
    self.type = type
    self.method = method
    self.also_defined_in = also_defined_in

def check_for_overridden_pymethod(types: [TypeInfo]) -> bool:
  types_by_name = { }
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
      base.all_methods =  [] if base_type_name == 'PyObject' else base.methods + base.static_functions + base.class_functions
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
Following methods we found to be both 'pymethod' and Swift method overrides
(function with 'override' keyword):\
''')

    for override in overridden_pymethods:
      swift_type = override.type.swift_type
      swift_method = override.method.swift_name
      also_defined_in = ', '.join(map(lambda t: t.swift_type, override.also_defined_in))

      print(f'- {swift_type}.{swift_method} is override of similar method in {also_defined_in}')

    print('!!! Error !!!')
    return True

  return False

# ----
# Main
# ----

if __name__ == '__main__':
  types: [TypeInfo] = get_types()

  has_overridden_pymethod = check_for_overridden_pymethod(types)

  if has_overridden_pymethod:
    exit(1)
