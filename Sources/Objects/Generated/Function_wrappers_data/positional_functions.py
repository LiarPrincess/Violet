from typing import List, Tuple, Union

# ===============================
# === Argument configurations ===
# ===============================

# Tuple of: arguments + documentation
# Note that those are only arguments WITHOUT RETURN TYPE (it will be added later)
# As for the names go to: https://en.wikipedia.org/wiki/Arity
supported_argument_configurations: List[Tuple[str, str]] = [
    # Positional nullary
    ('Void', 'Positional nullary: no arguments (or an empty tuple of arguments, also known as `Void` argument).'),

    # Positional unary
    ('Self', 'Positional unary: single `self` argument.'),
    ('Object', 'Positional unary: single `object` argument.'),
    ('Object?', 'Positional unary: single optional `object` argument.'),

    # Positional binary
    ('Self, Object', 'Positional binary: tuple of `self` and `object`.'),
    ('Self, Object?', 'Positional binary: tuple of `self` and optional `object`.'),
    ('Self -> Object', 'Positional binary: `self` and then `object`.'),
    ('Self -> Object?', 'Positional binary: `self` and then optional `object`.'),

    ('Self -> Void', 'Positional binary: property getter disguised as a method.'),

    ('Object, Object', 'Positional binary: tuple of 2 `objects`.'),
    ('Object, Object?', 'Positional binary: tuple of 2 `objects` (2nd one is optional).'),
    ('Object -> Object', 'Positional binary: `object` and then another `object`.'),
    ('Object -> Object?', 'Positional binary: `object` and then optional `object`.'),

    # Positional ternary
    ('Self -> Object, Object', 'Positional ternary: `self` and then tuple of 2 `objects`.'),
    ('Self -> Object, Object?', 'Positional ternary: `self` and then tuple of 2 `objects` (last one is optional).'),
    ('Self -> Object?, Object?', 'Positional ternary: `self` and then tuple of 2 `objects` (both optional).'),

    ('Object, Object, Object', 'Positional ternary: tuple of 3 `objects`.'),
    ('Object, Object, Object?', 'Positional ternary: tuple of 3 `objects` (3rd one is optional).'),
    ('Object, Object?, Object?', 'Positional ternary: tuple of 3 `objects` (2nd and 3rd are optional).'),

    # Positional quartary
    ('Self -> Object, Object, Object', 'Positional quartary: `self` and then tuple of 3 `objects`.'),
    ('Self -> Object, Object, Object?', 'Positional quartary: `self` and then tuple of 3 `objects` (last one is optional).'),
    ('Self -> Object, Object?, Object?', 'Positional quartary: `self` and then tuple of 3 `objects` (2nd and 3rd are optional).'),
    ('Self -> Object?, Object?, Object?', 'Positional quartary: `self` and then tuple of 3 `objects` (all optional).'),

    # Positional quintary
    # We are not doing this!
    # This is too much work and none of the functions are using it.
]


# =================
# === Arguments ===
# =================

class Argument:

    def __init__(self,
                 swift_type: str,
                 swift_type_in_struct_fn: Union[str, None],
                 type_name_part: str,
                 *,
                 is_self: bool = False,
                 is_optional: bool = False,
                 is_generic: bool = False,
                 generic_requirements: Union[str, None] = None):
        # Type name, if this is generic then generic alias ('T', 'U', 'R' etc.)
        self.swift_type = swift_type
        # Type stored in struct property (where no generics are allowed)
        # 'None' if not stored
        self.swift_type_stored_in_struct = swift_type_in_struct_fn
        # Part used in 'struct/enum/fn_typealias' name
        self.type_name_part = type_name_part
        # Is this 'self' argument?
        self.is_self = is_self
        # Is this argument optional?
        self.is_optional = is_optional
        # Is this generic argument?
        self.is_generic = is_generic
        # Generic requirements, for example: 'CustomStringConvertible'
        self.generic_requirements = generic_requirements

    def __repr__(self) -> str:
        return self.swift_type


void_argument = Argument('Void', None, 'Void')
self_argument = Argument('Zelf', 'PyObject', 'Self', is_self=True, is_generic=True)
object_argument = Argument('PyObject', 'PyObject', 'Object')
object_optional_argument = Argument('PyObject?', 'PyObject?', 'ObjectOpt', is_optional=True)


# ===================
# === Return type ===
# ===================

