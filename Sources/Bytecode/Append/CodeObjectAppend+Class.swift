import Core

extension CodeObject {

  /// Append a `loadBuildClass` instruction to code object.
  public func appendLoadBuildClass(at location: SourceLocation) throws {
    try self.append(.loadBuildClass, at: location)
  }

  /// Append a `loadMethod` instruction to code object.
  public func appendLoadMethod(name: String,
                               at location: SourceLocation) throws {
    // ADDOP_NAME(c, LOAD_METHOD, meth->v.Attribute.attr, names);
    // try self.append(.loadMethod, at: location)
    throw self.unimplemented()
  }

  /// Append a `callMethod` instruction to code object.
  public func appendCallMethod(argumentCount: Int,
                               at location: SourceLocation) throws {
    // ADDOP_I(c, CALL_METHOD, asdl_seq_LEN(e->v.Call.args));
    // try self.append(.callMethod, at: location)
    throw self.unimplemented()
  }
}
