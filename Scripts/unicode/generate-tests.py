import sys
import os.path
import unicodedata
from typing import List, Tuple

from UnicodeData import open_data
from Common import UNIDATA_VERSION, generated_warning

BLOCKS = "Blocks%s.txt"

# This is awesome:
# https://unicode-table.com/en/blocks/basic-latin/
BLOCK_NAMES = (
    'Basic Latin',
    'Latin-1 Supplement',  # Letters with accent, some currency symbols etc.
    'Latin Extended-A',  # Polish

    # 'Arabic',

    # 'Combining Diacritical Marks',  # Our favourite 'COMBINING ACUTE ACCENT'

    # 'Mathematical Operators',
    # 'Braille Patterns',

    # 'Hiragana',
    # 'Katakana',

    # 'Hangul Jamo',
    # # 'Hangul Syllables', # 11183 is too much

    # 'Playing Cards',

    # 'Emoticons',
    # 'Transport and Map Symbols',
    # 'Chess Symbols'
)


class Block:
    def __init__(self, line: str):
        # Example lines:
        # 0000..007F; Basic Latin
        # 0600..06FF; Arabic
        split = line.split(";")
        assert len(split) == 2
        self.name = split[1].strip()

        range_split = split[0].split('..')
        assert len(range_split) == 2
        self.start = int(range_split[0], 16)
        self.end = int(range_split[1], 16)


# ===============
# === Helpers ===
# ===============

def create_class_name(block_name: str) -> str:
    'PascalCase name'

    result = ''
    split = block_name.replace('-', '').split(' ')
    for block_name in split:
        block_name = block_name[0].upper() + block_name[1:]
        result += block_name

    return 'UnicodeData' + result + 'Tests'


def create_method_name(character_name: str) -> str:
    "Change '-' to '_' and camelCase"

    result = ''
    hyphen_split = character_name.split('-')
    for hyphen_group in hyphen_split:
        if len(result):
            result += '_'

        split = hyphen_group.split(' ')
        for index, word in enumerate(split):
            is_first = index == 0
            if is_first:
                result += word.lower()
            else:
                result += word[0].upper() + word[1:].lower()

    return 'test_' + result


def is_lowercase(ch: str) -> bool:
    # FEMININE ORDINAL INDICATOR - see: https://codepoints.net/U+00AA
    # MASCULINE ORDINAL INDICATOR - see: https://codepoints.net/U+00BA
    if ch == 'ª' or ch == 'º':
        return True

    category = unicodedata.category(ch)
    return category == 'Ll'


def is_uppercase(ch: str) -> bool:
    category = unicodedata.category(ch)
    return category == 'Lu'


def is_titlecase(ch: str) -> bool:
    category = unicodedata.category(ch)
    return category == 'Lt'


def check_decimal(ch: str):
    try:
        d = unicodedata.decimal(ch)
        return (True, str(d))
    except:
        return (False, 'nil')


def check_digit(ch: str) -> Tuple[bool, str]:
    try:
        d = unicodedata.digit(ch)
        return (True, str(d))
    except:
        return (False, 'nil')


def check_identifier(ch: str) -> Tuple[bool, bool]:
    if ch == '_':
        # '_' is a valid Python identifier start, but not Unicode!
        # See: https://codepoints.net/U+005F -> 'XID Start'
        return (False, True)

    start_string = ch + 'A'
    is_start = start_string.isidentifier()

    continue_string = 'A' + ch
    is_continue = continue_string.isidentifier()

    return (is_start, is_continue)


def swift_bool(b: bool) -> str:
    return 'true' if b else 'false'


def swift_string(s: str) -> str:
    if s == '"':
        return '\\"'

    if s == '\\':
        return '\\\\'

    return s


def swift_escape(ch: str) -> str:
    if ch == '"':
        return '\\"'

    if ch == '\\':
        return '\\\\'

    return ch


_LINE_BREAKS = None


