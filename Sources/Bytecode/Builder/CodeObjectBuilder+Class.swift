import Core

extension CodeObjectBuilder {

  /// Append a `loadBuildClass` instruction to this code object.
  public func appendLoadBuildClass() {
    self.append(.loadBuildClass)
  }

  /// Append a `loadMethod` instruction to this code object.
  public func appendLoadMethod(name: String) {
    // ADDOP_NAME(c, LOAD_METHOD, meth->v.Attribute.attr, names);
    // self.append(.loadMethod)
    self.unimplemented()
  }

  /// Append a `callMethod` instruction to this code object.
  public func appendCallMethod(argumentCount: Int) {
    // ADDOP_I(c, CALL_METHOD, asdl_seq_LEN(e->v.Call.args));
    // self.append(.callMethod)
    self.unimplemented()
  }
}
