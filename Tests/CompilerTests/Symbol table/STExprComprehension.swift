import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable file_length
// swiftlint:disable function_body_length

/// Basic checks for comprehension, without nested scopes.
/// Just so we know that we visit all childs.
/// Use 'Tools/dump_symtable.py' for reference.
class STExprComprehension: SymbolTableTestCase {

  // MARK: - List

  /// [ariel for ariel in sea]
  ///
  /// ```c
  ///  name: top
  ///  lineno: 0
  ///  symbols:
  ///    sea - referenced, global,
  ///  children:
  ///    name: listcomp
  ///    lineno: 1
  ///    is optimized
  ///    parameters: ('.0',)
  ///    locals: ('.0', 'ariel')
  ///    symbols:
  ///      .0 - parameter, local,
  ///      ariel - referenced, local, assigned,
  /// ```
  func test_list() {
    let expr = self.listComprehensionExpr(
      element: self.identifierExpr(value: "ariel", start: loc1),
      generators: [
        self.comprehension(
          target: self.identifierExpr(value: "ariel", context: .store, start: loc2),
          iter: self.identifierExpr(value: "sea", start: loc3),
          ifs: [],
          isAsync: false
        )
      ]
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "sea",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc3)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "listcomp", type: .function, flags: [.isNested])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varNames.count, 1)
      XCTAssertContainsParameter(listComp, name: ".0")

      XCTAssertEqual(listComp.symbols.count, 2)
      XCTAssertContainsSymbol(listComp,
                              name: ".0",
                              flags: [.defParam, .srcLocal])
      XCTAssertContainsSymbol(listComp,
                              name: "ariel",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc2)
    }
  }

  /// [ariel for ariel in [] if hasLegs]
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  /// children:
  ///   name: listcomp
  ///   lineno: 1
  ///   is optimized
  ///   parameters: ('.0',)
  ///   locals: ('.0', 'ariel')
  ///   globals: ('hasLegs',)
  ///   symbols:
  ///     .0 - parameter, local,
  ///     ariel - referenced, local, assigned,
  ///     hasLegs - referenced, global,
  /// ```
  func test_list_ifs() {
    let expr = self.listComprehensionExpr(
      element: self.identifierExpr(value: "ariel", start: loc1),
      generators: [
        self.comprehension(
          target: self.identifierExpr(value: "ariel", context: .store, start: loc2),
          iter: self.listExpr(elements: []),
          ifs: [
            self.identifierExpr(value: "hasLegs", start: loc3)
          ],
          isAsync: true
        )
      ]
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
      XCTAssert(top.symbols.isEmpty)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "listcomp", type: .function, flags: [.isNested, .isCoroutine])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varNames.count, 1)
      XCTAssertContainsParameter(listComp, name: ".0")

      XCTAssertEqual(listComp.symbols.count, 3)
      XCTAssertContainsSymbol(listComp,
                              name: ".0",
                              flags: [.defParam, .srcLocal])
      XCTAssertContainsSymbol(listComp,
                              name: "ariel",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc2)
      XCTAssertContainsSymbol(listComp,
                              name: "hasLegs",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc3)
    }
  }

  /// [eric for ariel in [] for eric in []]
  ///
  /// name: top
  /// lineno: 0
  /// symbols:
  /// children:
  ///   name: listcomp
  ///   lineno: 1
  ///   is optimized
  ///   parameters: ('.0',)
  ///   locals: ('.0', 'ariel', 'eric')
  ///   symbols:
  ///     .0 - parameter, local,
  ///     ariel - local, assigned,
  ///     eric - referenced, local, assigned,
  func test_list_nested() {
    let compr1 = self.comprehension(
      target: self.identifierExpr(value: "ariel", context: .store, start: loc1),
      iter: self.listExpr(elements: []),
      ifs: [],
      isAsync: false
    )

    let compr2 = self.comprehension(
      target: self.identifierExpr(value: "eric", context: .store, start: loc2),
      iter: self.listExpr(elements: []),
      ifs: [],
      isAsync: false
    )

    let expr = self.listComprehensionExpr(
      element: self.identifierExpr(value: "eric", start: loc3),
      generators: [compr1, compr2]
    )

    if let table = self.createSymbolTable(expr: expr) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)
      XCTAssert(top.symbols.isEmpty)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "listcomp", type: .function, flags: [.isNested])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varNames.count, 1)
      XCTAssertContainsParameter(listComp, name: ".0")

      XCTAssertEqual(listComp.symbols.count, 3)
      XCTAssertContainsSymbol(listComp,
                              name: ".0",
                              flags: [.defParam, .srcLocal])
      XCTAssertContainsSymbol(listComp,
                              name: "ariel",
                              flags: [.defLocal, .srcLocal],
                              location: loc1)
      XCTAssertContainsSymbol(listComp,
                              name: "eric",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc2)
    }
  }

  // MARK: - Set

  /// {ariel for ariel in sea}
  /// (similiar to `self.test_list`)
  func test_set() {
    let compr = self.comprehension(
      target: self.identifierExpr(value: "ariel", context: .store, start: loc1),
      iter: self.identifierExpr(value: "sea", start: loc2),
      ifs: [],
      isAsync: false
    )

    let kind = self.setComprehensionExpr(
      element: self.identifierExpr(value: "ariel", start: loc3),
      generators: [compr]
    )

    if let table = self.createSymbolTable(expr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "sea",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "setcomp", type: .function, flags: [.isNested])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varNames.count, 1)
      XCTAssertContainsParameter(listComp, name: ".0")

      XCTAssertEqual(listComp.symbols.count, 2)
      XCTAssertContainsSymbol(listComp,
                              name: ".0",
                              flags: [.defParam, .srcLocal])
      XCTAssertContainsSymbol(listComp,
                              name: "ariel",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc1)
    }
  }

  // MARK: - Dictionary

  /// {ariel: eric for ariel in sea}
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   sea - referenced, global,
  /// children:
  ///   name: dictcomp
  ///   lineno: 1
  ///   is optimized
  ///   parameters: ('.0',)
  ///   locals: ('.0', 'ariel')
  ///   globals: ('eric',)
  ///   symbols:
  ///     .0 - parameter, local,
  ///     ariel - referenced, local, assigned,
  ///     eric - referenced, global,
  /// ```
  func test_dictionary() {
    let compr = self.comprehension(
      target: self.identifierExpr(value: "ariel", context: .store, start: loc1),
      iter: self.identifierExpr(value: "sea", start: loc2),
      ifs: [],
      isAsync: false
    )

    let kind = self.dictionaryComprehensionExpr(
      key: self.identifierExpr(value: "ariel", start: loc3),
      value: self.identifierExpr(value: "eric", start: loc4),
      generators: [compr]
    )

    if let table = self.createSymbolTable(expr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "sea",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "dictcomp", type: .function, flags: [.isNested])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varNames.count, 1)
      XCTAssertContainsParameter(listComp, name: ".0")

      XCTAssertEqual(listComp.symbols.count, 3)
      XCTAssertContainsSymbol(listComp,
                              name: ".0",
                              flags: [.defParam, .srcLocal])
      XCTAssertContainsSymbol(listComp,
                              name: "ariel",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc1)
      XCTAssertContainsSymbol(listComp,
                              name: "eric",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc4)
    }
  }

  // MARK: - Generator

  /// [ariel for ariel in sea]
  /// (similiar to `self.test_list`)
  func test_generator() {
    let compr = self.comprehension(
      target: self.identifierExpr(value: "ariel", context: .store, start: loc1),
      iter: self.identifierExpr(value: "sea", start: loc2),
      ifs: [],
      isAsync: false
    )

    let kind = self.generatorExpr(
      element: self.identifierExpr(value: "ariel", start: loc3),
      generators: [compr]
    )

    if let table = self.createSymbolTable(expr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "sea",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp,
                     name: "genexpr",
                     type: .function,
                     flags: [.isNested, .isGenerator])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varNames.count, 1)
      XCTAssertContainsParameter(listComp, name: ".0")

      XCTAssertEqual(listComp.symbols.count, 2)
      XCTAssertContainsSymbol(listComp,
                              name: ".0",
                              flags: [.defParam, .srcLocal])
      XCTAssertContainsSymbol(listComp,
                              name: "ariel",
                              flags: [.defLocal, .srcLocal, .use],
                              location: loc1)
    }
  }
}
