import VioletCore

extension CodeObjectBuilder {

  /// Append a `formatValue` instruction to this code object.
  public func appendFormatValue(conversion: Instruction.StringConversion,
                                hasFormat: Bool) {
    self.append(.formatValue(conversion: conversion, hasFormat: hasFormat))
  }

  /// Append a `buildString` instruction to this code object.
  public func appendBuildString(count: Int) {
    let arg = self.appendExtendedArgIfNeeded(count)
    self.append(.buildString(elementCount: arg))
  }
}
