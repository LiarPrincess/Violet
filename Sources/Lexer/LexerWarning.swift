// TODO: (LexerWarning) We have warnings, but we don't do anything with them.
internal enum LexerWarning {

  /// Changed in version 3.6:
  /// Unrecognized escape sequences produce a DeprecationWarning.
  /// In some future version of Python they will be a SyntaxError.
  case unrecognizedEscapeSequence
}
