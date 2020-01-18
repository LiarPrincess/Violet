import os
import sys

def in_current_directory(file):
  current_file = __file__
  current_dir = os.path.dirname(current_file)
  return os.path.join(current_dir, file)

def read_file(filename):
  file = in_current_directory(filename)

  with open(file) as f:
    source = f.read()

  return source

def write_file(filename, content):
  file = in_current_directory(filename)

  with open(file,'w') as f:
    f.write(content)

if __name__ == '__main__':
  if len(sys.argv) != 2:
    print('Usage: python3 remove-sourcery-header.py file')
    exit(1)

  filename = sys.argv[1]
  content = read_file(filename)

  sourcery_marker = '// Generated using Sourcery'
  if not content.startswith(sourcery_marker):
    exit(0)

  do_not_edit = '// DO NOT EDIT'
  sourcery_end = content.find(do_not_edit)
  if sourcery_end == -1:
    print(f'\'{filename}\' has invalid sourcery header')
    exit(1)

  sourcery_end += len(do_not_edit)
  new_content = content[sourcery_end:].lstrip()

  write_file(filename, new_content)
