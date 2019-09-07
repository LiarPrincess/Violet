import Core

extension CodeObject {

  /// Append an `importName` instruction to code object.
  public func appendImportName(name: String, at location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, at: location)
    try self.append(.importName(nameIndex: index), at: location)
  }

  /// Append an `importStar` instruction to code object.
  public func appendImportStar(at location: SourceLocation) throws {
    try self.append(.importStar, at: location)
  }

  /// Append an `importFrom` instruction to code object.
  public func appendImportFrom(name: String, at location: SourceLocation) throws {
    // try self.append(.importFrom, at: location)
    throw self.unimplemented()
  }
}
