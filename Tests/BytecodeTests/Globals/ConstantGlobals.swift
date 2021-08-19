import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

// MARK: - True/false

let trueConstants: [CodeObject.Constant] = [
  .true,
  .ellipsis,
  .integer(BigInt(5)),
  .float(5.0),
  .complex(real: 0.0, imag: 1.0),
  .complex(real: 1.0, imag: 1.0),
  .complex(real: 1.0, imag: 1.0),
  .string("Elsa"),
  .bytes(Data([69, 108, 115, 97])),
  // .code(CodeObject),
  .tuple([.true, .false])
]

let falseConstants: [CodeObject.Constant] = [
  .false,
  .none,
  .integer(BigInt.zero),
  .float(0.0),
  .complex(real: 0.0, imag: 0.0),
  .string(""),
  .bytes(Data()),
  .tuple([])
]

// MARK: - Extended arg

/// Add 256 constants, so that the next one will require `extendedArg`.
func add256IntegerConstants(builder: CodeObjectBuilder) {
  for i in 0..<256 {
    builder.appendInteger(BigInt(i))
  }
}

/// Add 65 536 constants, so that the next one will require double `extendedArg`.
func add65536IntegerConstants(builder: CodeObjectBuilder, value: UInt8) {
  for i in 0..<65_536 {
    builder.appendInteger(BigInt(i))
  }
}

/// Assert `code.constants[256]`.
func XCTAssertConstantAtIndex256(_ code: CodeObject,
                                 _ expected: CodeObject.Constant,
                                 file: StaticString = #file,
                                 line: UInt = #line) {
  let count = code.constants.count
  let index = 256

  XCTAssertGreaterThanOrEqual(count, index, "Constant count", file: file, line: line)
  guard count >= index else {
    return
  }

  let constant = code.constants[index]
  XCTAssertEqual(constant, expected, file: file, line: line)
}

// MARK: - Asserts

func XCTAssertNoConstants(_ code: CodeObject,
                          file: StaticString = #file,
                          line: UInt = #line) {
  XCTAssertEqual(code.constants.count, 0, file: file, line: line)
}

func XCTAssertConstants(_ code: CodeObject,
                        _ expected: CodeObject.Constant...,
                        file: StaticString = #file,
                        line: UInt = #line) {
  XCTAssertConstants(code, expected, file: file, line: line)
}

func XCTAssertConstants(_ code: CodeObject,
                        _ expected: [CodeObject.Constant],
                        file: StaticString = #file,
                        line: UInt = #line) {
  let count = code.constants.count
  let expectedCount = expected.count

  XCTAssertEqual(count, expectedCount, "Count", file: file, line: line)

  for (index, (c, e)) in zip(code.constants, expected).enumerated() {
    XCTAssertEqual(c, e, "Constant \(index)", file: file, line: line)
  }
}

// MARK: - Assert equal

func XCTAssertEqual(_ lhs: CodeObject.Constant,
                    _ rhs: CodeObject.Constant,
                    file: StaticString = #file,
                    line: UInt = #line) {
  switch (lhs, rhs) {
  case (.true, .true),
       (.false, .false),
       (.none, .none),
       (.ellipsis, .ellipsis):
    break

  case let (.integer(l), .integer(r)):
    XCTAssertEqual(l, r, file: file, line: line)
  case let (.float(l), .float(r)):
    XCTAssertEqual(l, r, file: file, line: line)
  case let (.string(l), .string(r)):
    XCTAssertEqual(l, r, file: file, line: line)
  case let (.bytes(l), .bytes(r)):
    XCTAssertEqual(l, r, file: file, line: line)

  case let (.complex(real: lr, imag: li), .complex(real: rr, imag: ri)):
    XCTAssertEqual(lr, rr, file: file, line: line)
    XCTAssertEqual(li, ri, file: file, line: line)

  case let (.code(l), .code(r)):
    XCTAssert(l === r, file: file, line: line)

  case let (.tuple(ls), .tuple(rs)):
    XCTAssertEqual(ls.count,
                   rs.count,
                   "Tuple count: \(ls.count) vs \(rs.count)",
                   file: file,
                   line: line)

    for (l, r) in zip(ls, rs) {
      XCTAssertEqual(l, r, file: file, line: line)
    }

  default:
    let msg = "Constants '\(lhs)' and '\(rhs)' are not equal."
    XCTAssert(false, msg, file: file, line: line)
  }
}
