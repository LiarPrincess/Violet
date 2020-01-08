import XCTest
import Core
import Parser
import Bytecode
@testable import Compiler

/// Use 'Scripts/dump_dis.py' for reference.
class CompileSubscript: CompileTestCase {

  // MARK: - Index

  /// paris['notre_dame']
  ///
  /// 0 LOAD_NAME                0 (paris)
  /// 2 LOAD_CONST               0 ('notre_dame')
  /// 4 BINARY_SUBSCR
  /// 6 RETURN_VALUE
  func test_index_constant() {
    let expr = self.expression(.subscript(
      self.identifierExpr("paris"),
      slice: self.slice(.index(
        self.expression(.string(.literal("notre_dame")))
      ))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadConst, "'notre_dame'"),
      .init(.binarySubscript),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// paris[notre_dame]
  ///
  /// 0 LOAD_NAME                0 (paris)
  /// 2 LOAD_NAME                1 (notre_dame)
  /// 4 BINARY_SUBSCR
  /// 6 RETURN_VALUE
  func test_index_identifier() {
    let expr = self.expression(.subscript(
      self.identifierExpr("paris"),
      slice: self.slice(.index(
        self.identifierExpr("notre_dame")
      ))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadName, "notre_dame"),
      .init(.binarySubscript),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// paris[notre_dame][bell]
  ///
  ///  0 LOAD_NAME                0 (paris)
  ///  2 LOAD_NAME                1 (notre_dame)
  ///  4 BINARY_SUBSCR
  ///  6 LOAD_NAME                2 (bell)
  ///  8 BINARY_SUBSCR
  /// 10 RETURN_VALUE
  func test_index_afterIndex() {
    let left = self.expression(.subscript(
      self.identifierExpr("paris"),
      slice: self.slice(.index(
        self.identifierExpr("notre_dame")
      ))
    ))

    let expr = self.expression(.subscript(
      left,
      slice: self.slice(.index(
        self.identifierExpr("bell")
      ))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadName, "notre_dame"),
      .init(.binarySubscript),
      .init(.loadName, "bell"),
      .init(.binarySubscript),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Slice

  /// paris['Quasimodo':'Esmeralda':'Frollo']
  ///
  ///  0 LOAD_NAME                0 (paris)
  ///  2 LOAD_CONST               0 ('Quasimodo')
  ///  4 LOAD_CONST               1 ('Esmeralda')
  ///  6 LOAD_CONST               2 ('Frollo')
  ///  8 BUILD_SLICE              3
  /// 10 BINARY_SUBSCR
  /// 12 RETURN_VALUE
  func test_slice_constant() {
    let expr = self.expression(.subscript(
      self.identifierExpr("paris"),
      slice: self.slice(.slice(
        lower: self.expression(.string(.literal("Quasimodo"))),
        upper: self.expression(.string(.literal("Esmeralda"))),
        step:  self.expression(.string(.literal("Frollo")))
      ))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadConst, "'Quasimodo'"),
      .init(.loadConst, "'Esmeralda'"),
      .init(.loadConst, "'Frollo'"),
      .init(.buildSlice, "3"),
      .init(.binarySubscript),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// paris[Quasimodo:Esmeralda:Frollo]
  ///
  ///  0 LOAD_NAME                0 (paris)
  ///  2 LOAD_NAME                1 (Quasimodo)
  ///  4 LOAD_NAME                2 (Esmeralda)
  ///  6 LOAD_NAME                3 (Frollo)
  ///  8 BUILD_SLICE              3
  /// 10 BINARY_SUBSCR
  /// 12 RETURN_VALUE
  func test_slice_identifiers() {
    let expr = self.expression(.subscript(
      self.identifierExpr("paris"),
      slice: self.slice(.slice(
        lower: self.identifierExpr("Quasimodo"),
        upper: self.identifierExpr("Esmeralda"),
        step:  self.identifierExpr("Frollo")
      ))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadName, "Quasimodo"),
      .init(.loadName, "Esmeralda"),
      .init(.loadName, "Frollo"),
      .init(.buildSlice, "3"),
      .init(.binarySubscript),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// paris[Quasimodo:Esmeralda]
  ///
  ///  0 LOAD_NAME                0 (paris)
  ///  2 LOAD_NAME                1 (Quasimodo)
  ///  4 LOAD_NAME                2 (Esmeralda)
  ///  6 BUILD_SLICE              2
  ///  8 BINARY_SUBSCR
  /// 10 RETURN_VALUE
  func test_slice_identifiers_withoutStep() {
    let expr = self.expression(.subscript(
      self.identifierExpr("paris"),
      slice: self.slice(.slice(
        lower: self.identifierExpr("Quasimodo"),
        upper: self.identifierExpr("Esmeralda"),
        step:  nil
      ))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadName, "Quasimodo"),
      .init(.loadName, "Esmeralda"),
      .init(.buildSlice, "2"),
      .init(.binarySubscript),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  /// paris[::]
  ///
  ///  0 LOAD_NAME                0 (paris)
  ///  2 LOAD_CONST               0 (None)
  ///  4 LOAD_CONST               0 (None)
  ///  6 BUILD_SLICE              2
  ///  8 BINARY_SUBSCR
  /// 10 RETURN_VALUE
  func test_slice_allNil() {
    let expr = self.expression(.subscript(
      self.identifierExpr("paris"),
      slice: self.slice(.slice(lower: nil, upper: nil, step: nil))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadConst, "none"),
      .init(.loadConst, "none"),
      .init(.buildSlice, "2"),
      .init(.binarySubscript),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }

  // MARK: - Ext slice

  /// paris[Quasimodo:Esmeralda, Frollo]
  ///
  ///  0 LOAD_NAME                0 (paris)
  ///  2 LOAD_NAME                1 (Quasimodo)
  ///  4 LOAD_NAME                2 (Esmeralda)
  ///  6 BUILD_SLICE              2
  ///  8 LOAD_NAME                3 (Frollo)
  /// 10 BUILD_TUPLE              2
  /// 12 BINARY_SUBSCR
  /// 14 RETURN_VALUE
  func test_slice_extended() {
    let expr = self.expression(.subscript(
      self.identifierExpr("paris"),
      slice: self.slice(
        .extSlice(NonEmptyArray(
          first: self.slice(.slice(
            lower: self.identifierExpr("Quasimodo"),
            upper: self.identifierExpr("Esmeralda"),
            step:  nil
          )),
          rest: [
            self.slice(.index(
              self.identifierExpr("Frollo")
            ))
          ])
        ))
    ))

    let expected: [EmittedInstruction] = [
      .init(.loadName, "paris"),
      .init(.loadName, "Quasimodo"),
      .init(.loadName, "Esmeralda"),
      .init(.buildSlice, "2"),
      .init(.loadName, "Frollo"),
      .init(.buildTuple, "2"),
      .init(.binarySubscript),
      .init(.return)
    ]

    if let code = self.compile(expr: expr) {
      XCTAssertCode(code, name: "<module>", qualified: "", type: .module)
      XCTAssertInstructions(code, expected)
    }
  }
}
