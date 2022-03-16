from typing import List, Optional


class ArgumentInfo:
    def __init__(self, label: Optional[str], name: str, typ: str, default_value: Optional[str]):
        self.label = label
        self.name = name
        self.typ = typ
        self.default_value = default_value


def parse_arguments(s: str) -> List[ArgumentInfo]:
    index = 0
    result: List[ArgumentInfo] = []

    def consume_whitespaces():
        nonlocal s
        nonlocal index
        while index < len(s) and s[index].isspace():
            index += 1

    def consume_name_or_label() -> str:
        nonlocal s
        nonlocal index

        start_index = index
        while index < len(s):
            ch = s[index]
            is_valid_character = ch.isalnum() or ch == '_'

            if is_valid_character:
                index += 1
            else:
                return s[start_index:index]

    def consume_type() -> str:
        nonlocal s
        nonlocal index

        # We do allow ',' inside parenthesis:
        # @escaping (PyType, [PyObject], PyDict?) -> PyResult<Zelf>
        # FunctionWrapper.Self_to_Result_Fn<Zelf, R>
        paren_count = 0

        start_index = index
        while index < len(s):
            ch = s[index]
            is_end = paren_count == 0 and ch in (',', '=')

            if is_end:
                break

            if ch in ('(', '<'):
                paren_count += 1
            if ch in (')', '>'):
                paren_count -= 1

            # Consume '->' as one (so, that it does not mess with 'paren_count')
            if ch == '-' and (index + 1 < len(s)) and s[index + 1] == '>':
                index += 1

            index += 1

        result = s[start_index:index]
        return result.rstrip()

    def consume_default_value() -> Optional[str]:
        nonlocal s
        nonlocal index

        start_index = index
        while index < len(s):
            ch = s[index]
            is_end = ch.isspace() or ch == ','

            if is_end:
                break

            index += 1

        result = s[start_index:index]
        result = result.rstrip()
        return result if len(result) else None

    while index < len(s):
        # Reset
        label = None
        name = None
        typ = None
        default_value = None
        consume_whitespaces()

        name = consume_name_or_label()
        consume_whitespaces()

        is_type_start = s[index] == ':'
        if not is_type_start:
            label = name
            name = consume_name_or_label()
            consume_whitespaces()

        is_type_start = s[index] == ':'
        assert is_type_start
        index += 1  # Consume ':'
        consume_whitespaces()

        typ = consume_type()
        consume_whitespaces()

        has_default_value = index < len(s) and s[index] == '='
        if has_default_value:
            index += 1  # Consume '='
            consume_whitespaces()
            default_value = consume_default_value()

        consume_whitespaces()
        is_argument_end = index == len(s) or s[index] == ','
        assert is_argument_end
        index += 1  # Consume ',' or go after 'len(s)'

        argument = ArgumentInfo(label, name, typ, default_value)
        result.append(argument)

    return result


class SignatureInfo:
    '''
    Parse Swift function signature.
    '''

    def __init__(self,
                 selector_with_types: str,
                 return_type: str):
        self.return_type = return_type

        selector_with_types = remove_indentation(selector_with_types)
        self.selector_with_types = selector_with_types

        if not '(' in selector_with_types:
            assert selector_with_types == 'deinit'
            self.name = 'deinit'
            self.arguments = []
            return

        open_paren_index = selector_with_types.index('(')
        self.name = selector_with_types[:open_paren_index]

        close_paren_index = selector_with_types.rindex(')')

        arguments_start_index = open_paren_index + 1
        arguments = selector_with_types[arguments_start_index:close_paren_index]
        self.arguments = parse_arguments(arguments)


def remove_indentation(sig: str) -> str:
    ''' If signature spans multiple lines then Sourcery will ignore new lines, but
    preserve indentation, so we end up with:
    func find(_ value: PyObject,                     start: PyObject?,                     end: PyObject?) -> PyResult<Int>

    This function will remove those '   '.
    '''

    while '  ' in sig:
        sig = sig.replace('  ', ' ')

    return sig


