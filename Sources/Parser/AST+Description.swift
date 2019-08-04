import Foundation
import Core
import Lexer

// swiftlint:disable file_length

// MARK: - Helpers

private func join<A>(_ arr: [A], _ separator: String = " ") -> String {
  return arr.map { describe($0) }.joined(separator: separator)
}

private func describe<T>(_ obj: T) -> String {
  return String(describing: obj)
}

// MARK: - Descriptions

extension Expression: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return describe(self.kind)
  }

  public var debugDescription: String {
    return "Expression(\(self.kind), start: \(self.start), end: \(self.end))"
  }
}

extension ExpressionKind: CustomStringConvertible {
  public var description: String {
    switch self {

    case .true:  return "True"
    case .false: return "False"
    case .none:  return "None"
    case .ellipsis: return "..."

    case let .identifier(value): return describe(value)
    case let .int(value):        return describe(value)
    case let .float(value):      return describe(value)

    case let .complex(real: real, imag: imag):
      return "(complex \(real) \(imag))"
    case let .bytes(data):
      return "(bytes count:\(data.count))"

    case let .unaryOp(op, right: right):
      return "(\(op) \(right))"
    case let .binaryOp(op, left: left, right: right):
      return "(\(op) \(left) \(right))"
    case let .boolOp(op, left: left, right: right):
      return "(\(op) \(left) \(right))"
    case let .compare(left: left, elements: elements):
      return "(cmp \(left) \(join(elements)))"

    case let .tuple(value):
      return "(" + join(value) + ")"
    case let .list(value):
      return describe(value)
    case let .set(value):
      return "{" + join(value) + "}"

    case let .listComprehension(elt, generators):
      return "(listCompr \(elt) \(join(generators)))"
    case let .setComprehension(elt, generators):
      return "(setCompr \(elt) \(join(generators)))"
    case let .dictionaryComprehension(key, value, generators):
      return "(dicCompr \(key) \(value) \(join(generators)))"
    case let .generatorExp(elt, generators):
      return "(generatorCompr \(elt) \(join(generators)))"

    case let .await(value):
      return "(await \(value))"
    case let .yield(value):
      let s = value.map { " " + describe($0) } ?? ""
      return "(yield\(s))"
    case let .yieldFrom(value):
      return "(yieldFrom \(value))"

    case let .lambda(args: args, body: body):
      return "(lambda \(args) \(body))"
    case let .call(name, args, keywords):
      // We could skip 'call' at the beginning,
      // but that is way too similiar to identifier.
      // This may actully reorder arguments! Positional before keyword ones.
      let a = args.isEmpty ? "" : " " + join((args))
      let k = keywords.isEmpty ? "" : " " + join((keywords))
      return "(call \(name)\(a)\(k))"

    case let .namedExpr(target: target, value: value):
      return "(namedExpr \(target) \(value))"
    case let .ifExpression(test: test, body: body, orElse: orElse):
      return "(if \(test)) then \(body)) else \(orElse))"
    case let .starred(value):
      return "*\(value)"
    case let .attribute(value, name):
      return "(attribute \(value) \(name))"
    case let .subscript(value, slice):
      return "(subscript \(value) \(slice))"
    }
  }
}

extension UnaryOperator: CustomStringConvertible {
  public var description: String {
    switch self {
    case .invert: return "inv"
    case .not:    return "not"
    case .plus:  return "+"
    case .minus: return "-"
    }
  }
}

extension BooleanOperator: CustomStringConvertible {
  public var description: String {
    switch self {
    case .and: return "and"
    case .or:  return "or"
    }
  }
}

extension BinaryOperator: CustomStringConvertible {
  public var description: String {
    switch self {
    case .add: return "+"
    case .sub: return "-"
    case .mul: return "*"
    case .matMul: return "@"
    case .div: return "/"
    case .modulo: return "%"
    case .pow: return "**"
    case .leftShift: return "<<"
    case .rightShift: return ">>"
    case .bitOr: return "|"
    case .bitXor: return "^"
    case .bitAnd: return "&"
    case .floorDiv: return "//"
    }
  }
}

extension ComparisonElement: CustomStringConvertible {
  public var description: String {
    return "(\(self.op) \(self.right))"
  }
}

extension ComparisonOperator: CustomStringConvertible {
  public var description: String {
    switch self {
    case .equal:    return "="
    case .notEqual: return "!="
    case .less:      return "<"
    case .lessEqual: return "<="
    case .greater:      return ">"
    case .greaterEqual: return ">="
    case .is:    return "is"
    case .isNot: return "is not"
    case .in:    return "in"
    case .notIn: return "not in"
    }
  }
}

