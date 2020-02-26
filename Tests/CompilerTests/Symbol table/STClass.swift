import XCTest
import Core
import Parser
@testable import Compiler

// swiftlint:disable function_body_length

/// Use 'Tools/dump_symtable.py' for reference.
class STClass: SymbolTableTestCase {

  /// class Aurora:
  /// def __init__(self, name):
  ///     self.name = name
  ///
  /// ```c
  /// name: top
  /// lineno: 0
  /// symbols:
  ///   Aurora - local, assigned, namespace,
  /// children:
  ///   name: Aurora
  ///   lineno: 1
  ///   methods: ('__init__',)
  ///   symbols:
  ///     __init__ - local, assigned, namespace,
  ///   children:
  ///     name: __init__
  ///     lineno: 2
  ///     is optimized
  ///     parameters: ('self', 'name')
  ///     locals: ('self', 'name')
  ///     symbols:
  ///       self - referenced, parameter, local,
  ///       name - referenced, parameter, local,
  /// ```
  func test_init_singleArg() {
    let __init__ = self.functionDefStmt(
      name: "__init__",
      args: self.arguments(
        args: [
          self.arg(name: "self", start: loc1),
          self.arg(name: "name", start: loc2)
        ]
      ),
      body: [
        self.assignStmt(
          targets: [
            self.attributeExpr(
              object: self.identifierExpr(value: "self"),
              name: "name",
              context: .store
            )
          ],
          value: self.identifierExpr(value: "name")
        )
      ],
      start: loc3
    )

    let stmt = self.classDefStmt(
      name: "Aurora",
      bases: [],
      keywords: [],
      body: [__init__],
      start: loc4
    )

    if let table = self.createSymbolTable(stmt: stmt) {
      let top = table.top
      XCTAssertScope(top, name: "top", type: .module, flags: [])
      XCTAssert(top.varNames.isEmpty)

      XCTAssertEqual(top.symbols.count, 1)
      XCTAssertContainsSymbol(top,
                              name: "Aurora",
                              flags: [.defLocal, .srcLocal],
                              location: loc4)

      XCTAssertEqual(top.children.count, 1)
      guard top.children.count == 1 else { return }

      let cls = top.children[0]
      XCTAssertScope(cls,
                     name: "Aurora",
                     type: .class,
                     flags: [])

      XCTAssert(cls.varNames.isEmpty)

      XCTAssertEqual(cls.symbols.count, 1)
      XCTAssertContainsSymbol(cls,
                              name: "__init__",
                              flags: [.defLocal, .srcLocal],
                              location: loc3)

      XCTAssertEqual(cls.children.count, 1)
      guard cls.children.count == 1 else { return }

      let __init__ = cls.children[0]
      XCTAssertScope(__init__,
                     name: "__init__",
                     type: .function,
                     flags: [.isNested])

      XCTAssert(__init__.children.isEmpty)

      XCTAssertEqual(__init__.varNames.count, 2)
      XCTAssertContainsParameter(__init__, name: "self")
      XCTAssertContainsParameter(__init__, name: "name")

      XCTAssertEqual(__init__.symbols.count, 2)
      XCTAssertContainsSymbol(__init__,
                              name: "self",
                              flags: [.defParam, .srcLocal, .use],
                              location: loc1)
      XCTAssertContainsSymbol(__init__,
                              name: "name",
                              flags: [.defParam, .srcLocal, .use],
                              location: loc2)
    }
  }
}
