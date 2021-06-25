from typing import List

swift_keywords = [
    'as', 'associatedtype', 'associativity', 'break', 'case', 'catch', 'class',
    'continue', 'convenience', 'default', 'defer', 'deinit', 'didSet', 'do',
    'dynamic', 'else', 'enum', 'extension', 'fallthrough', 'false', 'fileprivate',
    'final', 'for', 'func', 'get', 'guard', 'if', 'import', 'in', 'indirect',
    'infix', 'init', 'inout', 'internal', 'is', 'lazy', 'left', 'let', 'mutating',
    'nil', 'none', 'nonmutating', 'open', 'operator', 'optional', 'override',
    'postfix', 'precedence', 'prefix', 'private', 'protocol', 'Protocol', 'public',
    'repeat', 'required', 'rethrows', 'return', 'right', 'self', 'Self', 'set',
    'static', 'struct', 'subscript', 'super', 'switch', 'throw', 'throws', 'true',
    'try', 'Type', 'typealias', 'unowned', 'var', 'weak', 'where', 'while', 'willSet'
]


class HandWrittenFunction:
    def __init__(self,
                 struct_name_part: str,
                 doc: str):
        # Name of the generated struct
        self.struct_name = struct_name_part
        # Name of the function typealias
        self.fn_typealias_name = self.struct_name + '_Fn'
        # Name of the case inside 'Kind' enum
        self.enum_case_name = self.struct_name[0].lower() + self.struct_name[1:]
        if self.enum_case_name in swift_keywords:
            self.enum_case_name = '`' + self.enum_case_name + '`'

        self.doc = doc


def get_hand_written_functions() -> List[HandWrittenFunction]:
    return [
        HandWrittenFunction('New', 'Python `__new__` function.'),
        HandWrittenFunction('Init', 'Python `__init__` function.'),
        HandWrittenFunction('ArgsKwargsAsMethod', 'Function with `*args` and `**kwargs`.'),
        HandWrittenFunction('ArgsKwargsAsStaticFunction', 'Function with `*args` and `**kwargs.')
    ]
