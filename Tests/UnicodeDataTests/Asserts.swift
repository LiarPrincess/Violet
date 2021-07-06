import XCTest
import UnicodeData

internal func XCTAssertCase(_ mapping: UnicodeData.CaseMapping,
                            _ expectedString: String,
                            file: StaticString = #file,
                            line: UInt = #line) {
  let expected = expectedString.unicodeScalars

  var count = 0
  for (index, (m, e)) in zip(mapping, expected).enumerated() {
    XCTAssertEqual(m, e, "Scalar at \(index)", file: file, line: line)
    count += 1
  }

  XCTAssertEqual(count, expected.count, "Count", file: file, line: line)
}

internal func XCTAssertDigit(_ value: UInt8?,
                             _ expected: UInt8?,
                             file: StaticString = #file,
                             line: UInt = #line) {
  XCTAssertEqual(value, expected, file: file, line: line)
}
