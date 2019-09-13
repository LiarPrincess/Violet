import Core

extension CodeObjectBuilder {

  // MARK: - Absolute

  /// Append a `jumpAbsolute` instruction to this code object.
  public func appendJumpAbsolute(to label: Label,
                                 at location: SourceLocation) throws {
    let index = try self.addLabelWithExtendedArgIfNeeded(label, at: location)
    try self.append(.jumpAbsolute(labelIndex: index), at: location)
  }

  // MARK: - If

  /// Append a `popJumpIfTrue` instruction to this code object.
  public func appendPopJumpIfTrue(to label: Label,
                                  at location: SourceLocation) throws {
    let index = try self.addLabelWithExtendedArgIfNeeded(label, at: location)
    try self.append(.popJumpIfTrue(labelIndex: index), at: location)
  }

  /// Append a `popJumpIfFalse` instruction to this code object.
  public func appendPopJumpIfFalse(to label: Label,
                                   at location: SourceLocation) throws {
    let index = try self.addLabelWithExtendedArgIfNeeded(label, at: location)
    try self.append(.popJumpIfFalse(labelIndex: index), at: location)
  }

  // MARK: - Pop

  /// Append a `jumpIfTrueOrPop` instruction to this code object.
  public func appendJumpIfTrueOrPop(to label: Label,
                                    at location: SourceLocation) throws {
    let index = try self.addLabelWithExtendedArgIfNeeded(label, at: location)
    try self.append(.jumpIfTrueOrPop(labelIndex: index), at: location)
  }

  /// Append a `jumpIfFalseOrPop` instruction to this code object.
  public func appendJumpIfFalseOrPop(to label: Label,
                                     at location: SourceLocation) throws {
    let index = try self.addLabelWithExtendedArgIfNeeded(label, at: location)
    try self.append(.jumpIfFalseOrPop(labelIndex: index), at: location)
  }
}
