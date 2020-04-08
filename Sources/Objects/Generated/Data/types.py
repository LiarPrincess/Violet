import os
from typing import (Union)

# -----
# Types
# -----

class TypeInfo:
  '''
  Python type.
  '''
  def __init__(self, python_type: str, swift_type: str, is_error_type: bool):
    self.python_type = python_type
    self.swift_type = swift_type
    self.is_error_type = is_error_type
    self.swift_static_doc_property = None
    self.sourcery_flags = []

    self.properties = []
    self.static_functions = []
    self.methods = []

class PropertyInfo:
  '''
  Python property backed by Swift property.

  In Swift:
  ```Swift
  // sourcery: pyproperty = argv, setter = setArgv
  internal var argv: PyObject { ... }
  ```
  '''
  def __init__(self, python_name: str, swift_getter_fn: str, swift_setter_fn: str, swift_static_doc_property: str):
    self.python_name = python_name
    self.swift_getter_fn = swift_getter_fn
    self.swift_setter_fn = swift_setter_fn or None
    self.swift_static_doc_property = swift_static_doc_property or None

class FunctionInfo:
  '''
  Python function/method.

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

# Functions and methods have exactly the same properties.
MethodInfo = FunctionInfo

# -------
# Parsing
# -------

def get_types() -> [TypeInfo]:
  dir_path = os.path.dirname(__file__)
  input_file = os.path.join(dir_path, 'types.txt')

  result: [TypeInfo] = []
  current_type: Union[TypeInfo, None] = None
  def commit_current_type():
    if current_type:
      current_type.sourcery_flags.sort()
      result.append(current_type)

  with open(input_file, 'r') as reader:
    for line in reader:
      line = line.strip()

      if not line or line.startswith('#'):
        continue

      split = line.split('|')
      assert len(split) >= 1

      line_type = split[0]
      if line_type == 'Type' or line_type == 'ErrorType':
        commit_current_type()

        assert len(split) == 3
        python_type = split[1]
        swift_type = split[2]
        is_error_type = line_type == 'ErrorType'
        current_type = TypeInfo(python_type, swift_type, is_error_type)

      elif line_type == 'Annotation':
        assert current_type
        assert len(split) == 2

        annotation = split[1]
        if annotation == 'pytype' or annotation == 'pyerrortype':
          continue

        current_type.sourcery_flags.append(annotation)

      elif line_type == 'Doc':
        assert current_type
        assert len(split) == 2
        current_type.swift_static_doc_property = split[1]

      elif line_type == 'Property':
        assert current_type
        assert len(split) == 5
        python_name = split[1]
        swift_getter_fn = split[2]
        swift_setter_fn = split[3]
        swift_static_doc_property = split[4]

        prop = PropertyInfo(python_name, swift_getter_fn, swift_setter_fn, swift_static_doc_property)
        current_type.properties.append(prop)

      elif line_type == 'StaticFunction':
        assert current_type
        assert len(split) == 5
        python_name = split[1]
        swift_function_name = split[2]
        swift_selector = split[3]
        swift_static_doc_property = split[4]
        fn = FunctionInfo(python_name, swift_function_name, swift_selector, swift_static_doc_property)
        current_type.static_functions.append(fn)

      elif line_type == 'Method':
        assert current_type
        assert len(split) == 5
        python_name = split[1]
        swift_function_name = split[2]
        swift_selector = split[3]
        swift_static_doc_property = split[4]
        fn = MethodInfo(python_name, swift_function_name, swift_selector, swift_static_doc_property)
        current_type.methods.append(fn)

      else:
        assert False, f"Unknown line type: '{line_type}'"

  commit_current_type()
  return result

# ------------------
# Main (for testing)
# ------------------

if __name__ == '__main__':
  for mod in get_types():
    python_type = mod.python_type
    swift_type = mod.swift_type
    doc_property = mod.swift_static_doc_property
    print(f'{python_type} (swift_type: {swift_type}, doc_property: {doc_property})')
