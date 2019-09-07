import Core
import Bytecode
import Parser

// In CPython:
// Include -> symtable.h

public struct SymbolFlags: OptionSet, Equatable {

  public let rawValue: UInt16

  // MARK: Variable definition (based only on current scope)

  /// Defined in code block, for example: `elsa = 5`.
  /// Used for `assigned` property in `symtable` module.
  public static let defLocal = SymbolFlags(rawValue: 1 << 0)
  /// Defined by `global` statement, for example: `global elsa`
  public static let defGlobal = SymbolFlags(rawValue: 1 << 1)
  /// Defined by `nonlocal` statement, for example: `nonlocal elsa`
  public static let defNonlocal = SymbolFlags(rawValue: 1 << 2)
  /// Defined by formal function parameter
  public static let defParam = SymbolFlags(rawValue: 1 << 3)
  /// Defined by using import statement
  public static let defImport = SymbolFlags(rawValue: 1 << 4)
  /// Name used but not defined in nested block
  public static let defFree = SymbolFlags(rawValue: 1 << 5)
  /// Free variable from class's method
  public static let defFreeClass = SymbolFlags(rawValue: 1 << 6)

  /// Bound in scope.
  /// Includes: local, param or import
  public static let defBoundMask: SymbolFlags = [
    .defLocal, .defParam, .defImport
  ]

  /// Used in scope.
  /// Includes: global, nonlocal, local, param
  /// Does NOT include: import, free, freeClass
  public static let defScopeMask: SymbolFlags = [
    .defGlobal, .defNonlocal, .defLocal, .defParam
  ]

  // MARK: Variable source (based on other scopes)

  /// Local variable, parameter or import
  public static let srcLocal = SymbolFlags(rawValue: 1 << 7)
  /// `global` symbol (the one that can be used with `global` statement)
  public static let srcGlobalExplicit = SymbolFlags(rawValue: 1 << 8)
  /// Free variable without binding in an enclosing function scope.
  /// It is either a global or a builtin.
  public static let srcGlobalImplicit = SymbolFlags(rawValue: 1 << 9)
  /// Variable comes from parent scope (its exact source is called `cell`)
  public static let srcFree = SymbolFlags(rawValue: 1 << 10)

  /// Variable provides binding that is used for `srcFree` variables
  /// in enclosed blocks (it is a captured)
  public static let cell = SymbolFlags(rawValue: 1 << 11)

  public static let srcMask: SymbolFlags = [
    .srcLocal, .srcGlobalExplicit, .srcGlobalImplicit, .srcFree, .cell
  ]

  // MARK: Additional

  /// Name is used.
  /// Used for `referenced` property in `symtable` module.
  public static let use = SymbolFlags(rawValue: 1 << 12)
  /// This name is annotated
  public static let annotated = SymbolFlags(rawValue: 1 << 13)

  public init(rawValue: UInt16) {
    self.rawValue = rawValue
  }
}
