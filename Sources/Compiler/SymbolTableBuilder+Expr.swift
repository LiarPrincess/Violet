import Core
import Parser

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length

extension SymbolTableBuilder {

  // MARK: - Expression

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visit<S: Sequence>(_ exprs: S,
                                   isAssignmentTarget: Bool = false) throws
    where S.Element == Expression {

    for e in exprs {
      try self.visit(e)
    }
  }

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  internal func visit(_ expr: Expression?) throws {
    if let e = expr {
      try self.visit(e)
    }
  }

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  ///
  /// - Parameters:
  ///   - expr: Expression to visit.
  ///   - isAssignmentTarget: Are we visiting target for an assignment statement?
  /// Used only for: identifiers, attributes, subscripts, starred, lists, tuples
  /// (see `expr_context` in CPython -> Parser -> Python.asdl).
  internal func visit(_ expr: Expression,
                      isAssignmentTarget: Bool = false) throws {
    switch expr.kind {
    case .true, .false, .none, .ellipsis:
      break
    case .int, .float, .complex, .bytes:
      break

    case let .identifier(name):
      let flags: SymbolFlags = isAssignmentTarget ? .defLocal : .use
      try self.addSymbol(name, flags: flags, location: expr.start)

      let isSuper = self.currentScope.type == .function && name == "super"
      if !isAssignmentTarget && isSuper {
        let name = SpecialIdentifiers.__class__
        try self.addSymbol(name, flags: .use, location: expr.start)
      }
    case let .string(group):
      try self.visit(group)

    case let .unaryOp(_, right):
      try self.visit(right)
    case let .binaryOp(_, left, right),
         let .boolOp(_, left, right):
      try self.visit(left)
      try self.visit(right)
    case let .compare(left, elements):
      try self.visit(left)
      try self.visit(elements)

    case let .tuple(elements),
         let .list(elements):
      try self.visit(elements, isAssignmentTarget: isAssignmentTarget)
    case let .set(elements):
      try self.visit(elements)
    case let .dictionary(elements):
      try self.visit(elements)

    case let .listComprehension(elt, generators):
      try self.visitComprehension(elt: elt,
                                  value: nil,
                                  generators: generators,
                                  kind: .list)

    case let .setComprehension(elt, generators):
      try self.visitComprehension(elt: elt,
                                  value: nil,
                                  generators: generators,
                                  kind: .set)

    case let .dictionaryComprehension(key, value, generators):
      try self.visitComprehension(elt: key,
                                  value: value,
                                  generators: generators,
                                  kind: .dictionary)

    case let .generatorExp(elt, generators):
      try self.visitComprehension(elt: elt,
                                  value: nil,
                                  generators: generators,
                                  kind: .generator)

    case let .await(value):
      try self.visit(value)
      self.currentScope.isCoroutine = true
    case let .yield(value):
      try self.visit(value)
      self.currentScope.isGenerator = true
    case let .yieldFrom(value):
      try self.visit(value)
      self.currentScope.isGenerator = true

    case let .lambda(args, body):
      try self.visitDefaults(args)

      self.enterScope(name: SpecialIdentifiers.lambda, type: .function)
      try self.visitArguments(args)
      try self.visit(body)
      self.leaveScope()

    case let .call(`func`, args, keywords):
      try self.visit(`func`)
      try self.visit(args)
      try self.visit(keywords)

    case let .ifExpression(test, body, orElse):
      try self.visit(test)
      try self.visit(body)
      try self.visit(orElse)

    case let .attribute(expr, _):
      try self.visit(expr, isAssignmentTarget: isAssignmentTarget)
    case let .subscript(expr, slice):
      try self.visit(expr, isAssignmentTarget: isAssignmentTarget)
      try self.visit(slice)
    case let .starred(expr):
      try self.visit(expr, isAssignmentTarget: isAssignmentTarget)
    }
  }

  // MARK: - ComparisonElement

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  private func visit(_ elements: NonEmptyArray<ComparisonElement>) throws {
    for e in elements {
      try self.visit(e.right)
    }
  }

  // MARK: - Slice

  /// symtable_visit_slice(struct symtable *st, slice_ty s)
  private func visit(_ slice: Slice) throws {
    switch slice.kind {
    case let .slice(lower, upper, step):
      try self.visit(lower)
      try self.visit(upper)
      try self.visit(step)
    case let .extSlice(slices):
      for s in slices {
        try self.visit(s)
      }
    case let .index(expr):
      try self.visit(expr)
    }
  }

  // MARK: - DictionaryElement

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
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

  // MARK: - Comprehension

  /// symtable_handle_comprehension(struct symtable *st, expr_ty e, ...)
  ///
  /// - Parameters:
  ///   - elt: element (key in dictionary)
  ///   - value: value in dictionary, nil otherwise
  private func visitComprehension(elt:   Expression,
                                  value: Expression?,
                                  generators: NonEmptyArray<Comprehension>,
                                  kind: ComprehensionKind) throws {

    // iterator (source) is evaluated in parent scope
    let first = generators.first
    try self.visit(first.iter)

    // new scope for comprehensions
    let scopeKind = self.getIdentifier(for: kind)
    self.enterScope(name: scopeKind, type: .function)
    defer { self.leaveScope() }

    if first.isAsync {
      self.currentScope.isCoroutine = true
    }

    try self.implicitArg(pos: 0, location: elt.start)
    try self.visit(first.target)
    try self.visit(first.ifs)

    for c in generators.dropFirst() {
      try self.visit(c)
    }

    try self.visit(value)
    try self.visit(elt)

    if currentScope.isGenerator {
      // we don't have a better location, we just know it happened
      self.warn(.yieldInsideComprehension(kind), location: elt.start)
    }

    if kind == .generator {
      self.currentScope.isGenerator = true
    }
  }

  private func getIdentifier(for kind: ComprehensionKind) -> String {
    switch kind {
    case .list: return SpecialIdentifiers.listcomp
    case .set: return SpecialIdentifiers.setcomp
    case .dictionary: return SpecialIdentifiers.dictcomp
    case .generator: return SpecialIdentifiers.genexpr
    }
  }

  /// Add implicit `.pos` argument to scope.
  /// symtable_implicit_arg(struct symtable *st, int pos)
  private func implicitArg(pos: Int, location: SourceLocation) throws {
    let id = ".\(pos)"
    try self.addSymbol(id, flags: .defParam, location: location)
  }

  /// symtable_visit_comprehension(struct symtable *st, comprehension_ty lc)
  private func visit(_ comprehension: Comprehension) throws {
    try self.visit(comprehension.target)
    try self.visit(comprehension.iter)
    try self.visit(comprehension.ifs)

    if comprehension.isAsync {
      self.currentScope.isCoroutine = true
    }
  }

  // MARK: - StringGroup

  /// symtable_visit_expr(struct symtable *st, expr_ty e)
  private func visit(_ group: StringGroup) throws {
    switch group {
    case .string:
      break
    case let .formattedValue(expr, _, _):
      try self.visit(expr)
      // add format spec here
      // NotImplemented.expressionInFormatSpecifierInsideFString
    case let .joinedString(groups):
      for g in groups {
        try self.visit(g)
      }
    }
  }
}
