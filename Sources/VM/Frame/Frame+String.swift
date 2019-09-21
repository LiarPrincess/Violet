import Bytecode

extension Frame {

  /// Used for implementing formatted literal strings (f-strings).
  /// (And yes, Swift will pack both payloads in single byte).
  internal func formatValue(conversion: StringConversion, hasFormat: Bool) throws {
    self.unimplemented()
  }

  /// Concatenates `count` strings from the stack
  /// and pushes the resulting string onto the stack.
  internal func buildString(value: Int) throws {
    self.unimplemented()
  }
}
