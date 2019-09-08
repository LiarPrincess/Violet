import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Basic checks for expressions, without nested scopes.
/// Just so we know that we visit all childs.
/// Use 'Tools/dump_symtable.py' for reference.
class CompileAtomTests: XCTestCase, CommonCompiler {

  // MARK: - Empty

  func test_empty() {
    if let code = self.compile(stmts: []) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, [])
    }
  }

  // MARK: - None, ellipsis

  func test_none() {
    let expr = self.expression(.none)

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "1"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  func test_ellipsis() {
    let expr = self.expression(.ellipsis)

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, [])
    }
  }

  // MARK: - Boolean

  func test_true() {
    let expr = self.expression(.true)

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, [])
    }
  }

  func test_false() {
    let expr = self.expression(.false)

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, [])
    }
  }

  // MARK: - Numbers
  //  .int(BigInt(1)), .float(2.0), .complex(real: 3.0, imag: 4.0),

  // MARK: - Bytes, string
  // .bytes(Data())
  // string
}
