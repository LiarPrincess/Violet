import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

// swiftlint:disable file_length

/// Basic checks for assigns, without nested scopes.
/// Just so we know that we visit all children.
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
    let stmt = self.assignStmt(
      targets: [
        self.identifierExpr(value: "rapunzel", context: .store, start: loc1)
      ],
      value: self.intExpr(value: 5)
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

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
    let stmt = self.assignStmt(
      targets: [
        self.identifierExpr(value: "rapunzel", context: .store, start: loc1)
      ],
      value: self.identifierExpr(value: "rapunzel")
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc1)
    }
  }

  /// rapunzel = eugene = 5
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - local, assigned,
  ///   eugene - local, assigned,
  /// ```
  func test_assign_multiple() {
    let stmt = self.assignStmt(
      targets: [
        self.identifierExpr(value: "rapunzel", context: .store, start: loc1),
        self.identifierExpr(value: "eugene", context: .store, start: loc2)
      ],
      value: self.intExpr(value: 5)
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "rapunzel",
                              flags: [.defLocal, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(top,
                              name: "eugene",
                              flags: [.defLocal, .srcLocal],
                              location: loc2)
    }
  }

  // MARK: - Augmented assign

  /// rapunzel += 5
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   rapunzel - local, assigned,
  /// ```
  func test_augAssign() {
    let stmt = self.augAssignStmt(
      target: self.identifierExpr(value: "rapunzel", context: .store, start: loc1),
      op: .add,
      value: self.intExpr(value: 5)
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

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
    let stmt = self.augAssignStmt(
      target: self.identifierExpr(value: "rapunzel", context: .store, start: loc1),
      op: .add,
      value: self.identifierExpr(value: "rapunzel")
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

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
    let stmt = self.annAssignStmt(
      target: self.identifierExpr(value: "rapunzel", context: .store, start: loc1),
      annotation: self.identifierExpr(value: "Int", start: loc2),
      value: self.intExpr(value: 5),
      isSimple: true
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

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
    let stmt = self.annAssignStmt(
      target: self.identifierExpr(value: "rapunzel", context: .store, start: loc1),
      annotation: self.identifierExpr(value: "Int", start: loc2),
      value: self.intExpr(value: 5),
      isSimple: false // <- parens
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

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
  ///   tangled - referenced, global,
  ///   Int - referenced, global,
  /// ```
  func test_annAssign_attribute() {
    let target = self.attributeExpr(
      object: self.identifierExpr(value: "tangled", start: loc1),
      name: "rapunzel",
      context: .store
    )

    let stmt = self.annAssignStmt(
      target: target,
      annotation: self.identifierExpr(value: "Int", start: loc3),
      value: self.intExpr(value: 5),
      isSimple: false
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 2)
      XCTAssertContainsSymbol(top,
                              name: "tangled",
                              flags: [.srcGlobalImplicit, .use],
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
    let stmt = self.annAssignStmt(
      target: self.identifierExpr(value: "rapunzel", context: .store, start: loc1),
      annotation: self.identifierExpr(value: "Int", start: loc2),
      value: self.identifierExpr(value: "rapunzel", start: loc3),
      isSimple: true
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

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
    let stmt = self.annAssignStmt(
      target: self.identifierExpr(value: "rapunzel", context: .store, start: loc1),
      annotation: self.identifierExpr(value: "Int", start: loc2),
      value: nil,
      isSimple: true
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.children.isEmpty)
      XCTAssert(top.parameterNames.isEmpty)

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
    let stmt1 = self.globalStmt(identifier: "rapunzel")

    let stmt2 = self.annAssignStmt(
      target: self.identifierExpr(value: "rapunzel"),
      annotation: self.identifierExpr(value: "Int"),
      value: nil,
      isSimple: true,
      start: loc1
    )

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .globalAnnotated("rapunzel"))
      XCTAssertEqual(error.location, loc1)
    }
  }

  // nonlocal rapunzel
  // rapunzel: Int
  func test_annAssign_nonlocal_withAnnotation_throws() {
    let stmt1 = self.nonlocalStmt(identifier: "rapunzel")

    let stmt2 = self.annAssignStmt(
      target: self.identifierExpr(value: "rapunzel"),
      annotation: self.identifierExpr(value: "Int"),
      value: nil,
      isSimple: true,
      start: loc1
    )

    if let error = self.error(forStmts: [stmt1, stmt2]) {
      XCTAssertEqual(error.kind, .nonlocalAnnotated("rapunzel"))
      XCTAssertEqual(error.location, loc1)
    }
  }
}
