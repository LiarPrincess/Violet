import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append an `importName` instruction to code object.
  public func emitImportName(name: String, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name,
                                                        location: location)

    try self.emit(.importName(nameIndex: index), location: location)
  }

  /// Append an `importStar` instruction to code object.
  public func emitImportStar(location: SourceLocation) throws {
    try self.emit(.importStar, location: location)
  }

  /// Append an `importFrom` instruction to code object.
  public func emitImportFrom(name: String, location: SourceLocation) throws {
    // try self.emit(.importFrom, location: location)
    throw self.unimplemented()
  }
}
