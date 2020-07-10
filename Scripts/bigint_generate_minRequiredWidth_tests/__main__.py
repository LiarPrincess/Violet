from generate_numbers import (generateSmiNumbers, generateHeapNumbers)

if __name__ == '__main__':
  for value in generateSmiNumbers():
    bitWidth = value.bit_length()
    print(f'({value}, {bitWidth}),')

  print()
  print()
  print()

  for value in generateHeapNumbers(30):
    bitWidth = value.bit_length()
    print(f'("{value}", {bitWidth}),')
