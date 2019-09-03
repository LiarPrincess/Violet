import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `popExcept` instruction to code object.
  public func emitPopExcept(location: SourceLocation) throws {
    try self.emit(.popExcept, location: location)
  }

  /// Append an `endFinally` instruction to code object.
  public func emitEndFinally(location: SourceLocation) throws {
    try self.emit(.endFinally, location: location)
  }

  /// Append a `setupExcept` instruction to code object.
  public func emitSetupExcept(value: Delta, location: SourceLocation) throws {
    // try self.emit(.setupExcept, location: location)
    throw self.unimplemented()
  }

  /// Append a `setupFinally` instruction to code object.
  public func emitSetupFinally(value: Delta, location: SourceLocation) throws {
    // try self.emit(.setupFinally, location: location)
    throw self.unimplemented()
  }

  /// Append a `raiseVarargs` instruction to code object.
  public func emitRaiseVarargs(arg: RaiseArg, location: SourceLocation) throws {
    let argc = self.getArgumentCount(arg)
    try self.emit(.raiseVarargs(argc: argc), location: location)
  }

  private func getArgumentCount(_ type: RaiseArg) -> UInt8 {
    switch type {
    case .reRaise: return 0
    case .exceptionOnly: return 1
    case .exceptionAndCause: return 2
    }
  }
}
