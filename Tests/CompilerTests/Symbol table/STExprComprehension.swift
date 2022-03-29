import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

// swiftlint:disable function_body_length

/// Basic checks for comprehension, without nested scopes.
/// Just so we know that we visit all children.
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
          iterable: self.identifierExpr(value: "sea", start: loc3),
          ifs: [],
          isAsync: false
        )
      ]
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "sea", flags: [.use, .srcGlobalImplicit], location: loc3)
      ],
      parameters: [],
      childrenCount: 1
    )

    guard let comp = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      comp,
      name: "listcomp",
      kind: .comprehension(.list),
      flags: [.isNested],
      symbols: [
        .init(name: ".0", flags: [.defParam, .srcLocal]),
        .init(name: "ariel", flags: [.defLocal, .srcLocal, .use], location: loc1)
      ],
      parameters: [".0"],
      childrenCount: 0
    )
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
          iterable: self.listExpr(elements: []),
          ifs: [
            self.identifierExpr(value: "hasLegs", start: loc3)
          ],
          isAsync: true // This will make it coroutine!
        )
      ]
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [],
      parameters: [],
      childrenCount: 1
    )

    guard let comp = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      comp,
      name: "listcomp",
      kind: .comprehension(.list),
      flags: [.isNested, .isCoroutine], // Coroutine!
      symbols: [
        .init(name: ".0", flags: [.defParam, .srcLocal]),
        .init(name: "ariel", flags: [.defLocal, .srcLocal, .use], location: loc1),
        .init(name: "hasLegs", flags: [.srcGlobalImplicit, .use], location: loc3)
      ],
      parameters: [".0"],
      childrenCount: 0
    )
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
    let comp1 = self.comprehension(
      target: self.identifierExpr(value: "ariel", context: .store, start: loc1),
      iterable: self.listExpr(elements: []),
      ifs: [],
      isAsync: false
    )

    let comp2 = self.comprehension(
      target: self.identifierExpr(value: "eric", context: .store, start: loc2),
      iterable: self.listExpr(elements: []),
      ifs: [],
      isAsync: false
    )

    let expr = self.listComprehensionExpr(
      element: self.identifierExpr(value: "eric", start: loc3),
      generators: [comp1, comp2]
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [],
      parameters: [],
      childrenCount: 1
    )

    guard let compScope = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      compScope,
      name: "listcomp",
      kind: .comprehension(.list),
      flags: [.isNested],
      symbols: [
        .init(name: ".0", flags: [.defParam, .srcLocal]),
        .init(name: "ariel", flags: [.defLocal, .srcLocal], location: loc1),
        .init(name: "eric", flags: [.defLocal, .srcLocal, .use], location: loc2)
      ],
      parameters: [".0"],
      childrenCount: 0
    )
  }

  // MARK: - Set

  /// {ariel for ariel in sea}
  /// (similar to `self.test_list`)
  func test_set() {
    let expr = self.setComprehensionExpr(
      element: self.identifierExpr(value: "ariel", start: loc3),
      generators: [
        self.comprehension(
          target: self.identifierExpr(value: "ariel", context: .store, start: loc1),
          iterable: self.identifierExpr(value: "sea", start: loc2),
          ifs: [],
          isAsync: false
        )
      ]
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "sea", flags: [.use, .srcGlobalImplicit], location: loc2)
      ],
      parameters: [],
      childrenCount: 1
    )

    guard let comp = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      comp,
      name: "setcomp",
      kind: .comprehension(.set),
      flags: [.isNested],
      symbols: [
        .init(name: ".0", flags: [.defParam, .srcLocal]),
        .init(name: "ariel", flags: [.defLocal, .srcLocal, .use], location: loc1)
      ],
      parameters: [".0"],
      childrenCount: 0
    )
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
    let expr = self.dictionaryComprehensionExpr(
      key: self.identifierExpr(value: "ariel", start: loc3),
      value: self.identifierExpr(value: "eric", start: loc4),
      generators: [
        self.comprehension(
          target: self.identifierExpr(value: "ariel", context: .store, start: loc1),
          iterable: self.identifierExpr(value: "sea", start: loc2),
          ifs: [],
          isAsync: false
        )
      ]
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "sea", flags: [.use, .srcGlobalImplicit], location: loc2)
      ],
      parameters: [],
      childrenCount: 1
    )

    guard let comp = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      comp,
      name: "dictcomp",
      kind: .comprehension(.dictionary),
      flags: [.isNested],
      symbols: [
        .init(name: ".0", flags: [.defParam, .srcLocal]),
        .init(name: "ariel", flags: [.defLocal, .srcLocal, .use], location: loc1),
        .init(name: "eric", flags: [.srcGlobalImplicit, .use], location: loc4)
      ],
      parameters: [".0"],
      childrenCount: 0
    )
  }

  // MARK: - Generator

  /// [ariel for ariel in sea]
  /// (similar to `self.test_list`)
  func test_generator() {
    let expr = self.generatorExpr(
      element: self.identifierExpr(value: "ariel", start: loc3),
      generators: [
        self.comprehension(
          target: self.identifierExpr(value: "ariel", context: .store, start: loc1),
          iterable: self.identifierExpr(value: "sea", start: loc2),
          ifs: [],
          isAsync: false
        )
      ]
    )

    guard let table = self.createSymbolTable(expr: expr) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "sea", flags: [.use, .srcGlobalImplicit], location: loc2)
      ],
      parameters: [],
      childrenCount: 1
    )

    guard let comp = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      comp,
      name: "genexpr",
      kind: .comprehension(.generator),
      flags: [.isNested, .isGenerator],
      symbols: [
        .init(name: ".0", flags: [.defParam, .srcLocal]),
        .init(name: "ariel", flags: [.defLocal, .srcLocal, .use], location: loc1)
      ],
      parameters: [".0"],
      childrenCount: 0
    )
  }
}