//extension StringGroup: CustomStringConvertible {
//  public var description: String {
//    switch self {
//    case let .string(value):
//      return "string(\(value))"
//    case let .formattedValue(value: value, conversion: conversion, spec: spec):
//      return "formattedValue(value: \(value)), conversion: \(conversion)), spec: \(spec)))"
//    case let .joinedString(value):
//      return "joinedString(\(value))"
//    }
//  }
//}

extension ConversionFlag: CustomStringConvertible {
  public var description: String {
    switch self {
    case .str:   return "str"
    case .ascii: return "ascii"
    case .repr:  return "repr"
    }
  }
}

extension Slice: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return describe(self.kind)
  }

  public var debugDescription: String {
    return "Slice(\(self.kind), start: \(self.start), end: \(self.end))"
  }
}

extension SliceKind: CustomStringConvertible {
  public var description: String {
    switch self {
    case let .index(index):
      return describe(index)
    case let .extSlice(dims: dims):
      return "(" + join(dims) + ")"
    case let .slice(lower: lower, upper: upper, step: step):
      let l = lower.map(describe) ?? ""
      let u = upper.map(describe) ?? ""
      let s = step.map(describe) ?? ""
      return "\(l):\(u):\(s)"
    }
  }
}

extension Comprehension: CustomStringConvertible {
  public var description: String {
    var ifs = ""
    switch self.ifs.count {
    case 0: break
    case 1: ifs = " if " + describe(self.ifs[0])
    default: ifs = " (if " + join(self.ifs) + ")"
    }

    let async = self.isAsync ? "async " : ""
    return "(\(async)for \(self.target) in \(self.iter)\(ifs))"
  }
}

extension Arguments: CustomStringConvertible, CustomDebugStringConvertible {

  /// (a *b c=None **d)
  public var description: String {
    var result = ""

    result += self.describeArguments(args: self.args, defaults: self.defaults)

    switch self.vararg {
    case .none: break
    case .unnamed: result += "* "
    case .named(let arg): result += "*" + describe(arg) + " "
    }

    result += self.describeArguments(args: self.kwOnlyArgs, defaults: self.kwOnlyDefaults)

    switch self.kwarg {
    case .none: break
    case .some(let arg): result += "**" + describe(arg)
    }

    if result.last == " " {
      result = String(result.dropLast())
    }

    return "(" + result + ")"
  }

  public var debugDescription: String {
    var result = ""
    result += "args: \(self.args), "
    result += "defaults: \(self.defaults), "
    result += "vararg: \(self.vararg), "
    result += "kwOnlyArgs: \(self.kwOnlyArgs), "
    result += "kwOnlyDefaults: \(self.kwOnlyDefaults), "
    result += "kwarg: \(self.kwarg), "
    result += "start: \(self.start), "
    result += "end: \(self.end))"

    return "Arguments(\(result))"
  }

  private func describeArguments(args: [Arg],
                                 defaults: [Expression]) -> String {
    assert(defaults.count <= args.count)

    if args.isEmpty {
      return ""
    }

    let defaultsStart = args.count - defaults.count

    // args: (a (b=1) (c:Int) (c:Int=1))
    var result = [String]()
    for (index, arg) in args.enumerated() {
      let defaultIndex = index - defaultsStart
      let defaultValue = defaultIndex < 0 ? nil : defaults[defaultIndex]

      switch (arg.annotation, defaultValue) {
      case (.none, .none): // a
        result.append(arg.name)
      case let (.some(ann), .none): // a:Int
        result.append("\(arg.name):\(describe(ann))")
      case let (.none, .some(def)): // a=5
        result.append("\(arg.name)=\(describe(def))")
      case let (.some(ann), .some(def)): // a:Int=1
        result.append("\(arg.name):\(describe(ann)) = \(describe(def))")
      }
    }
    return join(result) + " "
  }
}

extension Arg: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    switch self.annotation {
    case .none: return self.name
    case .some(let ann): return "(\(self.name):\(ann))"
    }
  }

  public var debugDescription: String {
    var result = ""
    result += "name: \(self.name), "
    result += self.annotation.map { "annotation: \($0), " } ?? ""
    result += "start: \(self.start), "
    result += "end: \(self.end)"
    return "Arg(\(result)"
  }
}

extension Vararg: CustomStringConvertible {
  public var description: String {
    switch self {
    case .none:    return "none"
    case .unnamed: return "unnamed"
    case .named(let value): return "named(\(value))"
    }
  }
}

extension Keyword: CustomStringConvertible {
  public var description: String {
    let name = self.name ?? "**"
    return "\(name)=\(self.value)"
  }
}
