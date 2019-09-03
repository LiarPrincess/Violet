// TODO: Rename to SliceArg
public enum BuildSliceType {
  case lowerUpper
  case lowerUpperStep
}

public enum RaiseArg {
  /// Re-raise previous exception.
  /// CPython 0.
  case reRaise
  /// Raise exception instance or type at TOS
  /// CPython 1.
  case exceptionOnly
  /// Raise exception instance or type at TOS1 with Cause set to TOS
  /// CPython 2.
  case exceptionAndCause
}
