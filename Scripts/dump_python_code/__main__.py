import os
from dump_ast import dump_ast
from dump_symtable import dump_symtable
from dump_code import dump_code


def in_current_directory(file):
    current_file = __file__
    current_dir = os.path.dirname(current_file)
    return os.path.join(current_dir, file)


def read_input_file():
    file = in_current_directory('input.py')

    with open(file) as f:
        source = f.read()

    return source


if __name__ == '__main__':
    code = read_input_file()

    print('=== AST ===')
    dump_ast(code)
    print()

    print('=== Symbol table ===')
    dump_symtable(code)
    print()

    print('=== Code ===')
    dump_code(code)