class ReturnType:

    def __init__(self,
                 swift_type: str,
                 type_name_part: str,
                 *,
                 is_generic: bool = False,
                 generic_requirements: Union[str, None] = None):
        # Type name, if this is generic then generic alias ('T', 'U', 'R' etc.)
        self.swift_type = swift_type
        # Part used in 'struct/enum/fn_typealias' name
        self.type_name_part = type_name_part
        # Is this generic return type?
        self.is_generic = is_generic
        # Generic requirements, for example: 'CustomStringConvertible'
        self.generic_requirements = generic_requirements

    def __repr__(self) -> str:
        return self.swift_type


void_return = ReturnType('Void', 'Void')
result_return = ReturnType('R', 'Result', is_generic=True, generic_requirements='PyFunctionResultConvertible')


# ==============================
# === Signature - type names ===
# ==============================

class Names:
    def __init__(self, struct_name: str, enum_case_name: str, fn_typealias_name: str):
        self.struct_name = struct_name
        self.enum_case_name = enum_case_name
        self.fn_typealias_name = fn_typealias_name


def _create_struct_enum_case_and_function_typealias_names(
    arguments: List[List[Argument]],
    return_type: ReturnType
) -> Names:
    struct_name = ''
    for arg_group_index, arg_group in enumerate(arguments):
        if arg_group_index > 0:
            struct_name += '_then_'

        for arg_index, arg in enumerate(arg_group):
            if arg_index > 0:
                struct_name += '_'

            struct_name += arg.type_name_part

    struct_name += '_to_' + return_type.type_name_part
    enum_case_name = struct_name[0].lower() + struct_name[1:]
    fn_typealias_name = struct_name + '_Fn'

    return Names(struct_name, enum_case_name, fn_typealias_name)


def assert_equal(lhs, rhs):
    is_equal = lhs == rhs
    if not is_equal:
        print(lhs)
        print(rhs)
        assert False


# Run this script as '__main__' to run all of the tests
def _test_create_names():
    # Nullary: () -> R
    arguments = [[void_argument]]
    return_type = result_return
    result = _create_struct_enum_case_and_function_typealias_names(arguments, return_type)
    assert_equal(result.struct_name, 'Void_to_Result')
    assert_equal(result.enum_case_name, 'void_to_Result')
    assert_equal(result.fn_typealias_name, 'Void_to_Result_Fn')

    # Unary: Object -> Void
    arguments = [[object_argument]]
    return_type = void_return
    result = _create_struct_enum_case_and_function_typealias_names(arguments, return_type)
    assert_equal(result.struct_name, 'Object_to_Void')
    assert_equal(result.enum_case_name, 'object_to_Void')
    assert_equal(result.fn_typealias_name, 'Object_to_Void_Fn')

    # Binary: Object, Object -> Void
    arguments = [[object_argument, object_argument]]
    return_type = void_return
    result = _create_struct_enum_case_and_function_typealias_names(arguments, return_type)
    assert_equal(result.struct_name, 'Object_Object_to_Void')
    assert_equal(result.enum_case_name, 'object_Object_to_Void')
    assert_equal(result.fn_typealias_name, 'Object_Object_to_Void_Fn')

    # Binary property setter: Self -> () -> R
    arguments = [[self_argument], [void_argument]]
    return_type = result_return
    result = _create_struct_enum_case_and_function_typealias_names(arguments, return_type)
    assert_equal(result.struct_name, 'Self_then_Void_to_Result')
    assert_equal(result.enum_case_name, 'self_then_Void_to_Result')
    assert_equal(result.fn_typealias_name, 'Self_then_Void_to_Result_Fn')


# ==============================
# === Signature - signatures ===
# ==============================

class Signatures:
    def __init__(self,
                 human_readable: str,
                 generic: str,
                 stored_in_struct: str,
                 stored_in_struct_min_arg_count: int,
                 stored_in_struct_max_arg_count: int):
        assert stored_in_struct_min_arg_count <= stored_in_struct_max_arg_count, \
            f'min_argument_count ({stored_in_struct_min_arg_count}) > argument_count ({stored_in_struct_max_arg_count})'

        self.human_readable = human_readable
        self.generic = generic
        self.stored_in_struct = stored_in_struct
        self.stored_in_struct_min_arg_count = stored_in_struct_min_arg_count
        self.stored_in_struct_max_arg_count = stored_in_struct_max_arg_count


