import Foundation
import Core
import Parser
import Bytecode

public enum DerefContext {
  case store
  case load
  case loadClass
  case del
}

extension CodeObjectBuilder {

  // MARK: - Constants

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
  public func emitComplex(real: Double, imag: Double, location: SourceLocation) throws {
    try self.emitConstant(.complex(real: real, imag: imag), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitString(_ value: String, location: SourceLocation) throws {
    try self.emitConstant(.string(value), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitBytes(_ value: Data, location: SourceLocation) throws {
    try self.emitConstant(.bytes(value), location: location)
  }

  /// Append a `loadConst` instruction to code object.
  public func emitTuple(_ value: [Constant], location: SourceLocation) throws {
    try self.emitConstant(.tuple(value), location: location)
  }

  public func emitConstant(_ constant: Constant, location: SourceLocation) throws {
    // TODO: check if this value was already added

    let rawIndex = self.codeObject.constants.endIndex
    self.codeObject.constants.append(constant)

    let index = try self.emitExtendedArgIfNeeded(rawIndex, location: location)
    try self.emit(.loadConst(index: index), location: location)
  }

  // MARK: - Name

  public func emitName(name: MangledName,
                       context:  ExpressionContext,
                       location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreName (name: name, location: location)
    case .load:  try self.emitLoadName  (name: name, location: location)
    case .del:   try self.emitDeleteName(name: name, location: location)
    }
  }

  /// Append a `storeName` instruction to code object.
  public func emitStoreName(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.storeName(nameIndex: index), location: location)
  }

  /// Append a `loadName` instruction to code object.
  public func emitLoadName(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.loadName(nameIndex: index), location: location)
  }

  /// Append a `deleteName` instruction to code object.
  public func emitDeleteName(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.deleteName(nameIndex: index), location: location)
  }

  // MARK: - Attribute

  public func emitAttribute(name: MangledName,
                       context:  ExpressionContext,
                       location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreAttribute (name: name, location: location)
    case .load:  try self.emitLoadAttribute  (name: name, location: location)
    case .del:   try self.emitDeleteAttribute(name: name, location: location)
    }
  }

  /// Append a `storeAttr` instruction to code object.
  public func emitStoreAttribute(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.storeAttr(nameIndex: index), location: location)
  }

  /// Append a `loadAttr` instruction to code object.
  public func emitLoadAttribute(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.loadAttr(nameIndex: index), location: location)
  }

  /// Append a `deleteAttr` instruction to code object.
  public func emitDeleteAttribute(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.deleteAttr(nameIndex: index), location: location)
  }

  // MARK: - Subscript

  public func emitSubscript(context: ExpressionContext,
                            location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreSubscr (location: location)
    case .load:  try self.emitBinarySubscr(location: location)
    case .del:   try self.emitDeleteSubscr(location: location)
    }
  }

  /// Append a `binarySubscr` instruction to code object.
  public func emitBinarySubscr(location: SourceLocation) throws {
    try self.emit(.binarySubscr, location: location)
  }

  /// Append a `storeSubscr` instruction to code object.
  public func emitStoreSubscr(location: SourceLocation) throws {
    try self.emit(.storeSubscr, location: location)
  }

  /// Append a `deleteSubscr` instruction to code object.
  public func emitDeleteSubscr(location: SourceLocation) throws {
    try self.emit(.deleteSubscr, location: location)
  }

  // MARK: - Global

  public func emitGlobal(name: MangledName,
                         context:  ExpressionContext,
                         location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreGlobal (name: name, location: location)
    case .load:  try self.emitLoadGlobal  (name: name, location: location)
    case .del:   try self.emitDeleteGlobal(name: name, location: location)
    }
  }

  /// Append a `storeGlobal` instruction to code object.
  public func emitStoreGlobal(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.storeGlobal(nameIndex: index), location: location)
  }

  /// Append a `loadGlobal` instruction to code object.
  public func emitLoadGlobal(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.loadGlobal(nameIndex: index), location: location)
  }

  /// Append a `deleteGlobal` instruction to code object.
  public func emitDeleteGlobal(name: MangledName, location: SourceLocation) throws {
    let index = try self.addNameWithExtendedArgIfNeeded(name: name, location: location)
    try self.emit(.deleteGlobal(nameIndex: index), location: location)
  }
  // MARK: - Fast

  public func emitFast(name: MangledName,
                       context:  ExpressionContext,
                       location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreFast (name: name, location: location)
    case .load:  try self.emitLoadFast  (name: name, location: location)
    case .del:   try self.emitDeleteFast(name: name, location: location)
    }
  }

  /// Append a `loadFast` instruction to code object.
  public func emitLoadFast(name: MangledName, location: SourceLocation) throws {
    // try self.emit(.loadFast, location: location)
    throw self.unimplemented()
  }

  /// Append a `storeFast` instruction to code object.
  public func emitStoreFast(name: MangledName, location: SourceLocation) throws {
    // try self.emit(.storeFast, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteFast` instruction to code object.
  public func emitDeleteFast(name: MangledName, location: SourceLocation) throws {
    // try self.emit(.deleteFast, location: location)
    throw self.unimplemented()
  }

  // MARK: - Deref

  internal func emitDeref(name: MangledName,
                          context: DerefContext,
                          location: SourceLocation) throws {
    switch context {
    case .store: try self.emitStoreDeref (name: name, location: location)
    case .load:  try self.emitLoadDeref  (name: name, location: location)
    case .del:   try self.emitDeleteDeref(name: name, location: location)
    case .loadClass: try self.emitLoadClassDeref(name: name, location: location)
    }
  }

  /// Append a `loadDeref` instruction to code object.
  public func emitLoadDeref(name: MangledName, location: SourceLocation) throws {
    // try self.emit(.loadDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `loadClassDeref` instruction to code object.
  public func emitLoadClassDeref(name: MangledName, location: SourceLocation) throws {
    // try self.emit(.loadClassDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `storeDeref` instruction to code object.
  public func emitStoreDeref(name: MangledName, location: SourceLocation) throws {
    // try self.emit(.storeDeref, location: location)
    throw self.unimplemented()
  }

  /// Append a `deleteDeref` instruction to code object.
  public func emitDeleteDeref(name: MangledName, location: SourceLocation) throws {
    // try self.emit(.deleteDeref, location: location)
    throw self.unimplemented()
  }
}
