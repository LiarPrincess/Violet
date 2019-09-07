import Core

public enum ClosureVariable {
  /// Captured variable
  case cell(MangledName)
  /// Closure over 'name'
  case free(MangledName)
}

extension CodeObject {

  /// Append a `nop` instruction to code object.
  public func appendNop(at location: SourceLocation) throws {
    try self.append(.nop, at: location)
  }

  /// Append a `popTop` instruction to code object.
  public func appendPopTop(at location: SourceLocation) throws {
    try self.append(.popTop, at: location)
  }

  /// Append a `rotTwo` instruction to code object.
  public func appendRotTwo(at location: SourceLocation) throws {
    try self.append(.rotTwo, at: location)
  }

  /// Append a `rotThree` instruction to code object.
  public func appendRotThree(at location: SourceLocation) throws {
    try self.append(.rotThree, at: location)
  }

  /// Append a `dupTop` instruction to code object.
  public func appendDupTop(at location: SourceLocation) throws {
    try self.append(.dupTop, at: location)
  }

  /// Append a `dupTopTwo` instruction to code object.
  public func appendDupTopTwo(at location: SourceLocation) throws {
    try self.append(.dupTopTwo, at: location)
  }

  /// Append a `printExpr` instruction to code object.
  public func appendPrintExpr(at location: SourceLocation) throws {
    try self.append(.printExpr, at: location)
  }

  /// Append an `extendedArg` instruction to code object.
  public func appendExtendedArg(value: UInt8,
                                at location: SourceLocation) throws {
    // try self.append(.extendedArg, at: location)
    throw self.unimplemented()
  }

  /// Append a `setupAnnotations` instruction to code object.
  public func appendSetupAnnotations(at location: SourceLocation) throws {
    try self.append(.setupAnnotations, at: location)
  }

  /// Append a `popBlock` instruction to code object.
  public func appendPopBlock(at location: SourceLocation) throws {
    try self.append(.popBlock, at: location)
  }

  /// Append a `loadClosure` instruction to code object.
  public func appendLoadClosure(_ variable: ClosureVariable,
                                at location: SourceLocation) throws {
    // try self.append(.loadClosure, at: location)
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

    throw self.unimplemented()
  }

  /// Append a `buildSlice` instruction to code object.
  public func appendBuildSlice(_ arg: SliceArg,
                               at location: SourceLocation) throws {
    try self.append(.buildSlice(arg), at: location)
  }
}
