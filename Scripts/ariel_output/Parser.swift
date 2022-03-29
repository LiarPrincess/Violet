=====================
=== ASTNode.swift ===
=====================

public typealias ASTNodeId = UInt
public protocol ASTNode: Hashable {}
extension ASTNode {
  public static func ==(lhs: Self, rhs: Self) -> Bool
  public func hash(into hasher: inout Hasher)
}

==========================
=== ASTValidator.swift ===
==========================

public final class ASTValidator {
  public init()
  public func validate(ast: AST) throws
}

================================
=== Atoms/FStringError.swift ===
================================

public indirect enum FStringError: Error, Equatable, CustomStringConvertible {
  public var description: String { get }
}

==================================
=== Errors/ExpectedToken.swift ===
==================================

public enum ExpectedToken {}
extension ExpectedToken: CustomStringConvertible {
  public var description: String { get }
}

extension Token.Kind {
  public var expected: ExpectedToken { get }
}

================================
=== Errors/ParserError.swift ===
================================

public struct ParserError: Error, Equatable, CustomStringConvertible {
  public let kind: ParserErrorKind
  public let location: SourceLocation
  public var description: String { get }
  public init(_ kind: ParserErrorKind, location: SourceLocation)
}

====================================
=== Errors/ParserErrorKind.swift ===
====================================

public enum ParserErrorKind: Equatable {}
extension ParserErrorKind: CustomStringConvertible {
  public var description: String { get }
}

==================================
=== Errors/ParserWarning.swift ===
==================================

public struct ParserWarning: CustomStringConvertible {
  public let kind: ParserWarningKind
  public let location: SourceLocation
  public var description: String { get }
  public init(_ kind: ParserWarningKind, location: SourceLocation)
}

public enum ParserWarningKind: CustomStringConvertible {
  public var description: String { get }
}

===========================
=== Generated/AST.swift ===
===========================

public class AST: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, start: SourceLocation, end: SourceLocation)
  public func accept<V: ASTVisitor>(_ visitor: V) throws -> V.ASTResult
  public func accept<V: ASTVisitorWithPayload>(_ visitor: V, payload: V.ASTPayload) throws -> V.ASTResult
}

public final class InteractiveAST: AST {
  public var statements: [Statement]
  public init(id: ASTNodeId, statements: [Statement], start: SourceLocation, end: SourceLocation)
  public override func accept<V: ASTVisitor>(_ visitor: V) throws -> V.ASTResult
  public override func accept<V: ASTVisitorWithPayload>(_ visitor: V, payload: V.ASTPayload) throws -> V.ASTResult
}

public final class ModuleAST: AST {
  public var statements: [Statement]
  public init(id: ASTNodeId, statements: [Statement], start: SourceLocation, end: SourceLocation)
  public override func accept<V: ASTVisitor>(_ visitor: V) throws -> V.ASTResult
  public override func accept<V: ASTVisitorWithPayload>(_ visitor: V, payload: V.ASTPayload) throws -> V.ASTResult
}

