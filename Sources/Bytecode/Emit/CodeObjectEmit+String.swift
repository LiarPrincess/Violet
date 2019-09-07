import Core

extension CodeObject {

  /// Append a `formatValue` instruction to code object.
  public func emitFormatValue(conversion: StringConversion,
                              hasFormat:  Bool,
                              location: SourceLocation) throws {
    // try self.emit(.formatValue, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildString` instruction to code object.
  public func emitBuildString(count: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildString, location: location)
    throw self.unimplemented()
  }
}
