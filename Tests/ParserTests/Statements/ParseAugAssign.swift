import XCTest
import BigInt
import VioletCore
import VioletLexer
@testable import VioletParser

// swiftlint:disable function_body_length
// swiftformat:disable consecutiveSpaces

class ParseAugAssign: XCTestCase, Common {

  // MARK: - Augumented assignment

  /// Ariel += "legs"
  func test_simple() {
    let augAssign: [TokenKind: BinaryOpExpr.Operator] = [
      .plusEqual: .add, // +=
      .minusEqual: .sub, // -=
      .starEqual: .mul, // *=
      .atEqual: .matMul, // @=
      .slashEqual: .div, // /=
      .percentEqual: .modulo, // %=

      .amperEqual: .bitAnd, // &=
      .vbarEqual: .bitOr, // |=
      .circumflexEqual: .bitXor, // ^=

      .leftShiftEqual: .leftShift, // <<=
      .rightShiftEqual: .rightShift, // >>=
      .starStarEqual: .pow, // **=
      .slashSlashEqual: .floorDiv // //=
    ]

    for (tokenKind, op) in augAssign {
      let parser = self.createStmtParser(
        self.token(.identifier("Ariel"), start: loc0, end: loc1),
        self.token(tokenKind,            start: loc2, end: loc3),
        self.token(.string("legs"),      start: loc4, end: loc5)
      )

      guard let ast = self.parse(parser) else { continue }

      XCTAssertAST(ast, """
      ModuleAST(start: 0:0, end: 5:10)
        AugAssignStmt(start: 0:0, end: 5:10)
          Target
            IdentifierExpr(context: Store, start: 0:0, end: 1:6)
              Value: Ariel
          Operator: \(op)
          Value
            StringExpr(context: Load, start: 4:4, end: 5:10)
              String: 'legs'
      """)
    }
  }

  /// sea.cavern += "Gizmos"
  func test_toAttribute() {
    let parser = self.createStmtParser(
      self.token(.identifier("sea"),    start: loc0, end: loc1),
      self.token(.dot,                  start: loc2, end: loc3),
      self.token(.identifier("cavern"), start: loc4, end: loc5),
      self.token(.plusEqual,            start: loc6, end: loc7),
      self.token(.string("Gizmos"),     start: loc8, end: loc9)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 9:14)
      AugAssignStmt(start: 0:0, end: 9:14)
        Target
          AttributeExpr(context: Store, start: 0:0, end: 5:10)
            Object
              IdentifierExpr(context: Load, start: 0:0, end: 1:6)
                Value: sea
            Name: cavern
        Operator: +
        Value
          StringExpr(context: Load, start: 8:8, end: 9:14)
            String: 'Gizmos'
    """)
  }

  /// sea[cavern] += "Gizmos"
  func test_toSubscript() {
    let parser = self.createStmtParser(
      self.token(.identifier("sea"),    start: loc0, end: loc1),
      self.token(.leftSqb,              start: loc2, end: loc3),
      self.token(.identifier("cavern"), start: loc4, end: loc5),
      self.token(.rightSqb,             start: loc6, end: loc7),
      self.token(.plusEqual,            start: loc8, end: loc9),
      self.token(.string("Gizmos"),     start: loc10, end: loc11)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 11:16)
      AugAssignStmt(start: 0:0, end: 11:16)
        Target
          SubscriptExpr(context: Store, start: 0:0, end: 7:12)
            Object
              IdentifierExpr(context: Load, start: 0:0, end: 1:6)
                Value: sea
            Slice(start: 2:2, end: 7:12)
              Index
                IdentifierExpr(context: Load, start: 4:4, end: 5:10)
                  Value: cavern
        Operator: +
        Value
          StringExpr(context: Load, start: 10:10, end: 11:16)
            String: 'Gizmos'
    """)
  }

  /// 3 += "Ursula"
  func test_toConstants_throws() {
    let parser = self.createStmtParser(
      self.token(.int(BigInt(3)),    start: loc0, end: loc1),
      self.token(.plusEqual,         start: loc2, end: loc3),
      self.token(.string("Ursula"),  start: loc4, end: loc5)
    )

    if let error = self.error(parser) {
      XCTAssertEqual(error.kind, .illegalAugAssignmentTarget)
      XCTAssertEqual(error.location, loc0)
    }
  }

  /// Ariel += yield "legs"
  func test_yield() {
    let parser = self.createStmtParser(
      self.token(.identifier("Ariel"), start: loc0, end: loc1),
      self.token(.plusEqual,           start: loc2, end: loc3),
      self.token(.yield,               start: loc4, end: loc5),
      self.token(.string("legs"),      start: loc6, end: loc7)
    )

    guard let ast = self.parse(parser) else { return }

    XCTAssertAST(ast, """
    ModuleAST(start: 0:0, end: 7:12)
      AugAssignStmt(start: 0:0, end: 7:12)
        Target
          IdentifierExpr(context: Store, start: 0:0, end: 1:6)
            Value: Ariel
        Operator: +
        Value
          YieldExpr(context: Load, start: 4:4, end: 7:12)
            Value
              StringExpr(context: Load, start: 6:6, end: 7:12)
                String: 'legs'
    """)
  }
}
