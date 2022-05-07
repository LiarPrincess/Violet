import VioletCore
import Rapunzel

// swiftlint:disable file_length
// swiftlint:disable vertical_parameter_alignment_on_call

extension ASTPrinter {

  private func base(expr: Expression, lines: Doc...) -> Doc {
    return self.base(expr: expr, lines: lines)
  }

  private func base(expr: Expression, lines: [Doc] = []) -> Doc {
    let type = self.typeName(of: expr)
    let title = "\(type)(context: \(expr.context), start: \(expr.start), end: \(expr.end))"

    return lines.isEmpty ?
      self.text(title) :
      self.block(title: title, lines: lines)
  }

  public func visit(_ context: ExpressionContext) -> Doc {
    switch context {
    case .store: return self.text("Store")
    case .load: return self.text("Load")
    case .del: return self.text("Del")
    }
  }

  // MARK: - Expr

  public func visit(_ node: Expression) -> Doc {
    // swiftlint:disable:next force_try
    return try! node.accept(self)
  }

  // MARK: - Bool expr

  public func visit(_ node: TrueExpr) -> Doc {
    return self.base(expr: node, lines: [])
  }

  public func visit(_ node: FalseExpr) -> Doc {
    return self.base(expr: node, lines: [])
  }

  // MARK: - Basic expr

  public func visit(_ node: NoneExpr) -> Doc {
    return self.base(expr: node, lines: [])
  }

  public func visit(_ node: EllipsisExpr) -> Doc {
    return self.base(expr: node, lines: [])
  }

  // MARK: - Identifier expr

  public func visit(_ node: IdentifierExpr) -> Doc {
    return self.base(
      expr: node,
      lines: self.text("Value: \(node.value)")
    )
  }

  // MARK: - String expr

  public func visit(_ node: StringExpr) -> Doc {
    return self.base(
      expr: node,
      lines: self.visit(node.value)
    )
  }

  public func visit(_ group: StringExpr.Group) -> Doc {
    switch group {
    case let .literal(s):
      return self.text("String: '\(self.trim(s))'")

    case let .formattedValue(value, conversion, spec):
      let c = conversion.map(self.visit) ?? self.text("none")
      return self.block(
        title: "Formatted string",
        lines:
          self.visit(value),
          self.text("Conversion: ") <> c,
          self.text("Spec: \(spec?.description ?? "none")")
      )

    case let .joined(elements):
      return self.block(
        title: "Joined string",
        lines: elements.map { self.visit($0) }
      )
    }
  }

  public func visit(_ flag: StringExpr.Conversion) -> Doc {
    switch flag {
    case .str: return self.text("str")
    case .ascii: return self.text("ascii")
    case .repr: return self.text("repr")
    }
  }

  // MARK: - Number expr

  public func visit(_ node: IntExpr) -> Doc {
    return self.base(
      expr: node,
      lines: self.text("Value: \(node.value)")
    )
  }

  public func visit(_ node: FloatExpr) -> Doc {
    return self.base(
      expr: node,
      lines: self.text("Value: \(node.value)")
    )
  }