def get_line_breaks():
    global _LINE_BREAKS

    if _LINE_BREAKS:
        return _LINE_BREAKS

    result = []
    for n in range(0, 0x110000):
        ch = chr(n)
        s = 'A' + ch + 'A'
        split = s.splitlines()
        if len(split) != 1:
            result.append(ch)

    _LINE_BREAKS = result
    return result


def is_line_break(ch: str) -> bool:
    line_breaks = get_line_breaks()
    return ch in line_breaks


# =======================
# === Write test file ===
# =======================

def write_test_file(output_dir_path: str, block: Block):
    name = block.name
    start = block.start
    end = block.end

    file_path = os.path.join(output_dir_path, f'UnicodeData - {name}.swift')
    print('Generating:', file_path)

    with open(file_path, 'w') as f:
        class_name = create_class_name(name)
        print(f" class name: '{class_name}'")

        f.write(f'''\
{generated_warning(__file__)}

import XCTest
import UnicodeData

// swiftlint:disable file_length

/// Tests for: {start:04x}..{end:04x} {name} block
class {class_name}: XCTestCase {{\
''')

        for n in range(start, end + 1):
            ch = chr(n)
            name = ''
            try:
                name = unicodedata.name(ch)
            except:
                continue

            test_name = create_method_name(name)
            (is_decimal, decimal_value) = check_decimal(ch)
            (is_digit, digit_value) = check_digit(ch)
            (is_identifier_start, is_identifier_continue) = check_identifier(ch)

            # Not supported:
            # XCTAssertEqual(UnicodeData.isCased(scalar), true)
            # XCTAssertEqual(UnicodeData.isCaseIgnorable(scalar), false)

            f.write(f'''

  /// '{ch}' - {name} (U+{n:04x})
  func {test_name}() {{
    let scalar: UnicodeScalar = "{swift_escape(ch)}"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), {swift_bool(is_lowercase(ch))})
    XCTAssertCase(UnicodeData.toLowercase(scalar), "{swift_string(ch.lower())}")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), {swift_bool(is_uppercase(ch))})
    XCTAssertCase(UnicodeData.toUppercase(scalar), "{swift_string(ch.upper())}")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), {swift_bool(is_titlecase(ch))})
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "{swift_string(ch.title())}")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "{swift_string(ch.casefold())}")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), {swift_bool(is_decimal)})
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), {decimal_value})
    XCTAssertEqual(UnicodeData.isDigit(scalar), {swift_bool(is_digit)})
    XCTAssertDigit(UnicodeData.toDigit(scalar), {digit_value})

    XCTAssertEqual(ASCIIData.isASCII(scalar), {swift_bool(ch.isascii())})
    XCTAssertEqual(UnicodeData.isAlpha(scalar), {swift_bool(ch.isalpha())})
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), {swift_bool(ch.isalnum())})
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), {swift_bool(ch.isspace())})
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), {swift_bool(is_line_break(ch))})
    XCTAssertEqual(UnicodeData.isXidStart(scalar), {swift_bool(is_identifier_start)})
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), {swift_bool(is_identifier_continue)})
    XCTAssertEqual(UnicodeData.isNumeric(scalar), {swift_bool(ch.isnumeric())})
    XCTAssertEqual(UnicodeData.isPrintable(scalar), {swift_bool(ch.isprintable())})
  }}\
''')

        f.write('\n}\n')  # class end


# ============
# === Main ===
# ============

def main(output_dir_path: str):
    blocks: List[Block] = []
    with open_data(BLOCKS, UNIDATA_VERSION) as file:
        while True:
            line: str = file.readline()
            if not line:
                break

            line = line.strip()
            if line.startswith('#') or len(line) == 0:
                continue

            block = Block(line)
            blocks.append(block)

    for block in blocks:
        if block.name in BLOCK_NAMES:
            write_test_file(output_dir_path, block)


if __name__ == '__main__':
    args = sys.argv
    if len(args) < 2:
        raise ValueError('Missing output dir path argument')

    output_dir_path = args[1]
    main(output_dir_path)
