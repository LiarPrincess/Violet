import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable file_length

/// Basic checks for assigns, without nested scopes.
/// Just so we know that we visit all childs.
/// Use 'Tools/dump_symtable.py' for reference.
class STAssign: SymbolTableTestCase {

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
    let stmt = self.assign(
      target: self.identifierExpr("rapunzel", start: loc1),
      value: self.expression(.int(BigInt(5)))
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt = self.assign(
      target: self.identifierExpr("rapunzel", start: loc1),
      value: self.identifierExpr("rapunzel")
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt = self.assign(
      target: [
        self.identifierExpr("rapunzel", start: loc1),
        self.expression(.identifier("eugine"), start: loc2)
      ],
      value: self.expression(.int(BigInt(5)))
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt = self.augAssign(
      target: self.identifierExpr("rapunzel", start: loc1),
      op: .add,
      value: self.expression(.int(BigInt(5)))
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt = self.augAssign(
      target: self.identifierExpr("rapunzel", start: loc1),
      op: .add,
      value: self.identifierExpr("rapunzel")
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt = self.annAssign(
      target: self.identifierExpr("rapunzel", start: loc1),
      annotation: self.expression(.identifier("Int"), start: loc2),
      value: self.expression(.int(BigInt(5))),
      isSimple: true
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt = self.annAssign(
      target: self.identifierExpr("rapunzel", start: loc1),
      annotation: self.expression(.identifier("Int"), start: loc2),
      value: self.expression(.int(BigInt(5))),
      isSimple: false // <- parens
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let target = self.expression(
      .attribute(
        self.identifierExpr("tangled", start: loc1),
        name: "rapunzel"
      )
    )

    let stmt = self.annAssign(
      target: target,
      annotation: self.identifierExpr("Int", start: loc3),
      value: self.expression(.int(BigInt(5))),
      isSimple: false
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt = self.annAssign(
      target: self.identifierExpr("rapunzel", start: loc1),
      annotation: self.expression(.identifier("Int"), start: loc2),
      value: self.identifierExpr("rapunzel", start: loc3),
      isSimple: true
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt = self.annAssign(
      target: self.identifierExpr("rapunzel", start: loc1),
      annotation: self.expression(.identifier("Int"), start: loc2),
      value: nil,
      isSimple: true
    )

    if let table = self.createSymbolTable(forStmt: stmt) {
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
    let stmt1 = self.global(name: "rapunzel")

    let stmt2 = self.annAssign(
      target: self.identifierExpr("rapunzel"),
      annotation: self.identifierExpr("Int"),
      value: nil,
      isSimple: true,
      start: loc1
    )

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAnnot("rapunzel"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  // nonlocal rapunzel
  // rapunzel: Int
  func test_annAssign_nonlocal_withAnnotation_throws() {
    let stmt1 = self.nonlocal(name: "rapunzel")

    let stmt2 = self.annAssign(
      target: self.identifierExpr("rapunzel"),
      annotation: self.identifierExpr("Int"),
      value: nil,
      isSimple: true,
      start: loc1
    )

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAnnot("rapunzel"))
      XCTAssertEqual(error.location, loc1)
    }
  }
}
