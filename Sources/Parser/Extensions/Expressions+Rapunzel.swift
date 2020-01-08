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

private func trim(_ value: String) -> String {
  let index = value.index(value.startIndex,
                          offsetBy: RapunzelConfig.stringCutoff,
                          limitedBy: value.endIndex)

  switch index {
  case .none:
    return value
  case .some(let i):
    return String(value[...i]) + "..."
  }
}

// MARK: - Expression

extension Expression: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Expression(start: \(self.start), end: \(self.end))",
      lines: self.kind.doc
    )
  }
}

extension ExpressionKind: RapunzelConvertible {
  public var doc: Doc {
    switch self {

    case .true:  return text("True")
    case .false: return text("False")
    case .none:  return text("None")
    case .ellipsis: return text("...")

    case let .identifier(value): return text(value)
    case let .int(value):        return text(value)
    case let .float(value):      return text(value)

    case let .complex(real: real, imag: imag):
      return block(
        title: "Complex",
        lines:
          text("real: \(real)"),
          text("imag: \(imag)")
      )

    case let .string(s):
      return s.doc
    case let .bytes(data):
      return block(title: "Bytes", lines: text("Count: \(data.count)"))

    case let .unaryOp(op, right: right):
      return block(
        title: "Unary operation",
        lines:
          text("Operation: \(op)"),
          block(title: "Right", lines: right.doc)
      )
    case let .binaryOp(op, left: left, right: right):
      return block(
        title: "Binary operation",
        lines:
          text("Operation: \(op)"),
          block(title: "Left", lines: left.doc),
          block(title: "Right", lines: right.doc)
      )
    case let .boolOp(op, left: left, right: right):
      return block(
        title: "Bool operation",
        lines:
          text("Operation: \(op)"),
          block(title: "Left", lines: left.doc),
          block(title: "Right", lines: right.doc)
      )
    case let .compare(left: left, elements: elements):
      return block(
        title: "Compare operation",
        lines:
          block(title: "Left", lines: left.doc),
          block(title: "Elements", lines: elements.map { $0.doc })
      )

    case let .tuple(elements):
      return block(title: "Tuple", lines: elements.map { $0.doc })
    case let .list(elements):
      return block(title: "List", lines: elements.map { $0.doc })
    case let .dictionary(elements):
      return block(title: "Dictionary", lines: elements.map { $0.doc })
    case let .set(elements):
      return block(title: "Set", lines: elements.map { $0.doc })

    case let .listComprehension(elt, generators):
      return comprehension(title: "ListComprehension",
                           element: elt,
                           generators: generators)
    case let .setComprehension(elt, generators):
      return comprehension(title: "SetComprehension",
                           element: elt,
                           generators: generators)
    case let .dictionaryComprehension(key, value, generators):
      return comprehension(title: "DictionaryComprehension",
                           key: key,
                           value: value,
                           generators: generators)
    case let .generatorExp(elt, generators):
      return comprehension(title: "GeneratorExpr",
                           element: elt,
                           generators: generators)

    case let .await(value):
      return block(title: "Await", lines: value.doc)
    case let .yield(value):
      let val = value.map { $0.doc } ?? text("(none)")
      return block(title: "Yield", lines: val)
    case let .yieldFrom(value):
      return block(title: "YieldFrom", lines: value.doc)

    case let .lambda(args: args, body: body):
      return block(
        title: "Lambda",
        lines:
          block(title: "Args", lines: args.doc),
          block(title: "Body", lines: body.doc)
      )
    case let .call(name, args, keywords):
      let args = args.isEmpty ?
        text("Args: none") :
        block(title: "Args", lines: args.map { $0.doc })

      let kwargs = keywords.isEmpty ?
        text("Keywords: none") :
        block(title: "Keywords", lines: keywords.map { $0.doc })

      return block(
        title: "Call",
        lines:
          block(title: "Name", lines: name.doc),
          args,
          kwargs
      )

    case let .ifExpression(test: test, body: body, orElse: orElse):
      return block(
        title: "IfExpression",
        lines:
          test.doc,
          body.doc,
          orElse.doc
      )

    case let .starred(value):
      return block(title: "Starred", lines: value.doc)
    case let .attribute(value, name):
      return block(
        title: "Attribute",
        lines:
          block(title: "Value", lines: value.doc),
          text("Name: \(name)")
      )
    case let .subscript(value, slice):
      return block(
        title: "Subscript",
        lines:
          block(title: "Value", lines: value.doc),
          block(title: "Slice", lines: slice.doc)
      )
    }
  }
}

private func comprehension(title: String,
                           element: Expression,
                           generators: NonEmptyArray<Comprehension>) -> Doc {
  return block(
    title: title,
    lines:
      block(title: "Element", lines: element.doc),
      block(title: "Generators", lines: generators.map { $0.doc })
  )
}

