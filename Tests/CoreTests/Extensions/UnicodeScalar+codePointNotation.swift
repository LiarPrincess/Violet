import XCTest
import VioletCore

class UnicodeScalarCodePointNotation: XCTestCase {

  func test_ascii() {
    let exclamationMark = 0x21
    self.assertCodePointNotation(exclamationMark, scalar: "!", expected: "U+0021")

    let A = 0x41
    self.assertCodePointNotation(A, scalar: "A", expected: "U+0041")

    let a = 0x61
    self.assertCodePointNotation(a, scalar: "a", expected: "U+0061")
  }

  func test_polish() {
    let ą = 0x0105 // LATIN SMALL LETTER A WITH OGONEK
    self.assertCodePointNotation(ą, scalar: "ą", expected: "U+0105")

    let ę = 0x0119 // LATIN SMALL LETTER E WITH OGONEK
    self.assertCodePointNotation(ę, scalar: "ę", expected: "U+0119")

    let ź = 0x017a // LATIN SMALL LETTER Z WITH ACUTE
    self.assertCodePointNotation(ź, scalar: "ź", expected: "U+017A")

    let ż = 0x017c // LATIN SMALL LETTER Z WITH DOT ABOVE
    self.assertCodePointNotation(ż, scalar: "ż", expected: "U+017C")

    let ł = 0x142 // LATIN SMALL LETTER L WITH STROKE
    self.assertCodePointNotation(ł, scalar: "ł", expected: "U+0142")
  }

  func test_highValues() {
    let value4 = 0xf1fa // Private_Use_Area
    self.assertCodePointNotation(value4, scalar: nil, expected: "U+F1FA")

    let value5 = 0xf_1fa2 // Supplementary_Private_Use_Area_A
    self.assertCodePointNotation(value5, scalar: nil, expected: "U+F1FA2")

    let value6 = 0xf_1fa3 // Supplementary_Private_Use_Area_A
    self.assertCodePointNotation(value6, scalar: nil, expected: "U+F1FA3")

    let lastValue = 0x10_ffff // Supplementary_Private_Use_Area_B
    self.assertCodePointNotation(lastValue, scalar: nil, expected: "U+10FFFF")
  }

  private func assertCodePointNotation(_ value: Int,
                                       scalar expectedScalar: UnicodeScalar?,
                                       expected: String,
                                       file: StaticString = #file,
                                       line: UInt = #line) {
    guard let scalar = UnicodeScalar(value) else {
      XCTFail("Unable to create scalar with value \(value).", file: file, line: line)
      return
    }

    if let es = expectedScalar {
      XCTAssertEqual(scalar,
                     es,
                     "Unexpected scalar '\(scalar)' (expected '\(es)').",
                     file: file,
                     line: line)
    }

    let result = scalar.codePointNotation
    XCTAssertEqual(result, expected, file: file, line: line)
  }
}
