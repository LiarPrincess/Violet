import XCTest
import BigInt
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

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(.none),
        .return
      ]
    )
  }

  /// ...
  func test_ellipsis() {
    let expr = self.ellipsisExpr()

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(.ellipsis),
        .return
      ]
    )
  }

  // MARK: - Boolean

  /// true
  func test_true() {
    let expr = self.trueExpr()

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(.true),
        .return
      ]
    )
  }

  /// false
  func test_false() {
    let expr = self.falseExpr()

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(.false),
        .return
      ]
    )
  }

  // MARK: - Numbers

  /// 3
  func test_integer() {
    let value = BigInt(42)
    let expr = self.intExpr(value: value)

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(integer: value),
        .return
      ]
    )
  }

  /// 12.3
  func test_float() {
    let value = 42.5
    let expr = self.floatExpr(value: value)

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(float: value),
        .return
      ]
    )
  }

  /// 1.2+3.4j
  func test_complex() {
    let real = 42.5
    let imag = 24.6
    let expr = self.complexExpr(real: real, imag: imag)

    guard let code = self.compile(expr: expr) else {
      return
    }

    XCTAssertCodeObject(
      code,
      name: "<module>",
      qualifiedName: "",
      kind: .module,
      flags: [],
      instructions: [
        .loadConst(real: real, imag: imag),
        .return
      ]
    )
  }
}
