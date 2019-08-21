import Core

// MARK: - Error

public struct CompilerError: Error, Equatable {

  /// Type of the error.
  public let kind: CompilerErrorKind

  /// Location of the error in the code.
  public let location: SourceLocation

  public init(_ kind: CompilerErrorKind,
              location: SourceLocation) {

    self.kind = kind
    self.location = location
  }
}

extension CompilerError: CustomStringConvertible {
  public var description: String {
    return "\(self.location): \(self.kind)"
  }
}

public enum ComprehensionKind: Equatable {
  case list
  case set
  case dictionary
  case generator

  internal var identifier: String {
    switch self {
    case .list: return SpecialIdentifiers.listcomp
    case .set: return SpecialIdentifiers.setcomp
    case .dictionary: return SpecialIdentifiers.dictcomp
    case .generator: return SpecialIdentifiers.genexpr
    }
  }
}

public enum CompilerErrorKind: Equatable {

  /// Name 'name' is parameter and global
  case globalParam(String)
  /// Name 'name' is assigned to before global declaration
  case globalAfterAssign(String)
  /// Name 'name' is used prior to global declaration
  case globalAfterUse(String)
  /// Annotated name 'name' can't be global
  case globalAnnot(String)

  /// Name 'name' is parameter and nonlocal
  case nonlocalParam(String)
  /// Name 'name' is assigned to before nonlocal declaration
  case nonlocalAfterAssign(String)
  /// Name 'name' is used prior to nonlocal declaration
  case nonlocalAfterUse(String)
  /// Annotated name 'name' can't be nonlocal
  case nonlocalAnnot(String)

  /// Duplicate argument 'name' in function definition
  case duplicateArgument(String)

  /// Import * only allowed at module level
  case nonModuleImportStar
}

// MARK: - Warning

public enum CompilerWarning: Warning {

  /// 'yield' inside 'kind' comprehension
  ///
  /// Due to their side effects on the containing scope, yield expressions
  /// are not permitted as part of the implicitly defined scopes used
  /// to implement comprehensions and generator expressions.
  ///
  /// See:
  /// - [docs](https://docs.python.org/3/reference/expressions.html#yield-expressions)
  /// - [bug report](https://bugs.python.org/issue10544)
  case yieldInsideComprehension(ComprehensionKind)
}
