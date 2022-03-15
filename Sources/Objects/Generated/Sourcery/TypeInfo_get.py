import os.path
from typing import List, Union

from Sourcery.TypeInfo import TypeInfo, SwiftProperty, SwiftInitializerInfo, PyPropertyInfo, PyFunctionInfo
from Sourcery.validateSwiftFunctionName import validateSwiftFunctionNames

def get_types() -> List[TypeInfo]:
    dir_path = os.path.dirname(__file__)
    input_file = os.path.join(dir_path, 'dump.txt')

    result: List[TypeInfo] = []
    current_type: Union[TypeInfo, None] = None
    python_name_to_info = {}

    def commit_current_type():
        nonlocal current_type, result, python_name_to_info
        if current_type:
            assert len(current_type.swift_initializers), 'No initializer?'
            current_type.sourcery_flags.sort()
            result.append(current_type)
            python_name_to_info[current_type.python_type_name] = current_type

    with open(input_file, 'r') as reader:
        for line in reader:
            line = line.strip()

            if not line or line.startswith('#'):
                continue

            split = line.split('|')
            assert len(split) >= 1

            line_type = split[0]
            if line_type in ('ObjectHeaderField', 'ErrorHeaderField'):
                # We are not interested in headers.
                pass
            elif line_type == 'Type' or line_type == 'ErrorType':
                commit_current_type()  # We are starting new type

                assert len(split) == 4
                swift_type = split[1]
                python_type = split[2]
                python_base_type = split[3]
                is_error = line_type == 'ErrorType'

                # For now we will put 'python_base_type' as 'base_type_info',
                # we will fill the correct type later.
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

                property_name = split[1]
                property_type = split[2]

                property = SwiftProperty(property_name, property_type)
                current_type.swift_properties.append(property)

            elif line_type == 'SwiftInit':
                assert current_type
                assert len(split) == 2

                selector_with_types = split[1]

                init = SwiftInitializerInfo(selector_with_types)
                current_type.swift_initializers.append(init)

            elif line_type == 'PyProperty':
                assert current_type
                assert len(split) == 4

                python_name = split[1]
                has_setter = bool(split[2])
                swift_static_doc_property = split[3]

                prop = PyPropertyInfo(python_name, has_setter, swift_static_doc_property)
                current_type.python_properties.append(prop)

            elif line_type == 'PyMethod' or line_type == 'PyClassMethod' or line_type == 'PyStaticMethod':
                assert current_type
                assert len(split) == 5
                python_name = split[1]
                swift_selector_with_types = split[2]
                swift_return_type = split[3]
                swift_static_doc_property = split[4]

                fn = PyFunctionInfo(python_name,
                                    swift_selector_with_types,
                                    swift_return_type,
                                    swift_static_doc_property)

                if line_type == 'PyMethod':
                    current_type.python_methods.append(fn)
                elif line_type == 'PyStaticMethod':
                    current_type.python_static_functions.append(fn)
                elif line_type == 'PyClassMethod':
                    current_type.python_class_functions.append(fn)

            else:
                assert False, f"Unknown line type: '{line_type}'"

    # Commit last type
    commit_current_type()

    # Fill 'base_type_info'
    for t in result:
        if t.python_type_name == 'object':
            t.base_type_info = None
            continue

        # If we don't have specifiec 'base' then 'object'
        python_base_type_name = t.base_type_info or 'object'
        t.base_type_info = python_name_to_info[python_base_type_name]

    validateSwiftFunctionNames(result)
    return result
