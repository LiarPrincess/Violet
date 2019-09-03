import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append an `importStar` instruction to code object.
  public func emitImportStar(location: SourceLocation) throws {
    try self.emit(.importStar, location: location)
  }

  /// Append an `importName` instruction to code object.
  public func emitImportName(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.importName, location: location)
    throw self.unimplemented()
  }

  /// Append an `importFrom` instruction to code object.
  public func emitImportFrom(nameIndex: UInt8, location: SourceLocation) throws {
    // try self.emit(.importFrom, location: location)
    throw self.unimplemented()
  }
}
