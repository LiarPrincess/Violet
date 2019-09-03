import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `formatValue` instruction to currently filled code object.
  public func emitFormatValue(flags: UInt8, location: SourceLocation) throws {
    // try self.emit(.formatValue, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildString` instruction to currently filled code object.
  public func emitBuildString(value: UInt8, location: SourceLocation) throws {
    // try self.emit(.buildString, location: location)
    throw self.unimplemented()
  }
}
