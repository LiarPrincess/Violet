/// Captures all symbols in the current scope
/// and has a list of subscopes (childrens).
public class SymbolScope {

  /// Name of the class if the table is for a class.
  /// Name of the function if the table is for a function.
  /// Otherwise 'top'.
  public let name: String

  /// Type of the symbol table.
  /// Possible values are 'class', 'module', and 'function'.
  public let type: ScopeType

  /// A set of symbols present on this scope level
  public internal(set) var symbols = [MangledName: SymbolFlags]()

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
  // For class scopes: true if a closure over __class__ should be created
  public internal(set) var needsClassClosure = false

  public init(name: String, type: ScopeType, isNested: Bool) {
    self.name = name
    self.type = type
    self.isNested = isNested
  }
}

public enum ScopeType {
  case function
  case `class`
  case module
}

public struct SymbolFlags: OptionSet {
  public let rawValue: UInt16

  /// Assignment in code block
  public static let local = SymbolFlags(rawValue: 1 << 0)
  /// `global` stmt
  public static let global = SymbolFlags(rawValue: 1 << 1)
  /// `nonlocal` stmt
  public static let nonlocal = SymbolFlags(rawValue: 1 << 2)
  /// Formal parameter
  public static let param = SymbolFlags(rawValue: 1 << 3)
  /// Assignment occurred via import
  public static let `import` = SymbolFlags(rawValue: 2 << 4)

  /// Name used but not defined in nested block
  public static let free = SymbolFlags(rawValue: 2 << 5)
  /// Free variable from class's method
  public static let freeClass = SymbolFlags(rawValue: 2 << 6)

  /// Name is used
  public static let use = SymbolFlags(rawValue: 1 << 7)
  /// This name is annotated
  public static let annotated = SymbolFlags(rawValue: 2 << 8)

  public init(rawValue: UInt16) {
    self.rawValue = rawValue
  }
}
