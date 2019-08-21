# Extract symbol table from file.
# This tool should be used with CPython!

import sys
import symtable

# Based on:
# https://eli.thegreenplace.net/2010/09/18/python-internals-symbol-tables-part-1/
def dumpTable(table: symtable.SymbolTable, level = 0):
  indent = level * '  '

  for symbol in table.get_symbols():
    print(indent, symbol.get_name())
    for prop in [ 'referenced', 'imported', 'parameter',
                  'global', 'declared_global', 'local',
                  'free', 'assigned', 'namespace']:

      if getattr(symbol, 'is_' + prop)():
          print(indent, '  is', prop)

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
