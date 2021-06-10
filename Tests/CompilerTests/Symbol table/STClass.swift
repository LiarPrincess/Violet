import XCTest
import VioletCore
import VioletParser
@testable import VioletCompiler

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

    guard let table = self.createSymbolTable(stmt: stmt) else {
      return
    }

    XCTAssertScope(
      table.top,
      name: "top",
      kind: .module,
      flags: [],
      symbols: [
        .init(name: "Aurora", flags: [.defLocal, .srcLocal], location: loc4)
      ],
      parameters: [],
      childrenCount: 1
    )

    guard let classScope = self.getChildScope(table.top, at: 0) else {
      return
    }

    XCTAssertScope(
      classScope,
      name: "Aurora",
      kind: .class,
      flags: [],
      symbols: [
        .init(name: "__init__", flags: [.defLocal, .srcLocal], location: loc3)
      ],
      parameters: [],
      childrenCount: 1
    )

    guard let __init__Scope = self.getChildScope(classScope, at: 0) else {
      return
    }

    XCTAssertScope(
      __init__Scope,
      name: "__init__",
      kind: .function,
      flags: [.isNested],
      symbols: [
        .init(name: "self", flags: [.defParam, .srcLocal, .use], location: loc1),
        .init(name: "name", flags: [.defParam, .srcLocal, .use], location: loc2)
      ],
      parameters: ["self", "name"],
      childrenCount: 0
    )
  }
}
