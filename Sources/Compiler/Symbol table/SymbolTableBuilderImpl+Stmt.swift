import VioletCore
import VioletParser

// In CPython:
// Python -> symtable.c

// cSpell:ignore withitem excepthandler

extension SymbolTableBuilderImpl {

  internal func visit(_ node: Statement) throws {
    try node.accept(self)
  }

  internal func visit(_ node: Statement?) throws {
    if let n = node {
      try self.visit(n)
    }
  }

  /// symtable_visit_stmt(struct symtable *st, stmt_ty s)
  internal func visit<S: Sequence>(_ nodes: S)
    throws where S.Element == Statement {

    for n in nodes {
      try self.visit(n)
    }
  }

  // MARK: - Function

  internal func visit(_ node: FunctionDefStmt) throws {
    try self.visitFunctionDef(name: node.name,
                              args: node.args,
                              body: node.body,
                              decorators: node.decorators,
                              returns: node.returns,
                              isAsync: false,
                              node: node)
  }

  internal func visit(_ node: AsyncFunctionDefStmt) throws {
    try self.visitFunctionDef(name: node.name,
                              args: node.args,
                              body: node.body,
                              decorators: node.decorators,
                              returns: node.returns,
                              isAsync: true,
                              node: node)
  }

  // swiftlint:disable function_parameter_count
  private func visitFunctionDef(name: String,
                                args: Arguments,
                                body: NonEmptyArray<Statement>,
                                decorators: [Expression],
                                returns: Expression?,
                                isAsync: Bool,
                                node stmt: Statement) throws {
    // swiftlint:enable function_parameter_count

    try self.addSymbol(name: name, flags: .defLocal, location: stmt.start)
    try self.visitDefaults(args: args)
    try self.visitAnnotations(args: args)
    try self.visit(returns) // in CPython it is a part of visitAnnotations
    try self.visit(decorators)

    try self.inNewScope(kind: .function(name: name), node: stmt) {
      if isAsync {
        self.currentScope.isCoroutine = true
      }

      try self.visitArguments(args)
      try self.visit(body)
    }
  }

  // MARK: - Class

  internal func visit(_ node: ClassDefStmt) throws {
    let name = node.name

    try self.addSymbol(name: name, flags: .defLocal, location: node.start)
    try self.visit(node.bases)
    try self.visitKeywords(keywords: node.keywords)
    try self.visit(node.decorators)

    try self.inNewScope(kind: .class(name: name), node: node) {
      let previousClassName = self.className
      self.className = name
      try self.visit(node.body)
      self.className = previousClassName
    }
  }

  // MARK: - Return

  internal func visit(_ node: ReturnStmt) throws {
    if let value = node.value {
      try self.visit(value)
      self.currentScope.hasReturnValue = true
    }
  }

  // MARK: - Delete

  internal func visit(_ node: DeleteStmt) throws {
    try self.visit(node.values)
  }

  // MARK: - Assign

  internal func visit(_ node: AssignStmt) throws {
    try self.visit(node.targets)
    try self.visit(node.value)
  }

  internal func visit(_ node: AugAssignStmt) throws {
    try self.visit(node.target)
    try self.visit(node.value)
  }

  internal func visit(_ node: AnnAssignStmt) throws {
    if let identifier = node.target as? IdentifierExpr {
      let name = identifier.value
      let current = self.lookupMangled(name: name)

      // This throws (the same for nonlocal):
      //   global rapunzel
      //   rapunzel: Int = 5
      // This does not throw:
      //   global rapunzel
      //   (rapunzel): Int = 5 (or tangled.rapunzel: Int = 5)
      // We use `isSimple` to differentiate between them.

      let isGlobal = current?.flags.contains(.defGlobal) ?? false
      if isGlobal && node.isSimple {
        throw self.error(.globalAnnotated(name), location: node.start)
      }

      let isNonlocal = current?.flags.contains(.defNonlocal) ?? false
      if isNonlocal && node.isSimple {
        throw self.error(.nonlocalAnnotated(name), location: node.start)
      }

      // '(rapunzel): Int = 5' is tuple -> not simple!
      if node.isSimple {
        let flags: SymbolInfo.Flags = [.defLocal, .annotated]
        try self.addSymbol(name: name, flags: flags, location: node.target.start)
      } else if node.value != nil {
        // different than CPython, but has the same effect:
        try self.visit(node.target)
      }
    } else {
      try self.visit(node.target)
    }

    try self.visit(node.annotation)
    try self.visit(node.value)
  }

  // MARK: - For

  internal func visit(_ node: ForStmt) throws {
    try self.visitFor(target: node.target,
                      iterable: node.iterable,
                      body: node.body,
                      orElse: node.orElse)
  }

  internal func visit(_ node: AsyncForStmt) throws {
    try self.visitFor(target: node.target,
                      iterable: node.iterable,
                      body: node.body,
                      orElse: node.orElse)
  }

  private func visitFor(target: Expression,
                        iterable: Expression,
                        body: NonEmptyArray<Statement>,
                        orElse: [Statement]) throws {
    try self.visit(target)
    try self.visit(iterable)
    try self.visit(body)
    try self.visit(orElse)
  }

  // MARK: - While

