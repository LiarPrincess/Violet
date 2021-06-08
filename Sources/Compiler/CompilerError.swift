import VioletCore

public struct CompilerError: Error, Equatable, CustomStringConvertible {

  /// Type of the error.
  public let kind: Kind

  /// Location of the error in the code.
  public let location: SourceLocation

  public var description: String {
    return "\(self.location): \(self.kind)"
  }

  public init(_ kind: Kind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }

  // MARK: - Kind

  public enum Kind: Equatable, CustomStringConvertible {

    // MARK: Symbol table

    /// Name 'value' is parameter and global
    case globalParam(String)
    /// Name 'value' is assigned to before global declaration
    case globalAfterAssign(String)
    /// Name 'value' is used prior to global declaration
    case globalAfterUse(String)
    /// Annotated name 'value' can't be global
    case globalAnnotated(String)

    /// Name 'value' is parameter and nonlocal
    case nonlocalParam(String)
    /// Name 'value' is assigned to before nonlocal declaration
    case nonlocalAfterAssign(String)
    /// Name 'value' is used prior to nonlocal declaration
    case nonlocalAfterUse(String)
    /// Annotated name 'value' can't be nonlocal
    case nonlocalAnnotated(String)
    /// 'nonlocal' declaration of 'value' not allowed at module level
    case nonlocalAtModuleLevel(String)
    /// No binding for nonlocal 'value' found
    case nonlocalWithoutBinding(String)

    /// Name 'value' is nonlocal and global
    case bothGlobalAndNonlocal(String)

    /// Duplicate argument 'value' in function definition
    case duplicateArgument(String)

    /// Import * only allowed at module level
    case nonModuleImportStar

    // MARK: Future

    /// `from __future__ import braces`
    case fromFutureImportBraces
    /// future feature 'value' is not defined
    case undefinedFutureFeature(String)
    /// `from __future__ imports` must occur at the beginning of the file
    case lateFuture

    // MARK: Compiler

    /// Two starred expressions in assignment
    case multipleStarredInAssignmentExpressions
    /// Too many expressions in star-unpacking assignment
    case tooManyExpressionsInStarUnpackingAssignment
    /// Starred assignment target must be in a list or tuple
    case starredAssignmentNotListOrTuple
    /// Invalid target for augmented assignment
    case invalidTargetForAugmentedAssignment
    /// Invalid target for annotated assignment
    case invalidTargetForAnnotatedAssignment

    /// Can't use starred expression here
    case invalidStarredExpression

    /// Extended slice invalid in nested slice
    case extendedSliceNestedInsideExtendedSlice

    /// 'return' outside function
    case returnOutsideFunction
    /// 'return' with value in async generator
    case returnWithValueInAsyncGenerator

    /// Unexpected import all
    case unexpectedStarImport

    /// 'break' outside loop
    case breakOutsideLoop
    /// 'continue' not properly in loop
    case continueOutsideLoop
    /// 'continue' not supported inside 'finally' clause
    case continueInsideFinally

    /// default 'except:' must be last
    case defaultExceptNotLast

    /// 'yield' outside function
    case yieldOutsideFunction
    /// 'yield from' inside async function
    case yieldFromInsideAsyncFunction
    /// 'await' outside function
    case awaitOutsideFunction
    /// 'await' outside async function
    case awaitOutsideAsyncFunction

    /// Given feature was not yet implemented.
    case unimplemented(CompilerUnimplemented)

    // MARK: Description

    public var description: String {
      switch self {

      case let .globalParam(name):
        return "Name '\(name)' is parameter and global"
      case let .globalAfterAssign(name):
        return "Name '\(name)' is assigned to before global declaration"
      case let .globalAfterUse(name):
        return "Name '\(name)' is used prior to global declaration"
      case let .globalAnnotated(name):
        return "Annotated name '\(name)' can't be global"

      case let .nonlocalParam(name):
        return "Name '\(name)' is parameter and nonlocal"
      case let .nonlocalAfterAssign(name):
        return "Name '\(name)' is assigned to before nonlocal declaration"
      case let .nonlocalAfterUse(name):
        return "Name '\(name)' is used prior to nonlocal declaration"
      case let .nonlocalAnnotated(name):
        return "Annotated name '\(name)' can't be nonlocal"
      case let .nonlocalAtModuleLevel(name):
        return "'nonlocal' declaration of '\(name)' not allowed at module level"
      case let .nonlocalWithoutBinding(name):
        return "No binding for nonlocal '\(name)' found"

      case .bothGlobalAndNonlocal(let name):
        return "Name '\(name)' is nonlocal and global"
      case .duplicateArgument(let name):
        return "Duplicate argument '\(name)' in function definition"
      case .nonModuleImportStar:
        return "Import * only allowed at module level"

      case .fromFutureImportBraces:
        // surprisingly appropriate:
        return """
        Let it go, let it go
        Can't hold it back anymore
        Let it go, let it go
        Turn away and slam the door!

        I don't care
        What they're going to say
        Let the storm rage on
        The cold never bothered me anyway!

        It's funny how some distance
        Makes everything seem small
        And the fears that once controlled me
        Can't get to me at all!

        It's time to see what I can do
        To test the limits and break through
        No right, no wrong, no rules for me I'm free!
        """
      case .undefinedFutureFeature(let name):
        return "future feature '\(name)' is not defined"
      case .lateFuture:
        return "`from __future__ imports` must occur at the beginning of the file"

      case .multipleStarredInAssignmentExpressions:
        return "Two starred expressions in assignment"
      case .tooManyExpressionsInStarUnpackingAssignment:
        return "Too many expressions in star-unpacking assignment"
      case .starredAssignmentNotListOrTuple:
        return "Starred assignment target must be in a list or tuple"
      case .invalidTargetForAugmentedAssignment:
        return "Invalid target for augmented assignment"
      case .invalidTargetForAnnotatedAssignment:
        return "Invalid target for annotated assignment"

      case .invalidStarredExpression:
        return "Can't use starred expression here"

      case .extendedSliceNestedInsideExtendedSlice:
        return "Extended slice invalid in nested slice"

      case .returnOutsideFunction:
        return "'return' outside function"
      case .returnWithValueInAsyncGenerator:
        return "'return' with value in async generator"

      case .unexpectedStarImport:
        return "Unexpected import all"

      case .breakOutsideLoop:
        return "'break' outside loop"
      case .continueOutsideLoop:
        return "'continue' not properly in loop"
      case .continueInsideFinally:
        return "'continue' not supported inside 'finally' clause"

      case .defaultExceptNotLast:
        return "default 'except:' must be last"

      case .yieldOutsideFunction:
        return "'yield' outside function"
      case .yieldFromInsideAsyncFunction:
        return "'yield from' inside async function"
      case .awaitOutsideFunction:
        return "'await' outside function"
      case .awaitOutsideAsyncFunction:
        return "'await' outside async function"

      case .unimplemented(let u):
        return "UNIMPLEMENTED IN VIOLET: " + String(describing: u)
      }
    }
  }
}
