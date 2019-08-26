import Core
import Parser

public class SymbolTable {

  public let top: SymbolScope

  public let scopeByNode: ScopeByNodeDictionary

  public var globals: [MangledName: SymbolInfo] {
    return self.top.symbols
  }

  // `internal` so, that we can't instantiate it outside of this module.
  internal init(top: SymbolScope, scopeByNode: ScopeByNodeDictionary) {
    self.top = top
    self.scopeByNode = scopeByNode
  }
}

/// Mapping from ASTNode to Symbol scope.
/// Returns `nil` if no scope is associated with given node.
public struct ScopeByNodeDictionary {

  private var inner = [NodeId:SymbolScope]()

  // `internal` so, that we can't instantiate it outside of this module.
  internal init() {}

  public subscript<N: ASTNode>(key: N) -> SymbolScope? {
    get { return self.get(key) }
    set { self.insert(key, value: newValue) }
  }

  public func get<N: ASTNode>(_ key: N) -> SymbolScope? {
    return self.inner[key.id]
  }

  public mutating func insert<N: ASTNode>(_ key: N, value: SymbolScope?) {
    self.inner[key.id] = value
  }
}

public enum ScopeType {
  case function
  case `class`
  case module
}

/// Captures all symbols in the current scope
/// and has a list of subscopes (childrens).
public class SymbolScope {

  /// Name of the class if the table is for a class.
  /// Name of the function if the table is for a function.
  /// Otherwise 'top'.
  public let name: String

  /// Type of the symbol table.
  /// Possible values are 'class', 'module' and 'function'.
  public let type: ScopeType

  /// A set of symbols present on this scope level
  public internal(set) var symbols = [MangledName: SymbolInfo]()

  /// A list of subscopes in the order as found in the AST nodes
  public internal(set) var children = [SymbolScope]()

  /// Locations of global and nonlocal statements
  public internal(set) var directives = [MangledName]()

  /// List of function parameters
  public internal(set) var varnames = [MangledName]()

  /// Return True if the block is a nested class or function.
  public let isNested: Bool
  /// true if block has free variables
  public internal(set) var hasFreeVariables = false
  /// true if a child block has free vars, including free refs to globals
  public internal(set) var hasChildFreeVariables = false
  /// true if namespace is a generator
  public internal(set) var isGenerator = false
  /// true if namespace is a coroutine
  public internal(set) var isCoroutine = false
  /// true if block has varargs
  public internal(set) var hasVarargs = false
  /// true if block has varKeywords
  public internal(set) var hasVarKeywords = false
  /// true if namespace uses return with an argument
  public internal(set) var hasReturnValue = false
  /// For class scopes: true if a closure over __class__ should be created
  public internal(set) var needsClassClosure = false

  // `internal` so, that we can't instantiate it outside of this module.
  internal init(name: String, type: ScopeType, isNested: Bool) {
    self.name = name
    self.type = type
    self.isNested = isNested
  }
}

public struct SymbolInfo {

  /// Symbol information.
  public let flags: SymbolFlags

  /// Location of the first character in the source code.
  public let location: SourceLocation
}

public struct SymbolFlags: OptionSet {
  public let rawValue: UInt16

  // MARK: Variable definition (in a current scope)

  /// Defined by assignment in code block
  public static let defLocal = SymbolFlags(rawValue: 1 << 0)
  /// Defined by `global` statement
  public static let defGlobal = SymbolFlags(rawValue: 1 << 1)
  /// Defined by `nonlocal` statement
  public static let defNonlocal = SymbolFlags(rawValue: 1 << 2)
  /// Defined by formal function parameter
  public static let defParam = SymbolFlags(rawValue: 1 << 3)
  /// Defined by using import statement
  public static let defImport = SymbolFlags(rawValue: 1 << 4)
  /// Name used but not defined in nested block
  public static let defFree = SymbolFlags(rawValue: 1 << 5)
  /// Free variable from class's method
  public static let defFreeClass = SymbolFlags(rawValue: 1 << 6)

  /// Bound in local scope (either by local, param or import)
  public static let defBound: SymbolFlags = [.defLocal, .defParam, .defImport]

  // MARK: Variable source (from other scopes)

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
  /// in enclosed blocks
  public static let cell = SymbolFlags(rawValue: 1 << 11)

  // MARK: Additional

  /// Name is used
  public static let use = SymbolFlags(rawValue: 1 << 12)
  /// This name is annotated
  public static let annotated = SymbolFlags(rawValue: 2 << 13)

  public init(rawValue: UInt16) {
    self.rawValue = rawValue
  }
}
