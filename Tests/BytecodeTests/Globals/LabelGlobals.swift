import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

// MARK: - Extended arg

/// Add 256 labels, so that the next one will require `extendedArg`.
func add256Labels(builder: CodeObjectBuilder) {
  for _ in 0..<256 {
    let label = builder.createLabel()
    builder.setLabel(label)
  }
}

/// Assert `code.labels[256]`.
func XCTAssertLabelAtIndex256(_ code: CodeObject,
                              instructionIndex: Int,
                              file: StaticString = #file,
                              line: UInt = #line) {
  let count = code.labels.count
  let index = 256

  XCTAssertGreaterThanOrEqual(count, index, "Label count", file: file, line: line)
  guard count >= index else {
    return
  }

  let label = code.labels[index]
  let expectedLabel = CodeObject.Label(instructionIndex: instructionIndex)
  XCTAssertEqual(label, expectedLabel, file: file, line: line)
}

// MARK: - Asserts

func XCTAssertNoLabels(_ code: CodeObject,
                       file: StaticString = #file,
                       line: UInt = #line) {
  XCTAssertEqual(code.labels.count, 0, file: file, line: line)
}

func XCTAssertLabelTargets(_ code: CodeObject,
                           _ expected: Int...,
                           file: StaticString = #file,
                           line: UInt = #line) {
  let count = code.labels.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)
  guard count == expectedCount else {
    return
  }

  for (l, e) in zip(code.labels, expected) {
    let eLabel = CodeObject.Label(instructionIndex: e)
    XCTAssertEqual(l, eLabel, file: file, line: line)
  }
}
