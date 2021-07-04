"Based on 'Tools/unicode/makeunicodedata.py' from CPython."

from genericpath import isfile
import sys
from typing import List, Tuple

from UnicodeData import UnicodeData

SCRIPT = sys.argv[0]
VERSION = "3.3"

UNIDATA_VERSION = "11.0.0"

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


def maketables(trace, file_path: str):
    # 'UnicodeData' class is taken directly from CPython.
    unicode = UnicodeData(UNIDATA_VERSION)

    # We only need 'makeunicodetype' (without 'makeunicodename' or 'makeunicodedata')
    makeunicodetype(unicode, trace, file_path)


# --------------------------------------------------------------------
# unicode character type tables

def makeunicodetype(unicode: UnicodeData, trace: int, file_path: str):

    # ==============================================================
    # === Violet: Every change for Violet is commented like this ===
    # ==============================================================

    FILE = file_path

    print("--- Preparing", FILE, "...")

    # extract unicode types
    dummy = (0, 0, 0, 0, 0, 0)
    table = [dummy]
    cache = {0: dummy}
    index = [0] * len(unicode.chars)
    numeric = {}
    spaces = []
    linebreaks = []

    # ==============================================================================================
    # === Violet: We are using list of tuples to convert them later to 'UnicodeData.CaseMapping' ===
    # ==============================================================================================
    extra_casing: List[Tuple[int]] = []

    for char in unicode.chars:
        record = unicode.table[char]
        if record:
            # extract database properties
            category = record[2]
            bidirectional = record[4]
            properties = record[16]
            flags = 0
            delta = True

            # === Mask ===
            if category in ["Lm", "Lt", "Lu", "Ll", "Lo"]:
                flags |= ALPHA_MASK
            if "Lowercase" in properties:
                flags |= LOWER_MASK
            if 'Line_Break' in properties or bidirectional == "B":
                flags |= LINEBREAK_MASK
                linebreaks.append(char)
            if category == "Zs" or bidirectional in ("WS", "B", "S"):
                flags |= SPACE_MASK
                spaces.append(char)
            if category == "Lt":
                flags |= TITLE_MASK
            if "Uppercase" in properties:
                flags |= UPPER_MASK
            if char == ord(" ") or category[0] not in ("C", "Z"):
                flags |= PRINTABLE_MASK
            if "XID_Start" in properties:
                flags |= XID_START_MASK
            if "XID_Continue" in properties:
                flags |= XID_CONTINUE_MASK
            if "Cased" in properties:
                flags |= CASED_MASK
            if "Case_Ignorable" in properties:
                flags |= CASE_IGNORABLE_MASK

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
                    upper = lower = title = 0
                else:
                    upper = upper - char  # Store diff
                    lower = lower - char
                    title = title - char
                    assert (abs(upper) <= 2147483647 and
                            abs(lower) <= 2147483647 and
                            abs(title) <= 2147483647)
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
                flags |= EXTENDED_CASE_MASK

                lower = len(extra_casing)
                extra_casing.append(special_casing[0])

                # if case_folding != special_casing[0]:
                #     lower |= len(case_folding) << 20
                #     extra_casing.extend(case_folding)

                upper = len(extra_casing)
                extra_casing.append(special_casing[2])

                # Title is probably equal to upper.
                if special_casing[1] == special_casing[2]:
                    title = upper
                else:
                    title = len(extra_casing)
                    extra_casing.append(special_casing[1])

            # === Decimal digit, integer digit ===
            decimal = 0
            if record[6]:
                flags |= DECIMAL_MASK
                decimal = int(record[6])

            digit = 0
            if record[7]:
                flags |= DIGIT_MASK
                digit = int(record[7])

            if record[8]:
                flags |= NUMERIC_MASK
                numeric.setdefault(record[8], []).append(char)

            item = (upper, lower, title, decimal, digit, flags)

            # add entry to index and item tables
            i = cache.get(item)
            if i is None:
                cache[item] = i = len(table)
                table.append(item)

            index[char] = i

    print(len(table), "unique character type entries")
    print(sum(map(len, numeric.values())), "numeric code points")
    print(len(spaces), "whitespace code points")
    print(len(linebreaks), "linebreak code points")
    print(len(extra_casing), "extended case array")

    # =================================================
    # === Violet: Printing modifications start here ===
    # =================================================

    print("--- Writing", FILE, "...")

    script_path = __file__
    script_path_scripts_index = script_path.index('/Scripts')
    if script_path_scripts_index != -1:
        script_path = script_path[script_path_scripts_index:]

    fp = open(FILE, "w")
    print(f'''\
// ==========================================================
// Automatically generated from: {script_path}
// DO NOT EDIT!
// ==========================================================

// swiftlint:disable trailing_comma
// swiftlint:disable number_separator
// swiftlint:disable function_body_length
// swiftlint:disable file_length

private typealias Record = UnicodeData.Record
private typealias CaseMapping = UnicodeData.CaseMapping
''', file=fp)

    print("/// A list of unique character type descriptors", file=fp)
    print("internal let _PyUnicode_TypeRecords: [UnicodeData.Record] = [", file=fp)
    for item in table:
        print('  Record(upper: %d, lower: %d, title: %d, decimal: %d, digit: %d, flags: %d),' % item, file=fp)
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
    index1, index2, shift = splitbins(index, trace)

    print("/// Type indexes", file=fp)
    print("internal let SHIFT =", shift, file=fp)
    print(file=fp)

    Array("index1", index1).dump(fp, trace)
    Array("index2", index2).dump(fp, trace)

    # Generate code for _PyUnicode_ToNumeric()
    numeric_items = sorted(numeric.items())
    print('/// Returns the numeric value as double for Unicode characters', file=fp)
    print('/// having this property, -1.0 otherwise.', file=fp)
    print('internal func _PyUnicode_ToNumeric(_ ch: UnicodeScalar) -> Double {', file=fp)
    print('    switch ch.value {', file=fp)
    for value, codepoints in numeric_items:
        # Turn text into float literals
        parts = value.split('/')
        parts = [repr(float(part)) for part in parts]
        value = '/'.join(parts)

        assert len(codepoints) != 0

        if len(codepoints) == 1:
            codepoint = codepoints[0]
            print('    case 0x%04X:' % (codepoint,), file=fp)
            print('        return %s' % (value,), file=fp)
        else:
            codepoints.sort()
            for index, codepoint in enumerate(codepoints):
                is_first = index == 0
                is_last = index == len(codepoints) - 1

                if is_first:
                    print('    case 0x%04X,' % (codepoint), file=fp)
                elif is_last:
                    print('         0x%04X:' % (codepoint,), file=fp)
                else:
                    print('         0x%04X,' % (codepoint,), file=fp)

            print('        return %s' % (value,), file=fp)

    print('    default:', file=fp)
    print('        return -1.0', file=fp)
    print('    }', file=fp)
    print('}', file=fp)
    print(file=fp)

    # Generate code for _PyUnicode_IsWhitespace()
    print("/// Returns 1 for Unicode characters having the bidirectional", file=fp)
    print("/// type 'WS', 'B' or 'S' or the category 'Zs', 0 otherwise.", file=fp)
    print('internal func _PyUnicode_IsWhitespace(_ ch: UnicodeScalar) -> Bool {', file=fp)
    print('    switch ch.value {', file=fp)

    for index, codepoint in enumerate(sorted(spaces)):
        is_first = index == 0
        is_last = index == len(spaces) - 1

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
    for index, codepoint in enumerate(sorted(linebreaks)):
        is_first = index == 0
        is_last = index == len(linebreaks) - 1

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
