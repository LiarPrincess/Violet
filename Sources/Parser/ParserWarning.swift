import Core

public enum ParserWarning: Warning {

  /// Something like `f(a for b in [])`.
  /// Basic support is implemented, but it may not work correctly.
  /// - Note:
  /// If there are other arguments present we should require parens!
  case callWithGeneratorArgument
}
