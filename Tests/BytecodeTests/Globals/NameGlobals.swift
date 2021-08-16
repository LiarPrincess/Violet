import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

func XCTAssertNames(_ code: CodeObject,
                    _ expected: String...,
                    file: StaticString = #file,
                    line: UInt = #line) {
  let count = code.names.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)
  guard count == expectedCount else {
    return
  }

  for (n, e) in zip(code.names, expected) {
    XCTAssertEqual(n, e, file: file, line: line)
  }
}