private func comprehension(title: String,
                           key: Expression,
                           value: Expression,
                           generators: NonEmptyArray<Comprehension>) -> Doc {
  return block(
    title: title,
    lines:
      block(title: "Key", lines: key.doc),
      block(title: "Value", lines: value.doc),
      block(title: "Generators", lines: generators.map { $0.doc })
  )
}

// MARK: - StringGroup

extension StringGroup: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case let .literal(s):
      return text("String: '\(trim(s))'")

    case let .formattedValue(s, conversion, spec):
      return block(
        title: "Formatted string",
        lines:
          s.doc,
          text("Conversion: \(conversion?.description ?? "none")"),
          text("Spec: \(spec?.description ?? "none")")
      )

    case let .joined(elements):
      return block(
        title: "Joined string",
        lines: elements.map { $0.doc }
      )
    }
  }
}

// MARK: - Dictionary

extension DictionaryElement: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case let .unpacking(expr):
      return block(title: "Unpack", lines: expr.doc)
    case let .keyValue(key: key, value: value):
      return block(
        title: "Key/value",
        lines:
          block(title: "Key", lines: key.doc),
          block(title: "Value", lines: value.doc)
      )
    }
  }
}

// MARK: - Comparison

extension ComparisonElement: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "ComparisonElement",
      lines:
        text("Operation: \(self.op)"),
        block(title: "Right", lines: self.right.doc)
    )
  }
}

// MARK: - Comprehension

extension Comprehension: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Comprehension(start: \(self.start), end: \(self.end))",
      lines:
        text("isAsync: \(self.isAsync)"),
        block(title: "Target", lines: self.target.doc),
        block(title: "Iterable", lines: self.iter.doc),
        self.ifs.isEmpty ?
          text("Ifs: none") :
          block(title: "Ifs", lines: self.ifs.map { $0.doc })
    )
  }
}

// MARK: - Arguments

extension Arguments: RapunzelConvertible {
  public var doc: Doc {
    let args = self.args.isEmpty ?
      text("Args: none") :
      block(title: "Args", lines: self.args.map { $0.doc })

    let defaults = self.defaults.isEmpty ?
      text("Defaults: none") :
      block(title: "Defaults", lines: self.defaults.map { $0.doc })

    let vararg =
      self.vararg == .none ? text("Vararg: none") :
      self.vararg == .unnamed ? text("Vararg: unnamed") :
      block(title: "Vararg", lines: self.vararg.doc)

    let kwargs = self.kwOnlyArgs.isEmpty ?
      text("KwOnlyArgs: none") :
      block(title: "KwOnlyArgs", lines: self.kwOnlyArgs.map { $0.doc })

    let kwargDefaults = self.kwOnlyDefaults.isEmpty ?
      text("KwOnlyDefaults: none") :
      block(title: "KwOnlyDefaults", lines: self.kwOnlyDefaults.map { $0.doc })

    return block(
      title: "Arguments(start: \(self.start), end: \(self.end))",
      lines:
        args,
        defaults,
        vararg,
        kwargs,
        kwargDefaults
    )
  }
}

extension Arg: RapunzelConvertible {
  public var doc: Doc {
    let ann = self.annotation.map { block(title: "Annotation", lines: $0.doc) } ??
      text("Annotation: none")

    return block(
      title: "Arg",
      lines:
        text("Name: \(self.name)"),
        ann
    )
  }
}

extension Vararg: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case .none:
      return text("None")
    case .unnamed:
      return text("Unnamed")
    case .named(let arg):
      return block(title: "Named", lines: arg.doc)
    }
  }
}

// MARK: - Keyword

extension Keyword: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Keyword(start: \(self.start), end: \(self.end))",
      lines:
        block(title: "Kind", lines: self.kind.doc),
        block(title: "Value", lines: self.value.doc)
    )
  }
}

extension KeywordKind: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case .dictionaryUnpack:
      return text("DictionaryUnpack")
    case .named(let n):
      return text("Named('\(n)')")
    }
  }
}

// MARK: - Slice

extension Slice: RapunzelConvertible {
  public var doc: Doc {
    return block(
      title: "Slice(start: \(self.start), end: \(self.end))",
      lines: self.kind.doc
    )
  }
}

extension SliceKind: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case let .slice(lower, upper, step):
      return block(
        title: "Slice",
        lines:
          self.sliceElement(name: "Lower", expr: lower),
          self.sliceElement(name: "Upper", expr: upper),
          self.sliceElement(name: "Step", expr: step)
      )

    case let .extSlice(s):
      return block(title: "ExtSlice", lines: s.map { $0.doc })

    case let .index(i):
      return block(title: "Index", lines: i.doc)
    }
  }

  private func sliceElement(name: String, expr: Expression?) -> Doc {
    switch expr {
    case .none:
      return text("\(name): none")
    case .some(let e):
      return block(title: name, lines: e.doc)
    }
  }
}
