import io
import os
import re
import dis
from typing import List


def in_current_directory(file):
    current_file = __file__
    current_dir = os.path.dirname(current_file)
    return os.path.join(current_dir, file)


def read_input_file():
    file = in_current_directory('input.py')

    with open(file) as f:
        source = f.read()

    return source


def print_docs(lines):
    index = 0

    # python code
    while not lines[index].startswith(' '):
        print('///', lines[index])
        index += 1

    # bytecode instructions
    without_source_code_line = 13
    while index < len(lines):
        line = lines[index]
        if len(line) > 0:
            print('///', line[without_source_code_line:])

        index += 1


def print_expected(lines: List[str]):
    index = 0

    # skip python code
    while not lines[index].startswith(' '):
        index += 1

    arg_value_from_parens_regex = re.compile('.*\((.*)\)')

    # expected
    without_source_code_line_and_bytecode_index = 16
    while index < len(lines):
        line = lines[index]
        index += 1

        if not line:
            continue

        # Are we now code object?
        if line.startswith('Disassembly of '):
            print()
            print(line)
            print()
            continue

        instruction = line[without_source_code_line_and_bytecode_index:]

        arg_start_index = instruction.find(' ')
        name_end = len(instruction) if arg_start_index == -1 else arg_start_index
        name = instruction[:name_end]
        name = to_camel_case(name)
        name = name.replace('Subscr', 'Subscript')
        name = name.replace('Attr', 'Attribute')

        if name == 'returnValue':
            name = 'return'
        if name == 'jumpForward':
            name = 'jumpAbsolute'
        if name == 'continueLoop':
            name = 'continue'

        args = '' if arg_start_index == -1 else instruction[arg_start_index:]
        args = args.strip()

        # Extract arg values from parens: '(0 ('Aurora')),' -> 'Aurora'
        value_in_paren = arg_value_from_parens_regex.findall(args)
        if value_in_paren:
            args = value_in_paren[0]

        # Jump addres
        if args.startswith('to '):
            args = args[3:]

        # Instruction specifics
        # (this is in the same order as cases in 'Instruction' enum)
        if name == 'compareOp':
            compare_type = \
                '.equal' if args == '==' else \
                '.notEqual' if args == '!=' else \
                '.less' if args == '<' else \
                '.lessEqual' if args == '<=' else \
                '.greater' if args == '>' else \
                '.greaterEqual' if args == '>=' else \
                '.is' if args == 'is' else \
                '.isNot' if args == 'is not' else \
                '.in' if args == 'in' else \
                '.notIn' if args == 'not in' else \
                '.exceptionMatch' if args == 'exception match' else \
                args

            args = 'type: ' + compare_type

        elif name == 'setupLoop':
            args = 'loopEndTarget: ' + args
        elif name == 'forIter':
            args = 'ifEmptyTarget: ' + args
        elif name == 'continue':
            args = 'loopStartTarget: ' + args

        elif name in ('buildTuple', 'buildList', 'buildSet', 'buildMap', 'buildConstKeyMap'):
            args = 'elementCount: ' + args
        elif name in ('setAdd', 'listAppend', 'mapAdd'):
            args = 'relativeStackIndex: ' + args
        elif name in ('buildTupleUnpack', 'buildTupleUnpackWithCall', 'buildListUnpack', 'buildSetUnpack', 'buildMapUnpack', 'buildMapUnpackWithCall', 'unpackSequence'):
            args = 'elementCount: ' + args

        elif name == 'unpackEx':
            pass  # TODO: unpackEx

        elif name == 'loadConst':
            if args in ('None', 'Ellipsis', 'True', 'False'):
                args = '.' + args.lower()

            elif args and args[0].isnumeric():
                # We sometimes get additional parens
                args = args.replace('(', '').replace(')', '')

                if '+' in args or args[-1] == 'j':
                    split = args.split('+')
                    real = split[0] if len(split) == 2 else '0'
                    imag = split[1] if len(split) == 2 else split[0]
                    args = f'real: {real}, imag: {imag}'
                elif '.' in args:
                    args = 'float: ' + args
                else:
                    args = 'integer: ' + args
            elif 'code object' in args:
                args = 'codeObject: .any'

            elif args.startswith("'") or args.startswith('"'):
                args = args.replace("'", '"')  # ' -> "
                args = 'string: ' + args
            elif args.startswith('b"') or args.startswith("b'"):
                args = args.replace("'", '"')  # ' -> "
                args = 'bytes: ' + args

            elif ',' in args:
                args = 'tuple: ' + args
            elif args.startswith('<code object'):
                args = 'codeObject: .any'

        elif name in ('loadName', 'storeName', 'deleteName'):
            args = f'name: "{args}"'
        elif name in ('loadAttribute', 'storeAttribute', 'deleteAttribute'):
            args = f'name: "{args}"'
        elif name in ('loadGlobal', 'storeGlobal', 'deleteGlobal'):
            args = f'name: "{args}"'
        elif name in ('loadFast', 'storeFast', 'deleteFast'):
            args = f'variable: MangledName(withoutClass: "{args}")'

        elif name in ('loadDeref', 'storeDeref', 'deleteDeref'):
            args = f'cell: MangledName(withoutClass: "{args}")'

            if name == 'loadDeref':
                name = 'loadCellOrFree'
            elif name == 'storeDeref':
                name = 'storeCellOrFree'
            elif name == 'deleteDeref':
                name = 'deleteCellOrFree'

        elif name == 'loadClosure':
            args = f'cellOrFree: MangledName(withoutClass: "{args}")'

        elif name == 'loadClassderef':
            name = 'loadClassFree'
            args = f'free: MangledName(withoutClass: "{args}")'

        elif name == 'makeFunction':
            if args == '0':
                args = 'flags: []'
            else:
                args = 'flags: ' + args
        elif name in ('callFunction', 'callFunctionKw'):
            args = 'argumentCount: ' + args
        elif name == 'callFunctionEx':
            value = 'true' if args == '1' else 'false'
            args = 'hasKeywordArguments: ' + value

        elif name == 'loadMethod':
            args = 'name: ' + args
        elif name == 'callMethod':
            args = 'argumentCount: ' + args

        elif name in ('importName', 'importFrom'):
            args = 'name: ' + args

        elif name == 'setupExcept':
            args = f'firstExceptTarget: {args}'
        elif name == 'setupFinally':
            args = f'finallyStartTarget: {args}'
        elif name == 'raiseVarargs':
            if args == '1':
                args = 'type: .exceptionOnly'
            else:
                # TODO: Other 'raiseVarargs'
                assert False, 'Add missing raiseVarargs arguments'

        elif name == 'setupWith':
            args = 'afterBodyTarget: ' + args

        elif name in ('jumpAbsolute', 'popJumpIfTrue', 'popJumpIfFalse', 'jumpIfTrueOrPop', 'jumpIfFalseOrPop'):
            args = f'target: {args}'

        elif name == 'formatValue':
            pass  # TODO: formatValue

        elif name == 'buildString':
            args = 'elementCount:' + args
        elif name == 'buildSlice':
            pass  # TODO: buildSlice

        if args:
            args = '(' + args + ')'

        is_last = index == len(lines)
        comma = '' if is_last else ','
        print(f'.{name}{args}{comma}')


def to_camel_case(snake_str):
    components = snake_str.split('_')
    return components[0].lower() + ''.join(x.title() for x in components[1:])


if __name__ == '__main__':
    code = read_input_file()

    bytecode_stream = io.StringIO()
    dis.dis(code, file=bytecode_stream)

    bytecode_stream.seek(0)
    bytecode_lines = bytecode_stream.readlines()

    lines = [l.replace('\n', '') for l in bytecode_lines]

    for c in code.splitlines():
        print('///', c)

    print('///')
    print_docs(lines)
    print('-----------------')
    print_expected(lines)
