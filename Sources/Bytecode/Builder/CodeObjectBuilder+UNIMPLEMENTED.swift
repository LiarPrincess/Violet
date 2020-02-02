extension CodeObjectBuilder {

  // MARK: - Class

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

  // MARK: - Collections

  /// Append a `setAdd` instruction to this code object.
  public func appendSetAdd(value: Any) {
    // self.append(.setAdd)
    self.unimplemented()
  }

  /// Append a `listAppend` instruction to this code object.
  public func appendListAppend(value: Any) {
    // self.append(.listAppend)
    self.unimplemented()
  }

  /// Append a `mapAdd` instruction to this code object.
  public func appendMapAdd(value: Any) {
    // self.append(.mapAdd)
    self.unimplemented()
  }

  /// Implements assignment with a starred target.
  ///
  /// Unpacks an iterable in TOS into individual values, where the total number
  /// of values can be smaller than the number of items in the iterable:
  /// one of the new values will be a list of all leftover items.
  ///
  /// The low byte of counts is the number of values before the list value,
  /// the high byte of counts the number of values after it.
  /// The resulting values are put onto the stack right-to-left.
  public func appendUnpackEx(countBefore: Int, countAfter: Int) {
    precondition(countBefore <= 0xff)
    precondition(countAfter  <= 0xffff_ff)

    //    let rawValue = countAfter << 8 | countBefore
    self.unimplemented()
  }

  // MARK: - General

  /// Append an `extendedArg` instruction to this code object.
  public func appendExtendedArg(value: UInt8) {
    // self.append(.extendedArg)
    self.unimplemented()
  }

  /// Append a `loadClosure` instruction to this code object.
  public func appendLoadClosure(_ variable: ClosureVariable) {
    // self.append(.loadClosure)
    //    if let i = codeObject.cellVars.firstIndex(of: name) {
    //      index = .cell(name)
    //    } else {
    //      assert(false)
    //    }
    //    switch index {
    //    case let .cell(i):
    //      // index = i
    //      break
    //    case let .free(i):
    //      let offset = self.cellVars.count
    //      // index = offset + i
    //      break
    //    }
    self.unimplemented()
  }

  // MARK: - Store+Load+Delete

  /// Append a `loadDeref` instruction to this code object.
  public func appendLoadDeref<S: ConstantString>(_ name: S) {
    // self.append(.loadDeref)
    self.unimplemented()
  }

  /// Append a `loadClassDeref` instruction to this code object.
  public func appendLoadClassDeref<S: ConstantString>(_ name: S) {
    // self.append(.loadClassDeref)
    self.unimplemented()
  }

  /// Append a `storeDeref` instruction to this code object.
  public func appendStoreDeref<S: ConstantString>(_ name: S) {
    // self.append(.storeDeref)
    self.unimplemented()
  }

  /// Append a `deleteDeref` instruction to this code object.
  public func appendDeleteDeref<S: ConstantString>(_ name: S) {
    // self.append(.deleteDeref)
    self.unimplemented()
  }

  private func unimplemented(fn: StaticString = #function) -> Never {
    fatalError("[CodeObjectBuilder] '\(fn)' is currently not implemented.")
  }
}
