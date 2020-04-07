import Core

extension FString {
  /// Expressions in format specifiers are not currently supported.
  ///
  /// For example:
  /// ```c
  /// width = 10
  /// s = f"Let it {'go':>{width}}!"
  /// ```
  internal func trapExpressionInFormatSpecifier() -> Never {
    let msg = "Expressions in format specifiers " +
      "(for example: 'f\"Let it {'go':>{width}}!\"')" +
      "are not currently supported."
    trap(msg)
  }
}
