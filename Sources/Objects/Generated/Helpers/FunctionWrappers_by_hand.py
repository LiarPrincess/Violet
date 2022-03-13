from typing import List

class FunctionWrapperByHand:
    def __init__(self,
                 name_struct: str,
                 name_enum_case: str,
                 swift_description: str,
                 doc: str):
        self.name_struct = name_struct
        self.name_enum_case = name_enum_case
        self.swift_description = swift_description
        self.doc = doc


def get_hand_written_function_wrappers() -> List[FunctionWrapperByHand]:
    return [
        FunctionWrapperByHand(
            'NewWrapper',
            '__new__',
            '(Type, *args, **kwargs) -> PyResult<PyObject>',
            'Python `__new__` function.'
        ),
        FunctionWrapperByHand(
            'InitWrapper',
            '__init__',
            '(Object, *args, **kwargs) -> PyResult<PyObject>',
            'Python `__init__` function.'
        ),

        FunctionWrapperByHand(
            'CompareWrapper',
            'compare',
            '(Py, PyObject, PyObject) -> CompareResult',
            'Python `__eq__`, `__ne__`, `__lt__`, `__le__`, `__gt__`, `__ge__` functions.'
        ),
        FunctionWrapperByHand(
            'HashWrapper',
            'hash',
            '(Py, PyObject) -> HashResult',
            'Python `__hash__` function.'
        ),
        FunctionWrapperByHand(
            'DirWrapper',
            'dir',
            '(Py, PyObject) -> PyResult<DirResult>',
            'Python `__dir__` function.'
        ),

        FunctionWrapperByHand(
            'ArgsKwargsFunction',
            'argsKwargsFunction',
            '(*args, **kwargs) -> PyResult<PyObject>',
            'Function with `*args` and `**kwargs`.'
        ),
        FunctionWrapperByHand(
            'ArgsKwargsMethod',
            'argsKwargsMethod',
            '(Object, *args, **kwargs) -> PyResult<PyObject>',
            'Method with `*args` and `**kwargs`.'
        )
    ]
