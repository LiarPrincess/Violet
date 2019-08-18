import Core

internal enum LexerWarning: Warning {

  /// Changed in version 3.6:
  /// Unrecognized escape sequences produce a DeprecationWarning.
  /// In some future version of Python they will be a SyntaxError.
  case unrecognizedEscapeSequence
}
