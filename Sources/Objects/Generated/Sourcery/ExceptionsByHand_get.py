import os.path
from typing import List, Optional, Union

from Sourcery.ExceptionsByHand import ExceptionByHand, SwiftInitializerInfo

def get_error_types_implemented_by_hand() -> List[ExceptionByHand]:
    dir_path = os.path.dirname(__file__)
    input_file = os.path.join(dir_path, 'exceptions-by-hand.txt')

    result: List[ExceptionByHand] = []
    current_type: Optional[ExceptionByHand] = None

    def commit_current_type():
        nonlocal current_type, result
        if current_type:
            assert len(current_type.swift_initializers), 'No initializer?'
            result.append(current_type)

    with open(input_file, 'r') as reader:
        for line in reader:
            line = line.strip()

            if not line or line.startswith('#'):
                continue

            split = line.split('|')
            assert len(split) >= 1

            line_type = split[0]
            if line_type == 'ErrorType':
                commit_current_type()  # We are starting new type

                assert len(split) == 4
                swift_type = split[1]
                python_type = split[2]
                # python_base_type = split[3]

                current_type = ExceptionByHand(swift_type, python_type)

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
