import XCTest
import VioletCore
import VioletLexer
@testable import VioletParser

class ParseRaise: XCTestCase, Common {

  /// raise
  func test_reRaise() {
    let parser = self.createStmtParser(
      self.token(.raise, start: loc0, end: loc1)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 1:6)
      RaiseStmt(start: 0:0, end: 1:6)
        Exc: none
        Cause: none
    """)
  }

  /// raise Hades
  func test_exception() {
    let parser = self.createStmtParser(
      self.token(.raise,               start: loc0, end: loc1),
      self.token(.identifier("Hades"), start: loc2, end: loc3)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 3:8)
      RaiseStmt(start: 0:0, end: 3:8)
        Exc
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Hades
        Cause: none
    """)
  }

  /// raise Hercules from Olympus
  func test_exception_from() {
    let parser = self.createStmtParser(
      self.token(.raise,                start: loc0, end: loc1),
      self.token(.identifier("Hercules"), start: loc2, end: loc3),
      self.token(.from,                 start: loc4, end: loc5),
      self.token(.identifier("Olympus"),   start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      RaiseStmt(start: 0:0, end: 7:12)
        Exc
          IdentifierExpr(context: Load, start: 2:2, end: 3:8)
            Value: Hercules
        Cause
          IdentifierExpr(context: Load, start: 6:6, end: 7:12)
            Value: Olympus
    """)
  }
}
