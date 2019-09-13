import Core

extension CodeObjectBuilder {

  /// Append a `loadBuildClass` instruction to this code object.
  public func appendLoadBuildClass() throws {
    try self.append(.loadBuildClass)
  }

  /// Append a `loadMethod` instruction to this code object.
  public func appendLoadMethod(name: String) throws {
    // ADDOP_NAME(c, LOAD_METHOD, meth->v.Attribute.attr, names);
    // try self.append(.loadMethod)
    throw self.unimplemented()
  }

  /// Append a `callMethod` instruction to this code object.
  public func appendCallMethod(argumentCount: Int) throws {
    // ADDOP_I(c, CALL_METHOD, asdl_seq_LEN(e->v.Call.args));
    // try self.append(.callMethod)
    throw self.unimplemented()
  }
}
