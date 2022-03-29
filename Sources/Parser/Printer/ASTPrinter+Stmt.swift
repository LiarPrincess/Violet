import VioletCore
import Rapunzel

// swiftlint:disable vertical_parameter_alignment_on_call

extension ASTPrinter {

  private func base(stmt: Statement, lines: Doc...) -> Doc {
    return self.base(stmt: stmt, lines: lines)
  }

  private func base(stmt: Statement, lines: [Doc] = []) -> Doc {
    let type = self.typeName(of: stmt)
    let title = "\(type)(start: \(stmt.start), end: \(stmt.end))"

    return lines.isEmpty ?
      self.text(title) :
      self.block(title: title, lines: lines)
  }

  // MARK: - Stmt

  public func visit(_ node: Statement) -> Doc {
    // swiftlint:disable:next force_try
    return try! node.accept(self)
  }

  // MARK: - Function def stmt

  public func visit(_ node: FunctionDefStmt) -> Doc {
    let d = node.decorators.isEmpty ?
      self.text("Decorators: none") :
      self.block(title: "Decorators", lines: node.decorators.map(self.visit))

    let r = node.returns.map { block(title: "Returns", lines: self.visit($0)) } ??
      self.text("Returns: none")

    return self.base(
      stmt: node,
      lines:
        self.text("Name: \(node.name)"),
        self.block(title: "Args", lines: self.visit(node.args)),
        self.block(title: "Body", lines: node.body.map(self.visit)),
        d,
        r
    )
  }

  public func visit(_ node: AsyncFunctionDefStmt) -> Doc {
    let d = node.decorators.isEmpty ?
      self.text("Decorators: none") :
      self.block(title: "Decorators", lines: node.decorators.map(self.visit))

    let r = node.returns.map { block(title: "Returns", lines: self.visit($0)) } ??
      self.text("Returns: none")

    return self.base(
      stmt: node,
      lines:
        self.text("Name: \(node.name)"),
        self.block(title: "Args", lines: self.visit(node.args)),
        self.block(title: "Body", lines: node.body.map(self.visit)),
        d,
        r
    )
  }

  // MARK: - Class stmt

  public func visit(_ node: ClassDefStmt) -> Doc {
    let b = node.bases.isEmpty ?
      self.text("Bases: none") :
      self.block(title: "Bases", lines: node.bases.map(self.visit))

    let k = node.keywords.isEmpty ?
      self.text("Keywords: none") :
      self.block(title: "Keywords", lines: node.keywords.map(self.visit))

    let d = node.decorators.isEmpty ?
      self.text("Decorators: none") :
      self.block(title: "Decorators", lines: node.decorators.map(self.visit))

    return self.base(
      stmt: node,
      lines:
        self.text("Name: \(node.name)"),
        b,
        k,
        self.block(title: "Body", lines: node.body.map(self.visit)),
        d
    )
  }

  // MARK: - Return stmt

  public func visit(_ node: ReturnStmt) -> Doc {
    let v = node.value.map {
      self.block(title: "Value", lines: self.visit($0))
    } ?? self.text("Value: none")

    return self.base(stmt: node, lines: v)
  }

  // MARK: - Delete stmt

  public func visit(_ node: DeleteStmt) -> Doc {
    return self.base(
      stmt: node,
      lines: node.values.map(self.visit)
    )
  }

  // MARK: - Assign stmt

  public func visit(_ node: AssignStmt) -> Doc {
    return self.base(
      stmt: node,
      lines:
        self.block(title: "Targets", lines: node.targets.map(self.visit)),
        self.block(title: "Value", lines: self.visit(node.value))
    )
  }

  public func visit(_ node: AugAssignStmt) -> Doc {
    return self.base(
      stmt: node,
      lines:
        self.block(title: "Target", lines: self.visit(node.target)),
        self.text("Operator: \(node.op)"),
        self.block(title: "Value", lines: self.visit(node.value))
    )
  }

  public func visit(_ node: AnnAssignStmt) -> Doc {
    let v = node.value.map {
      self.block(title: "Value", lines: self.visit($0))
    } ?? text("Value: none")

    return self.base(
      stmt: node,
      lines:
        self.block(title: "Target", lines: self.visit(node.target)),
        self.block(title: "Annotation", lines: self.visit(node.annotation)),
        v,
        self.text("IsSimple: \(node.isSimple)")
    )
  }

  // MARK: - For stmt

  public func visit(_ node: ForStmt) -> Doc {
    let e = node.orElse.isEmpty ?
      self.text("OrElse: none") :
      self.block(title: "OrElse", lines: node.orElse.map(self.visit))

    return self.base(
      stmt: node,
      lines:
        self.block(title: "Target", lines: self.visit(node.target)),
        self.block(title: "Iterable", lines: self.visit(node.iterable)),
        self.block(title: "Body", lines: node.body.map(self.visit)),
        e
    )
  }

  public func visit(_ node: AsyncForStmt) -> Doc {
    let e = node.orElse.isEmpty ?
      self.text("OrElse: none") :
      self.block(title: "OrElse", lines: node.orElse.map(self.visit))

    return self.base(
      stmt: node,
      lines:
        self.block(title: "Target", lines: self.visit(node.target)),
        self.block(title: "Iterable", lines: self.visit(node.iterable)),
        self.block(title: "Body", lines: node.body.map(self.visit)),
        e
    )
  }

  // MARK: - While stmt

  public func visit(_ node: WhileStmt) -> Doc {
    let e = node.orElse.isEmpty ?
      self.text("OrElse: none") :
      self.block(title: "OrElse", lines: node.orElse.map(self.visit))

    return self.base(
      stmt: node,
      lines:
        self.block(title: "Test", lines: self.visit(node.test)),
        self.block(title: "Body", lines: node.body.map(self.visit)),
        e
    )
  }

