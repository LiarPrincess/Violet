import sys
import os.path
import unicodedata
from typing import List, Tuple

from UnicodeData import open_data
from Common import UNIDATA_VERSION, generated_warning

# cSpell: ignore YPOGEGRAMMENI xiangqi

BLOCKS = "Blocks%s.txt"

# This is awesome:
# https://unicode-table.com/en/blocks/basic-latin/
BLOCK_NAMES = (
    'Basic Latin',
    'Latin-1 Supplement',  # Letters with accent, some currency symbols etc.
    'Latin Extended-A',  # Polish

    'Arabic',

    'Combining Diacritical Marks',  # Our favorite 'COMBINING ACUTE ACCENT'

    'Mathematical Operators',
    'Braille Patterns',

    'Hiragana',
    'Katakana',

    'Hangul Jamo',
    # 'Hangul Syllables',  # 11183 characters is too much

    'Playing Cards',

    'Emoticons',
    'Transport and Map Symbols',
    'Chess Symbols'
)


class Block:
    def __init__(self, line: str):
        # Example line:
        # 0000..007F; Basic Latin
        # 0600..06FF; Arabic
        split = line.split(";")
        assert len(split) == 2
        self.name = split[1].strip()

        range_split = split[0].split('..')
        assert len(range_split) == 2
        self.start = int(range_split[0], 16)
        self.end = int(range_split[1], 16)


# ====================
# === Class/method ===
# ====================

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


def create_method_doc(block: Block, ch: str) -> str:
    n = ord(ch)
    name = unicodedata.name(ch)

    if check_printable(block, ch):
        printed = ch

        is_combining = check_combining(block, ch)
        if is_combining:
            printed = '◌' + printed

        return f"'{printed}' - {name} (U+{n:04x})"

    return f"{name} (U+{n:04x})"


def check_combining(block: Block, ch: str) -> bool:
    name = unicodedata.name(ch).casefold()
    if 'combining' in name:
        return True

    block_name = block.name.casefold()
    if 'combining' in block_name:
        return True

    return False

# ==================
# === Properties ===
# ==================

# ====================================================================================
# IMPORTANT: Some of those things depend on the Python version that you are using
# (to be more precise: Unicode that they bundled).
# That's why sometimes we will override Python results and comment 'PYTHON IS WRONG?'.
# ====================================================================================


def check_lowercase(block: Block, ch: str) -> Tuple[bool, str]:
    cased = ch.lower()

    # TODO: PYTHON IS WRONG?
    # FEMININE ORDINAL INDICATOR - https://codepoints.net/U+00AA
    # MASCULINE ORDINAL INDICATOR - https://codepoints.net/U+00BA
    # COMBINING GREEK YPOGEGRAMMENI - https://codepoints.net/U+0345
    if ch in ('ª', 'º', 'ͅ'):
        return (True, cased)

    category = unicodedata.category(ch)
    is_cased = category == 'Ll'
    return (is_cased, cased)


def check_uppercase(block: Block, ch: str) -> Tuple[bool, str]:
    category = unicodedata.category(ch)
    is_cased = category == 'Lu'
    cased = ch.upper()
    return (is_cased, cased)


def check_titlecase(block: Block, ch: str) -> Tuple[bool, str]:
    category = unicodedata.category(ch)
    is_cased = category == 'Lt'
    cased = ch.title()
    return (is_cased, cased)


def get_casefold(block: Block, ch: str) -> str:
    return ch.casefold()


def check_decimal(block: Block, ch: str):
    try:
        d = unicodedata.decimal(ch)
        return (True, str(d))
    except:
        return (False, 'nil')


def check_digit(block: Block, ch: str) -> Tuple[bool, str]:
    try:
        d = unicodedata.digit(ch)
        return (True, str(d))
    except:
        return (False, 'nil')


def check_identifier(block: Block, ch: str) -> Tuple[bool, bool]:
    # TODO: PYTHON IS WRONG?
    # '_' is a valid Python identifier start, but not Unicode!
    # See: https://codepoints.net/U+005F -> 'ID Start'
    if ch == '_':
        return (False, True)

    start_string = ch + 'A'
    is_start = start_string.isidentifier()

    continue_string = 'A' + ch
    is_continue = continue_string.isidentifier()

    return (is_start, is_continue)


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


def check_line_break(ch: str) -> bool:
    line_breaks = get_line_breaks()
    return ch in line_breaks


def check_printable(block: Block, ch: str) -> bool:
    # Python conditions to consider character 'printable'
    # char == ord(" ") or category not in ("C", "Z"):

    n = ord(ch)

    # TODO: PYTHON IS WRONG?
    # 0x1f6d5 - HINDU TEMPLE
    # 0x1f6fa - AUTO RICKSHAW
    if n in (0x1f6d5, 0x1f6fa):
        return False

    block_name = block.name.casefold()
    is_chess_but_not_xiangqi = 'chess' in block_name and n < 0x1fa60
    if is_chess_but_not_xiangqi:
        return False

    return ch.isprintable()


