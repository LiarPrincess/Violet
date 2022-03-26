from typing import List, Tuple

# Tuple of: arguments + documentation
# All of them return 'PyResult'.
# As for the names go to: https://en.wikipedia.org/wiki/Arity
SIGNATURE_STRINGS: List[Tuple[str, str]] = [

    # Positional nullary
    ('', 'Positional nullary: no arguments (or an empty tuple of arguments, also known as `Void` argument).'),

    # Positional unary
    ('Object', 'Positional unary: single `object` (most probably `self`).'),
    ('Object?', 'Positional unary: single optional `object`.'),
    ('Type', 'Positional unary: `classmethod` with no arguments.'),

    # Positional binary
    ('Object, Object', 'Positional binary: `self` and `object`.'),
    ('Object, Object?', 'Positional binary: `self` and optional `object`.'),
    ('Object?, Object?', 'Positional binary: 2 `objects` (both optional).'),

    ('Type, Object', 'Positional binary: `classmethod` with a single argument.'),
    ('Type, Object?', 'Positional binary: `classmethod` with a single optional argument.'),

    # Positional ternary
    ('Object, Object, Object', 'Positional ternary: `self` and 2 `objects`.'),
    ('Object, Object, Object?', 'Positional ternary: `self` and 2 `objects` (last one is optional).'),
    ('Object, Object?, Object?', 'Positional ternary: `self` and 2 `objects` (both optional).'),
    ('Object?, Object?, Object?', 'Positional ternary: 3 `objects` (all optional).'),

    ('Type, Object, Object', 'Positional ternary: `classmethod` with 2 arguments.'),
    ('Type, Object, Object?', 'Positional ternary: `classmethod` with 2 arguments (last one is optional).'),
    ('Type, Object?, Object?', 'Positional ternary: `classmethod` with 2 arguments (both optional).'),

    # Positional quartary
    ('Object, Object, Object, Object', 'Positional quartary: `self` and 3 `objects`.'),
    ('Object, Object, Object, Object?', 'Positional quartary: `self` and 3 `objects` (last one is optional).'),
    ('Object, Object, Object?, Object?', 'Positional quartary: `self` and 3 `objects` (2nd and 3rd are optional).'),
    ('Object, Object?, Object?, Object?', 'Positional quartary: `self` and 3 `objects` (all optional).'),
    ('Object?, Object?, Object?, Object?', 'Positional quartary: `4 `objects` (all optional).'),

    ('Type, Object, Object, Object', 'Positional quartary: `classmethod` with 3 arguments.'),
    ('Type, Object, Object, Object?', 'Positional quartary: `classmethod` with 3 arguments (last one is optional).'),
    ('Type, Object, Object?, Object?', 'Positional quartary: `classmethod` with 3 arguments (2nd and 3rd are optional).'),
    ('Type, Object?, Object?, Object?', 'Positional quartary: `classmethod` with 3 arguments (all optional).'),

    # Positional quintary
    # We are not doing this!
    # This is too much work and none of the functions are using it.
]

# ================
# === Argument ===
# ================

class Argument:

    def __init__(self,
                 swift_type: str,
                 type_name_part: str,
                 *,
                 is_type: bool = False,
                 is_optional: bool = False):
        self.swift_type = swift_type
        # Part used in 'struct/enum/fn_typealias' name
        self.type_name_part = type_name_part
        # Is this the 'type' argument?
        self.is_type = is_type
        # Is this argument optional?
        self.is_optional = is_optional

    def __repr__(self) -> str:
        return self.swift_type

ARGUMENT_OBJECT = Argument('PyObject', 'Object')
ARGUMENT_OBJECT_OPTIONAL = Argument('PyObject?', 'ObjectOpt', is_optional=True)
ARGUMENT_TYPE = Argument('PyType', 'Type', is_type=True)

def get_argument(name: str) -> Argument:
    name_lower = name.strip().lower()

    if name_lower == 'object':
        return ARGUMENT_OBJECT
    if name_lower == 'object?':
        return  ARGUMENT_OBJECT_OPTIONAL
    if name_lower == 'type':
        return ARGUMENT_TYPE

    raise ValueError(f"Unknown argument type: '{name}'")

# ==================
# === ReturnType ===
# ==================

class ReturnType:

    def __init__(self, swift_type: str, type_name_part: str):
        self.swift_type = swift_type
        # Part used in 'struct/enum/fn_typealias' name
        self.type_name_part = type_name_part

    def __repr__(self) -> str:
        return self.swift_type

RETURN_RESULT = ReturnType('PyResult', 'Result')

def get_return_type(name: str) -> Argument:
    name_lower = name.strip().lower()

    if name_lower == 'result':
        return RETURN_RESULT

    raise ValueError(f"Unknown return type: '{name}'")

# =================================
# === PositionalFunctionWrapper ===
# =================================

class PositionalFunctionWrapper:
    def __init__(self,
                 doc: str,
                 arguments: List[Argument],
                 return_type: ReturnType):
        self.doc = doc
        self.arguments = arguments
        self.return_type = return_type

        # =============
        # === Names ===
        # =============

        name = ''
        for index, arg in enumerate(arguments):
            if index > 0:
                name += '_'

            name += arg.type_name_part

        if not name:
            name = 'Void'

        name = name + '_to_' + return_type.type_name_part
        self.name_struct = name
        self.name_enum_case = name[0].lower() + name[1:]
        self.name_fn_typealias = name + '_Fn'

        # ==================
        # === Signatures ===
        # ==================

        self.signature = '(Py'
        for index, arg in enumerate(arguments):
            self.signature += ', '
            self.signature += arg.swift_type

        self.signature += f') -> {return_type.swift_type}'

        # =============
        # === Other ===
        # =============

        self.min_arg_count = 0
        self.max_arg_count = len(arguments)
        self.has_type_as_1_argument = False

        for index, arg in enumerate(arguments):
            if not arg.is_optional:
                self.min_arg_count += 1

            if arg.is_type:
                if index != 0:
                    raise ValueError(f"Type can only be used as 1st argument")

                self.has_type_as_1_argument = True

# ====================
# === Get wrappers ===
# ====================

def get_positional_function_wrappers() -> List[PositionalFunctionWrapper]:
    result: List[PositionalFunctionWrapper] = []

    for arguments_str, doc in SIGNATURE_STRINGS:
        arguments: List[Argument] = []
        for arg_str in arguments_str.split(','):
            arg_str = arg_str.strip()
            if arg_str:
                arg = get_argument(arg_str)
                arguments.append(arg)

        return_type = get_return_type('Result')
        fn = PositionalFunctionWrapper(doc, arguments, return_type)
        result.append(fn)

    return result
