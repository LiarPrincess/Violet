import XCTest
import BigInt
import VioletCore
@testable import VioletBytecode

class InstructionTests: XCTestCase {

  // MARK: - Extend

  func test_extend() {
    var base = 0xfa
    var result = Instruction.extend(base: base, arg: 0xff)
    XCTAssertEqual(result, 0xfaff)

    base = 0xfafb
    result = Instruction.extend(base: base, arg: 0xff)
    XCTAssertEqual(result, 0xfa_fbff)

    base = 0xfa_fbfc
    result = Instruction.extend(base: base, arg: 0xff)
    XCTAssertEqual(result, 0xfafb_fcff)
  }

  // MARK: - Function flags

  func test_functionFlags_areUnique() {
    let flags: [Instruction.FunctionFlags] = [
      .hasPositionalArgDefaults,
      .hasKwOnlyArgDefaults,
      .hasAnnotations,
      .hasFreeVariables
    ]

    for f in flags {
      for intersectionFlag in flags where intersectionFlag != f {
        let common = f.intersection(intersectionFlag)
        XCTAssert(common.isEmpty)
      }
    }
  }

  // MARK: - UnpackExArg

  struct UnpackCase {
    let value: Int
    let before: Int
    let after: Int
  }

  func test_unpackExArg_isReversible() {
    let cases: [UnpackCase] = [
      UnpackCase(value: 0x00ff, before: 0xff, after: 0x00),
      UnpackCase(value: 0xff00, before: 0x00, after: 0xff),
      UnpackCase(value: 0xfafb, before: 0xfb, after: 0xfa)
    ]

    for c in cases {
      let fromValue = Instruction.UnpackExArg(value: c.value)
      XCTAssertEqual(fromValue.value, c.value)
      XCTAssertEqual(fromValue.countBefore, c.before)
      XCTAssertEqual(fromValue.countAfter, c.after)

      let fromBeforeAfter = Instruction.UnpackExArg(countBefore: c.before,
                                                    countAfter: c.after)

      XCTAssertEqual(fromBeforeAfter.value, c.value)
      XCTAssertEqual(fromBeforeAfter.countBefore, c.before)
      XCTAssertEqual(fromBeforeAfter.countAfter, c.after)
    }
  }
}
