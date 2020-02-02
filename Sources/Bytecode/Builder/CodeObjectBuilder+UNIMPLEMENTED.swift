extension CodeObjectBuilder {

  // MARK: - Collections

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

  // MARK: - Helper

  private func unimplemented(fn: StaticString = #function) -> Never {
    fatalError("[CodeObjectBuilder] '\(fn)' is currently not implemented.")
  }
}
