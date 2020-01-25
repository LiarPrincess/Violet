/*
import Core
import Rapunzel

// swiftlint:disable vertical_parameter_alignment_on_call
// swiftlint:disable file_length

// MARK: - Helpers

private func text<S: CustomStringConvertible>(_ value: S) -> Doc {
  return .text(String(describing: value))
}

private func block(title: String, lines: Doc...) -> Doc {
  return block(title: title, lines: lines)
}

private func block(title: String, lines: [Doc]) -> Doc {
  return .block(title: title,
                indent: RapunzelConfig.indent,
                lines: lines)
}

// MARK: - Statement

extension Statement: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Statement(start: \(self.start), end: \(self.end))",
      lines: self.kind.doc
    )
  }
}

// MARK: - StatementKind

extension StatementKind: RapunzelConvertible {

  public var doc: Doc {
    switch self {
    case let .functionDef(args):
      return self.functionDef(title: "FunctionDef", args: args)
    case let .asyncFunctionDef(args):
      return self.functionDef(title: "AsyncFunctionDef", args: args)

    case let .classDef(args):
      let b = args.bases.isEmpty ?
        text("Bases: none") :
        block(title: "Bases", lines: args.bases.map { $0.doc })

      let k = args.keywords.isEmpty ?
        text("Keywords: none") :
        block(title: "Keywords", lines: args.keywords.map { $0.doc })

      let d = args.decorators.isEmpty ?
        text("Decorators: none") :
        block(title: "Decorators", lines: args.decorators.map { $0.doc })

      return block(
        title: "ClassDef",
        lines:
          text("Name: \(args.name)"),
          b,
          k,
          block(title: "Body", lines: args.body.map { $0.doc }),
          d
      )

    case let .return(value):
      switch value {
      case .none:
        return text("Return")
      case .some(let v):
        return block(title: "Return", lines: v.doc)
      }

    case let .delete(elements):
      return block(title: "Delete", lines: elements.map { $0.doc })

    case let .assign(targets, value):
      return block(
        title: "Assign",
        lines:
          block(title: "Targets", lines: targets.map { $0.doc }),
          block(title: "Value", lines: value.doc)
      )

    case let .annAssign(target, annotation, value, _):
      let v = value.map { block(title: "Value", lines: $0.doc) } ??
        text("Value: none")

      return block(
        title: "AnnAssign",
        lines:
          block(title: "Target", lines: target.doc),
          block(title: "Annotation", lines: annotation.doc),
          v
      )

    case let .augAssign(target, op, value):
      return block(
        title: "AugAssign",
        lines:
          block(title: "Target", lines: target.doc),
          text("Operator: \(op)"),
          block(title: "Value", lines: value.doc)
      )

    case let .for(target, iter, body, orElse):
      return self.forDoc(title: "For",
                         target: target,
                         iter: iter,
                         body: body,
                         orElse: orElse)
    case let .asyncFor(target, iter, body, orElse):
      return self.forDoc(title: "AsyncFor",
                         target: target,
                         iter: iter,
                         body: body,
                         orElse: orElse)

    case let .while(test, body, orElse):
      let e = orElse.isEmpty ?
        text("OrElse: none") :
        block(title: "OrElse", lines: orElse.map { $0.doc })

      return block(
        title: "While",
        lines:
          block(title: "Test", lines: test.doc),
          block(title: "Body", lines: body.map { $0.doc }),
          e
      )

    case let .if(test, body, orElse):
      let e = orElse.isEmpty ?
        text("OrElse: none") :
        block(title: "OrElse", lines: orElse.map { $0.doc })

      return block(
        title: "If",
        lines:
          block(title: "Test", lines: test.doc),
          block(title: "Body", lines: body.map { $0.doc }),
          e
      )

    case let .with(items, body):
      return self.with(title: "With", items: items, body: body)
    case let .asyncWith(items, body):
      return self.with(title: "AsyncWith", items: items, body: body)

    case let .try(body, handlers, orElse, finalBody):
      let h = handlers.isEmpty ?
        text("Handlers: none") :
        block(title: "Handlers", lines: handlers.map { $0.doc })

      let e = orElse.isEmpty ?
        text("OrElse: none") :
        block(title: "OrElse", lines: orElse.map { $0.doc })

      let f = finalBody.isEmpty ?
        text("FinalBody: none") :
        block(title: "FinalBody", lines: finalBody.map { $0.doc })

      return block(
        title: "Try",
        lines:
          block(title: "Body", lines: body.map { $0.doc }),
          h,
          e,
          f
      )

    case let .raise(exc, cause):
      let e = exc.map { block(title: "Exc", lines: $0.doc) } ??
        text("Exc: none")

      let c = cause.map { block(title: "Cause", lines: $0.doc) } ??
        text("Cause: none")

      return block(title: "Raise", lines: e, c)

    case let .import(names):
      return block(title: "Import", lines: names.map { $0.doc })
    case let .importFrom(module, names, level):
      return block(
        title: "ImportFrom",
        lines:
          text("Module: \(module ?? "none")"),
          block(title: "Names", lines: names.map { $0.doc }),
          text("Level: \(level)")
      )
    case let .importFromStar(module, level):
      return block(
        title: "ImportFromStar",
        lines:
          text("Module: \(module ?? "none")"),
          text("Level: \(level)")
      )

    case let .global(v):
      return block(title: "Global", lines: v.map { $0.doc })
    case let .nonlocal(v):
      return block(title: "Nonlocal", lines: v.map { $0.doc })

    case let .assert(test, msg):
      let m = msg.map { block(title: "Msg", lines: $0.doc) } ??
        text("Msg: none")

      return block(
        title: "Assert",
        lines:
          block(title: "Test", lines: test.doc),
          m
      )

    case let .expr(e):
      return block(title: "ExpressionStatement", lines: e.doc)

    case .pass:
      return text("Pass")
    case .break:
      return text("Break")
    case .continue:
      return text("Continue")
    }
  }

// MARK: Helpers

  private func functionDef(title: String, args: FunctionDefArgs) -> Doc {
    let d = args.decorators.isEmpty ?
      text("Decorators: none") :
      block(title: "Decorators", lines: args.decorators.map { $0.doc })

    let r = args.returns.map { block(title: "Returns", lines: $0.doc) } ??
      text("Returns: none")

    return block(
      title: title,
      lines:
        text("Name: \(args.name)"),
        block(title: "Args", lines: args.args.doc),
        block(title: "Body", lines: args.body.map { $0.doc }),
        d,
        r
    )
  }

  private func forDoc(title: String,
                      target: Expression,
                      iter: Expression,
                      body: NonEmptyArray<Statement>,
                      orElse: [Statement]) -> Doc {
    let e = orElse.isEmpty ?
      text("OrElse: none") :
      block(title: "OrElse", lines: orElse.map { $0.doc })

    return block(
      title: title,
      lines:
        block(title: "Target", lines: target.doc),
        block(title: "Iter", lines: iter.doc),
        block(title: "Body", lines: body.map { $0.doc }),
        e
    )
  }

  private func with(title: String,
                    items: NonEmptyArray<WithItem>,
                    body: NonEmptyArray<Statement>) -> Doc {
    return block(
      title: title,
      lines:
        block(title: "Items", lines: items.map { $0.doc }),
        block(title: "Body", lines: body.map { $0.doc })
    )
  }
}

// MARK: - Alias

extension Alias: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Alias(start: \(self.start), end: \(self.end))",
      lines:
        text("Name: \(self.name)"),
        text("AsName: \(self.asName ?? "none")")
    )
  }
}

// MARK: - WithItem

extension WithItem: RapunzelConvertible {
  public var doc: Doc {
    let o = optionalVars.map { block(title: "OptionalVars", lines: $0.doc) } ??
      text("OptionalVars: none")

    return block(
      title: "WithItem(start: \(self.start), end: \(self.end))",
      lines:
        block(title: "ContextExpr", lines: self.contextExpr.doc),
        o
    )
  }
}

// MARK: - ExceptHandler

extension ExceptHandler: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "ExceptHandler(start: \(self.start), end: \(self.end))",
      lines:
        block(title: "Kind", lines: self.kind.doc),
        block(title: "Body", lines: self.body.map { $0.doc })
    )
  }
}

extension ExceptHandlerKind: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case .default:
      return text("Default")
    case let .typed(type: type, asName: name):
      return block(
        title: "Typed",
        lines:
          block(title: "Type", lines: type.doc),
          text("AsName: \(name ?? "none")")
      )
    }
  }
}
*/
