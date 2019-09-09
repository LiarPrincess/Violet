import Core

// MARK: - Error

public struct CompilerError: Error, Equatable {

  /// Type of the error.
  public let kind: CompilerErrorKind

  /// Location of the error in the code.
  public let location: SourceLocation

  public init(_ kind: CompilerErrorKind, location: SourceLocation) {
    self.kind = kind
    self.location = location
  }
}

extension CompilerError: CustomStringConvertible {
  public var description: String {
    return "\(self.location): \(self.kind)"
  }
}

// MARK: - Kind

public enum CompilerErrorKind: Equatable {

  // MARK: Symbol table

  /// Name 'value' is parameter and global
  case globalParam(String)
  /// Name 'value' is assigned to before global declaration
  case globalAfterAssign(String)
  /// Name 'value' is used prior to global declaration
  case globalAfterUse(String)
  /// Annotated name 'value' can't be global
  case globalAnnot(String)

  /// Name 'value' is parameter and nonlocal
  case nonlocalParam(String)
  /// Name 'value' is assigned to before nonlocal declaration
  case nonlocalAfterAssign(String)
  /// Name 'value' is used prior to nonlocal declaration
  case nonlocalAfterUse(String)
  /// Annotated name 'value' can't be nonlocal
  case nonlocalAnnot(String)
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

  // MARK: - Compiler

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
}

// TODO: surprisingly appropriate; `fromFutureImportBraces`
private let letItGo = """
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
