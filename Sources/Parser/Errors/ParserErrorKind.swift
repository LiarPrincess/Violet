import VioletLexer

// swiftlint:disable line_length
// cSpell:ignore nonbytes

public enum ParserErrorKind: Equatable {

  // MARK: - Function/lambda definition

  /// Non-default argument follows default argument.
  case defaultAfterNonDefaultArgument
  /// Duplicate non-keyworded variable length argument (the one with '*').
  case duplicateVarargs
  /// Duplicate keyworded variable length argument (the one with '**').
  case duplicateKwargs
  /// Positional only separator after variable length argument (the one with '*').
  case posOnlyAfterVarargs
  /// Positional only separator after keyworded variable length argument (the one with '**').
  case posOnlyAfterKwargs
  /// Argument after keyworded variable length argument (the one with '**').
  case argsAfterKwargs
  /// Non-keyworded variable length argument (the one with '*') after
  /// keyworded variable length argument (the one with '**').
  case varargsAfterKwargs
  /// Named arguments must follow bare *.
  case starWithoutFollowingArguments
  /// More positional defaults than args on arguments.
  case moreDefaultsThanArgs
  /// Length of kwOnlyArgs is not the same as kwOnlyDefaults on arguments.
  case kwOnlyArgsCountNotEqualToDefaults

  // MARK: - Call

  /// Positional argument follows keyword argument.
  case callWithPositionalArgumentAfterKeywordArgument
  /// Positional argument follows keyword argument unpacking.
  case callWithPositionalArgumentAfterKeywordUnpacking
  /// Iterable argument unpacking (the one with '*') after
  /// keyword argument unpacking (the one with '**').
  case callWithIterableArgumentAfterKeywordUnpacking
  /// Lambda argument cannot contain assignment
  /// (for example: `f(lambda x: x[0] = 3)`).
  case callWithLambdaAssignment
  /// Keyword can't be an expression.
  case callWithKeywordExpression
  /// Keyword argument repeated.
  case callWithDuplicateKeywordArgument(String)
  /// Generator expression must be parenthesized (or be the only argument)
  case callWithGeneratorArgumentWithoutParens

  // MARK: - Atom

  /// Dict unpacking cannot be used in dict comprehension.
  /// `{ **a for b in [] }`
  case dictUnpackingInsideComprehension
  /// Cannot mix bytes and nonbytes literals.
  case mixBytesAndNonBytesLiterals
  // For example: "f-string: single '}' is not allowed"
  case fStringError(FStringError)

  // MARK: - Import

  /// Trailing comma not allowed without surrounding parentheses.
  /// `from a import b,`
  case fromImportWithTrailingComma

  // MARK: - Assignment

  /// Illegal target for annotation
  case illegalAnnAssignmentTarget
  /// AnnAssign with simple non-Name target
  case simpleAnnAssignmentWithNonNameTarget
  /// Only single target (not list) can be annotated.
  case annAssignmentWithListTarget
  /// Only single target (not tuple) can be annotated.
  case annAssignmentWithTupleTarget
  /// Illegal expression for augmented assignment.
  case illegalAugAssignmentTarget
  /// Assignment to yield expression not possible.
  case assignmentToYield

  // MARK: - Try/raise

  /// `Try` without `except` or `finally` is not allowed.
  case tryWithoutExceptOrFinally
  /// `Else` requires at least one `except`.
  case tryWithElseWithoutExcept
  /// `Raise` with cause but no exception.
  case raiseWithCauseWithoutException

  // MARK: - Func, class

  /// Base class definition cannot contain generator.
  case baseClassWithGenerator

  // MARK: - General

  /// "'xxx' cannot be used as an identifier."
  case forbiddenName(String)
  /// Unexpected end of file, expected: [expected].
  case unexpectedEOF(expected: [ExpectedToken])
  /// Unexpected 'tokenKind', expected: 'expected'.
  case unexpectedToken(Token.Kind, expected: [ExpectedToken])
  /// Expression must have 'expected' context but has 'Expression.context' instead
  case invalidContext(Expression, expected: ExpressionContext)
}

