import Foundation
import Core
import Lexer

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length

// In CPython:
// Python -> ast.c
//  int PyAST_Validate(mod_ty mod)

public struct ASTValidationPass: ASTPass {

  public typealias PassResult = Void

  /// int PyAST_Validate(mod_ty mod)
  public func visit(_ ast: AST) throws {
    switch ast {
    case let .single(stmts):
      try self.visit(stmts)
    case let .fileInput(stmts):
      try self.visit(stmts)
    case let .expression(expr):
      try self.visit(expr)
    }
  }

  // MARK: - Statement

  private func visit<S: Sequence>(_ stmts: S) throws where S.Element == Statement {
    for s in stmts {
      try self.visit(s)
    }
  }

  /// validate_stmt(stmt_ty stmt)
  private func visit(_ stmt: Statement) throws {
    switch stmt.kind {
    case let .functionDef(_, args, body, decoratorList, returns),
         let .asyncFunctionDef(_, args, body, decoratorList, returns):
      try self.visit(body)
      try self.visit(args)
      try self.visit(decoratorList)
      try self.visit(returns)

    case let .classDef(_, bases, keywords, body, decoratorList):
      try self.visit(body)
      try self.visit(bases)
      try self.visit(keywords)
      try self.visit(decoratorList)

    case let .return(value):
      try self.visit(value)

    case let .delete(exprs):
      try self.visit(exprs)

    case let .assign(targets, value):
      try self.visit(targets)
      try self.visit(value)
    case let .augAssign(target, _, value):
      try self.visit(target)
      try self.visit(value)
    case let .annAssign(target, annotation, value, isSimple):
      if isSimple && !target.kind.isIdentifier {
        throw self.error(.simpleAnnAssignmentWithNonNameTarget, statement: stmt)
      }

      try self.visit(target)
      try self.visit(value)
      try self.visit(annotation)

    case let .for(target, iter, body, orElse),
         let .asyncFor(target, iter, body, orElse):
      try self.visit(target)
      try self.visit(iter)
      try self.visit(body)
      try self.visit(orElse)

    case let .while(test, body, orElse):
      try self.visit(test)
      try self.visit(body)
      try self.visit(orElse)

    case let .if(test, body, orElse):
      try self.visit(test)
      try self.visit(body)
      try self.visit(orElse)

    case let .with(items, body),
         let .asyncWith(items, body):
      // we don't have to check .isEmpty because of NonEmptyArray
      try self.visit(items)
      try self.visit(body)

    case let .raise(exc, cause):
      if let exc = exc {
        try self.visit(exc)
        try self.visit(cause)
      } else if cause != nil {
        throw self.error(.raiseWithCauseWithoutException, statement: stmt)
      }

    case let .try(body, handlers, orElse, finalBody):
      try self.visit(body)

      if handlers.isEmpty && finalBody.isEmpty {
        throw self.error(.tryWithoutExceptOrFinally, statement: stmt)
      }

      if handlers.isEmpty && !orElse.isEmpty {
        throw self.error(.tryWithElseWithoutExcept, statement: stmt)
      }

      try self.visit(handlers)
      try self.visit(finalBody)
      try self.visit(orElse)

    case let .assert(test, msg):
      try self.visit(test)
      try self.visit(msg)

    case .import, .importFrom:
      // we don't have to check names.isEmpty because of NonEmptyArray
      // we don't have to check level > 0 because of UInt
      break

    case .global, .nonlocal:
      // we don't have to check .isEmpty because of NonEmptyArray
      break

    case let .expr(expr):
      try self.visit(expr)

    case .pass, .break, .continue:
      break
    }
  }

  private func visit(_ items: NonEmptyArray<WithItem>) throws {
    for i in items {
      try self.visit(i.contextExpr)
      try self.visit(i.optionalVars)
    }
  }

  private func visit(_ handlers: [ExceptHandler]) throws {
    for h in handlers {
      try self.visit(h.type)
      try self.visit(h.body)
    }
  }

  // MARK: - Expression

  private func visit<S: Sequence>(_ exprs: S) throws where S.Element == Expression {
    for e in exprs {
      try self.visit(e)
    }
  }

  private func visit(_ expr: Expression?) throws {
    if let e = expr {
      try self.visit(e)
    }
  }

