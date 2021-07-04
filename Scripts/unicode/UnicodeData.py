"Based on 'Tools/unicode/makeunicodedata.py' from CPython."

# cSpell:ignore decomp aybe NFKD NFKC

import os
import sys
import zipfile

SCRIPT = sys.argv[0]
VERSION = "3.3"

# The Unicode Database
UNICODE_DATA = "UnicodeData%s.txt"
COMPOSITION_EXCLUSIONS = "CompositionExclusions%s.txt"
EASTASIAN_WIDTH = "EastAsianWidth%s.txt"
UNIHAN = "Unihan%s.zip"
DERIVED_CORE_PROPERTIES = "DerivedCoreProperties%s.txt"
DERIVEDNORMALIZATION_PROPS = "DerivedNormalizationProps%s.txt"
LINE_BREAK = "LineBreak%s.txt"
NAME_ALIASES = "NameAliases%s.txt"
NAMED_SEQUENCES = "NamedSequences%s.txt"
SPECIAL_CASING = "SpecialCasing%s.txt"
CASE_FOLDING = "CaseFolding%s.txt"

# Private Use Areas -- in planes 1, 15, 16
PUA_1 = range(0xE000, 0xF900)
PUA_15 = range(0xF0000, 0xFFFFE)
PUA_16 = range(0x100000, 0x10FFFE)

# we use this ranges of PUA_15 to store name aliases and named sequences
NAME_ALIASES_START = 0xF0000
NAMED_SEQUENCES_START = 0xF0200

CATEGORY_NAMES = ["Cn", "Lu", "Ll", "Lt", "Mn", "Mc", "Me", "Nd",
                  "Nl", "No", "Zs", "Zl", "Zp", "Cc", "Cf", "Cs", "Co", "Cn", "Lm",
                  "Lo", "Pc", "Pd", "Ps", "Pe", "Pi", "Pf", "Po", "Sm", "Sc", "Sk",
                  "So"]

BIDIRECTIONAL_NAMES = ["", "L", "LRE", "LRO", "R", "AL", "RLE", "RLO",
                       "PDF", "EN", "ES", "ET", "AN", "CS", "NSM", "BN", "B", "S", "WS",
                       "ON", "LRI", "RLI", "FSI", "PDI"]

EASTASIANWIDTH_NAMES = ["F", "H", "W", "Na", "A", "N"]

MANDATORY_LINE_BREAKS = ["BK", "CR", "LF", "NL"]

# these ranges need to match unicodedata.c:is_unified_ideograph
cjk_ranges = [
    ('3400', '4DB5'),
    ('4E00', '9FEF'),
    ('20000', '2A6D6'),
    ('2A700', '2B734'),
    ('2B740', '2B81D'),
    ('2B820', '2CEA1'),
    ('2CEB0', '2EBE0'),
]


