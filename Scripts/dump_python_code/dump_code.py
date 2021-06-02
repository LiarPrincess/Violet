'''
Dump code object from given source.
This tool should be used with CPython!
'''

import dis
import types
import typing


def dump_code(source: str):
    code = compile(source, 'input.py', 'exec')
    _dump(code)


def _dump(code: typing.types.CodeType):
    # We could use 'dis.code_info', but we want different formatting
    # (but we will shamelessly copy code from it)
    print(f'Code object: {code.co_name} <------------------ (name!)')

    print('Argument count:   ', code.co_argcount)
    print('Kw-only arguments:', code.co_kwonlyargcount)
    print('Number of locals: ', code.co_nlocals)
    print('Stack size:       ', code.co_stacksize)
    print('Flags:            ', dis.pretty_flags(code.co_flags))
    print()

    print('Constants:     ', code.co_consts)
    print('Names:         ', code.co_names)
    print()

    print('Variable names:', code.co_varnames)
    print('Free variables:', code.co_freevars)
    print('Cell variables:', code.co_cellvars)
    print()

    print('Instructions:')
    dis.disassemble(code)
    print()

    for c in code.co_consts:
        if isinstance(c, types.CodeType):
            _dump(c)
