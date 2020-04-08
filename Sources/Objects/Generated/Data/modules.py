import os
from typing import (Union)

# -----
# Types
# -----

class ModuleInfo:
  '''
  Python module.
  '''
  def __init__(self, python_type: str, swift_type: str):
    self.python_type = python_type
    self.swift_type = swift_type
    self.swift_static_doc_property = None

    self.properties = []
    self.functions = []

class PropertyInfo:
  '''
  Python property backed by Swift property.

  In Swift:
  ```Swift
  // sourcery: pyproperty = argv, setter = setArgv
  internal var argv: PyObject { ... }
  ```
  '''
  def __init__(self, python_name: str, swift_property_name: str, swift_setter_fn: str, swift_static_doc_property: str):
    self.python_name = python_name
    self.swift_property_name = swift_property_name
    self.swift_setter_fn = swift_setter_fn or None
    self.swift_static_doc_property = swift_static_doc_property or None

class FunctionInfo:
  '''
  Python function.

  In Swift:
  ```Swift
  // sourcery: pymethod = warnoptions
  internal func warnOptions() -> PyObject { ... }
  ```
  '''
  def __init__(self, python_name: str, swift_function_name: str, swift_selector: str, swift_static_doc_property: str):
    self.python_name = python_name
    self.swift_function_name = swift_function_name
    self.swift_selector = swift_selector
    self.swift_static_doc_property = swift_static_doc_property or None

# -------
# Parsing
# -------

def get_modules() -> [ModuleInfo]:
  dir_path = os.path.dirname(__file__)
  input_file = os.path.join(dir_path, 'modules.txt')

  result: [ModuleInfo] = []
  current_module: Union[ModuleInfo, None] = None

  with open(input_file, 'r') as reader:
    for line in reader:
      line = line.strip()

      if not line or line.startswith('#'):
        continue

      split = line.split('|')
      assert len(split) >= 1

      line_type = split[0]
      if line_type == 'Module':
        if current_module:
          result.append(current_module)

        assert len(split) == 3
        python_type = split[1]
        swift_type = split[2]
        current_module = ModuleInfo(python_type, swift_type)

      elif line_type == 'Doc':
        assert current_module
        assert len(split) == 2
        current_module.swift_static_doc_property = split[1]

      elif line_type == 'Property':
        assert current_module
        assert len(split) == 5
        python_name = split[1]
        swift_property_name = split[2]
        swift_setter_fn = split[3]
        swift_static_doc_property = split[4]

        prop = PropertyInfo(python_name, swift_property_name, swift_setter_fn, swift_static_doc_property)
        current_module.properties.append(prop)

      elif line_type == 'PropertyFn':
        assert False, 'Properties backed by function are not implemented. Maybe you can use standard Swift property?'

      elif line_type == 'Function':
        assert current_module
        assert len(split) == 5
        python_name = split[1]
        swift_function_name = split[2]
        swift_selector = split[3]
        swift_static_doc_property = split[4]
        fn = FunctionInfo(python_name, swift_function_name, swift_selector, swift_static_doc_property)
        current_module.functions.append(fn)

      else:
        assert False, f"Unknown line type: '{line_type}'"

  if current_module:
    result.append(current_module)

  return result

# ------------------
# Main (for testing)
# ------------------

if __name__ == '__main__':
  for mod in get_modules():
    python_type = mod.python_type
    swift_type = mod.swift_type
    doc_property = mod.swift_static_doc_property
    print(f'{python_type} (swift_type: {swift_type}, doc_property: {doc_property})')

    for prop in mod.properties:
      python_name = prop.python_name
      swift_property = prop.swift_property_name
      swift_setter_fn = prop.swift_setter_fn
      doc_property = prop.swift_static_doc_property
      print(f'  {python_name} (swift_property: {swift_property}, swift_setter_fn: {swift_setter_fn}, doc_property: {doc_property})')

    if mod.properties and mod.functions:
      print()

    for fn in mod.functions:
      python_name = fn.python_name
      swift_function_name = fn.swift_function_name
      swift_selector = fn.swift_selector
      doc_property = fn.swift_static_doc_property
      print(f'  {python_name} (swift_function_name: {swift_function_name}, swift_selector: {swift_selector}, doc_property: {doc_property})')

    print()
