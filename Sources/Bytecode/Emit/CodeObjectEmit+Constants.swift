import Foundation
import Core

extension CodeObject {

  /// Append a `loadConst` instruction to code object.
  public func emitTrue(location: SourceLocation) throws {
    try self.emitConstant(.true, location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitFalse(location: SourceLocation) throws {
    try self.emitConstant(.false, location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitNone(location: SourceLocation) throws {
    try self.emitConstant(.none, location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitEllipsis(location: SourceLocation) throws {
    try self.emitConstant(.ellipsis, location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitInteger(_ value: BigInt, location: SourceLocation) throws {
    try self.emitConstant(.integer(value), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitFloat(_ value: Double, location: SourceLocation) throws {
    try self.emitConstant(.float(value), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitComplex(real: Double,
                          imag: Double,
                          location: SourceLocation) throws {
    try self.emitConstant(.complex(real: real, imag: imag), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitString<S: ConstantString>(_ value: S,
                                            location: SourceLocation) throws {
    try self.emitConstant(.string(value.constant), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitBytes(_ value: Data, location: SourceLocation) throws {
    try self.emitConstant(.bytes(value), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitTuple(_ value: [Constant], location: SourceLocation) throws {
    try self.emitConstant(.tuple(value), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitCode(_ value: CodeObject, location: SourceLocation) throws {
    try self.emitConstant(.code(value), location: location)
  }

  public func emitConstant(_ constant: Constant,
                           location: SourceLocation) throws {
    let rawIndex = self.constants.endIndex
    self.constants.append(constant)

    let index = try self.emitExtendedArgIfNeeded(rawIndex, location: location)
    try self.emit(.loadConst(index: index), location: location)
  }
}
