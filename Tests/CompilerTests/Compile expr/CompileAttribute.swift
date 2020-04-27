import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileAttribute: CompileTestCase {

  /// paris.notre_dame
  ///
  /// 0 LOAD_NAME                0 (paris)
  /// 2 LOAD_ATTR                1 (notre_dame)
  /// 4 RETURN_VALUE
  func test_single() {
    let expr = self.attributeExpr(
      object: self.identifierExpr(value: "paris"),
      name: "notre_dame"
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadAttribute, "notre_dame"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// paris.notre_dame.bell
  ///
  /// 0 LOAD_NAME                0 (paris)
  /// 2 LOAD_ATTR                1 (notre_dame)
  /// 4 LOAD_ATTR                2 (bell)
  /// 6 RETURN_VALUE
  func test_nested() {
    let expr = self.attributeExpr(
      object: self.attributeExpr(
        object: self.identifierExpr(value: "paris"),
        name: "notre_dame"
      ),
      name: "bell"
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadAttribute, "notre_dame"),
      .init(.loadAttribute, "bell"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
