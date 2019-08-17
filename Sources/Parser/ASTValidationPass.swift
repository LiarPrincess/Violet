import Foundation
import Core
import Lexer

// swiftlint:disable type_body_length
// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length

// TODO: Elsa
extension ExpressionKind {
  internal var isIdentifier: Bool {
    if case ExpressionKind.identifier = self {
      return true
    }
    return false
  }
}

public class ASTValidationPass: ASTPass {

  public typealias PassResult = Void

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

  @available(*, deprecated, message: "Elsa")
  private func validate_nonempty_seq<T>(_ elements: [T]) throws {
    if elements.isEmpty {
      fatalError()
    }
  }

  private func validate_assignlist(_ exprs: [Expression]) throws {
    try self.validate_nonempty_seq(exprs)
    try self.visit(exprs)
  }

  private func validate_body(_ stmts: [Statement]) throws {
    try self.validate_nonempty_seq(stmts)
    try self.visit(stmts)
  }

  private func validate_stmts(_ stmts: [Statement]) throws {
    // just standard
  }

  private func visit(_ stmts: [Statement]) throws {
    for s in stmts {
      try self.visit(s)
    }
  }

  private func visit(_ stmt: Statement) throws {
    switch stmt.kind {
    case let .functionDef(_, args, body, decoratorList, returns):
      try self.validate_body(body)
      try self.visit(args)
      try self.visit(decoratorList)
      try self.visit(returns)
    case let .asyncFunctionDef(_, args, body, decoratorList, returns):
      try self.validate_body(body)
      try self.visit(args)
      try self.visit(decoratorList)
      try self.visit(returns)

    case let .classDef(_, bases, keywords, body, decoratorList):
      try self.validate_body(body)
      try self.visit(bases)
      try self.visit(keywords)
      try self.visit(decoratorList)

    case let .return(value):
      try self.visit(value)

    case let .delete(exprs):
      try self.validate_assignlist(exprs)

    case let .assign(targets, value):
      try validate_assignlist(targets)
      try self.visit(value)
    case let .augAssign(target, _, value):
      try self.visit(target)
      try self.visit(value)
    case let .annAssign(target, annotation, value, isSimple):
      if isSimple && !target.kind.isIdentifier {
        // PyErr_SetString(PyExc_TypeError, "AnnAssign with simple non-Name target");
        fatalError()
      }

      try self.visit(target)
      try self.visit(value)
      try self.visit(annotation)

    case let .for(target, iter, body, orElse):
      try self.visit(target)
      try self.visit(iter)
      try self.validate_body(body)
      try self.validate_stmts(orElse)
    case let .asyncFor(target, iter, body, orElse):
      try self.visit(target)
      try self.visit(iter)
      try self.validate_body(body)
      try self.validate_stmts(orElse)

    case let .while(test, body, orElse):
      try self.visit(test)
      try self.validate_body(body)
      try self.validate_stmts(orElse)

    case let .if(test, body, orElse):
      try self.visit(test)
      try self.validate_body(body)
      try self.validate_stmts(orElse)

    case let .with(items, body):
      try self.validate_nonempty_seq(items)
      try self.visit(items)
      try self.validate_body(body)
    case let .asyncWith(items, body):
      try self.validate_nonempty_seq(items)
      try self.visit(items)
      try self.validate_body(body)

    case let .raise(exc, cause):
      if let exc = exc {
        try self.visit(exc)
        try self.visit(cause)
      } else if cause != nil {
        // PyErr_SetString(PyExc_ValueError, "Raise with cause but no exception");
        fatalError()
      }

    case let .try(body, handlers, orElse, finalBody):
      try self.validate_body(body)

      if handlers.isEmpty && finalBody.isEmpty {
        // PyErr_SetString(PyExc_ValueError, "Try has neither except handlers nor finalbody");
        fatalError()
      }

      if handlers.isEmpty && !orElse.isEmpty {
        // PyErr_SetString(PyExc_ValueError, "Try has orelse but no except handlers");
        fatalError()
      }

      try self.visit(handlers)
      try self.validate_stmts(finalBody)
      try self.validate_stmts(orElse)

    case let .assert(test, msg):
      try self.visit(test)
      try self.visit(msg)

    case let .import(value):
      try self.validate_nonempty_seq(value)
    case let .importFrom(_, names, level):
      if let l = level, l < 0 {
        // PyErr_SetString(PyExc_ValueError, "Negative ImportFrom level");
        fatalError()
      }

      try self.validate_nonempty_seq(names)

    case let .global(value):
      try self.validate_nonempty_seq(value)
    case let .nonlocal(value):
      try self.validate_nonempty_seq(value)

    case let .expr(expr):
      try self.visit(expr)

    case .pass, .break, .continue:
      break
    }
  }

  private func visit(_ alias: Alias) throws {
  }

  private func visit(_ items: [WithItem]) throws {
    for i in items {
      try self.visit(i.contextExpr)
      try self.visit(i.optionalVars)
    }
  }

  private func visit(_ handlers: [ExceptHandler]) throws {
    for h in handlers {
      try self.visit(h.type)
      try self.validate_body(h.body)
    }
  }

  // MARK: - Expression

  private func visit(_ exprs: [Expression]) throws {
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

    case let .boolOp(_, left, right):
      try self.visit(left)
      try self.visit(right)
    case let .binaryOp(_, left, right):
      try self.visit(left)
      try self.visit(right)
    case let .unaryOp(_, right):
      try self.visit(right)
    case let .compare(left, elements):
      if elements.isEmpty { fatalError() }
      try self.visit(left)
      try self.visit(elements)

    case let .tuple(elements):
      try self.visit(elements)
    case let .list(elements):
      try self.visit(elements)
    case let .dictionary(elements):
      try self.visit(elements)
    case let .set(elements):
      try self.visit(elements)

    case let .listComprehension(elt, generators):
      try self.visit(elt)
      try self.visit(generators)
    case let .setComprehension(elt, generators):
      try self.visit(elt)
      try self.visit(generators)
    case let .generatorExp(elt, generators):
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

  private func visit(_ elements: [ComparisonElement]) throws {
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
      if dims.isEmpty { fatalError() }

      for slice in dims {
        try self.visit(slice)
      }

    case let .index(expr):
      try self.visit(expr)
    }
  }

  // MARK: - Comprehension

  /// validate_comprehension(asdl_seq *gens)
  private func visit(_ comprehensions: [Comprehension]) throws {
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
      // PyErr_SetString(PyExc_ValueError, "more positional defaults than args on arguments");
      fatalError()
    }

    if args.kwOnlyDefaults.count != args.kwOnlyArgs.count {
      // PyErr_SetString(PyExc_ValueError, "length of kwonlyargs is not the same as " "kw_defaults on arguments");
      fatalError()
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
}
