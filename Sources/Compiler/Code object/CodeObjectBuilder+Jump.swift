import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  // MARK: - Absolute

  /// Append a `jumpAbsolute` instruction to code object.
  public func emitJumpAbsolute(to label: Label,
                               location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.jumpAbsolute(labelIndex: index), location: location)
  }

  // MARK: - If

  /// Append a `popJumpIfTrue` instruction to code object.
  public func emitPopJumpIfTrue(to label: Label,
                                location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.popJumpIfTrue(labelIndex: index), location: location)
  }

  /// Append a `popJumpIfFalse` instruction to code object.
  public func emitPopJumpIfFalse(to label: Label,
                                 location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.popJumpIfFalse(labelIndex: index), location: location)
  }

  // MARK: - Pop

  /// Append a `jumpIfTrueOrPop` instruction to code object.
  public func emitJumpIfTrueOrPop(to label: Label,
                                  location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.jumpIfTrueOrPop(labelIndex: index), location: location)
  }

  /// Append a `jumpIfFalseOrPop` instruction to code object.
  public func emitJumpIfFalseOrPop(to label: Label,
                                   location: SourceLocation) throws {
    let index = try self.emitExtendedArgIfNeeded(label.index, location: location)
    try self.emit(.jumpIfFalseOrPop(labelIndex: index), location: location)
  }
}
