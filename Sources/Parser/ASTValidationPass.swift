import Foundation
import Core
import Lexer

// swiftlint:disable file_length
// swiftlint:disable function_body_length

// In CPython:
// Python -> ast.c
//  int PyAST_Validate(mod_ty mod)

public struct ASTValidationPass: ASTPass {

  public typealias PassResult = Void

  /// int PyAST_Validate(mod_ty mod)
  public func visit(_ ast: AST) throws {
    switch ast.kind {
    case let .interactive(stmts):
      try self.visitStatements(stmts)
    case let .module(stmts):
      try self.visitStatements(stmts)
    case let .expression(expr):
      try self.visitExpression(expr)
    }
  }

  // MARK: - Statement

  private func visitStatements<S: Sequence>(_ stmts: S)
    throws where S.Element == Statement {

    for s in stmts {
      try self.visitStatement(s)
    }
  }

  /// validate_stmt(stmt_ty stmt)
  private func visitStatement(_ stmt: Statement) throws {
    switch stmt.kind {
    case let .functionDef(_, args, body, decorators, returns),
         let .asyncFunctionDef(_, args, body, decorators, returns):
      try self.visitStatements(body)
      try self.visitArguments(args)
      try self.visitExpressions(decorators)
      try self.visitExpression(returns)

    case let .classDef(_, bases, keywords, body, decorators):
      try self.visitStatements(body)
      try self.visitExpressions(bases)
      try self.visitKeywords(keywords)
      try self.visitExpressions(decorators)

    case let .return(value):
      try self.visitExpression(value)

    case let .delete(exprs):
      try self.visitExpressions(exprs)

    case let .assign(targets, value):
      try self.visitExpressions(targets)
      try self.visitExpression(value)
    case let .augAssign(target, _, value):
      try self.visitExpression(target)
      try self.visitExpression(value)
    case let .annAssign(target, annotation, value, isSimple):
      if isSimple && !target.kind.isIdentifier {
        throw self.error(.simpleAnnAssignmentWithNonNameTarget, statement: stmt)
      }

      try self.visitExpression(target)
      try self.visitExpression(value)
      try self.visitExpression(annotation)

    case let .for(target, iter, body, orElse),
         let .asyncFor(target, iter, body, orElse):
      try self.visitExpression(target)
      try self.visitExpression(iter)
      try self.visitStatements(body)
      try self.visitStatements(orElse)

    case let .while(test, body, orElse):
      try self.visitExpression(test)
      try self.visitStatements(body)
      try self.visitStatements(orElse)

    case let .if(test, body, orElse):
      try self.visitExpression(test)
      try self.visitStatements(body)
      try self.visitStatements(orElse)

    case let .with(items, body),
         let .asyncWith(items, body):
      // we don't have to check .isEmpty because of NonEmptyArray
      try self.visitWithItems(items)
      try self.visitStatements(body)

    case let .raise(exception, cause):
      if let exc = exception {
        try self.visitExpression(exc)
        try self.visitExpression(cause)
      } else if cause != nil {
        throw self.error(.raiseWithCauseWithoutException, statement: stmt)
      }

    case let .try(body, handlers, orElse, finally):
      try self.visitStatements(body)

      if handlers.isEmpty && finally.isEmpty {
        throw self.error(.tryWithoutExceptOrFinally, statement: stmt)
      }

      if handlers.isEmpty && !orElse.isEmpty {
        throw self.error(.tryWithElseWithoutExcept, statement: stmt)
      }

      try self.visitExceptHandlers(handlers)
      try self.visitStatements(finally)
      try self.visitStatements(orElse)

    case let .assert(test, msg):
      try self.visitExpression(test)
      try self.visitExpression(msg)

    case .import, .importFrom, .importFromStar:
      // we don't have to check names.isEmpty because of NonEmptyArray
      // we don't have to check level > 0 because of UInt
      break

    case .global, .nonlocal:
      // we don't have to check .isEmpty because of NonEmptyArray
      break

    case let .expr(expr):
      try self.visitExpression(expr)

    case .pass, .break, .continue:
      break
    }
  }

  private func visitWithItems(_ items: NonEmptyArray<WithItem>) throws {
    for i in items {
      try self.visitExpression(i.contextExpr)
      try self.visitExpression(i.optionalVars)
    }
  }

  private func visitExceptHandlers(_ handlers: [ExceptHandler]) throws {
    for h in handlers {
      if case let .typed(type: type, asName: _) = h.kind {
        try self.visitExpression(type)
      }
      try self.visitStatements(h.body)
    }
  }

  // MARK: - Expression

  private func visitExpressions<S: Sequence>(_ exprs: S)
    throws where S.Element == Expression {

    for e in exprs {
      try self.visitExpression(e)
    }
  }

  private func visitExpression(_ expr: Expression?) throws {
    if let e = expr {
      try self.visitExpression(e)
    }
  }

