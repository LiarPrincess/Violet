import Core
import Parser

// In CPython:
// Python -> symtable.c

extension SymbolTableBuilder {

  // MARK: - Statement

  /// symtable_visit_stmt(struct symtable *st, stmt_ty s)
  internal func visitStatements<S: Sequence>(_ stmts: S)
    throws where S.Element == Statement {

    for s in stmts {
      try self.visitStatement(s)
    }
  }

// swiftlint:disable cyclomatic_complexity function_body_length

  /// symtable_visit_stmt(struct symtable *st, stmt_ty s)
  internal func visitStatement(_ stmt: Statement) throws {
// swiftlint:enable cyclomatic_complexity function_body_length

    switch stmt.kind {
    case let .functionDef(args),
         let .asyncFunctionDef(args):

      try self.addSymbol(args.name, flags: .defLocal, location: stmt.start)
      try self.visitDefaults(args.args)
      try self.visitAnnotations(args.args)
      try self.visitExpression(args.returns) // in CPython it is a part of visitAnnotations
      try self.visitExpressions(args.decorators)

      self.enterScope(name: args.name, type: .function, node: stmt)
      if stmt.kind.isAsyncFunctionDef {
        self.currentScope.isCoroutine = true
      }
      try self.visitArguments(args.args)
      try self.visitStatements(args.body)
      self.leaveScope()

    case let .classDef(args):
      try self.addSymbol(args.name, flags: .defLocal, location: stmt.start)
      try self.visitExpressions(args.bases)
      try self.visitKeywords(args.keywords)
      try self.visitExpressions(args.decorators)

      let previousClassName = self.className

      self.enterScope(name: args.name, type: .class, node: stmt)
      self.className = args.name
      try self.visitStatements(args.body)
      self.className = previousClassName
      self.leaveScope()

    case let .return(value):
      if let value = value {
        try self.visitExpression(value)
        self.currentScope.hasReturnValue = true
      }
    case let .delete(value):
      try self.visitExpressions(value, context: .del)

    case let .assign(targets, value):
      try self.visitExpressions(targets, context: .store)
      try self.visitExpression(value)
    case let .augAssign(target, _, value):
      try self.visitExpression(target, context: .store)
      try self.visitExpression(value)
    case let .annAssign(target, annotation, value, isSimple):
      if case let ExpressionKind.identifier(name) = target.kind {
        let current = self.lookupMangled(name)

        // This throws (the same for nonlocal):
        //   global rapunzel
        //   rapunzel: Int = 5
        // This does not throw:
        //   global rapunzel
        //   (rapunzel): Int = 5 (or tangled.rapunzel: Int = 5)
        // We use `isSimple` to differentiate between them.

        let isGlobal = current?.flags.contains(.defGlobal) ?? false
        if isGlobal && isSimple {
          throw self.error(.globalAnnot(name), location: stmt.start)
        }

        let isNonlocal = current?.flags.contains(.defNonlocal) ?? false
        if isNonlocal && isSimple {
          throw self.error(.nonlocalAnnot(name), location: stmt.start)
        }

        // '(rapunzel): Int = 5' is tuple -> not simple!
        if isSimple {
          let flags: SymbolFlags = [.defLocal, .annotated]
          try self.addSymbol(name, flags: flags, location: target.start)
        } else if value != nil {
          // different than CPython, but has the same effect:
          try self.visitExpression(target, context: .store)
        }
      } else {
        try self.visitExpression(target, context: .store)
      }

      try self.visitExpression(annotation)
      try self.visitExpression(value)

    case let .for(target, iter, body, orElse),
         let .asyncFor(target, iter, body, orElse):
      try self.visitExpression(target, context: .store)
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

    case let .raise(exception, cause):
      try self.visitExpression(exception)
      try self.visitExpression(cause)

    case let .try(body, handlers, orElse, finally):
      try self.visitStatements(body)
      try self.visitExceptHandlers(handlers)
      try self.visitStatements(orElse)
      try self.visitStatements(finally)

    case let .assert(test, msg):
      try self.visitExpression(test)
      try self.visitExpression(msg)

    case let .import(names),
         let .importFrom(_, names, _):
      try self.visitAliases(names, importStart: stmt.start)
    case .importFromStar:
      // No names here, but we can check this:
      if self.currentScope.type != .module {
        throw self.error(.nonModuleImportStar, location: stmt.start)
      }

    case let .global(names):
      for name in names {
        if let c = self.lookupMangled(name) {
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
        if let c = self.lookupMangled(name) {
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
      try self.visitExpression(i.optionalVars, context: .store)
    }
  }

  // MARK: - ExceptHandler

  /// symtable_visit_excepthandler(struct symtable *st, excepthandler_ty eh)
  private func visitExceptHandlers(_ handlers: [ExceptHandler]) throws {
    for h in handlers {
      if case let .typed(type: type, asName: asName) = h.kind {
        try self.visitExpression(type)
        if let n = asName {
          try self.addSymbol(n, flags: .defLocal, location: h.start)
        }
      }
      try self.visitStatements(h.body)
    }
  }

  // MARK: - Alias

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

      try self.addSymbol(name, flags: .defImport, location: alias.start)
    }
  }
}
