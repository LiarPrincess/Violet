import os

dir_path = os.path.dirname(__file__)
input_file =  os.path.join(dir_path, 'OwnerProtocols.tmp')

def remove_multispaces(line):
  ''' If signature spans multiple lines then Sourcery will ignore new lines, but
  preserve indentation, so we end up with:
  protocol findOwner { func find(_ value: PyObject,                     start: PyObject?,                     end: PyObject?) -> PyResult<Int> }

  This method will prettify those spaces.

  Also 'multispaces' is not a word, but whatever.
  '''
  while '  ' in line:
    line = line.replace('  ', ' ')

  return line

unique_lines = set()
with open(input_file, 'r') as reader:
  for line in reader:
    line = line.strip()
    if line.startswith('protocol'):
      line = remove_multispaces(line)
      unique_lines.add(line)

print('import Core')
print()
print('// swiftlint:disable line_length')
print()

for line in sorted(unique_lines):
  print(line)

os.remove(input_file)
