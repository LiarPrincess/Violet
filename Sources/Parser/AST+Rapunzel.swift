import Rapunzel

// swiftlint:disable multiline_arguments
// swiftlint:disable vertical_parameter_alignment_on_call

// MARK: - Helpers

private let indent = 2

private func text<S: CustomStringConvertible>(_ value: S) -> Doc {
  return .text(String(describing: value))
}

private func block(title: String, lines: Doc...) -> Doc {
  return block(title: title, lines: lines)
}

private func block(title: String, lines: [Doc]) -> Doc {
  return .block(title: title, indent: indent, lines: lines)
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

//      case let .listComprehension(elt, generators):
//        return "(listCompr \(elt) \(join(generators)))"
//      case let .setComprehension(elt, generators):
//        return "(setCompr \(elt) \(join(generators)))"
//      case let .dictionaryComprehension(key, value, generators):
//        return "(dicCompr \(key):\(value) \(join(generators)))"
//      case let .generatorExp(elt, generators):
//        return "(generatorCompr \(elt) \(join(generators)))"
//
//      case let .await(value):
//        return "(await \(value))"
//      case let .yield(value):
//        let s = value.map { " " + describe($0) } ?? ""
//        return "(yield\(s))"
//      case let .yieldFrom(value):
//        return "(yieldFrom \(value))"
//
//      case let .lambda(args: args, body: body):
//        return "(λ \(args) do: \(body))"
//
//      case let .call(name, args, keywords):
//        // This may reorder arguments! Positional before keyword ones.
//        var ak = ""
//        switch (args.isEmpty, keywords.isEmpty) {
//        case (true, true): break
//        case (false, true):  ak = join(args)
//        case (true, false):  ak = join(keywords)
//        case (false, false): ak = join(args) + " " + join(keywords)
//        }
//
//        return "\(name)(\(ak))"
//
//      case let .ifExpression(test: test, body: body, orElse: orElse):
//        return "(if \(test) then \(body) else \(orElse))"
//
//      case let .starred(value):
//        return "*\(value)"
//      case let .attribute(value, name):
//        return "\(value).\(name)"
//      case let .subscript(value, slice):
//        return "\(value)[\(slice)]"

    default:
      fatalError()
    }
  }
}

// MARK: - StringGroup

extension StringGroup: RapunzelConvertible {
  public var doc: Doc {
    switch self {
    case let .literal(s):
      return block(title: "String literal", lines: text("'" + s + "'"))

    case let .formattedValue(s, conversion, spec):
      var lines = [s.doc]
      if let c = conversion {
        lines.append(text("Conversion: \(c)"))
      }
      if let s = spec {
        lines.append(text("Spec: \(s)"))
      }

      return block(title: "Formatted string", lines: lines)

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
      self.right.doc
    )
  }
}

// MARK: - Comprehension

extension Comprehension: RapunzelConvertible {
  public var doc: Doc {
//    var ifs = ""
//    switch self.ifs.count {
//    case 0: break
//    case 1: ifs = " if " + describe(self.ifs[0])
//    default: ifs = " (if " + join(self.ifs) + ")"
//    }
//
//    let async = self.isAsync ? "async " : ""
//    return "(\(async)for \(self.target) in \(self.iter)\(ifs))"
    fatalError()
  }
}
