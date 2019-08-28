import Core
import Parser

// swiftlint:disable function_body_length cyclomatic_complexity

extension SymbolTableBuilder {

  // MARK: - Statement

  internal func visitStatements<S: Sequence>(_ stmts: S)
    throws where S.Element == Statement {

    for s in stmts {
      try self.visitStatement(s)
    }
  }

  internal func visitStatement(_ stmt: Statement) throws {
    switch stmt.kind {
    case let .functionDef(name, args, body, decoratorList, returns),
         let .asyncFunctionDef(name, args, body, decoratorList, returns):

      try self.addSymbol(name, flags: .defLocal, location: stmt.start)
      try self.visitDefaults(args)
      try self.visitAnnotations(args)
      try self.visitExpression(returns) // in CPython it is a part of visitAnnotations
      try self.visitExpressions(decoratorList)

      self.enterScope(name: name, type: .function, node: stmt)
      if stmt.kind.isAsyncFunctionDef {
        self.currentScope.isCoroutine = true
      }
      try self.visitArguments(args)
      try self.visitStatements(body)
      self.leaveScope()

    case let .classDef(name, bases, keywords, body, decoratorList):
      try self.addSymbol(name, flags: .defLocal, location: stmt.start)
      try self.visitExpressions(bases)
      try self.visitKeywords(keywords)
      try self.visitExpressions(decoratorList)

      let previousClassName = self.className

      self.enterScope(name: name, type: .class, node: stmt)
      self.className = name
      try self.visitStatements(body)
      self.className = previousClassName
      self.leaveScope()

    case let .return(value):
      if let value = value {
        try self.visitExpression(value)
        self.currentScope.hasReturnValue = true
      }
    case let .delete(value):
      try self.visitExpressions(value)

    case let .assign(targets, value):
      try self.visitExpressions(targets, isAssignmentTarget: true)
      try self.visitExpression(value)
    case let .augAssign(target, _, value):
      try self.visitExpression(target, isAssignmentTarget: true)
      try self.visitExpression(value)
    case let .annAssign(target, annotation, value, isSimple):
      if case let ExpressionKind.identifier(name) = target.kind {
        let current = self.lookupMangled(name)

        // global elsa
        // elsa: Int = 5 <- we can't do that
        let isGlobalNonlocal = current?.flags
          .containsAny([.defGlobal, .defNonlocal]) ?? false

        if isSimple && isGlobalNonlocal {
          let errorKind: CompilerErrorKind = current?.flags == .defGlobal ?
            .globalAnnot(name) :
            .nonlocalAnnot(name)
          throw self.error(errorKind, location: stmt.start)
        }

        let flags: SymbolFlags = isSimple ? [.defLocal, .annotated] : .defLocal
        try self.addSymbol(name, flags: flags, location: stmt.start)
      } else {
        try self.visitExpression(target, isAssignmentTarget: true)
      }

      try self.visitExpression(annotation)
      try self.visitExpression(value)

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
      try self.visitWithItems(items)
      try self.visitStatements(body)

    case let .raise(exc, cause):
      try self.visitExpression(exc)
      try self.visitExpression(cause)

    case let .try(body, handlers, orElse, finalBody):
      try self.visitStatements(body)
      try self.visitExceptHandlers(handlers)
      try self.visitStatements(orElse)
      try self.visitStatements(finalBody)

    case let .assert(test, msg):
      try self.visitExpression(test)
      try self.visitExpression(msg)

    case let .import(names),
         let .importFrom(_, names, _):
      try self.visitAliases(names)

    case let .global(names):
      for name in names {
        let current = self.lookupMangled(name)

        if let c = current {
          let errorLocation = stmt.start
          if c.flags.contains(.defParam) {
            throw self.error(.globalParam(name), location: errorLocation)
          }
          if c.flags.contains(.use) {
            throw self.error(.globalAfterUse(name), location: errorLocation)
          }
          if c.flags.contains(.annotated) {
            throw self.error(.globalAnnot(name), location: errorLocation)
          }
          if c.flags.contains(.defLocal) {
            throw self.error(.globalAfterAssign(name), location: errorLocation)
          }
        }

        try self.addSymbol(name, flags: .defGlobal, location: stmt.start)
      }

    case let .nonlocal(names):
      for name in names {
        let current = self.lookupMangled(name)

        if let c = current {
          let errorLocation = stmt.start
          if c.flags.contains(.defParam) {
            throw self.error(.nonlocalParam(name), location: errorLocation)
          }
          if c.flags.contains(.use) {
            throw self.error(.nonlocalAfterUse(name), location: errorLocation)
          }
          if c.flags.contains(.annotated) {
            throw self.error(.nonlocalAnnot(name), location: errorLocation)
          }
          if c.flags.contains(.defLocal) {
            throw self.error(.nonlocalAfterAssign(name), location: errorLocation)
          }
        }

        try self.addSymbol(name, flags: .defNonlocal, location: stmt.start)
      }

    case let .expr(expr):
      try self.visitExpression(expr)

    case .pass, .break, .continue:
      break
    }
  }

  // MARK: - WithItem

  /// symtable_visit_withitem(struct symtable *st, withitem_ty item)
  private func visitWithItems(_ items: NonEmptyArray<WithItem>) throws {
    for i in items {
      try self.visitExpression(i.contextExpr)
      try self.visitExpression(i.optionalVars)
    }
  }

  // MARK: - ExceptHandler

  /// symtable_visit_excepthandler(struct symtable *st, excepthandler_ty eh)
  private func visitExceptHandlers(_ handlers: [ExceptHandler]) throws {
    for h in handlers {
      try self.visitExpression(h.type)
      if let name = h.name {
        try self.addSymbol(name, flags: .defLocal, location: h.start)
      }
      try self.visitStatements(h.body)
    }
  }

  // MARK: - Alias

  /// symtable_visit_alias(struct symtable *st, alias_ty a)
  private func visitAliases(_ aliases: NonEmptyArray<Alias>) throws {
    for a in aliases {
      switch a.name {
      case "*":
        // TODO: AST -> Alias should be a sum type tith star|alias(name, as)
        if self.currentScope.type != .module {
          throw self.error(.nonModuleImportStar, location: a.start)
        }

      default:
        // import elsa <- register elsa
        // import elsa as queen <- register queen
        // import arendelle.elsa <- register arendelle (elsa is an attribute)

        // If symbol after 'import' is the name of a module or package,
        // then to use objects defined in X, you have to write X.object.

        var name = a.asName ?? a.name
        if let dotIndex = name.firstIndex(of: ".") {
          name = String(name[name.startIndex..<dotIndex])
        }

        try self.addSymbol(name, flags: .defImport, location: a.start)
      }
    }
  }
}
