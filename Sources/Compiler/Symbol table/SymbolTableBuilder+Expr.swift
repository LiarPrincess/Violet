import Core
import Parser

// In CPython:
// Python -> symtable.c

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length

extension SymbolTableBuilder {

  // MARK: - Expression

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visitExpressions<S: Sequence>(
    _ exprs: S,
    context: ExpressionContext = .load) throws where S.Element == Expression {

    for e in exprs {
      try self.visitExpression(e, context: context)
    }
  }

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visitExpression(_ expr: Expression?,
                                context: ExpressionContext = .load) throws {
    if let e = expr {
      try self.visitExpression(e, context: context)
    }
  }

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visitExpression(_ expr: Expression,
                                context: ExpressionContext = .load) throws {
    switch expr.kind {
    case .true, .false, .none, .ellipsis:
      break
    case .int, .float, .complex, .bytes:
      break

    case let .identifier(name):
      let flags: SymbolFlags = context == .store ? .defLocal : .use
      try self.addSymbol(name, flags: flags, location: expr.start)

      let isSuper = self.currentScope.type == .function && name == "super"
      if context == .load && isSuper {
        let name = SpecialIdentifiers.__class__
        try self.addSymbol(name, flags: .use, location: expr.start)
      }
    case let .string(group):
      try self.visitString(group)

    case let .unaryOp(_, right):
      try self.visitExpression(right)
    case let .binaryOp(_, left, right),
         let .boolOp(_, left, right):
      try self.visitExpression(left)
      try self.visitExpression(right)
    case let .compare(left, elements):
      try self.visitExpression(left)
      try self.visitComparisonElements(elements)

    case let .tuple(elements),
         let .list(elements):
      try self.visitExpressions(elements, context: context)
    case let .set(elements):
      try self.visitExpressions(elements)
    case let .dictionary(elements):
      try self.visitDictionaryElements(elements)

    case let .listComprehension(elt, generators):
      try self.visitComprehension(elt: elt,
                                  value: nil,
                                  generators: generators,
                                  expr: expr,
                                  kind: .list)

    case let .setComprehension(elt, generators):
      try self.visitComprehension(elt: elt,
                                  value: nil,
                                  generators: generators,
                                  expr: expr,
                                  kind: .set)

    case let .dictionaryComprehension(key, value, generators):
      try self.visitComprehension(elt: key,
                                  value: value,
                                  generators: generators,
                                  expr: expr,
                                  kind: .dictionary)

    case let .generatorExp(elt, generators):
      try self.visitComprehension(elt: elt,
                                  value: nil,
                                  generators: generators,
                                  expr: expr,
                                  kind: .generator)

    case let .await(value):
      try self.visitExpression(value)
      self.currentScope.isCoroutine = true
    case let .yield(value):
      try self.visitExpression(value)
      self.currentScope.isGenerator = true
    case let .yieldFrom(value):
      try self.visitExpression(value)
      self.currentScope.isGenerator = true

    case let .lambda(args, body):
      try self.visitDefaults(args)

      self.enterScope(name: SymbolScopeNames.lambda, type: .function, node: expr)
      try self.visitArguments(args)
      try self.visitExpression(body)
      self.leaveScope()

    case let .call(function, args, keywords):
      try self.visitExpression(function)
      try self.visitExpressions(args)
      try self.visitKeywords(keywords)

    case let .ifExpression(test, body, orElse):
      try self.visitExpression(test)
      try self.visitExpression(body)
      try self.visitExpression(orElse)

    case let .attribute(expr, _):
      try self.visitExpression(expr, context: context)
    case let .subscript(expr, slice):
      try self.visitExpression(expr, context: context)
      try self.visitSlice(slice)
    case let .starred(expr):
      try self.visitExpression(expr, context: context)
    }
  }

  // MARK: - ComparisonElement

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  private func visitComparisonElements(
    _ elements: NonEmptyArray<ComparisonElement>) throws {

    for e in elements {
      try self.visitExpression(e.right)
    }
  }

  // MARK: - Slice

  /// symtable_visit_slice(struct symtable *st, slice_ty s)
  private func visitSlice(_ slice: Slice) throws {
    switch slice.kind {
    case let .slice(lower, upper, step):
      try self.visitExpression(lower)
      try self.visitExpression(upper)
      try self.visitExpression(step)
    case let .extSlice(slices):
      for s in slices {
        try self.visitSlice(s)
      }
    case let .index(expr):
      try self.visitExpression(expr)
    }
  }

  // MARK: - DictionaryElement

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
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

  // MARK: - Comprehension

  /// symtable_handle_comprehension(struct symtable *st, expr_ty e, ...)
  ///
  /// - Parameters:
  ///   - elt: element (key in dictionary)
  ///   - value: value in dictionary, nil otherwise
  private func visitComprehension(elt:   Expression,
                                  value: Expression?,
                                  generators: NonEmptyArray<Comprehension>,
                                  expr: Expression,
                                  kind: ComprehensionKind) throws {

    // iterator (source) is evaluated in parent scope
    let first = generators.first
    try self.visitExpression(first.iter)

    // new scope for comprehensions
    let scopeKind = self.getIdentifier(for: kind)
    self.enterScope(name: scopeKind, type: .function, node: expr)

    if first.isAsync {
      self.currentScope.isCoroutine = true
    }

    // Outermost iter is received as an argument
    try self.implicitArg(pos: 0, location: generators.first.start)
    try self.visitExpression(first.target, context: .store)
    try self.visitExpressions(first.ifs)

    for c in generators.dropFirst() {
      try self.visitComprehension(c)
    }

    try self.visitExpression(value)
    try self.visitExpression(elt)

    if currentScope.isGenerator {
      // we don't have a better location, we just know it happened
      self.warn(.yieldInsideComprehension(kind), location: elt.start)
    }

    if kind == .generator {
      self.currentScope.isGenerator = true
    }
    self.leaveScope()
  }

  private func getIdentifier(for kind: ComprehensionKind) -> String {
    switch kind {
    case .list:       return SymbolScopeNames.listcomp
    case .set:        return SymbolScopeNames.setcomp
    case .dictionary: return SymbolScopeNames.dictcomp
    case .generator:  return SymbolScopeNames.genexpr
    }
  }

  /// Add implicit `.pos` argument for outermost iter.
  /// symtable_implicit_arg(struct symtable *st, int pos)
  private func implicitArg(pos: Int, location: SourceLocation) throws {
    let id = ".\(pos)"
    try self.addSymbol(id, flags: .defParam, location: location)
  }

  /// symtable_visit_comprehension(struct symtable *st, comprehension_ty lc)
  private func visitComprehension(_ comprehension: Comprehension) throws {
    try self.visitExpression(comprehension.target)
    try self.visitExpression(comprehension.iter)
    try self.visitExpressions(comprehension.ifs)

    if comprehension.isAsync {
      self.currentScope.isCoroutine = true
    }
  }

  // MARK: - StringGroup

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
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
}
