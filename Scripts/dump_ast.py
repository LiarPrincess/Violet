import ast
import sys

def classname(obj):
  return obj.__class__.__name__

def printNode(node, level = 0):
  name = classname(node)
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
        printNode(v, childLevel + 1)
      else:
        print(f"{childIndent}{k}: {classname(v)}")
    elif isinstance(v, list):
      if len(v) == 0:
        print(f"{childIndent}{k} (list): empty")
      else:
        print(f"{childIndent}{k} (list)")
        for e in v:
          if isinstance(e, ast.AST):
            printNode(e, childLevel + 1)
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

if __name__ == '__main__':
  # if len(sys.argv) < 2:
  #   print("Usage: 'python3 dump_ast.py [FILE]'")
  #   sys.exit(1)

  # filename = sys.argv[1]
  # code = open(filename).read()

  code = '''
2 + 2
'''
  root = ast.parse(code, '<string>')
  printNode(root)
