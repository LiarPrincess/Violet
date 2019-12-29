"""
Download 'CaseFolding.txt' from 'https://www.unicode.org/Public/UCD/latest/ucd/'
"""

import os

def to_swift_unicode_escape(code):
  '0061 -> \\u{0061}'
  return '\\u{' + code + '}'

def in_current_directory(file):
  current_file = __file__
  current_dir = os.path.dirname(current_file)
  return os.path.join(current_dir, file)

file = in_current_directory('CaseFolding.txt')

with open(file, 'r') as f:
  for line in f:
    line = line.strip()
    if not line or line.startswith('#'):
      continue

    data, name = line.split(' # ')
    code, status, mapping = data.split('; ')
    mapping = mapping.replace(';', '')

    # print(code, '->', mapping, '-', name)
    if status == 'C':
      # C: common case folding, common mappings shared by both simple and full mappings.
      print(f'  0x{code}: "{to_swift_unicode_escape(mapping)}", // {name}')

    elif status == 'F':
      # F: full case folding, mappings that cause strings to grow in length.
      # Multiple characters are separated by spaces.
      mapping = ''.join(map(to_swift_unicode_escape, mapping.split(' ')))
      print(f'  0x{code}: "{mapping}", // {name}')

    elif status == 'S':
      # S: simple case folding, mappings to single characters where different from F.
      # We will take 'F' form.
      pass

    elif status == 'T':
      # T: special case for uppercase I and dotted uppercase I, for example:
      # 0049; C; 0069; # LATIN CAPITAL LETTER I
      # 0049; T; 0131; # LATIN CAPITAL LETTER I
      # We only take 'C' version, so nothing to do here.
      pass

    else:
      print(f"INVALID STATUS '{status}' in line '{line}'.")
      exit(1)