public final class ExpressionAST: AST {
  public var expression: Expression
  public init(id: ASTNodeId, expression: Expression, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ASTVisitor>(_ visitor: V) throws -> V.ASTResult
  public override func accept<V: ASTVisitorWithPayload>(_ visitor: V, payload: V.ASTPayload) throws -> V.ASTResult
}

public class Statement: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, start: SourceLocation, end: SourceLocation)
  public func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class FunctionDefStmt: Statement {
  public var name: String
  public var args: Arguments
  public var body: NonEmptyArray<Statement>
  public var decorators: [Expression]
  public var returns: Expression?
  public init(id: ASTNodeId, name: String, args: Arguments, body: NonEmptyArray<Statement>, decorators: [Expression], returns: Expression?, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class AsyncFunctionDefStmt: Statement {
  public var name: String
  public var args: Arguments
  public var body: NonEmptyArray<Statement>
  public var decorators: [Expression]
  public var returns: Expression?
  public init(id: ASTNodeId, name: String, args: Arguments, body: NonEmptyArray<Statement>, decorators: [Expression], returns: Expression?, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class ClassDefStmt: Statement {
  public var name: String
  public var bases: [Expression]
  public var keywords: [KeywordArgument]
  public var body: NonEmptyArray<Statement>
  public var decorators: [Expression]
  public init(id: ASTNodeId, name: String, bases: [Expression], keywords: [KeywordArgument], body: NonEmptyArray<Statement>, decorators: [Expression], start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class ReturnStmt: Statement {
  public var value: Expression?
  public init(id: ASTNodeId, value: Expression?, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class DeleteStmt: Statement {
  public var values: NonEmptyArray<Expression>
  public init(id: ASTNodeId, values: NonEmptyArray<Expression>, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class AssignStmt: Statement {
  public var targets: NonEmptyArray<Expression>
  public var value: Expression
  public init(id: ASTNodeId, targets: NonEmptyArray<Expression>, value: Expression, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class AugAssignStmt: Statement {
  public var target: Expression
  public var op: BinaryOpExpr.Operator
  public var value: Expression
  public init(id: ASTNodeId, target: Expression, op: BinaryOpExpr.Operator, value: Expression, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class AnnAssignStmt: Statement {
  public var target: Expression
  public var annotation: Expression
  public var value: Expression?
  public var isSimple: Bool
  public init(id: ASTNodeId, target: Expression, annotation: Expression, value: Expression?, isSimple: Bool, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class ForStmt: Statement {
  public var target: Expression
  public var iterable: Expression
  public var body: NonEmptyArray<Statement>
  public var orElse: [Statement]
  public init(id: ASTNodeId, target: Expression, iterable: Expression, body: NonEmptyArray<Statement>, orElse: [Statement], start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class AsyncForStmt: Statement {
  public var target: Expression
  public var iterable: Expression
  public var body: NonEmptyArray<Statement>
  public var orElse: [Statement]
  public init(id: ASTNodeId, target: Expression, iterable: Expression, body: NonEmptyArray<Statement>, orElse: [Statement], start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class WhileStmt: Statement {
  public var test: Expression
  public var body: NonEmptyArray<Statement>
  public var orElse: [Statement]
  public init(id: ASTNodeId, test: Expression, body: NonEmptyArray<Statement>, orElse: [Statement], start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class IfStmt: Statement {
  public var test: Expression
  public var body: NonEmptyArray<Statement>
  public var orElse: [Statement]
  public init(id: ASTNodeId, test: Expression, body: NonEmptyArray<Statement>, orElse: [Statement], start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public struct WithItem: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var contextExpr: Expression
  public var optionalVars: Expression?
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, contextExpr: Expression, optionalVars: Expression?, start: SourceLocation, end: SourceLocation)
}

public final class WithStmt: Statement {
  public var items: NonEmptyArray<WithItem>
  public var body: NonEmptyArray<Statement>
  public init(id: ASTNodeId, items: NonEmptyArray<WithItem>, body: NonEmptyArray<Statement>, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class AsyncWithStmt: Statement {
  public var items: NonEmptyArray<WithItem>
  public var body: NonEmptyArray<Statement>
  public init(id: ASTNodeId, items: NonEmptyArray<WithItem>, body: NonEmptyArray<Statement>, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public struct ExceptHandler: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var kind: ExceptHandler.Kind
  public var body: NonEmptyArray<Statement>
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, kind: ExceptHandler.Kind, body: NonEmptyArray<Statement>, start: SourceLocation, end: SourceLocation)
}

extension ExceptHandler {
  public enum Kind: CustomStringConvertible {
    public var description: String { get }
  }
}

public final class RaiseStmt: Statement {
  public var exception: Expression?
  public var cause: Expression?
  public init(id: ASTNodeId, exception: Expression?, cause: Expression?, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class TryStmt: Statement {
  public var body: NonEmptyArray<Statement>
  public var handlers: [ExceptHandler]
  public var orElse: [Statement]
  public var finally: [Statement]
  public init(id: ASTNodeId, body: NonEmptyArray<Statement>, handlers: [ExceptHandler], orElse: [Statement], finally: [Statement], start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class AssertStmt: Statement {
  public var test: Expression
  public var msg: Expression?
  public init(id: ASTNodeId, test: Expression, msg: Expression?, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public struct Alias: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var name: String
  public var asName: String?
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, name: String, asName: String?, start: SourceLocation, end: SourceLocation)
}

public final class ImportStmt: Statement {
  public var names: NonEmptyArray<Alias>
  public init(id: ASTNodeId, names: NonEmptyArray<Alias>, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class ImportFromStmt: Statement {
  public var moduleName: String?
  public var names: NonEmptyArray<Alias>
  public var level: UInt8
  public init(id: ASTNodeId, moduleName: String?, names: NonEmptyArray<Alias>, level: UInt8, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class ImportFromStarStmt: Statement {
  public var moduleName: String?
  public var level: UInt8
  public init(id: ASTNodeId, moduleName: String?, level: UInt8, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class GlobalStmt: Statement {
  public var identifiers: NonEmptyArray<String>
  public init(id: ASTNodeId, identifiers: NonEmptyArray<String>, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class NonlocalStmt: Statement {
  public var identifiers: NonEmptyArray<String>
  public init(id: ASTNodeId, identifiers: NonEmptyArray<String>, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class ExprStmt: Statement {
  public var expression: Expression
  public init(id: ASTNodeId, expression: Expression, start: SourceLocation, end: SourceLocation)
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class PassStmt: Statement {
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class BreakStmt: Statement {
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public final class ContinueStmt: Statement {
  public override func accept<V: StatementVisitor>(_ visitor: V) throws -> V.StatementResult
  public override func accept<V: StatementVisitorWithPayload>(_ visitor: V, payload: V.StatementPayload) throws -> V.StatementResult
}

public enum ExpressionContext: CustomStringConvertible {
  public var description: String { get }
}

public class Expression: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var context: ExpressionContext
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class TrueExpr: Expression {
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class FalseExpr: Expression {
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class NoneExpr: Expression {
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class EllipsisExpr: Expression {
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

extension StringExpr {
  public enum Group: CustomStringConvertible {
    public var description: String { get }
  }
}

extension StringExpr {
  public enum Conversion: CustomStringConvertible {
    public var description: String { get }
  }
}

public final class IdentifierExpr: Expression {
  public var value: String
  public init(id: ASTNodeId, value: String, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class StringExpr: Expression {
  public var value: StringExpr.Group
  public init(id: ASTNodeId, value: StringExpr.Group, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class IntExpr: Expression {
  public var value: BigInt
  public init(id: ASTNodeId, value: BigInt, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class FloatExpr: Expression {
  public var value: Double
  public init(id: ASTNodeId, value: Double, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class ComplexExpr: Expression {
  public var real: Double
  public var imag: Double
  public init(id: ASTNodeId, real: Double, imag: Double, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class BytesExpr: Expression {
  public var value: Data
  public init(id: ASTNodeId, value: Data, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

extension UnaryOpExpr {
  public enum Operator: CustomStringConvertible {
    public var description: String { get }
  }
}

public final class UnaryOpExpr: Expression {
  public var op: UnaryOpExpr.Operator
  public var right: Expression
  public init(id: ASTNodeId, op: UnaryOpExpr.Operator, right: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

extension BinaryOpExpr {
  public enum Operator: CustomStringConvertible {
    public var description: String { get }
  }
}

public final class BinaryOpExpr: Expression {
  public var op: BinaryOpExpr.Operator
  public var left: Expression
  public var right: Expression
  public init(id: ASTNodeId, op: BinaryOpExpr.Operator, left: Expression, right: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

extension BoolOpExpr {
  public enum Operator: CustomStringConvertible {
    public var description: String { get }
  }
}

public final class BoolOpExpr: Expression {
  public var op: BoolOpExpr.Operator
  public var left: Expression
  public var right: Expression
  public init(id: ASTNodeId, op: BoolOpExpr.Operator, left: Expression, right: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

extension CompareExpr {
  public enum Operator: CustomStringConvertible {
    public var description: String { get }
  }
}

extension CompareExpr {
  public struct Element: CustomStringConvertible {
    public var op: CompareExpr.Operator
    public var right: Expression
    public var description: String { get }
    public init(op: CompareExpr.Operator, right: Expression)
  }
}

public final class CompareExpr: Expression {
  public var left: Expression
  public var elements: NonEmptyArray<CompareExpr.Element>
  public init(id: ASTNodeId, left: Expression, elements: NonEmptyArray<CompareExpr.Element>, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

extension DictionaryExpr {
  public enum Element: CustomStringConvertible {
    public var description: String { get }
  }
}

public final class TupleExpr: Expression {
  public var elements: [Expression]
  public init(id: ASTNodeId, elements: [Expression], context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class ListExpr: Expression {
  public var elements: [Expression]
  public init(id: ASTNodeId, elements: [Expression], context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class DictionaryExpr: Expression {
  public var elements: [DictionaryExpr.Element]
  public init(id: ASTNodeId, elements: [DictionaryExpr.Element], context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class SetExpr: Expression {
  public var elements: [Expression]
  public init(id: ASTNodeId, elements: [Expression], context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public struct Comprehension: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var target: Expression
  public var iterable: Expression
  public var ifs: [Expression]
  public var isAsync: Bool
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, target: Expression, iterable: Expression, ifs: [Expression], isAsync: Bool, start: SourceLocation, end: SourceLocation)
}

public final class ListComprehensionExpr: Expression {
  public var element: Expression
  public var generators: NonEmptyArray<Comprehension>
  public init(id: ASTNodeId, element: Expression, generators: NonEmptyArray<Comprehension>, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class SetComprehensionExpr: Expression {
  public var element: Expression
  public var generators: NonEmptyArray<Comprehension>
  public init(id: ASTNodeId, element: Expression, generators: NonEmptyArray<Comprehension>, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class DictionaryComprehensionExpr: Expression {
  public var key: Expression
  public var value: Expression
  public var generators: NonEmptyArray<Comprehension>
  public init(id: ASTNodeId, key: Expression, value: Expression, generators: NonEmptyArray<Comprehension>, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class GeneratorExpr: Expression {
  public var element: Expression
  public var generators: NonEmptyArray<Comprehension>
  public init(id: ASTNodeId, element: Expression, generators: NonEmptyArray<Comprehension>, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class AwaitExpr: Expression {
  public var value: Expression
  public init(id: ASTNodeId, value: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class YieldExpr: Expression {
  public var value: Expression?
  public init(id: ASTNodeId, value: Expression?, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class YieldFromExpr: Expression {
  public var value: Expression
  public init(id: ASTNodeId, value: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class LambdaExpr: Expression {
  public var args: Arguments
  public var body: Expression
  public init(id: ASTNodeId, args: Arguments, body: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class CallExpr: Expression {
  public var function: Expression
  public var args: [Expression]
  public var keywords: [KeywordArgument]
  public init(id: ASTNodeId, function: Expression, args: [Expression], keywords: [KeywordArgument], context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class AttributeExpr: Expression {
  public var object: Expression
  public var name: String
  public init(id: ASTNodeId, object: Expression, name: String, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public struct Slice: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var kind: Slice.Kind
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, kind: Slice.Kind, start: SourceLocation, end: SourceLocation)
}

extension Slice {
  public enum Kind: CustomStringConvertible {
    public var description: String { get }
  }
}

public final class SubscriptExpr: Expression {
  public var object: Expression
  public var slice: Slice
  public init(id: ASTNodeId, object: Expression, slice: Slice, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class IfExpr: Expression {
  public var test: Expression
  public var body: Expression
  public var orElse: Expression
  public init(id: ASTNodeId, test: Expression, body: Expression, orElse: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public final class StarredExpr: Expression {
  public var expression: Expression
  public init(id: ASTNodeId, expression: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation)
  public override func accept<V: ExpressionVisitor>(_ visitor: V) throws -> V.ExpressionResult
  public override func accept<V: ExpressionVisitorWithPayload>(_ visitor: V, payload: V.ExpressionPayload) throws -> V.ExpressionResult
}

public struct Arguments: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var args: [Argument]
  public var defaults: [Expression]
  public var vararg: Vararg
  public var kwOnlyArgs: [Argument]
  public var kwOnlyDefaults: [Expression]
  public var kwarg: Argument?
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, args: [Argument], defaults: [Expression], vararg: Vararg, kwOnlyArgs: [Argument], kwOnlyDefaults: [Expression], kwarg: Argument?, start: SourceLocation, end: SourceLocation)
}

public struct Argument: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var name: String
  public var annotation: Expression?
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, name: String, annotation: Expression?, start: SourceLocation, end: SourceLocation)
}

public enum Vararg: CustomStringConvertible {
  public var description: String { get }
}

public struct KeywordArgument: ASTNode, CustomStringConvertible {
  public var id: ASTNodeId
  public var kind: KeywordArgument.Kind
  public var value: Expression
  public var start: SourceLocation
  public var end: SourceLocation
  public var description: String { get }
  public init(id: ASTNodeId, kind: KeywordArgument.Kind, value: Expression, start: SourceLocation, end: SourceLocation)
}

extension KeywordArgument {
  public enum Kind: CustomStringConvertible {
    public var description: String { get }
  }
}

==================================
=== Generated/ASTBuilder.swift ===
==================================

public struct ASTBuilder {
  public private(set) var nextId: ASTNodeId = 0
  public init()
  public mutating func interactiveAST(statements: [Statement], start: SourceLocation, end: SourceLocation) -> InteractiveAST
  public mutating func moduleAST(statements: [Statement], start: SourceLocation, end: SourceLocation) -> ModuleAST
  public mutating func expressionAST(expression: Expression, start: SourceLocation, end: SourceLocation) -> ExpressionAST
  public mutating func functionDefStmt(name: String, args: Arguments, body: NonEmptyArray<Statement>, decorators: [Expression], returns: Expression?, start: SourceLocation, end: SourceLocation) -> FunctionDefStmt
  public mutating func asyncFunctionDefStmt(name: String, args: Arguments, body: NonEmptyArray<Statement>, decorators: [Expression], returns: Expression?, start: SourceLocation, end: SourceLocation) -> AsyncFunctionDefStmt
  public mutating func classDefStmt(name: String, bases: [Expression], keywords: [KeywordArgument], body: NonEmptyArray<Statement>, decorators: [Expression], start: SourceLocation, end: SourceLocation) -> ClassDefStmt
  public mutating func returnStmt(value: Expression?, start: SourceLocation, end: SourceLocation) -> ReturnStmt
  public mutating func deleteStmt(values: NonEmptyArray<Expression>, start: SourceLocation, end: SourceLocation) -> DeleteStmt
  public mutating func assignStmt(targets: NonEmptyArray<Expression>, value: Expression, start: SourceLocation, end: SourceLocation) -> AssignStmt
  public mutating func augAssignStmt(target: Expression, op: BinaryOpExpr.Operator, value: Expression, start: SourceLocation, end: SourceLocation) -> AugAssignStmt
  public mutating func annAssignStmt(target: Expression, annotation: Expression, value: Expression?, isSimple: Bool, start: SourceLocation, end: SourceLocation) -> AnnAssignStmt
  public mutating func forStmt(target: Expression, iterable: Expression, body: NonEmptyArray<Statement>, orElse: [Statement], start: SourceLocation, end: SourceLocation) -> ForStmt
  public mutating func asyncForStmt(target: Expression, iterable: Expression, body: NonEmptyArray<Statement>, orElse: [Statement], start: SourceLocation, end: SourceLocation) -> AsyncForStmt
  public mutating func whileStmt(test: Expression, body: NonEmptyArray<Statement>, orElse: [Statement], start: SourceLocation, end: SourceLocation) -> WhileStmt
  public mutating func ifStmt(test: Expression, body: NonEmptyArray<Statement>, orElse: [Statement], start: SourceLocation, end: SourceLocation) -> IfStmt
  public mutating func withItem(contextExpr: Expression, optionalVars: Expression?, start: SourceLocation, end: SourceLocation) -> WithItem
  public mutating func withStmt(items: NonEmptyArray<WithItem>, body: NonEmptyArray<Statement>, start: SourceLocation, end: SourceLocation) -> WithStmt
  public mutating func asyncWithStmt(items: NonEmptyArray<WithItem>, body: NonEmptyArray<Statement>, start: SourceLocation, end: SourceLocation) -> AsyncWithStmt
  public mutating func exceptHandler(kind: ExceptHandler.Kind, body: NonEmptyArray<Statement>, start: SourceLocation, end: SourceLocation) -> ExceptHandler
  public mutating func raiseStmt(exception: Expression?, cause: Expression?, start: SourceLocation, end: SourceLocation) -> RaiseStmt
  public mutating func tryStmt(body: NonEmptyArray<Statement>, handlers: [ExceptHandler], orElse: [Statement], finally: [Statement], start: SourceLocation, end: SourceLocation) -> TryStmt
  public mutating func assertStmt(test: Expression, msg: Expression?, start: SourceLocation, end: SourceLocation) -> AssertStmt
  public mutating func alias(name: String, asName: String?, start: SourceLocation, end: SourceLocation) -> Alias
  public mutating func importStmt(names: NonEmptyArray<Alias>, start: SourceLocation, end: SourceLocation) -> ImportStmt
  public mutating func importFromStmt(moduleName: String?, names: NonEmptyArray<Alias>, level: UInt8, start: SourceLocation, end: SourceLocation) -> ImportFromStmt
  public mutating func importFromStarStmt(moduleName: String?, level: UInt8, start: SourceLocation, end: SourceLocation) -> ImportFromStarStmt
  public mutating func globalStmt(identifiers: NonEmptyArray<String>, start: SourceLocation, end: SourceLocation) -> GlobalStmt
  public mutating func nonlocalStmt(identifiers: NonEmptyArray<String>, start: SourceLocation, end: SourceLocation) -> NonlocalStmt
  public mutating func exprStmt(expression: Expression, start: SourceLocation, end: SourceLocation) -> ExprStmt
  public mutating func passStmt(start: SourceLocation, end: SourceLocation) -> PassStmt
  public mutating func breakStmt(start: SourceLocation, end: SourceLocation) -> BreakStmt
  public mutating func continueStmt(start: SourceLocation, end: SourceLocation) -> ContinueStmt
  public mutating func trueExpr(context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> TrueExpr
  public mutating func falseExpr(context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> FalseExpr
  public mutating func noneExpr(context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> NoneExpr
  public mutating func ellipsisExpr(context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> EllipsisExpr
  public mutating func identifierExpr(value: String, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> IdentifierExpr
  public mutating func stringExpr(value: StringExpr.Group, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> StringExpr
  public mutating func intExpr(value: BigInt, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> IntExpr
  public mutating func floatExpr(value: Double, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> FloatExpr
  public mutating func complexExpr(real: Double, imag: Double, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> ComplexExpr
  public mutating func bytesExpr(value: Data, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> BytesExpr
  public mutating func unaryOpExpr(op: UnaryOpExpr.Operator, right: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> UnaryOpExpr
  public mutating func binaryOpExpr(op: BinaryOpExpr.Operator, left: Expression, right: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> BinaryOpExpr
  public mutating func boolOpExpr(op: BoolOpExpr.Operator, left: Expression, right: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> BoolOpExpr
  public mutating func compareExpr(left: Expression, elements: NonEmptyArray<CompareExpr.Element>, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> CompareExpr
  public mutating func tupleExpr(elements: [Expression], context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> TupleExpr
  public mutating func listExpr(elements: [Expression], context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> ListExpr
  public mutating func dictionaryExpr(elements: [DictionaryExpr.Element], context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> DictionaryExpr
  public mutating func setExpr(elements: [Expression], context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> SetExpr
  public mutating func comprehension(target: Expression, iterable: Expression, ifs: [Expression], isAsync: Bool, start: SourceLocation, end: SourceLocation) -> Comprehension
  public mutating func listComprehensionExpr(element: Expression, generators: NonEmptyArray<Comprehension>, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> ListComprehensionExpr
  public mutating func setComprehensionExpr(element: Expression, generators: NonEmptyArray<Comprehension>, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> SetComprehensionExpr
  public mutating func dictionaryComprehensionExpr(key: Expression, value: Expression, generators: NonEmptyArray<Comprehension>, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> DictionaryComprehensionExpr
  public mutating func generatorExpr(element: Expression, generators: NonEmptyArray<Comprehension>, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> GeneratorExpr
  public mutating func awaitExpr(value: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> AwaitExpr
  public mutating func yieldExpr(value: Expression?, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> YieldExpr
  public mutating func yieldFromExpr(value: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> YieldFromExpr
  public mutating func lambdaExpr(args: Arguments, body: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> LambdaExpr
  public mutating func callExpr(function: Expression, args: [Expression], keywords: [KeywordArgument], context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> CallExpr
  public mutating func attributeExpr(object: Expression, name: String, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> AttributeExpr
  public mutating func slice(kind: Slice.Kind, start: SourceLocation, end: SourceLocation) -> Slice
  public mutating func subscriptExpr(object: Expression, slice: Slice, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> SubscriptExpr
  public mutating func ifExpr(test: Expression, body: Expression, orElse: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> IfExpr
  public mutating func starredExpr(expression: Expression, context: ExpressionContext, start: SourceLocation, end: SourceLocation) -> StarredExpr
  public mutating func arguments(args: [Argument], defaults: [Expression], vararg: Vararg, kwOnlyArgs: [Argument], kwOnlyDefaults: [Expression], kwarg: Argument?, start: SourceLocation, end: SourceLocation) -> Arguments
  public mutating func argument(name: String, annotation: Expression?, start: SourceLocation, end: SourceLocation) -> Argument
  public mutating func keywordArgument(kind: KeywordArgument.Kind, value: Expression, start: SourceLocation, end: SourceLocation) -> KeywordArgument
}

===================================
=== Generated/ASTVisitors.swift ===
===================================

public protocol ASTVisitor {}
public protocol ASTVisitorWithPayload: AnyObject {}
public protocol StatementVisitor {}
public protocol StatementVisitorWithPayload: AnyObject {}
public protocol ExpressionVisitor {}
public protocol ExpressionVisitorWithPayload: AnyObject {}

==================================
=== Parser+UNIMPLEMENTED.swift ===
==================================

public enum FStringUnimplemented: CustomStringConvertible, Equatable {
  public var description: String { get }
}

====================
=== Parser.swift ===
====================

public final class Parser {
  public enum Mode {
    public static var exec: Mode { get }
    public static var single: Mode { get }
  }
  public var builder = ASTBuilder()
  public init(mode: Parser.Mode, tokenSource: LexerType, delegate: ParserDelegate?, lexerDelegate: LexerDelegate?)
  public func parse() throws -> AST
}

============================
=== ParserDelegate.swift ===
============================

public protocol ParserDelegate: AnyObject {}

=====================================
=== Printer/ASTPrinter+Expr.swift ===
=====================================

extension ASTPrinter {
  public func visit(_ context: ExpressionContext) -> Doc
  public func visit(_ node: Expression) -> Doc
  public func visit(_ node: TrueExpr) -> Doc
  public func visit(_ node: FalseExpr) -> Doc
  public func visit(_ node: NoneExpr) -> Doc
  public func visit(_ node: EllipsisExpr) -> Doc
  public func visit(_ node: IdentifierExpr) -> Doc
  public func visit(_ node: StringExpr) -> Doc
  public func visit(_ group: StringExpr.Group) -> Doc
  public func visit(_ flag: StringExpr.Conversion) -> Doc
  public func visit(_ node: IntExpr) -> Doc
  public func visit(_ node: FloatExpr) -> Doc
  public func visit(_ node: ComplexExpr) -> Doc
  public func visit(_ node: BytesExpr) -> Doc
  public func visit(_ node: UnaryOpExpr) -> Doc
  public func visit(_ node: BinaryOpExpr) -> Doc
  public func visit(_ node: BoolOpExpr) -> Doc
  public func visit(_ node: CompareExpr) -> Doc
  public func visit(_ element: CompareExpr.Element) -> Doc
  public func visit(_ node: TupleExpr) -> Doc
  public func visit(_ node: ListExpr) -> Doc
  public func visit(_ node: DictionaryExpr) -> Doc
  public func visit(_ element: DictionaryExpr.Element) -> Doc
  public func visit(_ node: SetExpr) -> Doc
  public func visit(_ node: ListComprehensionExpr) -> Doc
  public func visit(_ node: SetComprehensionExpr) -> Doc
  public func visit(_ node: DictionaryComprehensionExpr) -> Doc
  public func visit(_ node: GeneratorExpr) -> Doc
  public func visit(_ node: Comprehension) -> Doc
  public func visit(_ node: AwaitExpr) -> Doc
  public func visit(_ node: YieldExpr) -> Doc
  public func visit(_ node: YieldFromExpr) -> Doc
  public func visit(_ node: LambdaExpr) -> Doc
  public func visit(_ node: Arguments) -> Doc
  public func visit(_ node: Argument) -> Doc
  public func visit(_ node: Vararg) -> Doc
  public func visit(_ node: KeywordArgument) -> Doc
  public func visit(_ node: KeywordArgument.Kind) -> Doc
  public func visit(_ node: CallExpr) -> Doc
  public func visit(_ node: IfExpr) -> Doc
  public func visit(_ node: AttributeExpr) -> Doc
  public func visit(_ node: SubscriptExpr) -> Doc
  public func visit(_ slice: Slice) -> Doc
  public func visit(_ kind: Slice.Kind) -> Doc
  public func visit(_ node: StarredExpr) -> Doc
  public func visit(_ op: UnaryOpExpr.Operator) -> Doc
  public func visit(_ op: BoolOpExpr.Operator) -> Doc
  public func visit(_ op: BinaryOpExpr.Operator) -> Doc
  public func visit(_ op: CompareExpr.Operator) -> Doc
}

=====================================
=== Printer/ASTPrinter+Stmt.swift ===
=====================================

extension ASTPrinter {
  public func visit(_ node: Statement) -> Doc
  public func visit(_ node: FunctionDefStmt) -> Doc
  public func visit(_ node: AsyncFunctionDefStmt) -> Doc
  public func visit(_ node: ClassDefStmt) -> Doc
  public func visit(_ node: ReturnStmt) -> Doc
  public func visit(_ node: DeleteStmt) -> Doc
  public func visit(_ node: AssignStmt) -> Doc
  public func visit(_ node: AugAssignStmt) -> Doc
  public func visit(_ node: AnnAssignStmt) -> Doc
  public func visit(_ node: ForStmt) -> Doc
  public func visit(_ node: AsyncForStmt) -> Doc
  public func visit(_ node: WhileStmt) -> Doc
  public func visit(_ node: IfStmt) -> Doc
  public func visit(_ node: WithStmt) -> Doc
  public func visit(_ node: AsyncWithStmt) -> Doc
  public func visit(_ item: WithItem) -> Doc
  public func visit(_ node: RaiseStmt) -> Doc
  public func visit(_ node: TryStmt) -> Doc
  public func visit(_ node: ExceptHandler) -> Doc
  public func visit(_ node: ExceptHandler.Kind) -> Doc
  public func visit(_ node: AssertStmt) -> Doc
  public func visit(_ node: ImportStmt) -> Doc
  public func visit(_ node: ImportFromStmt) -> Doc
  public func visit(_ node: ImportFromStarStmt) -> Doc
  public func visit(_ node: Alias) -> Doc
  public func visit(_ node: GlobalStmt) -> Doc
  public func visit(_ node: NonlocalStmt) -> Doc
  public func visit(_ node: ExprStmt) -> Doc
  public func visit(_ node: PassStmt) -> Doc
  public func visit(_ node: BreakStmt) -> Doc
  public func visit(_ node: ContinueStmt) -> Doc
}

================================
=== Printer/ASTPrinter.swift ===
================================

public final class ASTPrinter: ASTVisitor, StatementVisitor, ExpressionVisitor {
  public typealias ASTResult = Doc
  public typealias StatementResult = Doc
  public typealias ExpressionResult = Doc
  public func visit(_ node: AST) -> Doc
  public func visit(_ node: InteractiveAST) -> Doc
  public func visit(_ node: ModuleAST) -> Doc
  public func visit(_ node: ExpressionAST) -> Doc
}

