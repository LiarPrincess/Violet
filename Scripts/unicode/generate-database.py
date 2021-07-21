"Based on 'Tools/unicode/makeunicodedata.py' from CPython."

import sys
from typing import Dict, List, Tuple, Optional

from UnicodeData import UnicodeData
from Common import UNIDATA_VERSION, generated_warning

SCRIPT = sys.argv[0]
VERSION = "3.3"

# note: should match definitions in Objects/unicodectype.c
ALPHA_MASK = 0x01
DECIMAL_MASK = 0x02
DIGIT_MASK = 0x04
LOWER_MASK = 0x08
LINEBREAK_MASK = 0x10
SPACE_MASK = 0x20
TITLE_MASK = 0x40
UPPER_MASK = 0x80
XID_START_MASK = 0x100
XID_CONTINUE_MASK = 0x200
PRINTABLE_MASK = 0x400
NUMERIC_MASK = 0x800
CASE_IGNORABLE_MASK = 0x1000
CASED_MASK = 0x2000
EXTENDED_CASE_MASK = 0x4000


class UniquePropertyValues:
    def __init__(self):
        self.upper: int = 0
        self.lower: int = 0
        self.title: int = 0
        self.fold: Optional[int] = None
        self.decimal: int = 0
        self.digit: int = 0
        self.flags: int = 0

    def as_tuple(self) -> Tuple:
        return (self.upper, self.lower, self.title, self.fold, self.decimal, self.digit, self.flags)

    def __hash__(self) -> int:
        return hash(self.as_tuple())

    def __eq__(self, o: object) -> bool:
        return self.as_tuple() == o.as_tuple()


def maketables(trace, file_path: str):
    # 'UnicodeData' class is taken directly from CPython.
    unicode = UnicodeData(UNIDATA_VERSION)

    # We only need 'makeunicodetype' (without 'makeunicodename' or 'makeunicodedata')
    makeunicodetype(unicode, trace, file_path)


# --------------------------------------------------------------------
# unicode character type tables

