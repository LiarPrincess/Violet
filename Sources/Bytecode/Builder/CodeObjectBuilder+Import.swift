import Core

extension CodeObjectBuilder {

  /// Append an `importName` instruction to this code object.
  public func appendImportName(name: String) throws {
    let arg = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.importName(nameIndex: arg))
  }

  /// Append an `importStar` instruction to this code object.
  public func appendImportStar() throws {
    try self.append(.importStar)
  }

  /// Append an `importFrom` instruction to this code object.
  public func appendImportFrom(name: String) throws {
    let arg = try self.addNameWithExtendedArgIfNeeded(name: name)
    try self.append(.importFrom(nameIndex: arg))
  }
}
