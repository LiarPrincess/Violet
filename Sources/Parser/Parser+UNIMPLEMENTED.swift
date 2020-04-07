import Core

// Technically this is an 'FString', but it belongs to 'Parser',
// thats why we have it in 'Parser+UNIMPLEMENTED.swift' file.
extension FString {

  /// Expressions in format specifiers are not currently supported.
  ///
  /// For example:
  /// ```c
  /// width = 10
  /// s = f"Let it {'go':>{width}}!"
  /// ```
  /// In this example 'width' is an expression.
  internal func trapExpressionInFormatSpecifier() -> Never {
    let msg = "Expressions in format specifiers " +
      "(for example 'width' in 'f\"Let it {'go':>{width}}!\"')" +
      "are not currently supported."
    trap(msg)
  }
}
