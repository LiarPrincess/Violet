from generate_numbers import (generate_smi_numbers, generate_heap_numbers)

if __name__ == '__main__':
    for value in generate_smi_numbers():
        bitWidth = value.bit_length()
        print(f'({value}, {bitWidth}),')

    print()
    print()
    print()

    for value in generate_heap_numbers(30):
        bitWidth = value.bit_length()
        print(f'("{value}", {bitWidth}),')