extension ParserErrorKind: CustomStringConvertible {
  public var description: String {
    switch self {

    case .defaultAfterNonDefaultArgument:
      return "Non-default argument follows default argument."
    case .duplicateVarargs:
      return "Duplicate non-keyworded variable length argument (the one with '*')."
    case .duplicateKwargs:
      return "Duplicate keyworded variable length argument (the one with '**')."
    case .posOnlyAfterVarargs:
      return "Positional only separator after variable length argument (the one with '*')"
    case .posOnlyAfterKwargs:
      return "Positional only separator after keyworded variable length argument (the one with '**')"
    case .argsAfterKwargs:
      return "Argument after keyworded variable length argument (the one with '**')."
    case .varargsAfterKwargs:
      return "Non-keyworded variable length argument (the one with '*') after " +
             "keyworded variable length argument (the one with '**')."
    case .starWithoutFollowingArguments:
      return "Named arguments must follow bare *."
    case .moreDefaultsThanArgs:
      return "More positional defaults than args on arguments."
    case .kwOnlyArgsCountNotEqualToDefaults:
      return "Length of kwOnlyArgs is not the same as kwOnlyDefaults on arguments."

    case .callWithPositionalArgumentAfterKeywordArgument:
      return "Positional argument follows keyword argument."
    case .callWithPositionalArgumentAfterKeywordUnpacking:
      return "Positional argument follows keyword argument unpacking."
    case .callWithIterableArgumentAfterKeywordUnpacking:
      return "Iterable argument unpacking (the one with '*') after " +
             "keyword argument unpacking (the one with '**')."
    case .callWithLambdaAssignment:
      return "Lambda argument cannot contain assignment."
    case .callWithKeywordExpression:
      return "Keyword can't be an expression."
    case .callWithDuplicateKeywordArgument(let name):
      return "Duplicate keyword argument '\(name)'."
    case .callWithGeneratorArgumentWithoutParens:
      return "Generator expression must be parenthesized"

    case .dictUnpackingInsideComprehension:
      return "Dictionary unpacking (the one with '**') " +
             "cannot be used in dictionary comprehension."
    case .mixBytesAndNonBytesLiterals:
      return "Cannot mix bytes and nonbytes literals."
    case .fStringError(let e):
      return "f-string: \(e)."

    case .fromImportWithTrailingComma:
      return "Trailing comma not allowed without surrounding parentheses."

    case .illegalAnnAssignmentTarget:
      return "Illegal target for annotation."
    case .simpleAnnAssignmentWithNonNameTarget:
      return "AnnAssign with simple non-Name target"
    case .annAssignmentWithListTarget:
      return "Only single target (not list) can be annotated."
    case .annAssignmentWithTupleTarget:
      return "Only single target (not tuple) can be annotated."
    case .illegalAugAssignmentTarget:
      return "Illegal expression for augmented assignment."
    case .assignmentToYield:
      return "Assignment to yield expression not possible."

    case .tryWithoutExceptOrFinally:
      return "'Try' without 'except' or 'finally' is not allowed."
    case .tryWithElseWithoutExcept:
      return "'Else' requires at least one 'except'."
    case .raiseWithCauseWithoutException:
      return "Raise with cause but no exception."

    case .baseClassWithGenerator:
      return "Base class definition cannot contain generator."

    case let .forbiddenName(name):
      return "'\(name)' cannot be used as an identifier."

    case let .unexpectedEOF(expected):
      switch expected.count {
      case 0:
        return "Unexpected end of file."
      default:
        let e = joinWithCommaAndOr(expected)
        return "Unexpected end of file, expected \(e)."
      }
    case let .unexpectedToken(tokenKind, expected):
      let token = needsQuotes(tokenKind) ?
        "'" + String(describing: tokenKind) + "'" :
        String(describing: tokenKind)

      switch expected.count {
      case 0:
        return "Unexpected \(token)."
      default:
        let e = joinWithCommaAndOr(expected)
        return "Unexpected \(token), expected \(e)."
      }
    case let .invalidContext(expr, expected):
      let real = expr.context
      return "Expression must have '\(expected)' context but has '\(real)' instead"
    }
  }
}

/// Comma between elements and 'or' before last one.
private func joinWithCommaAndOr<T>(_ elements: [T]) -> String {
  var result = String(describing: elements[0])

  for (index, element) in elements.dropFirst().enumerated() {
    let isLast = index == elements.count - 2 // -1 for count, -1 for dropFirst
    result += isLast ? " or " : ", "
    result += String(describing: element)
  }

  return result
}

private func needsQuotes(_ kind: Token.Kind) -> Bool {
  switch kind {
  case
    // atoms
    .identifier,
    .string,
    .formatString,
    .int,
    .float,
    .imaginary,
    .bytes,
    // whitespace
    .indent,
    .dedent,
    .newLine,
    // other
    .comment:
    return false

  default:
    return true
  }
}
