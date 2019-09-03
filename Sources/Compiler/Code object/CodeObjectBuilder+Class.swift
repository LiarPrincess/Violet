import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `loadBuildClass` instruction to code object.
  public func emitLoadBuildClass(location: SourceLocation) throws {
    try self.emit(.loadBuildClass, location: location)
  }

  /// Append a `loadMethod` instruction to code object.
  public func emitLoadMethod(name: String,
                             location: SourceLocation) throws {
    // ADDOP_NAME(c, LOAD_METHOD, meth->v.Attribute.attr, names);
    // try self.emit(.loadMethod, location: location)
    throw self.unimplemented()
  }

  /// Append a `callMethod` instruction to code object.
  public func emitCallMethod(argumentCount: Int,
                             location: SourceLocation) throws {
    // ADDOP_I(c, CALL_METHOD, asdl_seq_LEN(e->v.Call.args));
    // try self.emit(.callMethod, location: location)
    throw self.unimplemented()
  }
}
