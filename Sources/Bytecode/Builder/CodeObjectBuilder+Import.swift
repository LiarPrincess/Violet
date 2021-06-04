import VioletCore

extension CodeObjectBuilder {

  /// Append an `importName` instruction to this code object.
  public func appendImportName(name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.importName(nameIndex: arg))
  }

  /// Append an `importStar` instruction to this code object.
  public func appendImportStar() {
    self.append(.importStar)
  }

  /// Append an `importFrom` instruction to this code object.
  public func appendImportFrom(name: String) {
    let arg = self.appendExtendedArgsForNameIndex(name: name)
    self.append(.importFrom(nameIndex: arg))
  }
}
