import VioletCore
import VioletParser
import VioletBytecode

// In CPython:
// Include -> symtable.h

/// Captures all symbols in the current scope and has a list of subscopes (children).
public final class SymbolScope {

  // MARK: - Kind

  public enum Kind: Equatable {
    case module
    case `class`
    case function
  }

  // MARK: - SymbolByName

  /// Ordered dictionary that holds `Symbol` instances.
  ///
  /// It will remember the order in which symbols were inserted.
  public struct SymbolByName: Sequence {

    // This is a very unsophisticated implementation of ordered dictionary,
    // but it is enough.
    private var dict = [MangledName: Symbol]()
    private var list = [MangledName]()

    public var count: Int {
      assert(self.dict.count == self.list.count)
      return self.list.count
    }

    public var isEmpty: Bool {
      assert(self.dict.count == self.list.count)
      return self.list.isEmpty
    }

    public internal(set) subscript(name: MangledName) -> Symbol? {
      get { return self.dict[name] }
      set {
        // We don't need removal operation, but we want fancy subscript syntax.
        guard let newValue = newValue else {
          trap("Symbol removal was not implemented.")
        }

        let oldValue = self.dict.updateValue(newValue, forKey: name)

        let isInsert = oldValue == nil
        if isInsert {
          self.list.append(name)
        }

        assert(self.dict.count == self.list.count)
      }
    }

    public typealias Element = (key: MangledName, info: Symbol)
    public typealias Iterator = AnyIterator<Self.Element>

    public func makeIterator() -> Iterator {
      var index = 0
      return AnyIterator { () -> Self.Element? in
        guard index < self.list.count else {
          return nil
        }

        defer { index += 1 }

        let name = self.list[index]
        guard let info = self.dict[name] else {
          trap("[SymbolByNameDictionary] Missing '\(name)' in dictionary.")
        }

        return (name, info)
      }
    }
  }

  // MARK: - Properties

  /// Non-unique name of this scope.
  ///
  /// It will be:
  /// - module -> module
  /// - class -> class name
  /// - function -> function name
  /// - lambda -> lambda
  /// - generator -> genexpr
  /// - list comprehension -> listcomp
  /// - set comprehension -> setcomp
  /// - dictionary comprehension -> dictcomp
  public let name: String
  /// Type of the symbol table.
  /// Possible values are: module, class and function.
  public let kind: Kind
  /// A set of symbols present on this scope level
  public internal(set) var symbols = SymbolByName()
  /// A list of subscopes in the order as found in the AST
  public internal(set) var children = [SymbolScope]()
  /// List of function parameters
  ///
  /// CPython: `varNames`.
  public internal(set) var parameterNames = [MangledName]()

  /// Block is a nested class or function.
  public let isNested: Bool
  /// Namespace is a generator (yield)
  public internal(set) var isGenerator = false
  /// Namespace is a coroutine (async/await)
  public internal(set) var isCoroutine = false
  /// Block has varargs (the ones with '*')
  public internal(set) var hasVarargs = false
  /// Block has varKeywords (the ones with '**')
  public internal(set) var hasVarKeywords = false
  /// Namespace uses return with an argument
  public internal(set) var hasReturnValue = false
  /// For class scopes: true if a closure over `__class__` should be created
  public internal(set) var needsClassClosure = false

  // MARK: - Init

  // CPython also contains:
  // - ste_directives - locations of global and nonlocal statements
  //                    we don't need it because we store location of each variable
  // - ste_free       - true if block has free variables - not used
  // - ste_child_free - true if a child block has free vars,
  //                    including free refs to globals - not used

  // `internal` so, that we can't instantiate it outside of this module.
  internal init(name: String, kind: Kind, isNested: Bool) {
    self.name = name
    self.kind = kind
    self.isNested = isNested
  }
}
