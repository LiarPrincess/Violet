'''
Extract symbol table from file.
This tool should be used with CPython!
'''

import symtable


def dump_symtable(code):
    table = symtable.symtable(code, '<string>', 'exec')
    _dump(table)


def _dump(table: symtable.SymbolTable, level=0):
    indent = level * '  '

    print(indent, 'name:', table.get_name())
    print(indent, 'lineno:', table.get_lineno())

    if table.is_optimized():
        print(indent, 'is optimized')

    if table.is_nested():
        print(indent, 'is nested')

    if table.has_exec():
        print(indent, 'has exec')

    # Function
    if hasattr(table, 'get_parameters') and table.get_parameters():
        print(indent, 'parameters:', table.get_parameters())

    if hasattr(table, 'get_locals') and table.get_locals():
        print(indent, 'locals:', table.get_locals())

    if hasattr(table, 'get_globals') and table.get_globals():
        print(indent, 'globals:', table.get_globals())

    if hasattr(table, 'get_frees') and table.get_frees():
        print(indent, 'frees:', table.get_frees())

    # Class
    if hasattr(table, 'get_methods') and table.get_methods():
        print(indent, 'methods:', table.get_methods())

    print(indent, 'symbols:')
    for symbol in table.get_symbols():
        symbolProps = ''
        for prop in ['referenced', 'imported', 'parameter',
                     'global', 'declared_global', 'local',
                     'free', 'assigned', 'namespace']:

            if getattr(symbol, 'is_' + prop)():
                symbolProps += prop + ', '

        print(indent, ' ', symbol.get_name(), '-', symbolProps)

    if table.has_children():
        print(indent, 'children:')
        for child in table.get_children():
            _dump(child, level + 1)