  // MARK: - If stmt

  public func visit(_ node: IfStmt) -> Doc {
    let e = node.orElse.isEmpty ?
      self.text("OrElse: none") :
      self.block(title: "OrElse", lines: node.orElse.map(self.visit))

    return self.base(
      stmt: node,
      lines:
        self.block(title: "Test", lines: self.visit(node.test)),
        self.block(title: "Body", lines: node.body.map(self.visit)),
        e
    )
  }

  // MARK: - With stmt

  public func visit(_ node: WithStmt) -> Doc {
    return self.base(
      stmt: node,
      lines:
        self.block(title: "Items", lines: node.items.map(self.visit)),
        self.block(title: "Body", lines: node.body.map(self.visit))
    )
  }

  public func visit(_ node: AsyncWithStmt) -> Doc {
    return self.base(
      stmt: node,
      lines:
        self.block(title: "Items", lines: node.items.map(self.visit)),
        self.block(title: "Body", lines: node.body.map(self.visit))
    )
  }

  public func visit(_ item: WithItem) -> Doc {
    let o = item.optionalVars.map {
      self.block(title: "OptionalVars", lines: self.visit($0))
    } ?? text("OptionalVars: none")

    return self.block(
      title: "WithItem(start: \(item.start), end: \(item.end))",
      lines:
        self.block(title: "ContextExpr", lines: self.visit(item.contextExpr)),
        o
    )
  }

  // MARK: - Raise stmt

  public func visit(_ node: RaiseStmt) -> Doc {
    let e = node.exception.map { block(title: "Exc", lines: self.visit($0)) } ??
      self.text("Exc: none")

    let c = node.cause.map { block(title: "Cause", lines: self.visit($0)) } ??
      self.text("Cause: none")

    return self.base(stmt: node, lines: e, c)
  }

  // MARK: - Try stmt

  public func visit(_ node: TryStmt) -> Doc {
    let h = node.handlers.isEmpty ?
      self.text("Handlers: none") :
      self.block(title: "Handlers", lines: node.handlers.map(self.visit))

    let e = node.orElse.isEmpty ?
      self.text("OrElse: none") :
      self.block(title: "OrElse", lines: node.orElse.map(self.visit))

    let f = node.finally.isEmpty ?
      self.text("Finally: none") :
      self.block(title: "Finally", lines: node.finally.map(self.visit))

    return self.base(
      stmt: node,
      lines:
        self.block(title: "Body", lines: node.body.map(self.visit)),
        h,
        e,
        f
    )
  }

  public func visit(_ node: ExceptHandler) -> Doc {
    return self.block(
      title: "ExceptHandler(start: \(node.start), end: \(node.end))",
      lines:
        self.block(title: "Kind", lines: self.visit(node.kind)),
        self.block(title: "Body", lines: node.body.map(self.visit))
    )
  }

  public func visit(_ node: ExceptHandler.Kind) -> Doc {
      switch node {
      case .default:
        return self.text("Default")
      case let .typed(type: type, asName: name):
        return self.block(
          title: "Typed",
          lines:
            self.block(title: "Type", lines: self.visit(type)),
            self.text("AsName: \(name ?? "none")")
        )
      }
  }

  // MARK: - Assert stmt

  public func visit(_ node: AssertStmt) -> Doc {
    let m = node.msg.map {
      self.block(title: "Msg", lines: self.visit($0))
    } ?? text("Msg: none")

    return self.base(
      stmt: node,
      lines:
        self.block(title: "Test", lines: self.visit(node.test)),
        m
    )
  }

  // MARK: - Import stmt

  public func visit(_ node: ImportStmt) -> Doc {
    return self.base(
      stmt: node,
      lines: self.block(title: "Aliases", lines: node.names.map(self.visit))
    )
  }

  public func visit(_ node: ImportFromStmt) -> Doc {
    return self.base(
      stmt: node,
      lines:
        self.text("Module: \(node.moduleName ?? "none")"),
        self.block(title: "Names", lines: node.names.map(self.visit)),
        self.text("Level: \(node.level)")
    )
  }

  public func visit(_ node: ImportFromStarStmt) -> Doc {
    return self.base(
      stmt: node,
      lines:
        self.text("Module: \(node.moduleName ?? "none")"),
        self.text("Level: \(node.level)")
    )
  }

  public func visit(_ node: Alias) -> Doc {
    return self.block(
      title: "Alias(start: \(node.start), end: \(node.end))",
      lines:
        self.text("Name: \(node.name)"),
        self.text("AsName: \(node.asName ?? "none")")
    )
  }

  // MARK: - Global stmt

  public func visit(_ node: GlobalStmt) -> Doc {
    return self.base(
      stmt: node,
      lines: node.identifiers.map(self.text)
    )
  }

  // MARK: - Nonlocal stmt

  public func visit(_ node: NonlocalStmt) -> Doc {
    return self.base(
      stmt: node,
      lines: node.identifiers.map(self.text)
    )
  }

  // MARK: - Expr stmt

  public func visit(_ node: ExprStmt) -> Doc {
    return self.base(
      stmt: node,
      lines: self.visit(node.expression)
    )
  }

  // MARK: - Pass stmt

  public func visit(_ node: PassStmt) -> Doc {
    return self.base(stmt: node, lines: [])
  }

  // MARK: - Break stmt

  public func visit(_ node: BreakStmt) -> Doc {
    return self.base(stmt: node, lines: [])
  }

  // MARK: - Continue stmt

  public func visit(_ node: ContinueStmt) -> Doc {
    return self.base(stmt: node, lines: [])
  }
}
