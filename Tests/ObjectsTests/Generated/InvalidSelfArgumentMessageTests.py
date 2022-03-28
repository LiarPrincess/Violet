# Hack to be able to import things from 'Objects/Generated'
import os
import sys
sys.path.append(os.getcwd())

from Helpers import generated_warning
from Helpers.PyTypeDefinition_helpers import get_property_name
from Sourcery import get_types

def main():
    file = __file__
    tests_start_index = file.index('/Tests')
    if tests_start_index != -1:
        file = file[tests_start_index:]

    print(f'''\
{generated_warning(file)}

import XCTest
import Foundation
import FileSystem
import VioletObjects

// swiftlint:disable line_length
// swiftlint:disable function_body_length
// swiftlint:disable file_length

class InvalidSelfArgumentMessageTests: PyTestCase {{\
''')

    all_types = get_types()
    for t in all_types:
        python_type_name = t.python_type_name
        swift_type_name = t.swift_type_name

        if python_type_name == 'object':
            # Every python object is an instance of 'object',
            # so no 'invalid self' is possible.
            continue

        print()
        print(f'  func test_{python_type_name}() {{')
        print(f'    let py = self.createPy()')

        types_container = 'errorTypes' if t.is_error else 'types'
        print(f'    let type = py.{types_container}.{get_property_name(python_type_name)}')

        has_printed_property = False
        for p in t.python_properties:
            p_python_name = p.python_name
            if p_python_name == '__class__':
                continue

            if not has_printed_property:
                print()
                has_printed_property = True

            print(f'    self.assertInvalidSelfArgumentMessage(py, type: type, getter: "{p_python_name}")')
            if p.has_setter:
                print(f'    self.assertInvalidSelfArgumentMessage(py, type: type, setter: "{p_python_name}")')

        print()
        for fn in t.python_methods:
            fn_python_name = fn.python_name

            positional_arg_count = 0
            has_args = False
            has_kwargs = False
            for arg in fn.swift_arguments:
                arg_swift_type = arg.typ
                if arg_swift_type == 'Py':
                    pass
                elif arg_swift_type in ('PyObject', 'PyObject?'):
                    positional_arg_count += 1
                elif arg_swift_type in ('[PyObject]', 'PyTuple', 'PyTuple?'):
                    has_args = True
                elif arg_swift_type == 'PyDict?':
                    has_kwargs = True
                else:
                    assert False, f"Unknown argument type: '{swift_type_name}.{fn_python_name}: {arg_swift_type}'"

            if has_args or has_kwargs:
                print(f'    self.assertInvalidSelfArgumentMessage(py, type: type, argsKwargsFn: "{fn_python_name}")')
            else:
                print(f'    self.assertInvalidSelfArgumentMessage(py, type: type, fn: "{fn_python_name}", positionalArgCount: {positional_arg_count})')

        print(f'  }}')

    print('}')

if __name__ == '__main__':
    main()
