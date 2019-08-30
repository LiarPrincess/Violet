import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable function_body_length
// swiftlint:disable file_length

/// Basic checks for comprehension, without nested scopes.
/// Just so we know that we visit all childs.
/// Use 'Tools/dump_symtable.py' for reference.
class STExprComprehension: XCTestCase, CommonSymbolTable {

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
    let elt = self.expression(.identifier("ariel"), start: loc1)
    let iter = self.expression(.identifier("sea"), start: loc2)

    let compr = self.comprehension(target: elt,
                                   iter: iter,
                                   ifs: [],
                                   isAsync: false)

    let kind = ExpressionKind.listComprehension(
      elt: elt,
      generators: NonEmptyArray(first: compr)
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "sea",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc2)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "listcomp", type: .function, flags: [.isNested])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varnames.count, 1)
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
    let elt = self.expression(.identifier("ariel"), start: loc1)
    let iff = self.expression(.identifier("hasLegs"), start: loc2)

    let compr = self.comprehension(target: elt,
                                   iter: self.expression(.list([])),
                                   ifs: [iff],
                                   isAsync: true)

    let kind = ExpressionKind.listComprehension(
      elt: elt,
      generators: NonEmptyArray(first: compr)
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.symbols.isEmpty)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "listcomp", type: .function, flags: [.isNested, .isCoroutine])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varnames.count, 1)
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
                              name: "hasLegs",
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
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
    let elt1 = self.expression(.identifier("ariel"), start: loc1)
    let compr1 = self.comprehension(target: elt1,
                                    iter: self.expression(.list([])),
                                    ifs: [],
                                    isAsync: false)

    let elt2 = self.expression(.identifier("eric"), start: loc2)
    let compr2 = self.comprehension(target: elt2,
                                    iter: self.expression(.list([])),
                                    ifs: [],
                                    isAsync: false)

    let kind = ExpressionKind.listComprehension(
      elt: elt2,
      generators: NonEmptyArray(first: compr1, rest: [compr2])
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)
      XCTAssert(top.symbols.isEmpty)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "listcomp", type: .function, flags: [.isNested])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varnames.count, 1)
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
                              flags: [.srcGlobalImplicit, .use],
                              location: loc2)
    }
  }

  // MARK: - Set

  /// {ariel for ariel in sea}
  /// (similiar to `self.test_list`)
  func test_set() {
    let elt = self.expression(.identifier("ariel"), start: loc1)
    let iter = self.expression(.identifier("sea"), start: loc2)

    let compr = self.comprehension(target: elt,
                                   iter: iter,
                                   ifs: [],
                                   isAsync: false)

    let kind = ExpressionKind.setComprehension(
      elt: elt,
      generators: NonEmptyArray(first: compr)
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)

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

      XCTAssertEqual(listComp.varnames.count, 1)
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
    let key = self.expression(.identifier("ariel"), start: loc1)
    let value = self.expression(.identifier("eric"), start: loc2)
    let iter = self.expression(.identifier("sea"), start: loc3)

    let compr = self.comprehension(target: key,
                                   iter: iter,
                                   ifs: [],
                                   isAsync: false)

    let kind = ExpressionKind.dictionaryComprehension(
      key: key,
      value: value,
      generators: NonEmptyArray(first: compr)
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "sea",
                              flags: [.use, .srcGlobalImplicit],
                              location: loc3)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let listComp = top.children[0]
      XCTAssertScope(listComp, name: "dictcomp", type: .function, flags: [.isNested])
      XCTAssert(listComp.children.isEmpty)

      XCTAssertEqual(listComp.varnames.count, 1)
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
                              location: loc2)
    }
  }

  // MARK: - Generator

  /// [ariel for ariel in sea]
  /// (similiar to `self.test_list`)
  func test_generator() {
    let elt = self.expression(.identifier("ariel"), start: loc1)
    let iter = self.expression(.identifier("sea"), start: loc2)

    let compr = self.comprehension(target: elt,
                                   iter: iter,
                                   ifs: [],
                                   isAsync: false)

    let kind = ExpressionKind.generatorExp(
      elt: elt,
      generators: NonEmptyArray(first: compr)
    )

    if let table = self.createSymbolTable(forExpr: kind) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varnames.isEmpty)

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

      XCTAssertEqual(listComp.varnames.count, 1)
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
