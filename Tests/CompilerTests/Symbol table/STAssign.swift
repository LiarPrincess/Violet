import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable file_length

/// Basic checks for assigns, without nested scopes.
/// Just so we know that we visit all childs.
/// Use 'Tools/dump_symtable.py' for reference.
class STAssign: XCTestCase, CommonSymbolTable {

  // MARK: - Assign

  /// rapunzel = 5
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - local, assigned,
  /// ```
  func test_assign() {
    let target = self.expression(.identifier("rapunzel"), start: loc1)
    let value  = self.expression(.int(BigInt(5)))

    let kind = StatementKind.assign(targets: NonEmptyArray(first: target),
                                    value: value)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal],
                              location: loc1)
    }
  }

  /// rapunzel = rapunzel
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - referenced, local, assigned,
  /// ```
  func test_assign_toItself() {
    let target = self.expression(.identifier("rapunzel"), start: loc1)
    let value  = self.expression(.identifier("rapunzel"))

    let kind = StatementKind.assign(targets: NonEmptyArray(first: target),
                                    value: value)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc1)
    }
  }

  /// rapunzel = eugine = 5
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - local, assigned,
  ///   eugine - local, assigned,
  /// ```
  func test_assign_multiple() {
    let target1 = self.expression(.identifier("rapunzel"), start: loc1)
    let target2 = self.expression(.identifier("eugine"),   start: loc2)
    let value   = self.expression(.int(BigInt(5)))

    let kind = StatementKind.assign(
      targets: NonEmptyArray(first: target1, rest: [target2]),
      value: value
    )

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "eugine",
                              flags: [.defLocal, .srcLocal],
                              location: loc2)
    }
  }

  // MARK: - Augumented assign

  /// rapunzel += 5
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - local, assigned,
  /// ```
  func test_augAssign() {
    let target = self.expression(.identifier("rapunzel"), start: loc1)
    let value  = self.expression(.int(BigInt(5)))

    let kind = StatementKind.augAssign(target: target, op: .add, value: value)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal],
                              location: loc1)
    }
  }

  /// rapunzel += rapunzel
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - referenced, local, assigned,
  /// ```
  func test_augAssign_toItself() {
    let target = self.expression(.identifier("rapunzel"), start: loc1)
    let value  = self.expression(.identifier("rapunzel"))

    let kind = StatementKind.augAssign(target: target, op: .add, value: value)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc1)
    }
  }

  // MARK: - Annotated assign

  /// rapunzel: Int = 5
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - local, assigned, (+annotated, not supported by symtable module)
  ///   Int - referenced, global,
  /// ```
  func test_annAssign() {
    let target = self.expression(.identifier("rapunzel"), start: loc1)
    let ann    = self.expression(.identifier("Int"),      start: loc2)
    let value  = self.expression(.int(BigInt(5)))

    let kind = StatementKind.annAssign(target: target,
                                       annotation: ann,
                                       value: value,
                                       isSimple: true)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal, .annotated],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "Int",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  /// (rapunzel): Int = 5
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - referenced, global,
  ///   Int - referenced, global,
  /// ```
  func test_annAssign_inParens() {
    let target = self.expression(.identifier("rapunzel"), start: loc1)
    let ann    = self.expression(.identifier("Int"),      start: loc2)
    let value  = self.expression(.int(BigInt(5)))

    let kind = StatementKind.annAssign(target: target,
                                       annotation: ann,
                                       value: value,
                                       isSimple: false) // <- parens

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "Int",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  /// tangled.rapunzel: Int = 5
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   tangled - referenced, global, <- not really sure why CPython does it
  ///   Int - referenced, global,
  /// ```
  func test_annAssign_attribute() {
    let object = self.expression(.identifier("tangled"), start: loc1)
    let target = self.expression(.attribute(object, name: "rapunzel"))

    let ann   = self.expression(.identifier("Int"), start: loc3)
    let value = self.expression(.int(BigInt(5)))

    let kind = StatementKind.annAssign(target: target,
                                       annotation: ann,
                                       value: value,
                                       isSimple: false)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "tangled",
                              flags: [.defLocal, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "Int",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc3)
    }
  }

  /// rapunzel: Int = rapunzel
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - referenced, local, assigned,
  ///   Int - referenced, global,
  /// ```
  func test_annAssign_toItself() {
    let target = self.expression(.identifier("rapunzel"), start: loc1)
    let ann    = self.expression(.identifier("Int"),      start: loc2)
    let value  = self.expression(.identifier("rapunzel"), start: loc3)

    let kind = StatementKind.annAssign(target: target,
                                       annotation: ann,
                                       value: value,
                                       isSimple: true)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal, .use, .annotated],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "Int",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  /// rapunzel: Int
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - local, assigned,
  ///   Int - referenced, global,
  /// ```
  func test_annAssign_withoutValue() {
    let target = self.expression(.identifier("rapunzel"), start: loc1)
    let ann    = self.expression(.identifier("Int"),      start: loc2)

    let kind = StatementKind.annAssign(target: target,
                                       annotation: ann,
                                       value: nil,
                                       isSimple: true)

    if let table = self.createSymbolTable(forStmt: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal, .annotated],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "Int",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  // global rapunzel
  // rapunzel: Int
  func test_annAssign_global_withAnnotation_throws() {
    let stmt1 = self.globalStmt(name: "rapunzel")

    let target = self.expression(.identifier("rapunzel"))
    let ann    = self.expression(.identifier("Int"))

    let kind = StatementKind.annAssign(target: target,
                                       annotation: ann,
                                       value: nil,
                                       isSimple: true)
    let stmt2 = self.statement(kind, start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAnnot("rapunzel"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  // nonlocal rapunzel
  // rapunzel: Int
  func test_annAssign_nonlocal_withAnnotation_throws() {
    let stmt1 = self.nonlocalStmt(name: "rapunzel")

    let target = self.expression(.identifier("rapunzel"))
    let ann    = self.expression(.identifier("Int"))

    let kind = StatementKind.annAssign(target: target,
                                       annotation: ann,
                                       value: nil,
                                       isSimple: true)
    let stmt2 = self.statement(kind, start: loc1)

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAnnot("rapunzel"))
      XCTAssertEqual(error.location, loc1)
    }
  }
}
