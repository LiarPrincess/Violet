import os.path
from typing import List, Union

from Sourcery.entities import TypeInfo, SwiftFieldInfo, SwiftFunctionInfo, PyPropertyInfo, PyFunctionInfo
from Sourcery.validate_overridden_pymethods import check_for_overridden_pymethods
from Sourcery.validate_final_keyword import check_final_keyword


def get_types() -> List[TypeInfo]:
    dir_path = os.path.dirname(__file__)
    input_file = os.path.join(dir_path, 'dump.txt')

    result: List[TypeInfo] = []
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
                commit_current_type()  # We are starting new type

                assert len(split) == 4
                python_type = split[1]
                swift_type = split[2]
                swift_base_type = split[3]
                is_error = line_type == 'ErrorType'
                current_type = TypeInfo(python_type,
                                        swift_type,
                                        swift_base_type, is_error)

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

            elif line_type == 'SwiftField':
                assert current_type
                assert len(split) == 3

                field_name = split[1]
                field_type = split[2]

                field = SwiftFieldInfo(field_name, field_type)
                current_type.swift_fields.append(field)

            elif line_type == 'SwiftMethod':
                assert current_type
                assert len(split) == 4

                access_modifier = split[1]
                selector_with_types = split[2]
                return_type = split[3]

                method = SwiftFunctionInfo(access_modifier, selector_with_types, return_type)
                current_type.swift_methods.append(method)

                if method.name == 'init':
                    current_type.swift_initializers.append(method)

            elif line_type == 'PyProperty':
                assert current_type
                assert len(split) == 6
                python_name = split[1]
                swift_getter_fn = split[2]
                swift_setter_fn = split[3]
                swift_type = split[4]
                swift_static_doc_property = split[5]

                prop = PyPropertyInfo(python_name,
                                      swift_getter_fn,
                                      swift_setter_fn,
                                      swift_type,
                                      swift_static_doc_property)
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

    commit_current_type()  # Commit last type
    run_validation(result)
    return result
