import XCTest
import UnicodeData

internal func XCTAssertProperty(_ fn: (UnicodeScalar) -> Bool,
                                for scalar: UnicodeScalar,
                                expected: Bool,
                                file: StaticString = #file,
                                line: UInt = #line) {
  let value = fn(scalar)
  let msg = "\(scalar) (value: \(scalar.value))"
  XCTAssertEqual(value, expected, msg, file: file, line: line)
}

internal func XCTAssertCase(_ mapping: UnicodeData.CaseMapping,
                            expected: Int,
                            file: StaticString = #file,
                            line: UInt = #line) {
  let scalars = Array(mapping)
  XCTAssertEqual(scalars.count, 1, "Count", file: file, line: line)
  
  let scalar = scalars[0]
  let expectedScalar = UnicodeScalar(expected)!
  XCTAssertEqual(scalar, expectedScalar, file: file, line: line)
}

internal func XCTAssertDigit(_ value: UInt8?,
                             expected: Int?,
                             file: StaticString = #file,
                             line: UInt = #line) {
  let expected8 = expected.map(UInt8.init)
  XCTAssertEqual(value, expected8, file: file, line: line)
}
