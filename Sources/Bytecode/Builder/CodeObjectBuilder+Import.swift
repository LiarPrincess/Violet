import Core

extension CodeObjectBuilder {

  /// Append an `importName` instruction to this code object.
  public func appendImportName(name: String, at location: SourceLocation) throws {
    let arg = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.importName(nameIndex: arg), at: location)
  }

  /// Append an `importStar` instruction to this code object.
  public func appendImportStar(at location: SourceLocation) throws {
    try self.append(.importStar, at: location)
  }

  /// Append an `importFrom` instruction to this code object.
  public func appendImportFrom(name: String, at location: SourceLocation) throws {
    let arg = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.importFrom(nameIndex: arg), at: location)
  }
}