def makeunicodetype(unicode: UnicodeData, trace: int, file_path: str):

    FILE = file_path

    print("--- Preparing", FILE, "...")

    # extract unicode types
    dummy = UniquePropertyValues()
    unique_property_values: List[UniquePropertyValues] = [dummy]
    # There is an error in CPython, they have '{0:dummy}',
    # but it will work anyway, just the 1st entry will be duplicated.
    unique_values_to_index: Dict[UniquePropertyValues, int] = {dummy: 0}
    extra_casing: List[Tuple[int]] = []
    index_by_char = [0] * len(unicode.chars)
    numeric = {}
    spaces = []
    linebreaks = []

    for char in unicode.chars:
        record = unicode.table[char]
        if record:
            # extract database properties
            category = record[2]
            bidirectional = record[4]
            properties = record[16]

            unique_values = UniquePropertyValues()

            # === Flags ===
            if category in ["Lm", "Lt", "Lu", "Ll", "Lo"]:
                unique_values.flags |= ALPHA_MASK
            if "Lowercase" in properties:
                unique_values.flags |= LOWER_MASK
            if 'Line_Break' in properties or bidirectional == "B":
                unique_values.flags |= LINEBREAK_MASK
                linebreaks.append(char)
            if category == "Zs" or bidirectional in ("WS", "B", "S"):
                unique_values.flags |= SPACE_MASK
                spaces.append(char)
            if category == "Lt":
                unique_values.flags |= TITLE_MASK
            if "Uppercase" in properties:
                unique_values.flags |= UPPER_MASK
            if char == ord(" ") or category[0] not in ("C", "Z"):
                unique_values.flags |= PRINTABLE_MASK
            if "XID_Start" in properties:
                unique_values.flags |= XID_START_MASK
            if "XID_Continue" in properties:
                unique_values.flags |= XID_CONTINUE_MASK
            if "Cased" in properties:
                unique_values.flags |= CASED_MASK
            if "Case_Ignorable" in properties:
                unique_values.flags |= CASE_IGNORABLE_MASK

            # === Upper, lower, title ===
            if record[12]:
                upper = int(record[12], 16)
            else:
                upper = char

            if record[13]:
                lower = int(record[13], 16)
            else:
                lower = char

            if record[14]:
                title = int(record[14], 16)
            else:
                title = upper

            # === Special case things ===
            special_casing = unicode.special_casing.get(char)
            case_folding = unicode.case_folding.get(char, [char])

            if special_casing is None and case_folding != [lower]:
                special_casing = ([lower], [title], [upper])

            if special_casing is None:
                if upper == lower == title:
                    unique_values.upper = 0
                    unique_values.lower = 0
                    unique_values.title = 0
                else:
                    # Store relative index
                    unique_values.upper = upper - char
                    unique_values.lower = lower - char
                    unique_values.title = title - char
                    assert (abs(unique_values.upper) <= 2147483647 and
                            abs(unique_values.lower) <= 2147483647 and
                            abs(unique_values.title) <= 2147483647)
            else:
                # =======================================================================================
                # === Violet: Store list of tuples to convert them later to 'UnicodeData.CaseMapping' ===
                # =======================================================================================

                # This happens either when:
                # 1) some character maps to more than one character in uppercase,
                # lowercase, or titlecase
                # 2) casefolded version of the character is different from the
                # lowercase.
                # The extra characters are stored in a different array.
                unique_values.flags |= EXTENDED_CASE_MASK

                unique_values.lower = len(extra_casing)
                extra_casing.append(special_casing[0])

                if case_folding != special_casing[0]:
                    unique_values.fold = len(extra_casing)
                    extra_casing.append(case_folding)

                unique_values.upper = len(extra_casing)
                extra_casing.append(special_casing[2])

                # Title is probably equal to upper.
                if special_casing[1] == special_casing[2]:
                    unique_values.title = unique_values.upper
                else:
                    unique_values.title = len(extra_casing)
                    extra_casing.append(special_casing[1])

            # === Decimal digit, integer digit ===
            if record[6]:
                unique_values.flags |= DECIMAL_MASK
                unique_values.decimal = int(record[6])

            if record[7]:
                unique_values.flags |= DIGIT_MASK
                unique_values.digit = int(record[7])

            if record[8]:
                unique_values.flags |= NUMERIC_MASK
                numeric.setdefault(record[8], []).append(char)

            # === Add entry to index and item tables ===
            i = unique_values_to_index.get(unique_values)
            if i is None:
                unique_values_to_index[unique_values] = len(unique_property_values)
                i = len(unique_property_values)
                unique_property_values.append(unique_values)

            index_by_char[char] = i

    print(len(unique_property_values), "unique character type entries")
    print(sum(map(len, numeric.values())), "numeric code points")
    print(len(spaces), "whitespace code points")
    print(len(linebreaks), "linebreak code points")
    print(len(extra_casing), "extended case array")

    # =================================================
    # === Violet: Printing modifications start here ===
    # =================================================

    print("--- Writing", FILE, "...")

    fp = open(FILE, "w")
    print(f'''\
{generated_warning(__file__)}

// swiftlint:disable trailing_comma
// swiftlint:disable number_separator
// swiftlint:disable function_body_length
// swiftlint:disable file_length
// swiftformat:disable all

private typealias Record = UnicodeData.Record
private typealias CaseMapping = UnicodeData.CaseMapping
''', file=fp)

    print("/// A list of unique character type descriptors", file=fp)
    print("internal let _PyUnicode_TypeRecords: [UnicodeData.Record] = [", file=fp)
    for v in unique_property_values:
        fold = v.fold if v.fold else 'nil'
        print(f'  Record(upper: {v.upper}, lower: {v.lower}, title: {v.title}, fold: {fold}, decimal: {v.decimal}, digit: {v.digit}, flags: {v.flags}),', file=fp)
    print("]", file=fp)
    print(file=fp)

    print("/// Extended case mappings", file=fp)
    print("internal let _PyUnicode_ExtendedCase: [UnicodeData.CaseMapping] = [", file=fp)
    for scalar_values in extra_casing:
        s = ", ".join(map(lambda i: str(i), scalar_values))
        print("    CaseMapping(%s)," % s, file=fp)
        pass
    print("]", file=fp)
    print(file=fp)

    # split decomposition index table
    index1, index2, shift = splitbins(index_by_char, trace)

    print("/// Type indexes", file=fp)
    print("internal let SHIFT =", shift, file=fp)
    print(file=fp)

    Array("index1", index1).dump(fp, trace)
    Array("index2", index2).dump(fp, trace)

    # Generate code for _PyUnicode_ToNumeric()
    # numeric_items = sorted(numeric.items())
    # print('/// Returns the numeric value as double for Unicode characters', file=fp)
    # print('/// having this property, -1.0 otherwise.', file=fp)
    # print('internal func _PyUnicode_ToNumeric(_ ch: UnicodeScalar) -> Double {', file=fp)
    # print('    switch ch.value {', file=fp)
    # for value, codepoints in numeric_items:
    #     # Turn text into float literals
    #     parts = value.split('/')
    #     parts = [repr(float(part)) for part in parts]
    #     value = '/'.join(parts)

    #     assert len(codepoints) != 0

    #     if len(codepoints) == 1:
    #         codepoint = codepoints[0]
    #         print('    case 0x%04X:' % (codepoint,), file=fp)
    #         print('        return %s' % (value,), file=fp)
    #     else:
    #         codepoints.sort()
    #         for index, codepoint in enumerate(codepoints):
    #             is_first = index == 0
    #             is_last = index == len(codepoints) - 1

    #             if is_first:
    #                 print('    case 0x%04X,' % (codepoint), file=fp)
    #             elif is_last:
    #                 print('         0x%04X:' % (codepoint,), file=fp)
    #             else:
    #                 print('         0x%04X,' % (codepoint,), file=fp)

    #         print('        return %s' % (value,), file=fp)

    # print('    default:', file=fp)
    # print('        return -1.0', file=fp)
    # print('    }', file=fp)
    # print('}', file=fp)
    # print(file=fp)

    # Generate code for _PyUnicode_IsWhitespace()
    print("/// Returns 1 for Unicode characters having the bidirectional", file=fp)
    print("/// type 'WS', 'B' or 'S' or the category 'Zs', 0 otherwise.", file=fp)
    print('internal func _PyUnicode_IsWhitespace(_ ch: UnicodeScalar) -> Bool {', file=fp)
    print('    switch ch.value {', file=fp)

    for index_by_char, codepoint in enumerate(sorted(spaces)):
        is_first = index_by_char == 0
        is_last = index_by_char == len(spaces) - 1

        if is_first:
            print('    case 0x%04X,' % (codepoint), file=fp)
        elif is_last:
            print('         0x%04X:' % (codepoint,), file=fp)
        else:
            print('         0x%04X,' % (codepoint,), file=fp)
    print('        return true', file=fp)

    print('    default:', file=fp)
    print('        return false', file=fp)
    print('    }', file=fp)
    print('}', file=fp)
    print(file=fp)

    # Generate code for _PyUnicode_IsLineBreak()
    print("/// Returns 1 for Unicode characters having the line break", file=fp)
    print("/// property 'BK', 'CR', 'LF' or 'NL' or having bidirectional", file=fp)
    print("/// type 'B', 0 otherwise.", file=fp)
    print('internal func _PyUnicode_IsLineBreak(_ ch: UnicodeScalar) -> Bool {', file=fp)
    print('    switch ch.value {', file=fp)
    for index_by_char, codepoint in enumerate(sorted(linebreaks)):
        is_first = index_by_char == 0
        is_last = index_by_char == len(linebreaks) - 1

        if is_first:
            print('    case 0x%04X,' % (codepoint), file=fp)
        elif is_last:
            print('         0x%04X:' % (codepoint,), file=fp)
        else:
            print('         0x%04X,' % (codepoint,), file=fp)
    print('        return true', file=fp)

    print('    default:', file=fp)
    print('        return false', file=fp)
    print('    }', file=fp)
    print('}', file=fp)

    fp.close()


