import Core
import Bytecode
import Parser

// In CPython:
// Include -> symtable.h

public struct SymbolFlags: OptionSet, Equatable, CustomStringConvertible {

  public let rawValue: UInt16

  // MARK: Variable definition (based only on current scope)

  /// Variable defined in code block, for example: `elsa = 5`.
  /// Used for `assigned` property in `symtable` module.
  /// CPython: `DEF_LOCAL`.
  public static let defLocal = SymbolFlags(rawValue: 1 << 0)
  /// Variable defined by `global` statement, for example: `global elsa`
  /// CPython: `DEF_GLOBAL`.
  public static let defGlobal = SymbolFlags(rawValue: 1 << 1)
  /// Variable defined by `nonlocal` statement, for example: `nonlocal elsa`
  /// CPython: `DEF_NONLOCAL`.
  public static let defNonlocal = SymbolFlags(rawValue: 1 << 2)
  /// Variable defined by formal function parameter
  /// CPython: `DEF_PARAM`.
  public static let defParam = SymbolFlags(rawValue: 1 << 3)
  /// Variable defined by using import statement
  /// CPython: `DEF_IMPORT`.
  public static let defImport = SymbolFlags(rawValue: 1 << 4)
  /// Name used but not defined in nested block
  /// CPython: `DEF_FREE`.
  public static let defFree = SymbolFlags(rawValue: 1 << 5)
  /// Free variable from class's method
  /// CPython: `DEF_FREE_CLASS`.
  public static let defFreeClass = SymbolFlags(rawValue: 1 << 6)

  /// Bound in scope.
  /// Includes: local, param or import
  /// CPython: `DEF_BOUND`.
  public static let defBoundMask: SymbolFlags = [
    .defLocal, .defParam, .defImport
  ]

  /// Used in scope.
  /// Includes: global, nonlocal, local, param
  /// Does NOT include: import, free, freeClass
  /// CPython: `SCOPE_OFFSET`.
  public static let SCOPE_MASK: SymbolFlags = [
    .defGlobal, .defNonlocal, .defLocal, .defParam
  ]

  // MARK: Variable source - where the value comes from (based on other scopes)

  /// Variable source (where the value comes from):
  /// local, parameter or import.
  /// CPython: `LOCAL`.
  public static let srcLocal = SymbolFlags(rawValue: 1 << 7)
  /// Variable source (where the value comes from):
  /// `global` symbol (the one that can be used with `global` statement).
  /// CPython: `GLOBAL_EXPLICIT`.
  public static let srcGlobalExplicit = SymbolFlags(rawValue: 1 << 8)
  /// Variable source (where the value comes from):
  /// free variable without binding in an enclosing function scope.
  /// It is either a global or a builtin.
  /// CPython: `GLOBAL_IMPLICIT`.
  public static let srcGlobalImplicit = SymbolFlags(rawValue: 1 << 9)
  /// Variable source (where the value comes from):
  /// from parent scope (its source is called `cell`).
  /// CPython: `FREE`.
  public static let srcFree = SymbolFlags(rawValue: 1 << 10)
  /// Variable provides binding that is used for `srcFree` variables
  /// in enclosed blocks (it is a captured)
  /// CPython: `CELL`.
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

  // MARK: - Description

  public var description: String {
    let namedFlags: [(SymbolFlags, String)] = [
      (.defLocal, "defLocal"),
      (.defGlobal, "defGlobal"),
      (.defNonlocal, "defNonlocal"),
      (.defParam, "defParam"),
      (.defImport, "defImport"),
      (.defFree, "defFree"),
      (.defFreeClass, "defFreeClass"),
      (.srcLocal, "srcLocal"),
      (.srcGlobalExplicit, "srcGlobalExplicit"),
      (.srcGlobalImplicit, "srcGlobalImplicit"),
      (.srcFree, "srcFree"),
      (.cell, "cell"),
      (.use, "use"),
      (.annotated, "annotated")
    ]

    var result = ""
    for (flag, name) in namedFlags where self.contains(flag) {
      if !result.isEmpty {
        result.append(", ")
      }

      result.append(name)
    }
    return result
  }

  // MARK: - Init

  public init(rawValue: UInt16) {
    self.rawValue = rawValue
  }
}
