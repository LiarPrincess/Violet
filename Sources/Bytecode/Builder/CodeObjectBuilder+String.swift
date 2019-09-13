import Core

extension CodeObjectBuilder {

  /// Append a `formatValue` instruction to this code object.
  public func appendFormatValue(conversion: StringConversion,
                                hasFormat:  Bool) throws {
    try self.append(.formatValue(conversion: conversion, hasFormat: hasFormat))
  }

  /// Append a `buildString` instruction to this code object.
  public func appendBuildString(count: Int) throws {
    let arg = try self.appendExtendedArgIfNeeded(count)
    try self.append(.buildString(arg))
  }
}
