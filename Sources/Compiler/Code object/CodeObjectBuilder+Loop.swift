import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  // MARK: - Loops

  /// Append a `setupLoop` instruction to code object.
  public func emitSetupLoop(loopEnd: Label, location: SourceLocation) throws {
    // try self.emit(.setupLoop, location: location)
    throw self.unimplemented()
  }

  /// Append a `getIter` instruction to code object.
  public func emitGetIter(location: SourceLocation) throws {
    try self.emit(.getIter, location: location)
  }

  /// Append a `forIter` instruction to code object.
  public func emitForIter(ifEmpty: Label, location: SourceLocation) throws {
    // try self.emit(.forIter, location: location)
    throw self.unimplemented()
  }

  /// Append a `getYieldFromIter` instruction to code object.
  public func emitGetYieldFromIter(location: SourceLocation) throws {
    try self.emit(.getYieldFromIter, location: location)
  }

  // MARK: - Continue, break

  /// Append a `continueLoop` instruction to code object.
  public func emitContinue(value: Target, location: SourceLocation) throws {
    // try self.emit(.continueLoop, location: location)
    throw self.unimplemented()
  }

  /// Append a `breakLoop` instruction to code object.
  public func emitBreak(location: SourceLocation) throws {
    try self.emit(.break, location: location)
  }
}