class Array:

    def __init__(self, name, data):
        self.name = name
        self.data = data

    def dump(self, file, trace=0):
        # write data to file, as a C array
        size = getsize(self.data)
        if trace:
            print(self.name+":", size*len(self.data), "bytes", file=sys.stderr)

        typ = ''
        if size == 1:
            typ = "UInt8"
        elif size == 2:
            typ = "UInt16"
        else:
            typ = "UInt32"

        file.write("internal let " + self.name + ": [" + typ + "] = [\n")
        if self.data:
            s = "    "
            for item in self.data:
                i = str(item) + ", "
                if len(s) + len(i) > 78:
                    file.write(s.rstrip() + "\n")
                    s = "    " + i
                else:
                    s = s + i

            if s.strip():
                file.write(s.rstrip() + "\n")

        file.write("]\n\n")


def getsize(data):
    # return smallest possible integer size for the given array
    maxdata = max(data)
    if maxdata < 256:
        return 1
    elif maxdata < 65536:
        return 2
    else:
        return 4


def splitbins(t, trace=0):
    """t, trace=0 -> (t1, t2, shift).  Split a table to save space.

    t is a sequence of ints.  This function can be useful to save space if
    many of the ints are the same.  t1 and t2 are lists of ints, and shift
    is an int, chosen to minimize the combined size of t1 and t2 (in C
    code), and where for each i in range(len(t)),
        t[i] == t2[(t1[i >> shift] << shift) + (i & mask)]
    where mask is a bitmask isolating the last "shift" bits.

    If optional arg trace is non-zero (default zero), progress info
    is printed to sys.stderr.  The higher the value, the more info
    you'll get.
    """

    if trace:
        def dump(t1, t2, shift, bytes):
            print("%d+%d bins at shift %d; %d bytes" % (
                len(t1), len(t2), shift, bytes), file=sys.stderr)
        print("Size of original table:", len(t)*getsize(t),
              "bytes", file=sys.stderr)
    n = len(t)-1    # last valid index
    maxshift = 0    # the most we can shift n and still have something left
    if n > 0:
        while n >> 1:
            n >>= 1
            maxshift += 1
    del n
    bytes = sys.maxsize  # smallest total size so far
    t = tuple(t)    # so slices can be dict keys
    for shift in range(maxshift + 1):
        t1 = []
        t2 = []
        size = 2**shift
        bincache = {}
        for i in range(0, len(t), size):
            bin = t[i:i+size]
            index = bincache.get(bin)
            if index is None:
                index = len(t2)
                bincache[bin] = index
                t2.extend(bin)
            t1.append(index >> shift)
        # determine memory size
        b = len(t1)*getsize(t1) + len(t2)*getsize(t2)
        if trace > 1:
            dump(t1, t2, shift, b)
        if b < bytes:
            best = t1, t2, shift
            bytes = b
    t1, t2, shift = best
    if trace:
        print("Best:", end=' ', file=sys.stderr)
        dump(t1, t2, shift, bytes)
    if __debug__:
        # exhaustively verify that the decomposition is correct
        mask = ~((~0) << shift)  # i.e., low-bit mask of shift bits
        for i in range(len(t)):
            assert t[i] == t2[(t1[i >> shift] << shift) + (i & mask)]
    return best


if __name__ == "__main__":
    args = sys.argv
    if len(args) < 2:
        raise ValueError('Missing output file path argument')

    file_path = args[1]
    maketables(1, file_path)
