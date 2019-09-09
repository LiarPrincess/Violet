import Core

extension CodeObject {

  /// Append a `formatValue` instruction to this code object.
  public func appendFormatValue(conversion: StringConversion,
                                hasFormat:  Bool,
                                at location: SourceLocation) throws {
    try self.append(
      .formatValue(conversion: conversion, hasFormat: hasFormat),
      at: location
    )
  }

  /// Append a `buildString` instruction to this code object.
  public func appendBuildString(count: Int, at location: SourceLocation) throws {
    let arg = try self.appendExtendedArgIfNeeded(count, at: location)
    try self.append(.buildString(arg), at: location)
  }
}
