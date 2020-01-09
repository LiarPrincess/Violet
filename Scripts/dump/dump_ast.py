'''
Dump AST.
This tool should be used with CPython!
'''

import ast
import sys

def class_name(obj):
  return obj.__class__.__name__

def dump_ast(code, indent = 0):
  root = ast.parse(code, '<string>')
  dump_ast_inner(root, level=indent)

def dump_ast_inner(node, level = 0):
  name = class_name(node)
  print(' ' * level * 2 + name + " (node)")

  childLevel = level + 1
  childIndent = ' ' * (childLevel * 2)
  childs = [x for x in dir(node) if not x.startswith('_')
                                  and x not in ['col_offset', 'lineno']]

  for k in childs:
    v = node.__dict__[k]

    if isinstance(v, ast.AST):
      if v._fields:
        print(f"{childIndent}{k} (node)")
        dump_ast_inner(v, childLevel + 1)
      else:
        print(f"{childIndent}{k}: {class_name(v)}")
    elif isinstance(v, list):
      if len(v) == 0:
        print(f"{childIndent}{k} (list): empty")
      else:
        print(f"{childIndent}{k} (list)")
        for e in v:
          if isinstance(e, ast.AST):
            dump_ast_inner(e, childLevel + 1)
          else:
            print(f"{childIndent}  {e}")
    elif isinstance(v, str):
      print(f"{childIndent}{k}: {v}")
    elif isinstance(v, int) or isinstance(v, float):
      print(f"{childIndent}{k}: {v}")
    elif v is None:
      print(f"{childIndent}{k}: null")
    else:
      print(f"{childIndent}{k}: ?")