  public func visit(_ node: ComplexExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.text("Real: \(node.real)"),
        self.text("Imag: \(node.imag)")
    )
  }

  // MARK: - Bytes expr

  public func visit(_ node: BytesExpr) -> Doc {
    return self.base(
      expr: node,
      lines: text("Count: \(node.value.count)")
    )
  }

  // MARK: - Operator expr

  public func visit(_ node: UnaryOpExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.text("Operator: \(node.op)"),
        self.block(title: "Right", lines: self.visit(node.right))
    )
  }

  public func visit(_ node: BinaryOpExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.text("Operator: \(node.op)"),
        self.block(title: "Left", lines: self.visit(node.left)),
        self.block(title: "Right", lines: self.visit(node.right))
    )
  }

  public func visit(_ node: BoolOpExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.text("Operator: \(node.op)"),
        self.block(title: "Left", lines: self.visit(node.left)),
        self.block(title: "Right", lines: self.visit(node.right))
    )
  }

  public func visit(_ node: CompareExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.block(title: "Left", lines: self.visit(node.left)),
        self.block(title: "Elements", lines: node.elements.map(self.visit))
    )
  }

  public func visit(_ element: CompareExpr.Element) -> Doc {
    return self.block(
      title: "ComparisonElement",
      lines:
        self.text("Operator: \(element.op)"),
        self.block(title: "Right", lines: self.visit(element.right))
    )
  }

  // MARK: - Collection expr

  public func visit(_ node: TupleExpr) -> Doc {
    let e = node.elements.isEmpty ?
      self.text("Elements: none") :
      self.block(title: "Elements", lines: node.elements.map(self.visit))

    return self.base(expr: node, lines: e)
  }

  public func visit(_ node: ListExpr) -> Doc {
    let e = node.elements.isEmpty ?
      self.text("Elements: none") :
      self.block(title: "Elements", lines: node.elements.map(self.visit))

    return self.base(expr: node, lines: e)
  }

  public func visit(_ node: DictionaryExpr) -> Doc {
    let e = node.elements.isEmpty ?
      self.text("Elements: none") :
      self.block(title: "Elements", lines: node.elements.map(self.visit))

    return self.base(expr: node, lines: e)
  }

  public func visit(_ element: DictionaryExpr.Element) -> Doc {
    switch element {
    case let .unpacking(expr):
      return self.block(title: "Unpack", lines: self.visit(expr))
    case let .keyValue(key: key, value: value):
      return self.block(
        title: "Key/value",
        lines:
          self.block(title: "Key", lines: self.visit(key)),
          self.block(title: "Value", lines: self.visit(value))
      )
    }
  }

  public func visit(_ node: SetExpr) -> Doc {
    let e = node.elements.isEmpty ?
      self.text("Elements: none") :
      self.block(title: "Elements", lines: node.elements.map(self.visit))

    return self.base(expr: node, lines: e)
  }

  // MARK: - Comprehension expr

  public func visit(_ node: ListComprehensionExpr) -> Doc {
    // return nodes.map(self.visit)
    return self.base(
      expr: node,
      lines:
        self.block(title: "Element", lines: self.visit(node.element)),
        self.block(title: "Generators", lines: node.generators.map(self.visit))
    )
  }

  public func visit(_ node: SetComprehensionExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.block(title: "Element", lines: self.visit(node.element)),
        self.block(title: "Generators", lines: node.generators.map(self.visit))
    )
  }

  public func visit(_ node: DictionaryComprehensionExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.block(title: "Key", lines: self.visit(node.key)),
        self.block(title: "Value", lines: self.visit(node.value)),
        self.block(title: "Generators", lines: node.generators.map(self.visit))
    )
  }

  public func visit(_ node: GeneratorExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.block(title: "Element", lines: self.visit(node.element)),
        self.block(title: "Generators", lines: node.generators.map(self.visit))
    )
  }

  public func visit(_ node: Comprehension) -> Doc {
    return self.block(
      title: "Comprehension(start: \(node.start), end: \(node.end))",
      lines:
        self.text("isAsync: \(node.isAsync)"),
        self.block(title: "Target", lines: self.visit(node.target)),
        self.block(title: "Iterable", lines: self.visit(node.iterable)),
        node.ifs.isEmpty ?
          self.text("Ifs: none") :
          self.block(title: "Ifs", lines: node.ifs.map(self.visit))
    )
  }

  // MARK: - Await expr

  public func visit(_ node: AwaitExpr) -> Doc {
    return self.base(
      expr: node,
      lines: self.block(title: "Value", lines: self.visit(node.value))
    )
  }

  // MARK: - Yield expr

  public func visit(_ node: YieldExpr) -> Doc {
    let v = node.value.map {
      self.block(title: "Value", lines: self.visit($0))
    } ?? text("Value: none")

    return self.base(expr: node, lines: v)
  }

  public func visit(_ node: YieldFromExpr) -> Doc {
    return self.base(
      expr: node,
      lines: self.block(title: "Value", lines: self.visit(node.value))
    )
  }

  // MARK: - Lambda expr

  public func visit(_ node: LambdaExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.block(title: "Args", lines: self.visit(node.args)),
        self.block(title: "Body", lines: self.visit(node.body))
    )
  }

  // MARK: - Arguments

  public func visit(_ node: Arguments) -> Doc {
    let args = node.args.isEmpty ?
      self.text("Args: none") :
      self.block(title: "Args", lines: node.args.map(self.visit))

    let defaults = node.defaults.isEmpty ?
      self.text("Defaults: none") :
      self.block(title: "Defaults", lines: node.defaults.map(self.visit))

    let vararg: Doc = {
      switch node.vararg {
      case .none: return .text("Vararg: none")
      case .unnamed: return text("Vararg: unnamed")
      case .named: return self.block(title: "Vararg", lines: self.visit(node.vararg))
      }
    }()

    let kwOnly = node.kwOnlyArgs.isEmpty ?
      self.text("KwOnlyArgs: none") :
      self.block(title: "KwOnlyArgs", lines: node.kwOnlyArgs.map(self.visit))

    let kwOnlyDefaults = node.kwOnlyDefaults.isEmpty ?
      self.text("KwOnlyDefaults: none") :
      self.block(title: "KwOnlyDefaults", lines: node.kwOnlyDefaults.map(self.visit))

    let kwarg = node.kwarg.map {
      self.block(title: "Kwarg", lines: self.visit($0))
    } ?? self.text("Kwarg: none")

    return self.block(
      title: "Arguments(start: \(node.start), end: \(node.end))",
      lines:
        args,
        self.text("PosOnlyArgCount: \(node.posOnlyArgCount)"),
        defaults,
        vararg,
        kwOnly,
        kwOnlyDefaults,
        kwarg
    )
  }

  public func visit(_ node: Argument) -> Doc {
    let ann = node.annotation.map {
      self.block(title: "Annotation", lines: self.visit($0))
    } ?? text("Annotation: none")

    return self.block(
      title: "Arg",
      lines:
        self.text("Name: \(node.name)"),
        ann
    )
  }

  public func visit(_ node: Vararg) -> Doc {
    switch node {
    case .none:
      return self.text("None")
    case .unnamed:
      return self.text("Unnamed")
    case .named(let arg):
      return self.block(title: "Named", lines: self.visit(arg))
    }
  }

  // MARK: - Keyword

  public func visit(_ node: KeywordArgument) -> Doc {
    return self.block(
      title: "Keyword(start: \(node.start), end: \(node.end))",
      lines:
        self.block(title: "Kind", lines: self.visit(node.kind)),
        self.block(title: "Value", lines: self.visit(node.value))
    )
  }

  public func visit(_ node: KeywordArgument.Kind) -> Doc {
    switch node {
    case .dictionaryUnpack:
      return self.text("DictionaryUnpack")
    case .named(let n):
      return self.text("Named('\(n)')")
    }
  }

  // MARK: - Call expr

  public func visit(_ node: CallExpr) -> Doc {
    let args = node.args.isEmpty ?
      self.text("Args: none") :
      self.block(title: "Args", lines: node.args.map(self.visit))

    let kwargs = node.keywords.isEmpty ?
      self.text("Keywords: none") :
      self.block(title: "Keywords", lines: node.keywords.map(self.visit))

    return self.base(
      expr: node,
      lines:
        self.block(title: "Name", lines: self.visit(node.function)),
        args,
        kwargs
    )
  }

  // MARK: - If expr

  public func visit(_ node: IfExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.block(title: "Test", lines: self.visit(node.test)),
        self.block(title: "Body", lines: self.visit(node.body)),
        self.block(title: "OrElse", lines: self.visit(node.orElse))
    )
  }

  // MARK: - Attribute expr

  public func visit(_ node: AttributeExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.block(title: "Object", lines: self.visit(node.object)),
        self.text("Name: \(node.name)")
    )
  }

  // MARK: - Subscript expr

  public func visit(_ node: SubscriptExpr) -> Doc {
    return self.base(
      expr: node,
      lines:
        self.block(title: "Object", lines: self.visit(node.object)),
        self.visit(node.slice)
    )
  }

  public func visit(_ slice: Slice) -> Doc {
    return self.block(
      title: "Slice(start: \(slice.start), end: \(slice.end))",
      lines: self.visit(slice.kind)
    )
  }

  public func visit(_ kind: Slice.Kind) -> Doc {
    switch kind {
    case let .slice(lower, upper, step):
      return self.block(
        title: "Slice",
        lines:
          self.sliceElement(name: "Lower", expr: lower),
          self.sliceElement(name: "Upper", expr: upper),
          self.sliceElement(name: "Step", expr: step)
      )

    case let .extSlice(s):
      return self.block(title: "ExtSlice", lines: s.map(self.visit))

    case let .index(i):
      return self.block(title: "Index", lines: self.visit(i))
    }
  }

  private func sliceElement(name: String, expr: Expression?) -> Doc {
    switch expr {
    case .none:
      return self.text("\(name): none")
    case .some(let e):
      return self.block(title: name, lines: self.visit(e))
    }
  }

  // MARK: - Starred expr

  public func visit(_ node: StarredExpr) -> Doc {
    return self.base(
      expr: node,
      lines: self.block(title: "Expression", lines: self.visit(node.expression))
    )
  }

  // MARK: - Operators

  public func visit(_ op: UnaryOpExpr.Operator) -> Doc {
    switch op {
    case .invert: return self.text("inv")
    case .not: return self.text("not")
    case .plus: return self.text("+")
    case .minus: return self.text("-")
    }
  }

  public func visit(_ op: BoolOpExpr.Operator) -> Doc {
    switch op {
    case .and: return self.text("and")
    case .or: return self.text("or")
    }
  }

  public func visit(_ op: BinaryOpExpr.Operator) -> Doc {
    switch op {
    case .add: return self.text("+")
    case .sub: return self.text("-")
    case .mul: return self.text("*")
    case .matMul: return self.text("@")
    case .div: return self.text("/")
    case .modulo: return self.text("%")
    case .pow: return self.text("**")
    case .leftShift: return self.text("<<")
    case .rightShift: return self.text(">>")
    case .bitOr: return self.text("|")
    case .bitXor: return self.text("^")
    case .bitAnd: return self.text("&")
    case .floorDiv: return self.text("//")
    }
  }

  public func visit(_ op: CompareExpr.Operator) -> Doc {
    switch op {
    case .equal: return self.text("==")
    case .notEqual: return self.text("!=")
    case .less: return self.text("<")
    case .lessEqual: return self.text("<=")
    case .greater: return self.text(">")
    case .greaterEqual: return self.text(">=")
    case .is: return self.text("is")
    case .isNot: return self.text("is not")
    case .in: return self.text("in")
    case .notIn: return self.text("not in")
    }
  }
}
