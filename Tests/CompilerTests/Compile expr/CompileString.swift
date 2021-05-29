import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

private let a: UInt8 = 0x41 // it is 'A', but camelCase happened
private let l: UInt8 = 0x6c
private let i: UInt8 = 0x69
private let c: UInt8 = 0x63
private let e: UInt8 = 0x65

/// Use 'Scripts/dump_dis.py' for reference.
class CompileStringTests: CompileTestCase {

  // MARK: - Bytes

  func test_bytes() {
    let data = Data([a, l, i, c, e])
    let expr = self.bytesExpr(value: data)

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "b'Alice'"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - String - literal

  func test_stringLiteral() {
    let expr = self.stringExpr(value: .literal("Alice"))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "'Alice'"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - String - formatted

  /// f'{alice}'
  ///
  /// 0 LOAD_NAME                0 (alice)
  /// 2 FORMAT_VALUE             0
  /// 4 RETURN_VALUE
  func test_formattedValue_withoutConversion_orFormat() {
    let expr = self.stringExpr(value: .formattedValue(
      self.identifierExpr(value: "alice"),
      conversion: nil,
      spec: nil
      )
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "alice"),
      .init(.formatValue, ""),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// f'{alice!s}'
  ///
  ///  0 LOAD_NAME                0 (alice)
  ///  2 FORMAT_VALUE             1 (str)
  ///  4 RETURN_VALUE
  func test_formattedValue_withConversion() {
    let conversions: [StringExpr.Conversion: String] = [
      .str: "str",
      .ascii: "ascii",
      .repr: "repr"
    ]

    for (conversion, str) in conversions {
      let expr = self.stringExpr(value: .formattedValue(
        self.identifierExpr(value: "alice"),
        conversion: conversion,
        spec: nil)
      )

      let expected: [EmittedInstruction] = [
        .init(.loadName, "alice"),
        .init(.formatValue, str),
        .init(.return)
      ]

      if let code = self.compile(expr: expr) {
        XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
        XCTAssertInstructions(code, expected)
      }
    }
  }

  /// f'{alice:wonderland}'
  ///
  ///  0 LOAD_NAME                0 (alice)
  ///  2 LOAD_CONST               0 ('wonderland')
  ///  4 FORMAT_VALUE             4 (with format)
  ///  6 RETURN_VALUE
  func test_formattedValue_withFormat() {
    let expr = self.stringExpr(value: .formattedValue(
      self.identifierExpr(value: "alice"),
      conversion: nil,
      spec: "wonderland")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "alice"),
      .init(.loadConst, "'wonderland'"),
      .init(.formatValue, "with format"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// f'{alice!s:wonderland}'
  ///
  /// 0 LOAD_NAME                0 (alice)
  /// 2 LOAD_CONST               0 ('wonderland')
  /// 4 FORMAT_VALUE             5 (str, with format)
  /// 6 RETURN_VALUE
  func test_formattedValue_withConversion_andFormat() {
    let expr = self.stringExpr(value: .formattedValue(
      self.identifierExpr(value: "alice"),
      conversion: .str,
      spec: "wonderland")
    )

    let expected: [EmittedInstruction] = [
      .init(.loadName, "alice"),
      .init(.loadConst, "'wonderland'"),
      .init(.formatValue, "str, with format"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Joined string

  /// f'alice {in:wonderland}'
  ///
  ///  0 LOAD_CONST               0 ('alice ')
  ///  2 LOAD_NAME                0 (in)
  ///  4 LOAD_CONST               1 ('wonderland')
  ///  6 FORMAT_VALUE             5 (str, with format)
  ///  8 BUILD_STRING             2
  /// 10 RETURN_VALUE
  func test_joinedString() {
    let expr = self.stringExpr(value: .joined([
      .literal("alice "),
      .formattedValue(
        self.identifierExpr(value: "in"),
        conversion: .str,
        spec: "wonderland")
    ]))

    let expected: [EmittedInstruction] = [
      .init(.loadConst, "'alice '"),
      .init(.loadName, "in"),
      .init(.loadConst, "'wonderland'"),
      .init(.formatValue, "str, with format"),
      .init(.buildString, "2"),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", kind: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