  /// validate_constant(PyObject *value)
  /// validate_expr(expr_ty exp, expr_context_ty ctx)
  private func visit(_ expr: Expression) throws {
    switch expr.kind {

    case .none, .ellipsis,
         .true, .false,
         .int, .float, .complex,
         .string, .bytes,
         .identifier:
      break

    case let .unaryOp(_, right):
      try self.visit(right)
    case let .boolOp(_, left, right),
         let .binaryOp(_, left, right):
      try self.visit(left)
      try self.visit(right)
    case let .compare(left, elements):
      // we don't have to check elements.isEmpty because of NonEmptyArray
      try self.visit(left)
      try self.visit(elements)

    case let .tuple(elements),
         let .list(elements),
         let .set(elements):
      try self.visit(elements)
    case let .dictionary(elements):
      try self.visit(elements)

    case let .listComprehension(elt, generators),
         let .setComprehension(elt, generators),
         let .generatorExp(elt, generators):
      try self.visit(elt)
      try self.visit(generators)
    case let .dictionaryComprehension(key, value, generators):
      try self.visit(key)
      try self.visit(value)
      try self.visit(generators)

    case let .await(expr):
      try self.visit(expr)
    case let .yield(expr):
      try self.visit(expr)
    case let .yieldFrom(expr):
      try self.visit(expr)

    case let .lambda(args, body):
      try self.visit(args)
      try self.visit(body)
    case let .call(`func`, args, keywords):
      try self.visit(`func`)
      try self.visit(args)
      try self.visit(keywords)

    case let .ifExpression(test, body, orElse):
      try self.visit(test)
      try self.visit(body)
      try self.visit(orElse)

    case let .attribute(expr, _):
      try self.visit(expr)
    case let .subscript(expr, slice):
      try self.visit(expr)
      try self.visit(slice)
    case let .starred(expr):
      try self.visit(expr)
    }
  }

  // MARK: - Dictionary

  private func visit(_ elements: [DictionaryElement]) throws {
    for e in elements {
      switch e {
      case let .unpacking(expr):
        try self.visit(expr)
      case let .keyValue(key, value):
        try self.visit(key)
        try self.visit(value)
      }
    }
  }

  // MARK: - Comparison

  private func visit(_ elements: NonEmptyArray<ComparisonElement>) throws {
    for e in elements{
      try self.visit(e.right)
    }
  }

  // MARK: - String

  private func visit(_ group: StringGroup) throws {
    switch group {
    case .string:
      break
    case let .formattedValue(expr, _, _):
      try self.visit(expr)
    case let .joinedString(groups):
      for g in groups {
        try self.visit(g)
      }
    }
  }

  // MARK: - Slice

  /// validate_slice(slice_ty slice)
  private func visit(_ slice: Slice) throws {
    switch slice.kind {
    case let .slice(lower, upper, step):
      if let lower = lower { try self.visit(lower) }
      if let upper = upper { try self.visit(upper) }
      if let step  = step  { try self.visit(step) }

    case let .extSlice(dims):
      // we don't have to check .isEmpty because of NonEmptyArray
      for slice in dims {
        try self.visit(slice)
      }

    case let .index(expr):
      try self.visit(expr)
    }
  }

  // MARK: - Comprehension

  /// validate_comprehension(asdl_seq *gens)
  private func visit(_ comprehensions: NonEmptyArray<Comprehension>) throws {
    for c in comprehensions {
      try self.visit(c.target)
      try self.visit(c.iter)
      try self.visit(c.ifs)
    }
  }

  // MARK: - Arguments

  /// validate_arguments(arguments_ty args)
  private func visit(_ args: Arguments) throws {
    try self.visit(args.args)
    try self.visit(args.vararg)
    try self.visit(args.kwOnlyArgs)
    try self.visit(args.kwarg?.annotation)

    if args.defaults.count > args.args.count {
      throw self.error(.moreDefaultsThanArgs, location: args.start)
    }

    if args.kwOnlyDefaults.count != args.kwOnlyArgs.count {
      throw self.error(.kwOnlyArgsCountNotEqualToDefaults, location: args.start)
    }

    try self.visit(args.defaults)
    try self.visit(args.kwOnlyDefaults)
  }

  /// validate_args(asdl_seq *args)
  private func visit(_ args: [Arg]) throws {
    for a in args {
      try self.visit(a.annotation)
    }
  }

  /// validate_arguments(arguments_ty args)
  private func visit(_ arg: Vararg) throws {
    switch arg {
    case .none, .unnamed:
      break
    case let .named(arg):
      try self.visit(arg.annotation)
    }
  }

  /// validate_keywords(asdl_seq *keywords)
  private func visit(_ keywords: [Keyword]) throws {
    for keyword in keywords {
      try self.visit(keyword.value)
    }
  }

  // MARK: - Error

  /// Create parser error
  internal func error(_ kind: ParserErrorKind,
                      statement: Statement) -> ParserError {
    return ParserError(kind, location: statement.start)
  }

  /// Create parser error
  internal func error(_ kind:   ParserErrorKind,
                      location: SourceLocation) -> ParserError {
    return ParserError(kind, location: location)
  }
}
