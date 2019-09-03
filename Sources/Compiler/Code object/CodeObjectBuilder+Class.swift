import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `loadBuildClass` instruction to currently filled code object.
  public func emitLoadBuildClass(location: SourceLocation) throws {
    try self.emit(.loadBuildClass, location: location)
  }

  /// Append a `loadMethod` instruction to currently filled code object.
  public func emitLoadMethod(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.loadMethod, location: location)
    throw self.unimplemented()
  }

  /// Append a `callMethod` instruction to currently filled code object.
  public func emitCallMethod(argumentCount: UInt8, location: SourceLocation) throws {
    // try self.emit(.callMethod, location: location)
    throw self.unimplemented()
  }
}
