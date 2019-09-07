import Core

extension CodeObject {

  /// Append a `formatValue` instruction to code object.
  public func appendFormatValue(conversion: StringConversion,
                                hasFormat:  Bool,
                                at location: SourceLocation) throws {
    // try self.append(.formatValue, at: location)
    throw self.unimplemented()
  }

  /// Append a `buildString` instruction to code object.
  public func appendBuildString(count: UInt8, at location: SourceLocation) throws {
    // try self.append(.buildString, at: location)
    throw self.unimplemented()
  }
}
