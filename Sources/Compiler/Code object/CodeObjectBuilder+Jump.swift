import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `jumpAbsolute` instruction to currently filled code object.
  public func emitJumpAbsolute(labelIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.jumpAbsolute, location: location)
    throw self.unimplemented()
  }

  /// Append a `popJumpIfTrue` instruction to currently filled code object.
  public func emitPopJumpIfTrue(labelIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.popJumpIfTrue, location: location)
    throw self.unimplemented()
  }

  /// Append a `popJumpIfFalse` instruction to currently filled code object.
  public func emitPopJumpIfFalse(labelIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.popJumpIfFalse, location: location)
    throw self.unimplemented()
  }

  /// Append a `jumpIfTrueOrPop` instruction to currently filled code object.
  public func emitJumpIfTrueOrPop(labelIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.jumpIfTrueOrPop, location: location)
    throw self.unimplemented()
  }

  /// Append a `jumpIfFalseOrPop` instruction to currently filled code object.
  public func emitJumpIfFalseOrPop(labelIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.jumpIfFalseOrPop, location: location)
    throw self.unimplemented()
  }
}
