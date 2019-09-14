'''
Extract symbol table from file.
This tool should be used with CPython!
'''

import sys
import symtable

def dumpTable(table: symtable.SymbolTable, level = 0):
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

  if table.has_children():
    print(indent,'children:')
    for child in table.get_children():
      dumpTable(child, level + 1)

if __name__ == '__main__':
  # if len(sys.argv) < 2:
  #   print("Usage: 'python3 dump_symtable.py [FILE]'")
  #   sys.exit(1)

  # filename = sys.argv[1]
  # code = open(filename).read()

  code = '''
class FROZEN():
  def ELSA():
    ELSA
'''
  table = symtable.symtable(code, '<string>', 'exec')
  dumpTable(table)