  /// validate_constant(PyObject *value)
  /// validate_expr(expr_ty exp, expr_context_ty ctx)
  private func visitExpression(_ expr: Expression) throws {
    switch expr.kind {

    case .none, .ellipsis,
         .true, .false,
         .int, .float, .complex,
         .string, .bytes,
         .identifier:
      break

    case let .unaryOp(_, right):
      try self.visitExpression(right)
    case let .boolOp(_, left, right),
         let .binaryOp(_, left, right):
      try self.visitExpression(left)
      try self.visitExpression(right)
    case let .compare(left, elements):
      // we don't have to check elements.isEmpty because of NonEmptyArray
      try self.visitExpression(left)
      try self.visitComparisonElements(elements)

    case let .tuple(elements),
         let .list(elements),
         let .set(elements):
      try self.visitExpressions(elements)
    case let .dictionary(elements):
      try self.visitDictionaryElements(elements)

    case let .listComprehension(elt, generators),
         let .setComprehension(elt, generators),
         let .generatorExp(elt, generators):
      try self.visitExpression(elt)
      try self.visitComprehensions(generators)
    case let .dictionaryComprehension(key, value, generators):
      try self.visitExpression(key)
      try self.visitExpression(value)
      try self.visitComprehensions(generators)

    case let .await(expr):
      try self.visitExpression(expr)
    case let .yield(expr):
      try self.visitExpression(expr)
    case let .yieldFrom(expr):
      try self.visitExpression(expr)

    case let .lambda(args, body):
      try self.visitArguments(args)
      try self.visitExpression(body)
    case let .call(`func`, args, keywords):
      try self.visitExpression(`func`)
      try self.visitExpressions(args)
      try self.visitKeywords(keywords)

    case let .ifExpression(test, body, orElse):
      try self.visitExpression(test)
      try self.visitExpression(body)
      try self.visitExpression(orElse)

    case let .attribute(expr, _):
      try self.visitExpression(expr)
    case let .subscript(expr, slice):
      try self.visitExpression(expr)
      try self.visitSlice(slice)
    case let .starred(expr):
      try self.visitExpression(expr)
    }
  }

  // MARK: - Dictionary

  private func visitDictionaryElements(_ elements: [DictionaryElement]) throws {
    for e in elements {
      switch e {
      case let .unpacking(expr):
        try self.visitExpression(expr)
      case let .keyValue(key, value):
        try self.visitExpression(key)
        try self.visitExpression(value)
      }
    }
  }

  // MARK: - Comparison

  private func visitComparisonElements(
    _ elements: NonEmptyArray<ComparisonElement>) throws {

    for e in elements {
      try self.visitExpression(e.right)
    }
  }

  // MARK: - String

  private func visitString(_ group: StringGroup) throws {
    switch group {
    case .literal:
      break
    case let .formattedValue(expr, _, _):
      try self.visitExpression(expr)
    case let .joined(groups):
      for g in groups {
        try self.visitString(g)
      }
    }
  }

  // MARK: - Slice

  /// validate_slice(slice_ty slice)
  private func visitSlice(_ slice: Slice) throws {
    switch slice.kind {
    case let .slice(lower, upper, step):
      if let lower = lower { try self.visitExpression(lower) }
      if let upper = upper { try self.visitExpression(upper) }
      if let step  = step { try self.visitExpression(step) }

    case let .extSlice(dims):
      // we don't have to check .isEmpty because of NonEmptyArray
      for slice in dims {
        try self.visitSlice(slice)
      }

    case let .index(expr):
      try self.visitExpression(expr)
    }
  }

  // MARK: - Comprehension

  /// validate_comprehension(asdl_seq *gens)
  private func visitComprehensions(
    _ comprehensions: NonEmptyArray<Comprehension>) throws {

    for c in comprehensions {
      try self.visitExpression(c.target)
      try self.visitExpression(c.iter)
      try self.visitExpressions(c.ifs)
    }
  }

  // MARK: - Arguments

  /// validate_arguments(arguments_ty args)
  private func visitArguments(_ args: Arguments) throws {
    try self.visitArgs(args.args)
    try self.visitVararg(args.vararg)
    try self.visitArgs(args.kwOnlyArgs)
    try self.visitExpression(args.kwarg?.annotation)

    if args.defaults.count > args.args.count {
      throw self.error(.moreDefaultsThanArgs, location: args.start)
    }

    if args.kwOnlyDefaults.count != args.kwOnlyArgs.count {
      throw self.error(.kwOnlyArgsCountNotEqualToDefaults, location: args.start)
    }

    try self.visitExpressions(args.defaults)
    try self.visitExpressions(args.kwOnlyDefaults)
  }

  /// validate_args(asdl_seq *args)
  private func visitArgs(_ args: [Arg]) throws {
    for a in args {
      try self.visitExpression(a.annotation)
    }
  }

  /// validate_arguments(arguments_ty args)
  private func visitVararg(_ arg: Vararg) throws {
    switch arg {
    case .none, .unnamed:
      break
    case let .named(arg):
      try self.visitExpression(arg.annotation)
    }
  }

  /// validate_keywords(asdl_seq *keywords)
  private func visitKeywords(_ keywords: [Keyword]) throws {
    for keyword in keywords {
      try self.visitExpression(keyword.value)
    }
  }

  // MARK: - Error

  /// Create parser error
  internal func error(_ kind: ParserErrorKind,
                      statement: Statement) -> ParserError {
    return ParserError(kind, location: statement.start)
  }

  /// Create parser error
  internal func error(_ kind: ParserErrorKind,
                      location: SourceLocation) -> ParserError {
    return ParserError(kind, location: location)
  }
}
