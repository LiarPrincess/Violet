import Core
import Parser
import Bytecode

extension CodeObjectBuilder {

  /// Append a `nop` instruction to code object.
  public func emitNop(location: SourceLocation) throws {
    try self.emit(.nop, location: location)
  }

  /// Append a `popTop` instruction to code object.
  public func emitPopTop(location: SourceLocation) throws {
    try self.emit(.popTop, location: location)
  }

  /// Append a `rotTwo` instruction to code object.
  public func emitRotTwo(location: SourceLocation) throws {
    try self.emit(.rotTwo, location: location)
  }

  /// Append a `rotThree` instruction to code object.
  public func emitRotThree(location: SourceLocation) throws {
    try self.emit(.rotThree, location: location)
  }

  /// Append a `dupTop` instruction to code object.
  public func emitDupTop(location: SourceLocation) throws {
    try self.emit(.dupTop, location: location)
  }

  /// Append a `dupTopTwo` instruction to code object.
  public func emitDupTopTwo(location: SourceLocation) throws {
    try self.emit(.dupTopTwo, location: location)
  }

  /// Append a `printExpr` instruction to code object.
  public func emitPrintExpr(location: SourceLocation) throws {
    try self.emit(.printExpr, location: location)
  }

  /// Append an `extendedArg` instruction to code object.
  public func emitExtendedArg(value: UInt8, location: SourceLocation) throws {
    // try self.emit(.extendedArg, location: location)
    throw self.unimplemented()
  }

  /// Append a `setupAnnotations` instruction to code object.
  public func emitSetupAnnotations(location: SourceLocation) throws {
    try self.emit(.setupAnnotations, location: location)
  }

  /// Append a `popBlock` instruction to code object.
  public func emitPopBlock(location: SourceLocation) throws {
    try self.emit(.popBlock, location: location)
  }

  /// Append a `loadClosure` instruction to code object.
  public func emitLoadClosure(value: I, location: SourceLocation) throws {
    // try self.emit(.loadClosure, location: location)
    throw self.unimplemented()
  }

  /// Append a `buildSlice` instruction to code object.
  public func emitBuildSlice(_ arg: SliceArg,
                             location: SourceLocation) throws {
    let n = self.getArgumentCount(arg)
    try self.emit(.buildSlice(n), location: location)
  }

  private func getArgumentCount(_ arg: SliceArg) -> UInt8 {
    switch arg {
    case .lowerUpper: return 2
    case .lowerUpperStep: return 3
    }
  }
}
