import Foundation
import Core

extension CodeObject {

  /// Append a `loadConst` instruction to code object.
  public func appendTrue(at location: SourceLocation) throws {
    try self.appendConstant(.true, at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendFalse(at location: SourceLocation) throws {
    try self.appendConstant(.false, at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendNone(at location: SourceLocation) throws {
    try self.appendConstant(.none, at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendEllipsis(at location: SourceLocation) throws {
    try self.appendConstant(.ellipsis, at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendInteger(_ value: BigInt, at location: SourceLocation) throws {
    try self.appendConstant(.integer(value), at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendFloat(_ value: Double, at location: SourceLocation) throws {
    try self.appendConstant(.float(value), at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendComplex(real: Double,
                            imag: Double,
                            at location: SourceLocation) throws {
    try self.appendConstant(.complex(real: real, imag: imag), at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendString<S: ConstantString>(_ value: S,
                                              at location: SourceLocation) throws {
    try self.appendConstant(.string(value.constant), at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendBytes(_ value: Data, at location: SourceLocation) throws {
    try self.appendConstant(.bytes(value), at: location)
  }
  
  /// Append a `loadConst` instruction to code object.
  public func appendTuple(_ value: [Constant], at location: SourceLocation) throws {
    try self.appendConstant(.tuple(value), at: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func appendCode(_ value: CodeObject, at location: SourceLocation) throws {
    try self.appendConstant(.code(value), at: location)
  }

  public func appendConstant(_ constant: Constant,
                             at location: SourceLocation) throws {
    let rawIndex = self.constants.endIndex
    self.constants.append(constant)

    let index = try self.appendExtendedArgIfNeeded(rawIndex, at: location)
    try self.append(.loadConst(index: index), at: location)
  }
}