def _create_signatures(arguments: List[List[Argument]], return_type: ReturnType) -> Signatures:
    def get_human_readable_part(o: Union[Argument, ReturnType]):
        # In all arguments and return types we have at max 1 generic requirement,
        # so we can just use it instead of type.
        return o.generic_requirements or o.swift_type

    human_readable = ''
    generic = ''
    stored_in_struct = ''
    stored_in_struct_min_arg_count = 0
    stored_in_struct_max_arg_count = 0

    for arg_group_index, arg_group in enumerate(arguments):
        if arg_group_index > 0:
            generic += ' -> '
            human_readable += ' -> '

        generic += '('
        human_readable += '('

        for arg_index, arg in enumerate(arg_group):
            if arg_index > 0:
                generic += ', '
                human_readable += ', '

            generic += arg.swift_type
            human_readable += get_human_readable_part(arg)

            if arg.swift_type_stored_in_struct:
                if stored_in_struct:
                    stored_in_struct += ', '

                stored_in_struct += arg.swift_type_stored_in_struct
                stored_in_struct_max_arg_count += 1

                is_required = not arg.is_optional
                if is_required:
                    stored_in_struct_min_arg_count += 1

        generic += ')'
        human_readable += ')'

    def fix_signature(s: str) -> str:
        # Swift does not like '(Void)'
        return s.replace('(Void)', '()')

    human_readable += ' -> '
    human_readable += get_human_readable_part(return_type)
    human_readable = fix_signature(human_readable)

    generic += ' -> ' + return_type.swift_type
    generic = fix_signature(generic)

    stored_in_struct = '(' + stored_in_struct + ') -> PyFunctionResult'
    # We do not have to 'fix_signature' because stored signature skips 'Void'

    return Signatures(
        human_readable,
        generic,
        stored_in_struct,
        stored_in_struct_min_arg_count,
        stored_in_struct_max_arg_count
    )


# Run this script as '__main__' to run all of the tests
def _test_create_signatures():
    # Nullary: () -> Result
    arguments = [[void_argument]]
    return_type = result_return
    signatures = _create_signatures(arguments, return_type)
    assert_equal(signatures.human_readable, '() -> PyFunctionResultConvertible')
    assert_equal(signatures.generic, '() -> R')
    assert_equal(signatures.stored_in_struct, '() -> PyFunctionResult')
    assert_equal(signatures.stored_in_struct_min_arg_count, 0)
    assert_equal(signatures.stored_in_struct_max_arg_count, 0)

    # Self -> Object -> Void
    arguments = [[self_argument], [object_argument]]
    return_type = void_return
    signatures = _create_signatures(arguments, return_type)
    assert_equal(signatures.human_readable, '(Zelf) -> (PyObject) -> Void')
    assert_equal(signatures.generic, '(Zelf) -> (PyObject) -> Void')
    assert_equal(signatures.stored_in_struct, '(PyObject, PyObject) -> PyFunctionResult')
    assert_equal(signatures.stored_in_struct_min_arg_count, 2)
    assert_equal(signatures.stored_in_struct_max_arg_count, 2)

    # Object, Object, Object? -> Void
    arguments = [[object_argument, object_argument, object_optional_argument]]
    return_type = void_return
    signatures = _create_signatures(arguments, return_type)
    assert_equal(signatures.human_readable, '(PyObject, PyObject, PyObject?) -> Void')
    assert_equal(signatures.generic, '(PyObject, PyObject, PyObject?) -> Void')
    assert_equal(signatures.stored_in_struct, '(PyObject, PyObject, PyObject?) -> PyFunctionResult')
    assert_equal(signatures.stored_in_struct_min_arg_count, 2)
    assert_equal(signatures.stored_in_struct_max_arg_count, 3)

    # Property setter: Self -> () -> Result
    arguments = [[self_argument], [void_argument]]
    return_type = result_return
    signatures = _create_signatures(arguments, return_type)
    assert_equal(signatures.human_readable, '(Zelf) -> () -> PyFunctionResultConvertible')
    assert_equal(signatures.generic, '(Zelf) -> () -> R')
    assert_equal(signatures.stored_in_struct, '(PyObject) -> PyFunctionResult')
    assert_equal(signatures.stored_in_struct_min_arg_count, 1)
    assert_equal(signatures.stored_in_struct_max_arg_count, 1)

# ===========================
# === Signature - generic ===
# ===========================


class GenericArguments:
    def __init__(self, arguments: str, with_requirements: str):
        self.arguments = arguments
        self.with_requirements = with_requirements


def _create_generic_arguments(arguments: List[List[Argument]], return_type: ReturnType) -> GenericArguments:
    'The thingies that go into \'<HERE>\' in Swift function declarations'

    simple = ''
    with_requirements = ''

    def append(object: Union[Argument, ReturnType]):
        if not object.is_generic:
            return

        nonlocal simple
        nonlocal with_requirements

        has_previous_generic_arguments = bool(simple)
        if has_previous_generic_arguments:
            simple += ', '
            with_requirements += ', '

        swift_type: str = object.swift_type
        requirements: Union[str, None] = object.generic_requirements

        simple += swift_type
        with_requirements += swift_type

        if requirements:
            with_requirements += ': ' + requirements

    for arg_group in arguments:
        for arg in arg_group:
            append(arg)

    append(return_type)

    def append_angled_braces(s: str) -> str:
        return '<' + s + '>' if s else ''

    simple = append_angled_braces(simple)
    with_requirements = append_angled_braces(with_requirements)
    return GenericArguments(simple, with_requirements)


