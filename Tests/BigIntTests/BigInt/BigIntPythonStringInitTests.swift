import XCTest
@testable import BigInt

// In CPython:
// test -> test_int.py

// swiftlint:disable number_separator
// swiftlint:disable function_body_length
// swiftformat:disable numberFormatting

// Below the test class there is a layer of adapters!

/// Basically `Python` tests from `class IntTestCases(unittest.TestCase)`.
class BigIntPythonStringInitTests: XCTestCase {

  // MARK: - test_basic

  /// CPython: `L`
  private let values: [(string: String, expected: BigInt)] = [
    ("0", 0),
    ("1", 1),
    ("9", 9),
    ("10", 10),
    ("99", 99),
    ("100", 100),
    ("314", 314),
//    (" 314", 314), skip because '- 314' is error
    ("314 ", 314),
//    ("  \t\t  314  \t\t  ", 314), skip because '-  \t\t  314  \t\t  ' is error
    (repr(sys.maxsize), sys.maxsize)
  ]

  /// CPython: `L`
  private let valuesError = [
    "  1x",
//    ("  1  "), skip  because it is an error only if we have sign, otherwise 1
    "  1\02  ",
    "",
    " ",
    "  \t\t  ",
    "\u{0200}"
  ]

  /// def test_basic(self)
  func test_basic() {
    self.assertEqual(int("-3"), -3)
    self.assertEqual(int(" -3 "), -3)

    let emSpace = "\u{2003}"
    let enSpace = "\u{2002}"
    self.assertEqual(int("\(emSpace)-3\(enSpace)"), -3)

    // Different base:
    self.assertEqual(int("10", 16), 16)

    // Test conversion from strings and various anomalies
    // [Violet] we have separate 'values' and 'valuesError', so we reordered loops
    for sign in ["", "+", "-"] {
      for prefix in ["", " ", "\t", "  \t\t  "] {
        for (s, v) in self.values {
          let ss = prefix + sign + s
          let vv = sign == "-" ? -v : v
          self.assertEqual(int(ss), vv)
        }

        for s in self.valuesError {
          let ss = prefix + sign + s
          self.assertRaises(ss)
        }
      }
    }

    self.assertEqual(int("0o123", 0), 83)
    self.assertEqual(int("0x123", 16), 291)

    // Bug 1679: "0x" is not a valid hex literal
    self.assertRaises("0x", 16)
    self.assertRaises("0x", 0)

    self.assertRaises("0o", 8)
    self.assertRaises("0o", 0)

    self.assertRaises("0b", 2)
    self.assertRaises("0b", 0)

    // SF bug 1334662: int(string, base) wrong answers
    // Various representations of 2**32 evaluated to 0
    // rather than 2**32 in previous versions

    // cspell:disable
    self.assertEqual(int("100000000000000000000000000000000", 2), 4294967296)
    self.assertEqual(int("102002022201221111211", 3), 4294967296)
    self.assertEqual(int("10000000000000000", 4), 4294967296)
    self.assertEqual(int("32244002423141", 5), 4294967296)
    self.assertEqual(int("1550104015504", 6), 4294967296)
    self.assertEqual(int("211301422354", 7), 4294967296)
    self.assertEqual(int("40000000000", 8), 4294967296)
    self.assertEqual(int("12068657454", 9), 4294967296)
    self.assertEqual(int("4294967296", 10), 4294967296)
    self.assertEqual(int("1904440554", 11), 4294967296)
    self.assertEqual(int("9ba461594", 12), 4294967296)
    self.assertEqual(int("535a79889", 13), 4294967296)
    self.assertEqual(int("2ca5b7464", 14), 4294967296)
    self.assertEqual(int("1a20dcd81", 15), 4294967296)
    self.assertEqual(int("100000000", 16), 4294967296)
    self.assertEqual(int("a7ffda91", 17), 4294967296)
    self.assertEqual(int("704he7g4", 18), 4294967296)
    self.assertEqual(int("4f5aff66", 19), 4294967296)
    self.assertEqual(int("3723ai4g", 20), 4294967296)
    self.assertEqual(int("281d55i4", 21), 4294967296)
    self.assertEqual(int("1fj8b184", 22), 4294967296)
    self.assertEqual(int("1606k7ic", 23), 4294967296)
    self.assertEqual(int("mb994ag", 24), 4294967296)
    self.assertEqual(int("hek2mgl", 25), 4294967296)
    self.assertEqual(int("dnchbnm", 26), 4294967296)
    self.assertEqual(int("b28jpdm", 27), 4294967296)
    self.assertEqual(int("8pfgih4", 28), 4294967296)
    self.assertEqual(int("76beigg", 29), 4294967296)
    self.assertEqual(int("5qmcpqg", 30), 4294967296)
    self.assertEqual(int("4q0jto4", 31), 4294967296)
    self.assertEqual(int("4000000", 32), 4294967296)
    self.assertEqual(int("3aokq94", 33), 4294967296)
    self.assertEqual(int("2qhxjli", 34), 4294967296)
    self.assertEqual(int("2br45qb", 35), 4294967296)
    self.assertEqual(int("1z141z4", 36), 4294967296)
    // cspell:enable

    // tests with base 0
    // this fails on 3.0, but in 2.x the old octal syntax is allowed
    self.assertEqual(int(" 0o123  ", 0), 83)
    self.assertEqual(int(" 0o123  ", 0), 83)
    self.assertEqual(int("000", 0), 0)
    self.assertEqual(int("0o123", 0), 83)
    self.assertEqual(int("0x123", 0), 291)
    self.assertEqual(int("0b100", 0), 4)
    self.assertEqual(int(" 0O123   ", 0), 83)
    self.assertEqual(int(" 0X123  ", 0), 291)
    self.assertEqual(int(" 0B100 ", 0), 4)

    // without base still base 10
    self.assertEqual(int("0123"), 123)
    self.assertEqual(int("0123", 10), 123)

    // tests with prefix and base != 0
    self.assertEqual(int("0x123", 16), 291)
    self.assertEqual(int("0o123", 8), 83)
    self.assertEqual(int("0b100", 2), 4)
    self.assertEqual(int("0X123", 16), 291)
    self.assertEqual(int("0O123", 8), 83)
    self.assertEqual(int("0B100", 2), 4)

    // the code has special checks for the first character after the
    //  type prefix
    self.assertRaises("0b2", 2)
    self.assertRaises("0b02", 2)
    self.assertRaises("0B2", 2)
    self.assertRaises("0B02", 2)
    self.assertRaises("0o8", 8)
    self.assertRaises("0o08", 8)
    self.assertRaises("0O8", 8)
    self.assertRaises("0O08", 8)
    self.assertRaises("0xg", 16)
    self.assertRaises("0x0g", 16)
    self.assertRaises("0Xg", 16)
    self.assertRaises("0X0g", 16)

    // SF bug 1334662: int(string, base) wrong answers
    // Checks for proper evaluation of 2**32 + 1
    // cspell:disable
    self.assertEqual(int("100000000000000000000000000000001", 2), 4294967297)
    self.assertEqual(int("102002022201221111212", 3), 4294967297)
    self.assertEqual(int("10000000000000001", 4), 4294967297)
    self.assertEqual(int("32244002423142", 5), 4294967297)
    self.assertEqual(int("1550104015505", 6), 4294967297)
    self.assertEqual(int("211301422355", 7), 4294967297)
    self.assertEqual(int("40000000001", 8), 4294967297)
    self.assertEqual(int("12068657455", 9), 4294967297)
    self.assertEqual(int("4294967297", 10), 4294967297)
    self.assertEqual(int("1904440555", 11), 4294967297)
    self.assertEqual(int("9ba461595", 12), 4294967297)
    self.assertEqual(int("535a7988a", 13), 4294967297)
    self.assertEqual(int("2ca5b7465", 14), 4294967297)
    self.assertEqual(int("1a20dcd82", 15), 4294967297)
    self.assertEqual(int("100000001", 16), 4294967297)
    self.assertEqual(int("a7ffda92", 17), 4294967297)
    self.assertEqual(int("704he7g5", 18), 4294967297)
    self.assertEqual(int("4f5aff67", 19), 4294967297)
    self.assertEqual(int("3723ai4h", 20), 4294967297)
    self.assertEqual(int("281d55i5", 21), 4294967297)
    self.assertEqual(int("1fj8b185", 22), 4294967297)
    self.assertEqual(int("1606k7id", 23), 4294967297)
    self.assertEqual(int("mb994ah", 24), 4294967297)
    self.assertEqual(int("hek2mgm", 25), 4294967297)
    self.assertEqual(int("dnchbnn", 26), 4294967297)
    self.assertEqual(int("b28jpdn", 27), 4294967297)
    self.assertEqual(int("8pfgih5", 28), 4294967297)
    self.assertEqual(int("76beigh", 29), 4294967297)
    self.assertEqual(int("5qmcpqh", 30), 4294967297)
    self.assertEqual(int("4q0jto5", 31), 4294967297)
    self.assertEqual(int("4000001", 32), 4294967297)
    self.assertEqual(int("3aokq95", 33), 4294967297)
    self.assertEqual(int("2qhxjlj", 34), 4294967297)
    self.assertEqual(int("2br45qc", 35), 4294967297)
    self.assertEqual(int("1z141z5", 36), 4294967297)
    // cspell:enable
  }

