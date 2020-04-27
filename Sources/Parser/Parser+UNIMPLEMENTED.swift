import VioletCore

// Technically this is an 'FString', but it belongs to 'Parser',
// thats why we have it in 'Parser+UNIMPLEMENTED.swift' file.
public enum FStringUnimplemented: CustomStringConvertible, Equatable {

  /// Expressions in format specifiers are not currently supported.
  ///
  /// For example:
  /// ```c
  /// width = 10
  /// s = f"Let it {'go':>{width}}!"
  /// ```
  /// In this example 'width' is an expression.
  case expressionInFStringFormatSpecifier

  public var description: String {
    switch self {
    case .expressionInFStringFormatSpecifier:
      return "Expressions in format specifiers " +
      "(for example 'width' in 'f\"Let it {'go':>{width}}!\"')" +
      "are not currently supported."
    }
  }
}
