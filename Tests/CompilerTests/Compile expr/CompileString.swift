import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

private let e: UInt8 = 0x45 // it is 'E', but camelCase happened
private let l: UInt8 = 0x6c
private let s: UInt8 = 0x73
private let a: UInt8 = 0x61

/// Use 'Scripts/dump_dis.py' for reference.
class CompileStringTests: XCTestCase, CommonCompiler {

  // MARK: - Bytes

  func test_bytes() {
    let data = Data([e, l, s, a])
    let expr = self.expression(.bytes(data))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "b'Elsa'"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - String

  func test_string() {
    let expr = self.expression(.string(.literal("Elsa")))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "Elsa"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
