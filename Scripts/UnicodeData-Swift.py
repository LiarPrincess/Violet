"""
Download 'UnicodeData.txt' from 'https://www.unicode.org/Public/UCD/latest/ucd/'
Format description is available at: http://www.unicode.org/L2/L1999/UnicodeData.html
"""

whitespace_bidi_classes = ['WS', 'B', 'S']

with open('./Scripts/UnicodeData.txt', 'r') as f:
  for line in f:
    line = line.strip()
    if not line or line.startswith('#'):
      continue

    line_split = line.split(';')
    code = line_split[0]
    name = line_split[1]
    bidi_category = line_split[4]

    if bidi_category in whitespace_bidi_classes:
      print(f'0x{code}, // {name}, {bidi_category}')