# Run this script as '__main__' to run all of the tests
def _test_create_generic_arguments():
    # Object -> Void
    arguments = [[object_argument]]
    return_type = void_return
    generic = _create_generic_arguments(arguments, return_type)
    assert_equal(generic.arguments, '')
    assert_equal(generic.with_requirements, '')

    # Self -> Void
    arguments = [[self_argument]]
    return_type = void_return
    generic = _create_generic_arguments(arguments, return_type)
    assert_equal(generic.arguments, '<Zelf>')
    assert_equal(generic.with_requirements, '<Zelf>')

    # Object, Object -> Result
    arguments = [[object_argument, object_argument]]
    return_type = result_return
    generic = _create_generic_arguments(arguments, return_type)
    assert_equal(generic.arguments, '<R>')
    assert_equal(generic.with_requirements, '<R: PyFunctionResultConvertible>')

    # Self -> Object, Object? -> Result
    arguments = [[self_argument], [object_argument, object_optional_argument]]
    return_type = result_return
    generic = _create_generic_arguments(arguments, return_type)
    assert_equal(generic.arguments, '<Zelf, R>')
    assert_equal(generic.with_requirements, '<Zelf, R: PyFunctionResultConvertible>')


# =================
# === Signature ===
# =================

class Signature:
    '''
    We will treat all argument groups as lists.
    'Self -> Object, Object' becomes [[self_argument], [object_argument, object_argument]].

    Sometimes the group will have only 1 element, but that's ok.
    '''

    def __init__(self,
                 doc: str,
                 arguments: List[List[Argument]],
                 return_type: ReturnType):
        self.doc = doc
        # Parsed arguments, where each argument group is a List[]
        self.arguments = arguments
        # Return type (duh…)
        self.return_type = return_type

        names = _create_struct_enum_case_and_function_typealias_names(arguments, return_type)
        # Name of the generated struct
        self.struct_name = names.struct_name
        # Name of the case inside 'Kind' enum
        self.enum_case_name = names.enum_case_name
        # Name of the function typealias
        self.fn_typealias_name = names.fn_typealias_name

        signatures = _create_signatures(arguments, return_type)
        # (Self) -> PyFunctionResultConvertible, used in documentation
        self.human_readable_signature = signatures.human_readable
        # (Zelf) -> R, signature with generic function arguments
        self.generic_signature = signatures.generic
        # (PyObject) -> PyFunctionResult, signature stored as 'struct' property
        self.stored_in_struct_signature = signatures.stored_in_struct
        self.stored_in_struct_min_arg_count = signatures.stored_in_struct_min_arg_count
        self.stored_in_struct_max_arg_count = signatures.stored_in_struct_max_arg_count

        generic = _create_generic_arguments(arguments, return_type)
        # <Zelf, R>, generic function argument declaration
        self.generic_arguments = generic.arguments
        # <Zelf, R: PyFunctionResultConvertible>, generic function argument declaration
        self.generic_arguments_with_requirements = generic.with_requirements

        # Do we have generic 'Self'?
        self.has_self_argument = False
        for arg_group in arguments:
            for arg in arg_group:
                if arg.is_self:
                    self.has_self_argument = True


# ======================
# === Get signatures ===
# ======================

def get_positional_signatures() -> List[Signature]:
    result: List[Signature] = []

    for args_string, doc in supported_argument_configurations:
        arguments: List[List[Argument]] = []
        arrow_split = args_string.split('->')

        for argument_group_string in arrow_split:
            current_argument_group: List[Argument] = []
            types_split = argument_group_string.split(', ')

            for type in types_split:
                type_lower = type.strip().lower()

                if type_lower == 'void':
                    current_argument_group.append(void_argument)
                elif type_lower == 'self':
                    current_argument_group.append(self_argument)
                elif type_lower == 'object':
                    current_argument_group.append(object_argument)
                elif type_lower == 'object?':
                    current_argument_group.append(object_optional_argument)
                else:
                    raise ValueError(f"Unknown argument type: '{type}'")

            arguments.append(current_argument_group)

        for return_type in (result_return, void_return):
            signature = Signature(doc, arguments, return_type)
            result.append(signature)

    return result


# ============
# === Test ===
# ============

if __name__ == '__main__':
    _test_create_names()
    _test_create_signatures()
    _test_create_generic_arguments()
    print('Finished tests')
