import Foundation
import Core
import Lexer

// Note that you should probably use 'Rapunzel' ('dump()' method)
// instead of 'description'.

// MARK: - Helpers

private func join<S: Sequence>(_ arr: S, _ separator: String = " ") -> String {
  return arr.map { describe($0) }.joined(separator: separator)
}

private func describe<T>(_ value: T) -> String {
  return String(describing: value)
}

private func prefix(_ s: String, length: Int = 5) -> String {
  return s.count > length ? s.prefix(length) + "..." : s
}

// MARK: - Statement

extension Statement: CustomStringConvertible, CustomDebugStringConvertible {
  public var description: String {
    return describe(self.kind)
  }

  public var debugDescription: String {
    return "Statement(\(self.kind), start: \(self.start), end: \(self.end))"
  }
}

// MARK: - StatementKind

extension StatementKind: CustomStringConvertible {

  public var description: String {
    switch self {

    case let .functionDef(name, args, body, decorators, returns):
      return self.functionDef(header: "def",
                              name: name,
                              args: args,
                              body: body,
                              decorators: decorators,
                              returns: returns)
    case let .asyncFunctionDef(name, args, body, decorators, returns):
      return self.functionDef(header: "asyncDef",
                              name: name,
                              args: args,
                              body: body,
                              decorators: decorators,
                              returns: returns)

    case let .classDef(name, bases, keywords, body, decorators):
      var parents = ""
      switch (bases.isEmpty, keywords.isEmpty) {
      case (true, true): break
      case (false, true):  parents = " (" + join(bases) + ")"
      case (true, false):  parents = " (" + join(keywords) + ")"
      case (false, false): parents = " (" + join(bases) + " " + join(keywords) + ")"
      }

      let d = self.decorators(from: decorators)
      return "(class \(name)\(parents)\(d) body: \(join(body)))"

    case let .return(value):
      switch value {
      case .none: return "return"
      case .some(let v): return "(return \(describe(v)))"
      }

    case let .delete(v):
      return "(del \(join(v)))"

    case let .assign(targets, value):
      let t = join(targets, " = ")
      return "(\(t) = \(value))"

    case let .annAssign(target, annotation, value, _):
      let v = value.map { " = " + describe($0) } ?? ""
      return "(\(target):\(annotation)\(v))"

    case let .augAssign(target: target, op: op, value: value):
      return "(\(target) \(op)= \(value))"

    case let .for(target, iter, body, orElse):
      return self.forDescription(header: "for",
                                 target: target,
                                 iter: iter,
                                 body: body,
                                 orElse: orElse)
    case let .asyncFor(target, iter, body, orElse):
      return self.forDescription(header: "asyncFor",
                                 target: target,
                                 iter: iter,
                                 body: body,
                                 orElse: orElse)

    case let .while(test, body, orElse):
      var b: String?
      switch body.count {
      case 0: b = "()"
      case 1: b = "do: " + describe(body[0])
      default: b = "do: (\(join(body)))"
      }

      var e: String?
      switch orElse.count {
      case 0: e = ""
      case 1: e = " else: \(orElse[0])"
      default: e = " else: (\(join(body)))"
      }

      return "(while \(test) \(b ?? "")\(e ?? ""))"

    case let .if(test, body, orElse):
      var b: String?
      switch body.count {
      case 0: b = "()"
      case 1: b = describe(body[0])
      default: b = "(\(join(body))"
      }

      var e: String?
      switch orElse.count {
      case 0: e = ""
      case 1: e = " else: \(orElse[0])"
      default: e = " else: (\(join(body))"
      }

      return "(if \(test) then: \(b ?? "")\(e ?? ""))"

    case let .with(items, body):
      return "(with \(join(items)) do: \(join(body)))"
    case let .asyncWith(items, body):
      return "(asyncWith \(join(items)) do: \(join(body)))"

    case let .try(body, handlers, orElse, finalBody):
      let h = handlers.isEmpty  ? "" : " " + join(handlers)
      let o = orElse.isEmpty    ? "" : " else: \(join(orElse))"
      let f = finalBody.isEmpty ? "" : " finally: \(join(finalBody))"
      return "(try \(join(body))\(h)\(o)\(f))"

    case let .raise(exc, cause):
      let e = exc.map { " " + describe($0) } ?? ""
      let c = cause.map { " from: " + describe($0) } ?? ""
      return "(raise\(e)\(c))"

    case let .import(names):
      return "(import \(join(names)))"
    case let .importFrom(module, names, level):
      let d = level == 0 ? "" : String(repeating: ".", count: Int(level))
      let m = module.map(describe) ?? ""
      return "(from \(d)\(m) import: \(join(names)))"
    case let .importFromStar(module, level):
      let d = level == 0 ? "" : String(repeating: ".", count: Int(level))
      let m = module.map(describe) ?? ""
      return "(from \(d)\(m) import: *)"

    case let .global(v):
      return "(global \(join(v)))"
    case let .nonlocal(v):
      return "(nonlocal \(join(v)))"

    case let .assert(test, msg):
      let m = msg.map { " msg: " + describe($0) } ?? ""
      return "(assert \(test)\(m))"

    case let .expr(e):
      return describe(e)

    case .pass:
      return "(pass)"
    case .break:
      return "(break)"
    case .continue:
      return "(continue)"
    }
  }

  // MARK: Helpers

  // swiftlint:disable:next function_parameter_count
  private func functionDef(header: String,
                           name: String,
                           args: Arguments,
                           body: NonEmptyArray<Statement>,
                           decorators: [Expression],
                           returns: Expression?) -> String {
    let r = returns.map { " -> " + describe($0) } ?? ""
    let d = self.decorators(from: decorators)
    return "(\(header) \(name)\(args)\(r)\(d) do: \(join(body)))"
  }

  private func forDescription(header: String,
                              target: Expression,
                              iter: Expression,
                              body: NonEmptyArray<Statement>,
                              orElse: [Statement]) -> String {
    var b: String?
    switch body.count {
    case 0: b = "()"
    case 1: b = describe(body[0])
    default: b = "(\(join(body)))"
    }

    var e: String?
    switch orElse.count {
    case 0: e = ""
    case 1: e = " else: \(orElse[0])"
    default: e = " else: (\(join(body)))"
    }

    return "(\(header) \(target) in: \(iter) do: \(b ?? "")\(e ?? ""))"
  }

  private func decorators(from decorators: [Expression]) -> String {
    return decorators.isEmpty ? "" :
      " decorators: " + join(decorators.map { "@" + describe($0) })
  }
}

// MARK: - Alias

extension Alias: CustomStringConvertible {
  public var description: String {
    switch self.asName {
    case .none:
      return name
    case let .some(alias):
      return "(\(name) as: \(alias))"
    }
  }
}

// MARK: - WithItem

extension WithItem: CustomStringConvertible {
  public var description: String {
    switch self.optionalVars {
    case .none:
      return describe(self.contextExpr)
    case .some(let opt):
      return "(\(self.contextExpr) as: \(opt))"
    }
  }
}

// MARK: - ExceptHandler

extension ExceptHandler: CustomStringConvertible {
  public var description: String {
    let b = self.body.isEmpty ? "" : " do: \(join(self.body))"

    switch self.kind {
    case let .typed(type: type, asName: asName):
      let n = asName.map { " as: \($0)" } ?? ""
      return "(except \(describe(type))\(n)\(b))"
    case .default:
      return "(except\(b))"
    }
  }
}
