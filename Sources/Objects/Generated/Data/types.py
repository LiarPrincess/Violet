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
    self.swift_static_doc_property = None
    self.is_error_type = is_error_type

# -------
# Parsing
# -------

def get_types() -> [TypeInfo]:
  dir_path = os.path.dirname(__file__)
  input_file = os.path.join(dir_path, 'types.txt')

  result: [TypeInfo] = []
  current_type: Union[TypeInfo, None] = None

  with open(input_file, 'r') as reader:
    for line in reader:
      line = line.strip()

      if not line or line.startswith('#'):
        continue

      split = line.split('|')
      assert len(split) >= 1

      line_type = split[0]
      if line_type == 'Type' or line_type == 'ErrorType':
        if current_type:
          result.append(current_type)

        assert len(split) == 3
        python_type = split[1]
        swift_type = split[2]
        is_error_type = line_type == 'ErrorType'
        current_type = TypeInfo(python_type, swift_type, is_error_type)

      else:
        assert False, line_type

  if current_type:
    result.append(current_type)

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