  // MARK: - test_underscores

  // def test_underscores(self)
  func test_underscores() {
    for lit in VALID_UNDERSCORE_LITERALS {
      if lit.contains(where: self.isDotExponentOrImag(character:)) {
        continue
      }

      do {
        // Just check if we get the same thing as without underscores
        let noUnderscoresString = lit.replacingOccurrences(of: "_", with: "")
        let noUnderscores = try BigInt(
          parseUsingPythonRules: noUnderscoresString,
          base: 0
        )

        self.assertEqual(int(lit, 0), noUnderscores)
      } catch {
        XCTFail("'\(lit)', error: \(error)")
      }
    }

    for lit in INVALID_UNDERSCORE_LITERALS {
      if lit.contains(where: self.isDotExponentOrImag(character:)) {
        continue
      }

      self.assertRaises(lit, 0)
    }

    // Additional test cases with bases != 0, only for the constructor:
    self.assertEqual(int("1_00", 3), 9)
    self.assertEqual(int("0_100"), 100) // not valid as a literal!
    self.assertEqual(int("1_00"), 100) // byte underscore
    self.assertRaises("_100")
    self.assertRaises("+_100")
    self.assertRaises("1__00")
    self.assertRaises("100_")
  }

  private func isDotExponentOrImag(character: Character) -> Bool {
    return character == "."
      || character == "e" || character == "E"
      || character == "j" || character == "J"
  }

