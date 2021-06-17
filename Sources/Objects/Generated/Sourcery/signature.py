from typing import List, Union


class ArgumentInfo:
    def __init__(self, label: Union[str, None], name: str, typ: str):
        self.label = label
        self.name = name
        self.typ = typ


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

        open_paren_index = selector_with_types.index('(')
        self.name = selector_with_types[:open_paren_index]

        close_paren_index = selector_with_types.rindex(')')

        arguments_start_index = open_paren_index + 1
        arguments = selector_with_types[arguments_start_index:close_paren_index]

        self.arguments: List[ArgumentInfo] = []
        if arguments:
            for arg in arguments.split(','):
                label_name, typ = arg.strip().split(':')
                label_name_split = label_name.split(' ')

                has_label = len(label_name_split) == 2
                if has_label:
                    # label name: type
                    label = label_name_split[0].strip()
                    name = label_name_split[1].strip()
                else:
                    # name: type
                    label = None
                    name = label_name_split[0].strip()

                argument = ArgumentInfo(label, name, typ.strip())
                self.arguments.append(argument)


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

    sig = SignatureInfo('add(_ other: PyObject)', 'PyResult<PyObject>')
    assert sig.name == 'add'
    assert len(sig.arguments) == 1
    assert sig.arguments[0].label == '_'
    assert sig.arguments[0].name == 'other'
    assert sig.arguments[0].typ == 'PyObject'
    assert sig.return_type == 'PyResult<PyObject>'

    sig = SignatureInfo('call(args: [PyObject], kwargs: PyDict?)', 'PyResult<PyObject>')
    assert sig.name == 'call'
    assert len(sig.arguments) == 2
    assert sig.arguments[0].label == None
    assert sig.arguments[0].name == 'args'
    assert sig.arguments[0].typ == '[PyObject]'
    assert sig.arguments[1].label == None
    assert sig.arguments[1].name == 'kwargs'
    assert sig.arguments[1].typ == 'PyDict?'
    assert sig.return_type == 'PyResult<PyObject>'

    print('Finished')


if __name__ == '__main__':
    test()
