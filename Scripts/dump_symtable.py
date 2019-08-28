# Extract symbol table from file.
# This tool should be used with CPython!

import sys
import symtable

# Based on:
# https://eli.thegreenplace.net/2010/09/18/python-internals-symbol-tables-part-1/
def dumpTable(table: symtable.SymbolTable, level = 0):
  indent = level * '  '

  print(indent,'name:', table.get_name())
  print(indent,'lineno:', table.get_lineno())

  if table.is_optimized():
    print(indent,'is optimized')

  if table.is_nested():
    print(indent,'is nested')

  if table.has_exec():
    print(indent,'has exec')

  # Function
  if hasattr(table, 'get_parameters') and table.get_parameters():
    print('parameters:', table.get_parameters())

  if hasattr(table, 'get_locals') and table.get_locals():
    print('locals:', table.get_locals())

  if hasattr(table, 'get_globals') and table.get_globals():
    print('globals:', table.get_globals())

  if hasattr(table, 'get_frees') and table.get_frees():
    print('frees:', table.get_frees())

  # Class
  if hasattr(table, 'get_methods') and table.get_methods():
    print('methods:', table.get_methods())

  print(indent,'symbols:')
  for symbol in table.get_symbols():
    symbolProps = ''
    for prop in [ 'referenced', 'imported', 'parameter',
                  'global', 'declared_global', 'local',
                  'free', 'assigned', 'namespace']:

      if getattr(symbol, 'is_' + prop)():
        symbolProps += prop + ', '

    print(indent, ' ', symbol.get_name(), '-', symbolProps)
    pass

  for child in table.get_children():
    dumpTable(child, level + 1)

if __name__ == '__main__':
  if len(sys.argv) < 2:
    print("Usage: 'python3 dump_symtable.py <file.py>'")
    sys.exit(1)

  filename = sys.argv[1]
  code = open(filename).read()
  table = symtable.symtable(code, '<string>', 'exec')
  dumpTable(table)
