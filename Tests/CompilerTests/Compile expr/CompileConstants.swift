import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileConstants: CompileTestCase {

  // MARK: - None, ellipsis

  /// none
  func test_none() {
    let expr = self.noneExpr()

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// ...
  func test_ellipsis() {
    let expr = self.ellipsisExpr()

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "ellipsis"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Boolean

  /// true
  func test_true() {
    let expr = self.trueExpr()

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "true"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// false
  func test_false() {
    let expr = self.falseExpr()

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "false"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Numbers

  /// 3
  func test_integer() {
    let expr = self.intExpr(value: 3)

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "3"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// 12.3
  func test_float() {
    let expr = self.floatExpr(value: 12.3)

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "12.3"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// 1.2+3.4j
  func test_complex() {
    let expr = self.complexExpr(real: 1.2, imag: 3.4)

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1.2+3.4j"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
