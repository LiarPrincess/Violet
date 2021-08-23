import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Include -> symtable.h

/// Information about a single symbol.
///
/// It does not contain a symbol name, as this information is stored inside
/// `SymbolScope.symbols` dictionary.
public struct SymbolInfo: Equatable, CustomStringConvertible {

  // MARK: - Flags

  public struct Flags: OptionSet, Equatable, CustomStringConvertible {

    public let rawValue: UInt16

    // MARK: Variable definition (based only on current scope)

    /// Variable defined in code block, for example: `elsa = 5`.
    /// Used for `assigned` property in `symtable` module.
    ///
    /// CPython: `DEF_LOCAL`.
    public static let defLocal = Flags(rawValue: 1 << 0)
    /// Variable defined by `global` statement, for example: `global elsa`.
    ///
    /// CPython: `DEF_GLOBAL`.
    public static let defGlobal = Flags(rawValue: 1 << 1)
    /// Variable defined by `nonlocal` statement, for example: `nonlocal elsa`
    ///
    /// CPython: `DEF_NONLOCAL`.
    public static let defNonlocal = Flags(rawValue: 1 << 2)
    /// Variable defined by formal function parameter.
    ///
    /// CPython: `DEF_PARAM`.
    public static let defParam = Flags(rawValue: 1 << 3)
    /// Variable defined by using import statement.
    ///
    /// CPython: `DEF_IMPORT`.
    public static let defImport = Flags(rawValue: 1 << 4)
    /// Name used but not defined in nested block.
    ///
    /// CPython: `DEF_FREE`.
    public static let defFree = Flags(rawValue: 1 << 5)
    /// Free variable from class's method.
    ///
    /// CPython: `DEF_FREE_CLASS`.
    public static let defFreeClass = Flags(rawValue: 1 << 6)

    /// Bound in scope.
    /// Includes: `local`, `param` and `import`.
    /// Does NOT include: `global`, `nonlocal`, `free` and `freeClass`.
    ///
    /// CPython: `DEF_BOUND`.
    public static let defBoundMask: Flags = [
      .defLocal, .defParam, .defImport
    ]

    /// Used in scope.
    /// Includes: `local`, `global`, `nonlocal` and `param`.
    /// Does NOT include: `import`, `free` and `freeClass`.
    ///
    /// CPython: `SCOPE_OFFSET`.
    public static let scopeMask: Flags = [
      .defLocal, .defGlobal, .defNonlocal, .defParam
    ]

    // MARK: Variable source - where the value comes from (based on other scopes)

    /// Variable source (where the value comes from):
    /// `local`, `parameter` or `import`.
    ///
    /// CPython: `LOCAL`.
    public static let srcLocal = Flags(rawValue: 1 << 7)
    /// Variable source (where the value comes from):
    /// `global` symbol (the one that can be used with `global` statement).
    ///
    /// CPython: `GLOBAL_EXPLICIT`.
    public static let srcGlobalExplicit = Flags(rawValue: 1 << 8)
    /// Variable source (where the value comes from):
    /// `free` variable without binding in an enclosing function scope.
    /// It is either a `global` or a `builtin`.
    ///
    /// CPython: `GLOBAL_IMPLICIT`.
    public static let srcGlobalImplicit = Flags(rawValue: 1 << 9)
    /// Variable source (where the value comes from):
    /// from parent scope (its source is called `cell`).
    ///
    /// CPython: `FREE`.
    public static let srcFree = Flags(rawValue: 1 << 10)
    /// Variable provides binding that is used for `srcFree` variables
    /// in enclosed blocks (it is a captured).
    ///
    /// CPython: `CELL`.
    public static let cell = Flags(rawValue: 1 << 11)

    /// All `src` flags:
    /// `local`, `globalExplicit`, `globalImplicit`, `free` and `cell`.
    public static let srcMask: Flags = [
      .srcLocal, .srcGlobalExplicit, .srcGlobalImplicit, .srcFree, .cell
    ]

    // MARK: Additional

    /// Name is used.
    /// Used for `referenced` property in `symtable` module.
    public static let use = Flags(rawValue: 1 << 12)
    /// This name is annotated.
    public static let annotated = Flags(rawValue: 1 << 13)

    // MARK: - Description

    public var description: String {
      var result = "["
      var isFirst = true

      func appendIfSet(_ flag: Flags, name: String) {
        guard self.contains(flag) else {
          return
        }

        if !isFirst {
          result += ", "
        }

        result.append(name)
        isFirst = false
      }

      appendIfSet(.defLocal, name: "defLocal")
      appendIfSet(.defGlobal, name: "defGlobal")
      appendIfSet(.defNonlocal, name: "defNonlocal")
      appendIfSet(.defParam, name: "defParam")
      appendIfSet(.defImport, name: "defImport")
      appendIfSet(.defFree, name: "defFree")
      appendIfSet(.defFreeClass, name: "defFreeClass")
      appendIfSet(.srcLocal, name: "srcLocal")
      appendIfSet(.srcGlobalExplicit, name: "srcGlobalExplicit")
      appendIfSet(.srcGlobalImplicit, name: "srcGlobalImplicit")
      appendIfSet(.srcFree, name: "srcFree")
      appendIfSet(.cell, name: "cell")
      appendIfSet(.use, name: "use")
      appendIfSet(.annotated, name: "annotated")

      return result + "]"
    }

    // MARK: - Init

    public init(rawValue: UInt16) {
      self.rawValue = rawValue
    }
  }

  // MARK: - Properties

  /// Symbol information.
  public let flags: Flags
  /// Location of the first occurrence of a given symbol.
  public let location: SourceLocation

  public var description: String {
    return "SymbolInfo(flags: \(self.flags), location: \(self.location))"
  }
}
