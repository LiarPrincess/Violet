import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileConstantsTests: XCTestCase, CommonCompiler {

  // MARK: - Empty

  func test_empty() {
    let expected: [EmittedInstruction] = [
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(stmts: []) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - None, ellipsis

  func test_none() {
    let expr = self.expression(.none)

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "none"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  func test_ellipsis() {
    let expr = self.expression(.ellipsis)

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

  func test_true() {
    let expr = self.expression(.true)

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "true"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  func test_false() {
    let expr = self.expression(.false)

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

  func test_integer() {
    let expr = self.expression(.int(BigInt(3)))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "3"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  func test_float() {
    let expr = self.expression(.float(12.3))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "12.3"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  func test_complex() {
    let expr = self.expression(.complex(real: 1.2, imag: 3.4))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1.2+3.4j"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Tuple

  func test_tuple_empty() {
    let expr = self.expression(.tuple([]))

    let expected: [EmittedInstruction] = [
      .init(.buildTuple, "0"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  func test_tuple_constants() {
    let expr = self.expression(.tuple([
      self.expression(.string(.literal("elsa"))),
      self.expression(.true)
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "elsa"),
      .init(.loadConst, "true"),
      .init(.buildTuple, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  func test_tuple_withIdentifier() {
    let expr = self.expression(.tuple([
      self.expression(.identifier("elsa")),
      self.expression(.true)
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadName,  "elsa"),
      .init(.loadConst, "true"),
      .init(.buildTuple, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