class OtherProperties:
    def __init__(self,
                 is_ascii: bool,
                 is_alpha: bool,
                 is_alpha_numeric: bool,
                 is_whitespace: bool,
                 is_lineBreak: bool,
                 is_numeric: bool,
                 is_printable: bool):
        self.is_ascii = is_ascii
        self.is_alpha = is_alpha
        self.is_alpha_numeric = is_alpha_numeric
        self.is_whitespace = is_whitespace
        self.is_lineBreak = is_lineBreak
        self.is_numeric = is_numeric
        self.is_printable = is_printable


def check_other_properties(block: Block, ch: str) -> OtherProperties:
    is_ascii = ch.isascii()
    is_alpha = ch.isalpha()
    is_alpha_numeric = ch.isalnum()
    is_whitespace = ch.isspace()
    is_line_break = check_line_break(ch)
    is_numeric = ch.isnumeric()
    is_printable = check_printable(block, ch)

    return OtherProperties(is_ascii, is_alpha, is_alpha_numeric, is_whitespace, is_line_break, is_numeric, is_printable)


# =============
# === Swift ===
# =============

def swift_bool(b: bool) -> str:
    return 'true' if b else 'false'


def swift_string(block: Block, s: str) -> str:
    all_printable = all([check_printable(block, c) for c in s])
    if not all_printable:
        # Return code-point notation
        result = ''
        for c in s:
            n = ord(c)
            result += f'\\u{{{n:04x}}}'
        #
        return result

    if s == '"':
        return '\\"'

    if s == '\\':
        return '\\\\'

    return s


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

        f.write(f'''\
{generated_warning(__file__)}

import XCTest
import UnicodeData

// swiftlint:disable superfluous_disable_command
// swiftlint:disable xct_specific_matcher
// swiftlint:disable type_name
// swiftlint:disable file_length

/// Tests for: {start:04x}..{end:04x} {name} block
class {class_name}: XCTestCase {{\
''')

        for n in range(start, end + 1):
            ch = chr(n)
            ch_name = ''
            try:
                ch_name = unicodedata.name(ch)
            except:
                continue

            method_name = create_method_name(ch_name)
            method_doc = create_method_doc(block, ch)

            (is_lowercase, lowercased) = check_lowercase(block, ch)
            (is_uppercase, uppercased) = check_uppercase(block, ch)
            (is_titlecase, titlecased) = check_titlecase(block, ch)
            casefold = get_casefold(block, ch)
            (is_decimal, decimal_value) = check_decimal(block, ch)
            (is_digit, digit_value) = check_digit(block, ch)
            (is_identifier_start, is_identifier_continue) = check_identifier(block, ch)
            other = check_other_properties(block, ch)

            # Not supported:
            # XCTAssertEqual(UnicodeData.isCased(scalar), true)
            # XCTAssertEqual(UnicodeData.isCaseIgnorable(scalar), false)

            f.write(f'''

  /// {method_doc}
  func {method_name}() {{
    let scalar: UnicodeScalar = "{swift_string(block, ch)}"

    XCTAssertEqual(UnicodeData.isLowercase(scalar), {swift_bool(is_lowercase)})
    XCTAssertCase(UnicodeData.toLowercase(scalar), "{swift_string(block, lowercased)}")
    XCTAssertEqual(UnicodeData.isUppercase(scalar), {swift_bool(is_uppercase)})
    XCTAssertCase(UnicodeData.toUppercase(scalar), "{swift_string(block, uppercased)}")
    XCTAssertEqual(UnicodeData.isTitlecase(scalar), {swift_bool(is_titlecase)})
    XCTAssertCase(UnicodeData.toTitlecase(scalar), "{swift_string(block, titlecased)}")
    XCTAssertCase(UnicodeData.toCasefold(scalar), "{swift_string(block, casefold)}")

    XCTAssertEqual(UnicodeData.isDecimalDigit(scalar), {swift_bool(is_decimal)})
    XCTAssertDigit(UnicodeData.toDecimalDigit(scalar), {decimal_value})
    XCTAssertEqual(UnicodeData.isDigit(scalar), {swift_bool(is_digit)})
    XCTAssertDigit(UnicodeData.toDigit(scalar), {digit_value})

    XCTAssertEqual(ASCIIData.isASCII(scalar), {swift_bool(other.is_ascii)})
    XCTAssertEqual(UnicodeData.isAlpha(scalar), {swift_bool(other.is_alpha)})
    XCTAssertEqual(UnicodeData.isAlphaNumeric(scalar), {swift_bool(other.is_alpha_numeric)})
    XCTAssertEqual(UnicodeData.isWhitespace(scalar), {swift_bool(other.is_whitespace)})
    XCTAssertEqual(UnicodeData.isLineBreak(scalar), {swift_bool(check_line_break(ch))})
    XCTAssertEqual(UnicodeData.isXidStart(scalar), {swift_bool(is_identifier_start)})
    XCTAssertEqual(UnicodeData.isXidContinue(scalar), {swift_bool(is_identifier_continue)})
    XCTAssertEqual(UnicodeData.isNumeric(scalar), {swift_bool(other.is_numeric)})
    XCTAssertEqual(UnicodeData.isPrintable(scalar), {swift_bool(other.is_printable)})
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
