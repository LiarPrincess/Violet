import os.path
from typing import List, Union

from Sourcery.TypeInfo import TypeInfo, SwiftPropertyInfo, SwiftInitializerInfo, PyPropertyInfo, PyFunctionInfo

def get_types() -> List[TypeInfo]:
    dir_path = os.path.dirname(__file__)
    input_file = os.path.join(dir_path, 'dump.txt')

    result: List[TypeInfo] = []
    current_type: Union[TypeInfo, None] = None

    def commit_current_type():
        if current_type:
            assert len(current_type.swift_initializers), 'No initializer?'
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
            if line_type == 'ObjectHeaderField':
                # We are not interested in object header
                pass
            elif line_type == 'Type' or line_type == 'ErrorType':
                commit_current_type()  # We are starting new type

                assert len(split) == 4
                swift_type = split[1]
                python_type = split[2]
                python_base_type = split[3]
                is_error = line_type == 'ErrorType'

                current_type = TypeInfo(swift_type,
                                        python_type,
                                        python_base_type,
                                        is_error)

            elif line_type == 'Annotation':
                assert current_type
                assert len(split) == 2

                annotation = split[1]
                if annotation in ('pytype', 'pyerrortype', 'pybase'):
                    continue

                current_type.sourcery_flags.append(annotation)

            elif line_type == 'Doc':
                assert current_type
                assert len(split) == 2
                current_type.swift_static_doc_property = split[1]

            elif line_type == 'SwiftProperty':
                assert current_type
                assert len(split) == 3

                field_name = split[1]
                field_type = split[2]

                field = SwiftPropertyInfo(field_name, field_type)
                current_type.swift_properties.append(field)

            elif line_type == 'SwiftInit':
                assert current_type
                assert len(split) == 2

                selector_with_types = split[1]

                init = SwiftInitializerInfo(selector_with_types)
                current_type.swift_initializers.append(init)

            else:
                assert False, f"Unknown line type: '{line_type}'"

    # Commit last type
    commit_current_type()

    return result