class UnicodeData:
    # Record structure:
    # [ID, name, category, combining, bidi, decomp,  (6)
    #  decimal, digit, numeric, bidi-mirrored, Unicode-1-name, (11)
    #  ISO-comment, uppercase, lowercase, titlecase, ea-width, (16)
    #  derived-props] (17)

    def __init__(self, version,
                 linebreakprops=False,
                 expand=1,
                 cjk_check=True):
        self.changed = []
        table = [None] * 0x110000
        with open_data(UNICODE_DATA, version) as file:
            while 1:
                s = file.readline()
                if not s:
                    break
                s = s.strip().split(";")
                char = int(s[0], 16)
                table[char] = s

        cjk_ranges_found = []

        # expand first-last ranges
        if expand:
            field = None
            for i in range(0, 0x110000):
                s = table[i]
                if s:
                    if s[1][-6:] == "First>":
                        s[1] = ""
                        field = s
                    elif s[1][-5:] == "Last>":
                        if s[1].startswith("<CJK Ideograph"):
                            cjk_ranges_found.append((field[0],
                                                     s[0]))
                        s[1] = ""
                        field = None
                elif field:
                    f2 = field[:]
                    f2[0] = "%X" % i
                    table[i] = f2
            if cjk_check and cjk_ranges != cjk_ranges_found:
                raise ValueError("CJK ranges deviate: have %r" % cjk_ranges_found)

        # public attributes
        self.filename = UNICODE_DATA % ''
        self.table = table
        self.chars = list(range(0x110000))  # unicode 3.2

        # check for name aliases and named sequences, see #12753
        # aliases and named sequences are not in 3.2.0
        if version != '3.2.0':
            self.aliases = []
            # store aliases in the Private Use Area 15, in range U+F0000..U+F00FF,
            # in order to take advantage of the compression and lookup
            # algorithms used for the other characters
            pua_index = NAME_ALIASES_START
            with open_data(NAME_ALIASES, version) as file:
                for s in file:
                    s = s.strip()
                    if not s or s.startswith('#'):
                        continue
                    char, name, abbrev = s.split(';')
                    char = int(char, 16)
                    self.aliases.append((name, char))
                    # also store the name in the PUA 1
                    self.table[pua_index][1] = name
                    pua_index += 1
            assert pua_index - NAME_ALIASES_START == len(self.aliases)

            self.named_sequences = []
            # store named sequences in the PUA 1, in range U+F0100..,
            # in order to take advantage of the compression and lookup
            # algorithms used for the other characters.

            assert pua_index < NAMED_SEQUENCES_START
            pua_index = NAMED_SEQUENCES_START
            with open_data(NAMED_SEQUENCES, version) as file:
                for s in file:
                    s = s.strip()
                    if not s or s.startswith('#'):
                        continue
                    name, chars = s.split(';')
                    chars = tuple(int(char, 16) for char in chars.split())
                    # check that the structure defined in makeunicodename is OK
                    assert 2 <= len(chars) <= 4, "change the Py_UCS2 array size"
                    assert all(c <= 0xFFFF for c in chars), ("use Py_UCS4 in "
                                                             "the NamedSequence struct and in unicodedata_lookup")
                    self.named_sequences.append((name, chars))
                    # also store these in the PUA 1
                    self.table[pua_index][1] = name
                    pua_index += 1
            assert pua_index - NAMED_SEQUENCES_START == len(self.named_sequences)

        self.exclusions = {}
        with open_data(COMPOSITION_EXCLUSIONS, version) as file:
            for s in file:
                s = s.strip()
                if not s:
                    continue
                if s[0] == '#':
                    continue
                char = int(s.split()[0], 16)
                self.exclusions[char] = 1

        widths = [None] * 0x110000
        with open_data(EASTASIAN_WIDTH, version) as file:
            for s in file:
                s = s.strip()
                if not s:
                    continue
                if s[0] == '#':
                    continue
                s = s.split()[0].split(';')
                if '..' in s[0]:
                    first, last = [int(c, 16) for c in s[0].split('..')]
                    chars = list(range(first, last+1))
                else:
                    chars = [int(s[0], 16)]
                for char in chars:
                    widths[char] = s[1]

        for i in range(0, 0x110000):
            if table[i] is not None:
                table[i].append(widths[i])

        for i in range(0, 0x110000):
            if table[i] is not None:
                table[i].append(set())

        with open_data(DERIVED_CORE_PROPERTIES, version) as file:
            for s in file:
                s = s.split('#', 1)[0].strip()
                if not s:
                    continue

                r, p = s.split(";")
                r = r.strip()
                p = p.strip()
                if ".." in r:
                    first, last = [int(c, 16) for c in r.split('..')]
                    chars = list(range(first, last+1))
                else:
                    chars = [int(r, 16)]
                for char in chars:
                    if table[char]:
                        # Some properties (e.g. Default_Ignorable_Code_Point)
                        # apply to unassigned code points; ignore them
                        table[char][-1].add(p)

        with open_data(LINE_BREAK, version) as file:
            for s in file:
                s = s.partition('#')[0]
                s = [i.strip() for i in s.split(';')]
                if len(s) < 2 or s[1] not in MANDATORY_LINE_BREAKS:
                    continue
                if '..' not in s[0]:
                    first = last = int(s[0], 16)
                else:
                    first, last = [int(c, 16) for c in s[0].split('..')]
                for char in range(first, last+1):
                    table[char][-1].add('Line_Break')

        # We only want the quickcheck properties
        # Format: NF?_QC; Y(es)/N(o)/M(aybe)
        # Yes is the default, hence only N and M occur
        # In 3.2.0, the format was different (NF?_NO)
        # The parsing will incorrectly determine these as
        # "yes", however, unicodedata.c will not perform quickchecks
        # for older versions, and no delta records will be created.
        quickchecks = [0] * 0x110000
        qc_order = 'NFD_QC NFKD_QC NFC_QC NFKC_QC'.split()
        with open_data(DERIVEDNORMALIZATION_PROPS, version) as file:
            for s in file:
                if '#' in s:
                    s = s[:s.index('#')]
                s = [i.strip() for i in s.split(';')]
                if len(s) < 2 or s[1] not in qc_order:
                    continue
                quickcheck = 'MN'.index(s[2]) + 1  # Maybe or No
                quickcheck_shift = qc_order.index(s[1])*2
                quickcheck <<= quickcheck_shift
                if '..' not in s[0]:
                    first = last = int(s[0], 16)
                else:
                    first, last = [int(c, 16) for c in s[0].split('..')]
                for char in range(first, last+1):
                    assert not (quickchecks[char] >> quickcheck_shift) & 3
                    quickchecks[char] |= quickcheck
        for i in range(0, 0x110000):
            if table[i] is not None:
                table[i].append(quickchecks[i])

        with open_data(UNIHAN, version) as file:
            zip = zipfile.ZipFile(file)
            if version == '3.2.0':
                data = zip.open('Unihan-3.2.0.txt').read()
            else:
                data = zip.open('Unihan_NumericValues.txt').read()
        for line in data.decode("utf-8").splitlines():
            if not line.startswith('U+'):
                continue
            code, tag, value = line.split(None, 3)[:3]
            if tag not in ('kAccountingNumeric', 'kPrimaryNumeric',
                           'kOtherNumeric'):
                continue
            value = value.strip().replace(',', '')
            i = int(code[2:], 16)
            # Patch the numeric field
            if table[i] is not None:
                table[i][8] = value
        sc = self.special_casing = {}
        with open_data(SPECIAL_CASING, version) as file:
            for s in file:
                s = s[:-1].split('#', 1)[0]
                if not s:
                    continue
                data = s.split("; ")
                if data[4]:
                    # We ignore all conditionals (since they depend on
                    # languages) except for one, which is hardcoded. See
                    # handle_capital_sigma in unicodeobject.c.
                    continue
                c = int(data[0], 16)
                lower = [int(char, 16) for char in data[1].split()]
                title = [int(char, 16) for char in data[2].split()]
                upper = [int(char, 16) for char in data[3].split()]
                sc[c] = (lower, title, upper)
        cf = self.case_folding = {}
        if version != '3.2.0':
            with open_data(CASE_FOLDING, version) as file:
                for s in file:
                    s = s[:-1].split('#', 1)[0]
                    if not s:
                        continue
                    data = s.split("; ")
                    if data[1] in "CF":
                        c = int(data[0], 16)
                        cf[c] = [int(char, 16) for char in data[2].split()]

    def uselatin1(self):
        # restrict character range to ISO Latin 1
        self.chars = list(range(256))


def open_data(template: str, version: str):
    local_name = template % ('-' + version,)
    current_dir = os.path.dirname(__file__)
    local = os.path.join(current_dir, local_name)

    if not os.path.exists(local):
        import urllib.request
        if version == '3.2.0':
            # irregular url structure
            url = 'http://www.unicode.org/Public/3.2-Update/' + local
        else:
            url = ('http://www.unicode.org/Public/%s/ucd/' + template) % (version, '')
        urllib.request.urlretrieve(url, filename=local)

    if local.endswith('.txt'):
        return open(local, encoding='utf-8')
    else:
        # Unihan.zip
        return open(local, 'rb')
