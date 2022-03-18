import os.path
from typing import List

class SwiftStoredPropertyOnPy:
    def __init__(self, swift_name: str, swift_type: str):
        self.swift_name = swift_name
        self.swift_type = swift_type

class PyInfo:
    pass
    def __init__(self):
        self.swift_properties: List[SwiftStoredPropertyOnPy] = []

def get_py_info() -> PyInfo:
    dir_path = os.path.dirname(__file__)
    input_file = os.path.join(dir_path, 'dump.txt')

    result = PyInfo()
    with open(input_file, 'r') as reader:
        for line in reader:
            line = line.strip()

            if not line or line.startswith('#'):
                continue

            split = line.split('|')
            assert len(split) >= 1

            line_type = split[0]
            if line_type == 'SwiftStoredPropertyOnPy':
                assert len(split) == 3

                property_name = split[1]
                property_type = split[2]

                property = SwiftStoredPropertyOnPy(property_name, property_type)
                result.swift_properties.append(property)

    return result