  internal func visit(_ node: WhileStmt) throws {
    try self.visit(node.test)
    try self.visit(node.body)
    try self.visit(node.orElse)
  }

  // MARK: - If

  internal func visit(_ node: IfStmt) throws {
    try self.visit(node.test)
    try self.visit(node.body)
    try self.visit(node.orElse)
  }

  // MARK: - With

  internal func visit(_ node: WithStmt) throws {
    try self.visitWith(items: node.items, body: node.body)
  }

  internal func visit(_ node: AsyncWithStmt) throws {
    try self.visitWith(items: node.items, body: node.body)
  }

  private func visitWith(items: NonEmptyArray<WithItem>,
                         body: NonEmptyArray<Statement>) throws {
    try self.visitWithItems(items)
    try self.visit(body)
  }

  /// symtable_visit_withitem(struct symtable *st, withitem_ty item)
  private func visitWithItems(_ items: NonEmptyArray<WithItem>) throws {
    for i in items {
      try self.visit(i.contextExpr)
      try self.visit(i.optionalVars)
    }
  }

  // MARK: - Raise

  internal func visit(_ node: RaiseStmt) throws {
    try self.visit(node.exception)
    try self.visit(node.cause)
  }

  // MARK: - Try

  internal func visit(_ node: TryStmt) throws {
    try self.visit(node.body)
    try self.visitExceptHandlers(node.handlers)
    try self.visit(node.orElse)
    try self.visit(node.finally)
  }

  /// symtable_visit_excepthandler(struct symtable *st, excepthandler_ty eh)
  private func visitExceptHandlers(_ handlers: [ExceptHandler]) throws {
    for h in handlers {
      if case let .typed(type: type, asName: asName) = h.kind {
        try self.visit(type)
        if let n = asName {
          try self.addSymbol(name: n, flags: .defLocal, location: h.start)
        }
      }
      try self.visit(h.body)
    }
  }

  // MARK: - Assert

  internal func visit(_ node: AssertStmt) throws {
    try self.visit(node.test)
    try self.visit(node.msg)
  }

  // MARK: - Import

  internal func visit(_ node: ImportStmt) throws {
    try self.visitAliases(node.names, importStart: node.start)
  }

  internal func visit(_ node: ImportFromStmt) throws {
    try self.visitAliases(node.names, importStart: node.start)
  }

  internal func visit(_ node: ImportFromStarStmt) throws {
    // No names here, but we can check this:
    let scope = self.currentScope
    if !scope.kind.isModule {
      throw self.error(.nonModuleImportStar, location: node.start)
    }
  }

  /// symtable_visit_alias(struct symtable *st, alias_ty a)
  private func visitAliases(_ aliases: NonEmptyArray<Alias>,
                            importStart: SourceLocation) throws {
    for alias in aliases {
      // import elsa <- register elsa
      // import elsa as queen <- register queen
      // import arendelle.elsa <- register arendelle (elsa is an attribute)

      // If symbol after 'import' is the name of a module or package,
      // then to use objects defined in X, you have to write X.object.

      var name = alias.asName ?? alias.name
      if let dotIndex = name.firstIndex(of: ".") {
        name = String(name[name.startIndex..<dotIndex])
      }

      try self.addSymbol(name: name, flags: .defImport, location: alias.start)
    }
  }

  // MARK: - Global

  internal func visit(_ node: GlobalStmt) throws {
    for name in node.identifiers {
      if let c = self.lookupMangled(name: name) {
        let errorLocation = node.start

        if c.flags.contains(.defParam) {
          throw self.error(.globalParam(name), location: errorLocation)
        }

        if c.flags.contains(.use) {
          throw self.error(.globalAfterUse(name), location: errorLocation)
        }

        if c.flags.contains(.annotated) {
          throw self.error(.globalAnnotated(name), location: errorLocation)
        }

        if c.flags.contains(.defLocal) {
          throw self.error(.globalAfterAssign(name), location: errorLocation)
        }
      }

      try self.addSymbol(name: name, flags: .defGlobal, location: node.start)
    }
  }

  // MARK: - Nonlocal

  internal func visit(_ node: NonlocalStmt) throws {
    for name in node.identifiers {
      if let c = self.lookupMangled(name: name) {
        let errorLocation = node.start

        if c.flags.contains(.defParam) {
          throw self.error(.nonlocalParam(name), location: errorLocation)
        }

        if c.flags.contains(.use) {
          throw self.error(.nonlocalAfterUse(name), location: errorLocation)
        }

        if c.flags.contains(.annotated) {
          throw self.error(.nonlocalAnnotated(name), location: errorLocation)
        }

        if c.flags.contains(.defLocal) {
          throw self.error(.nonlocalAfterAssign(name), location: errorLocation)
        }
      }

      try self.addSymbol(name: name, flags: .defNonlocal, location: node.start)
    }
  }

  // MARK: - Expr

  internal func visit(_ node: ExprStmt) throws {
    try self.visit(node.expression)
  }

  // MARK: - Pass, break, continue

  internal func visit(_ node: PassStmt) throws {}
  internal func visit(_ node: BreakStmt) throws {}
  internal func visit(_ node: ContinueStmt) throws {}
}
