// TODO: (ParserWarning) We have warnings, but we don't do anything with them.
public enum ParserWarning {

  /// Something like `f(a for b in [])`.
  /// Basic support is implemented, but it may not work correctly.
  /// - Note:
  /// If there are other arguments present we should require parens!
  case callWithGeneratorArgument
}
