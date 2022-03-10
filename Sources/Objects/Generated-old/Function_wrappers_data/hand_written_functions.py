from typing import List


class HandWrittenFunction:
    def __init__(self,
                 struct_name: str,
                 enum_case_name: str,
                 swift_description: str,
                 doc: str):
        self.struct_name = struct_name
        self.enum_case_name = enum_case_name
        self.swift_description = swift_description
        self.doc = doc


def get_hand_written_functions() -> List[HandWrittenFunction]:
    return [
        HandWrittenFunction(
            'NewWrapper',
            '__new__',
            '(PyType, *args, **kwargs) -> PyObject',
            'Python `__new__` function.'
        ),
        HandWrittenFunction(
            'InitWrapper',
            '__init__',
            '(Zelf, *args, **kwargs) -> PyNone',
            'Python `__init__` function.'
        ),
        HandWrittenFunction(
            'ArgsKwargsAsMethod',
            'argsKwargsAsMethod',
            '(*args, **kwargs) -> PyFunctionResultConvertible',
            'Function with `*args` and `**kwargs`.'
        ),
        HandWrittenFunction(
            'ArgsKwargsAsStaticFunction',
            'argsKwargsAsStaticFunction',
            '(*args, **kwargs) -> PyFunctionResultConvertible',
            'Function with `*args` and `**kwargs`.'
        )
    ]
