import io
import os
import re
import dis
import sys

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

  # code object
  while index < len(lines):
    line = lines[index]
    if len(line) > 0:
      print('///', line[13:])
    index += 1

def print_expected(lines):
  index = 0

  # skip python code
  while not lines[index].startswith(' '):
    index += 1

  argRegex = re.compile('.*\((.*)\)')

  # expected
  while index < len(lines):
    line = lines[index]
    if len(line) > 0:
      instruction = line[16:]
      argStart = instruction.find(' ')

      if argStart == -1:
        # .init(.return)
        name = to_camel_case(instruction)
        name = 'return' if name == 'returnValue' else name
        name = name.replace('Subscr', 'Subscript')
        print(f'.init(.{name}),')

      else:
        # .init(.loadConst, "none"),
        name = to_camel_case(instruction[:argStart])
        name = 'jumpAbsolute' if name == 'jumpForward' else name
        name = name.replace('Attr', 'Attribute')

        args = instruction[argStart:].strip()
        f = argRegex.findall(args)
        if f:
          args = f[0]

        args = args[3:] if args.startswith('to ') else args
        args = 'none' if args == 'None' else args

        print(f'.init(.{name}, "{args}"),')

    index += 1

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
