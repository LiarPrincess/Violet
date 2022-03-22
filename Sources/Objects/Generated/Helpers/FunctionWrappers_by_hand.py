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
        FunctionWrapperByHand('NewWrapper',  'new',  '(Type, *args, **kwargs) -> PyResult',   'Python `__new__` function.'),
        FunctionWrapperByHand('InitWrapper', 'init', '(Object, *args, **kwargs) -> PyResult', 'Python `__init__` function.'),

        FunctionWrapperByHand('CompareWrapper', 'compare', '(Py, PyObject, PyObject) -> CompareResult', 'Python `__eq__`, `__ne__`, `__lt__`, `__le__`, `__gt__`, `__ge__` functions.'),
        FunctionWrapperByHand('HashWrapper',    'hash',    '(Py, PyObject) -> HashResult',              'Python `__hash__` function.'),
        FunctionWrapperByHand('DirWrapper',     'dir',     '(Py, PyObject) -> PyResult<DirResult>',     'Python `__dir__` function.'),
        FunctionWrapperByHand('ClassWrapper',   'class',   '(Py, PyObject) -> PyType',                  'Python `__class__` function.'),

        FunctionWrapperByHand('ArgsKwargsFunctionWrapper',    'argsKwargsFunction',    '(*args, **kwargs) -> PyResult',         'Function with `*args` and `**kwargs`.'),
        FunctionWrapperByHand('ArgsKwargsMethodWrapper',      'argsKwargsMethod',      '(Object, *args, **kwargs) -> PyResult', 'Method with `*args` and `**kwargs`.'),
        FunctionWrapperByHand('ArgsKwargsClassMethodWrapper', 'argsKwargsClassMethod', '(Type, *args, **kwargs) -> PyResult',   'Class method with `*args` and `**kwargs`.')
    ]
