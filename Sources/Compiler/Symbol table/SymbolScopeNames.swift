/// Predefined scope names
internal enum SymbolScopeNames {

  /// Name of the AST root scope
  internal static let top = "top"
  /// Name of the lambda scope
  internal static let lambda = "lambda"

  /// Name of the list comprehension scope
  internal static let listcomp = "listcomp"
  /// Name of the set comprehension scope
  internal static let setcomp  = "setcomp"
  /// Name of the dict comprehension scope
  internal static let dictcomp = "dictcomp"
  /// Name of the generator expression scope
  internal static let genexpr  = "genexpr"
}
