import XCTest
import VioletCore
@testable import VioletBytecode

internal func XCTAssertConstant(_ lhs: Constant,
                                _ rhs: Constant,
                                file: StaticString = #file,
                                line: UInt         = #line) {
  switch (lhs, rhs) {
  case (.`true`, .`true`),
       (.`false`, .`false`),
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
    for (l, r) in zip(ls, rs) {
      XCTAssertConstant(l, r, file: file, line: line)
    }

  default:
    let msg = "Constants '\(lhs)' and '\(rhs)' are not equal."
    XCTAssert(false, msg, file: file, line: line)
  }
}

class AppendConstants: XCTestCase {

  // MARK: - String

  // See comment above 'UseScalarsToHashString' for details.
  func test_string_usesScalars_toDifferentiateStrings() {
    let s0 = "é"
    let s1 = "e\u{0301}"
    XCTAssertEqual(s0, s1) // Equal according to Swift

    let codeObject = self.createCodeObject()
    let builder = self.createBuilder(codeObject: codeObject)

    builder.appendString(s0)
    builder.appendString(s1)

    guard codeObject.constants.count == 2 else {
      XCTAssert(false)
      return
    }

    XCTAssertConstant(codeObject.constants[0], Constant.string(s0))
    XCTAssertConstant(codeObject.constants[1], Constant.string(s1))

    guard codeObject.instructions.count == 2 else {
      XCTAssert(false)
      return
    }

    guard case .loadConst(index: 0) = codeObject.instructions[0] else {
      XCTAssert(false)
      return
    }

    guard case .loadConst(index: 1) = codeObject.instructions[1] else {
      XCTAssert(false)
      return
    }
  }

  private func createCodeObject() -> CodeObject {
    return CodeObject(
      name: "n",
      qualifiedName: "q",
      filename: "f",
      kind: .module,
      flags: CodeObject.Flags(),
      variableNames: [],
      freeVariableNames: [],
      cellVariableNames: [],
      argCount: 0,
      kwOnlyArgCount: 0,
      firstLine: 0
    )
  }

  private func createBuilder(codeObject: CodeObject) -> CodeObjectBuilder {
    return CodeObjectBuilder(codeObject: codeObject)
  }
}