  // MARK: - Helpers

  private func assertEqual(_ params: InitParams,
                           _ expected: BigInt,
                           file: StaticString = #file,
                           line: UInt = #line) {
    let string = params.string
    let base = params.base
    let msg = "string: '\(string)', base: \(base)"

    do {
      let result = try BigInt(parseUsingPythonRules: string, base: base)
      XCTAssertEqual(result, expected, msg, file: file, line: line)
    } catch {
      XCTFail(msg, file: file, line: line)
    }
  }

  private func assertRaises(_ string: String,
                            _ base: Int = 10,
                            file: StaticString = #file,
                            line: UInt = #line) {
    do {
      let result = try BigInt(parseUsingPythonRules: string, base: base)
      let msg = "string: '\(string)', base: \(base) --> \(result)"
      XCTFail(msg, file: file, line: line)
    } catch {
      // Expected
    }
  }
}

// MARK: - Adapters

// Adapters, so we can copy Python code and use it as our own tests

private struct InitParams {
  fileprivate let string: String
  fileprivate let base: Int
}

private func int(_ string: String) -> InitParams {
  return InitParams(string: string, base: 10)
}

private func int(_ string: String, _ base: Int) -> InitParams {
  return InitParams(string: string, base: base)
}

// swiftlint:disable:next type_name
private enum sys {

  /// The largest positive integer supported by the platform’s `Py_ssize_t` type,
  /// and thus the maximum size lists, strings, dicts,
  /// and many other containers can have.
  fileprivate static var maxsize: BigInt {
    return BigInt(Int.max)
  }
}

private func repr(_ value: BigInt) -> String {
  return String(value, radix: 10, uppercase: false)
}

// These are shared with test_tokenize and other test modules.
//
// Note: since several test cases filter out floats by looking for "e" and ".",
// don"t add hexadecimal literals that contain "e" or "E".
private let VALID_UNDERSCORE_LITERALS = [
    "0_0_0",
    "4_2",
    "1_0000_0000",
    "0b1001_0100",
    "0xffff_ffff",
    "0o5_7_7",
    "1_00_00.5",
    "1_00_00.5e5",
    "1_00_00e5_1",
    "1e1_0",
    ".1_4",
    ".1_4e1",
    "0b_0",
    "0x_f",
    "0o_5",
    "1_00_00j",
    "1_00_00.5j",
    "1_00_00e5_1j",
    ".1_4j",
    "(1_2.5+3_3j)",
    "(.5_6j)"
]

private let INVALID_UNDERSCORE_LITERALS = [
    // Trailing underscores:
    "0_",
    "42_",
    "1.4j_",
    "0x_",
    "0b1_",
    "0xf_",
    "0o5_",
    "0 if 1_Else 1",
    // Underscores in the base selector:
    "0_b0",
    "0_xf",
    "0_o5",
    // Old-style octal, still disallowed:
    "0_7",
    "09_99",
    // Multiple consecutive underscores:
    "4_______2",
    "0.1__4",
    "0.1__4j",
    "0b1001__0100",
    "0xffff__ffff",
    "0x___",
    "0o5__77",
    "1e1__0",
    "1e1__0j",
    // Underscore right before a dot:
    "1_.4",
    "1_.4j",
    // Underscore right after a dot:
    "1._4",
    "1._4j",
    "._5",
    "._5j",
    // Underscore right after a sign:
    "1.0e+_1",
    "1.0e+_1j",
    // Underscore right before j:
    "1.4_j",
    "1.4e5_j",
    // Underscore right before e:
    "1_e1",
    "1.4_e1",
    "1.4_e1j",
    // Underscore right after e:
    "1e_1",
    "1.4e_1",
    "1.4e_1j",
    // Complex cases with parens:
    "(1+1.5_j_)",
    "(1+1.5_j)"
]
