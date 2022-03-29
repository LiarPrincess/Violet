import XCTest
import VioletCore
import VioletParser
import VioletBytecode
@testable import VioletCompiler

// cSpell:ignore subscr

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
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "paris"),
      slice: self.slice(
        kind: .index(self.stringExpr(value: .literal("notre_dame")))
      )
    )

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
        .loadName(name: "paris"),
        .loadConst(string: "notre_dame"),
        .binarySubscript,
        .return
      ]
    )
  }

  /// paris[notre_dame]
  ///
  /// 0 LOAD_NAME                0 (paris)
  /// 2 LOAD_NAME                1 (notre_dame)
  /// 4 BINARY_SUBSCR
  /// 6 RETURN_VALUE
  func test_index_identifier() {
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "paris"),
      slice: self.slice(
        kind: .index(self.identifierExpr(value: "notre_dame"))
      )
    )

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
        .loadName(name: "paris"),
        .loadName(name: "notre_dame"),
        .binarySubscript,
        .return
      ]
    )
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
    let left = self.subscriptExpr(
      object: self.identifierExpr(value: "paris"),
      slice: self.slice(
        kind: .index(self.identifierExpr(value: "notre_dame"))
      )
    )

    let expr = self.subscriptExpr(
      object: left,
      slice: self.slice(
        kind: .index(self.identifierExpr(value: "bell"))
      )
    )

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
        .loadName(name: "paris"),
        .loadName(name: "notre_dame"),
        .binarySubscript,
        .loadName(name: "bell"),
        .binarySubscript,
        .return
      ]
    )
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
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "paris"),
      slice: self.slice(
        kind: .slice(
          lower: self.stringExpr(value: .literal("Quasimodo")),
          upper: self.stringExpr(value: .literal("Esmeralda")),
          step: self.stringExpr(value: .literal("Frollo"))
        )
      )
    )

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
        .loadName(name: "paris"),
        .loadConst(string: "Quasimodo"),
        .loadConst(string: "Esmeralda"),
        .loadConst(string: "Frollo"),
        .buildSlice(type: .lowerUpperStep),
        .binarySubscript,
        .return
      ]
    )
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
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "paris"),
      slice: self.slice(
        kind: .slice(
          lower: self.identifierExpr(value: "Quasimodo"),
          upper: self.identifierExpr(value: "Esmeralda"),
          step: self.identifierExpr(value: "Frollo")
        )
      )
    )

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
        .loadName(name: "paris"),
        .loadName(name: "Quasimodo"),
        .loadName(name: "Esmeralda"),
        .loadName(name: "Frollo"),
        .buildSlice(type: .lowerUpperStep),
        .binarySubscript,
        .return
      ]
    )
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
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "paris"),
      slice: self.slice(
        kind: .slice(
          lower: self.identifierExpr(value: "Quasimodo"),
          upper: self.identifierExpr(value: "Esmeralda"),
          step: nil
        )
      )
    )

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
        .loadName(name: "paris"),
        .loadName(name: "Quasimodo"),
        .loadName(name: "Esmeralda"),
        .buildSlice(type: .lowerUpper),
        .binarySubscript,
        .return
      ]
    )
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
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "paris"),
      slice: self.slice(
        kind: .slice(lower: nil, upper: nil, step: nil)
      )
    )

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
        .loadName(name: "paris"),
        .loadConst(.none),
        .loadConst(.none),
        .buildSlice(type: .lowerUpper),
        .binarySubscript,
        .return
      ]
    )
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
    let expr = self.subscriptExpr(
      object: self.identifierExpr(value: "paris"),
      slice: self.slice(
        kind: self.extSlice([
          self.slice(
            kind: .slice(
              lower: self.identifierExpr(value: "Quasimodo"),
              upper: self.identifierExpr(value: "Esmeralda"),
              step: nil
            )
          ),
          self.slice(
            kind: .index(self.identifierExpr(value: "Frollo"))
          )
        ])
      )
    )

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
        .loadName(name: "paris"),
        .loadName(name: "Quasimodo"),
        .loadName(name: "Esmeralda"),
        .buildSlice(type: .lowerUpper),
        .loadName(name: "Frollo"),
        .buildTuple(elementCount: 2),
        .binarySubscript,
        .return
      ]
    )
  }

  private func extSlice(_ slices: [Slice]) -> Slice.Kind {
    assert(slices.any)
    let first = slices[0]
    let rest = Array(slices.dropFirst())
    return .extSlice(NonEmptyArray(first: first, rest: rest))
  }
}
