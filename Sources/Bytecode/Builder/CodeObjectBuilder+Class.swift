import VioletCore

extension CodeObjectBuilder {

  /// Append a `loadBuildClass` instruction to this code object.
  public func appendLoadBuildClass() {
    self.append(.loadBuildClass)
  }
}