def test():
    sig = SignatureInfo('abs()', 'PyObject')
    assert sig.name == 'abs'
    assert len(sig.arguments) == 0
    assert sig.return_type == 'PyObject'

    sig = SignatureInfo('deinit', 'Void')
    assert sig.name == 'deinit'
    assert len(sig.arguments) == 0
    assert sig.return_type == 'Void'

    sig = SignatureInfo('add(_ other: PyObject)', 'PyResult<PyObject>')
    assert sig.name == 'add'
    assert len(sig.arguments) == 1
    assert sig.arguments[0].label == '_'
    assert sig.arguments[0].name == 'other'
    assert sig.arguments[0].typ == 'PyObject'
    assert sig.arguments[0].default_value == None
    assert sig.return_type == 'PyResult<PyObject>'

    sig = SignatureInfo('call(args: [PyObject], kwargs: PyDict?)', 'PyResult<PyObject>')
    assert sig.name == 'call'
    assert len(sig.arguments) == 2
    assert sig.arguments[0].label == None
    assert sig.arguments[0].name == 'args'
    assert sig.arguments[0].typ == '[PyObject]'
    assert sig.arguments[0].default_value == None
    assert sig.arguments[1].label == None
    assert sig.arguments[1].name == 'kwargs'
    assert sig.arguments[1].typ == 'PyDict?'
    assert sig.arguments[1].default_value == None
    assert sig.return_type == 'PyResult<PyObject>'

    arg0 = 'name: String'
    arg1 = 'fn: @escaping FunctionWrapper.Self_to_Result_Fn<Zelf, R>'
    arg2 = 'castSelf: @escaping FunctionWrapper.CastSelf<Zelf>'
    arg3 = 'module: PyString? = nil'
    sig = SignatureInfo(f'wrap({arg0}, {arg1}, {arg2}, {arg3})', 'PyResult<PyObject>')
    assert sig.name == 'wrap'
    assert sig.return_type == 'PyResult<PyObject>'

    assert len(sig.arguments) == 4
    assert sig.arguments[0].label == None
    assert sig.arguments[0].name == 'name'
    assert sig.arguments[0].typ == 'String'
    assert sig.arguments[0].default_value == None

    assert sig.arguments[1].label == None
    assert sig.arguments[1].name == 'fn'
    assert sig.arguments[1].typ == '@escaping FunctionWrapper.Self_to_Result_Fn<Zelf, R>'
    assert sig.arguments[1].default_value == None

    assert sig.arguments[2].label == None
    assert sig.arguments[2].name == 'castSelf'
    assert sig.arguments[2].typ == '@escaping FunctionWrapper.CastSelf<Zelf>'
    assert sig.arguments[2].default_value == None

    assert sig.arguments[3].label == None
    assert sig.arguments[3].name == 'module'
    assert sig.arguments[3].typ == 'PyString?'
    assert sig.arguments[3].default_value == 'nil'

    arg0 = '    type: PyType'
    arg1 = '    doc: String?'
    arg2 = '    fn: @escaping (Zelf) -> ([PyObject], PyDict?) -> PyResult<PyNone>'
    arg3 = '    castSelf: @escaping FunctionWrapper.CastSelfOptional<Zelf>'
    arg4 = '    module: PyString? = nil'
    sig = SignatureInfo(f'wrapInit<Zelf: PyObject>({arg0}, {arg1}, {arg2}, {arg3}, {arg4})', 'PyObject?')
    assert sig.name == 'wrapInit<Zelf: PyObject>'
    assert sig.return_type == 'PyObject?'

    assert len(sig.arguments) == 5
    assert sig.arguments[0].label == None
    assert sig.arguments[0].name == 'type'
    assert sig.arguments[0].typ == 'PyType'
    assert sig.arguments[0].default_value == None

    assert sig.arguments[1].label == None
    assert sig.arguments[1].name == 'doc'
    assert sig.arguments[1].typ == 'String?'
    assert sig.arguments[1].default_value == None

    assert sig.arguments[2].label == None
    assert sig.arguments[2].name == 'fn'
    assert sig.arguments[2].typ == '@escaping (Zelf) -> ([PyObject], PyDict?) -> PyResult<PyNone>'
    assert sig.arguments[2].default_value == None

    assert sig.arguments[3].label == None
    assert sig.arguments[3].name == 'castSelf'
    assert sig.arguments[3].typ == '@escaping FunctionWrapper.CastSelfOptional<Zelf>'
    assert sig.arguments[3].default_value == None

    assert sig.arguments[4].label == None
    assert sig.arguments[4].name == 'module'
    assert sig.arguments[4].typ == 'PyString?'
    assert sig.arguments[4].default_value == 'nil'

    print('Finished')


if __name__ == '__main__':
    test()
