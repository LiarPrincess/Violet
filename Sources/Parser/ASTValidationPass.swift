import Foundation
import Core
import Lexer

// swiftlint:disable function_body_length
// swiftlint:disable cyclomatic_complexity
// swiftlint:disable file_length

public class ASTValidationPass: ASTPass {

  public typealias PassResult = Void

  public func visit(_ ast: AST) throws {
    switch ast {
    case let .single(value):
      break

    case let .fileInput(value):
      break

    case let .expression(expr):
      break

    }
  }

  private func visit(_ stmt: Statement) throws {
  }

  private func visit(_ stmt: StatementKind) throws {
    switch stmt {
    case let .functionDef(name, args, body, decoratorList, returns):
      break

    case let .asyncFunctionDef(name, args, body, decoratorList, returns):
      break

    case let .classDef(name, bases, keywords, body, decoratorList):
      break

    case let .return(value):
      break

    case let .delete(value):
      break

    case let .assign(targets, value):
      break

    case let .augAssign(target, op, value):
      break

    case let .annAssign(target, annotation, value, simple):
      break

    case let .for(target, iter, body, orElse):
      break

    case let .asyncFor(target, iter, body, orElse):
      break

    case let .while(test, body, orElse):
      break

    case let .if(test, body, orElse):
      break

    case let .with(items, body):
      break

    case let .asyncWith(items, body):
      break

    case let .raise(exc, cause):
      break

    case let .try(body, handlers, orElse, finalBody):
      break

    case let .assert(test, msg):
      break

    case let .import(value):
      break

    case let .importFrom(moduleName, names, level):
      break

    case let .global(value):
      break

    case let .nonlocal(value):
      break

    case let .expr(expr):
      break

    case .pass:
      break

    case .break:
      break

    case .continue:
      break

    }
  }

  private func visit(_ alias: Alias) throws {
  }

  private func visit(_ item: WithItem) throws {
  }

  private func visit(_ handler: ExceptHandler) throws {
  }

  private func visit(_ expr: Expression) throws {
  }

  private func visit(_ expr: ExpressionKind) throws {
    switch expr {
    case .true:
      break

    case .false:
      break

    case .none:
      break

    case .ellipsis:
      break

    case let .identifier(value):
      break

    case let .string(group):
      break

    case let .int(value):
      break

    case let .float(value):
      break

    case let .complex(real, imag):
      break

    case let .bytes(value):
      break

    case let .unaryOp(op, right):
      break

    case let .binaryOp(op, left, right):
      break

    case let .boolOp(op, left, right):
      break

    case let .compare(left, elements):
      break

    case let .tuple(value):
      break

    case let .list(value):
      break

    case let .dictionary(value):
      break

    case let .set(value):
      break

    case let .listComprehension(elt, generators):
      break

    case let .setComprehension(elt, generators):
      break

    case let .dictionaryComprehension(key, value, generators):
      break

    case let .generatorExp(elt, generators):
      break

    case let .await(expr):
      break

    case let .yield(value):
      break

    case let .yieldFrom(expr):
      break

    case let .lambda(args, body):
      break

    case let .call(`func`, args, keywords):
      break

    case let .ifExpression(test, body, orElse):
      break

    case let .attribute(expr, name):
      break

    case let .subscript(expr, slice):
      break

    case let .starred(expr):
      break

    }
  }

  private func visit(_ op: UnaryOperator) throws {
    switch op {
    case .invert:
      break

    case .not:
      break

    case .plus:
      break

    case .minus:
      break

    }
  }

  private func visit(_ op: BooleanOperator) throws {
    switch op {
    case .and:
      break

    case .or:
      break

    }
  }

  private func visit(_ op: BinaryOperator) throws {
    switch op {
    case .add:
      break

    case .sub:
      break

    case .mul:
      break

    case .matMul:
      break

    case .div:
      break

    case .modulo:
      break

    case .pow:
      break

    case .leftShift:
      break

    case .rightShift:
      break

    case .bitOr:
      break

    case .bitXor:
      break

    case .bitAnd:
      break

    case .floorDiv:
      break

    }
  }

  private func visit(_ stmt: ComparisonElement) throws {
  }

  private func visit(_ op: ComparisonOperator) throws {
    switch op {
    case .equal:
      break

    case .notEqual:
      break

    case .less:
      break

    case .lessEqual:
      break

    case .greater:
      break

    case .greaterEqual:
      break

    case .is:
      break

    case .isNot:
      break

    case .in:
      break

    case .notIn:
      break

    }
  }

  private func visit(_ element: DictionaryElement) throws {
    switch element {
    case let .unpacking(expr):
      break

    case let .keyValue(key, value):
      break

    }
  }

  private func visit(_ group: StringGroup) throws {
    switch group {
    case let .string(value):
      break

    case let .formattedValue(expr, conversion, spec):
      break

    case let .joinedString(value):
      break

    }
  }

  private func visit(_ flag: ConversionFlag) throws {
    switch flag {
    case .str:
      break

    case .ascii:
      break

    case .repr:
      break

    }
  }

  private func visit(_ slice: Slice) throws {
  }

  private func visit(_ slice: SliceKind) throws {
    switch slice {
    case let .slice(lower, upper, step):
      break

    case let .extSlice(dims):
      break

    case let .index(expr):
      break

    }
  }

  private func visit(_ comprehension: Comprehension) throws {
  }

  private func visit(_ args: Arguments) throws {
  }

  private func visit(_ arg: Arg) throws {
  }

  private func visit(_ arg: Vararg) throws {
    switch arg {
    case .none:
      break

    case .unnamed:
      break

    case let .named(arg):
      break

    }
  }

  private func visit(_ keyword: Keyword) throws {
  }

}
