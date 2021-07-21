import VioletCore
import VioletParser
import VioletBytecode

// swiftlint:disable nesting

// In CPython:
// Include -> symtable.h

/// Captures all symbols in the current scope and has a list of subscopes (children).
public final class SymbolScope {

  // MARK: - Kind

  public enum Kind: Equatable {
    case module
    case `class`
    case function
    case asyncFunction
    case lambda
    case comprehension(CodeObject.ComprehensionKind)

    /// Use this when CPython checks if this is a `module` scope.
    ///
    /// CPython has only `module`, `class` and `function`, use this for mapping.
    internal var isModule: Bool {
      return self == .module
    }

    /// Use this when CPython checks if this is a `class` scope.
    ///
    /// CPython has only `module`, `class` and `function`, use this for mapping.
    internal var isClass: Bool {
      return self == .class
    }

    /// Use this when CPython checks if this is a `function` scope.
    ///
    /// CPython has only `module`, `class` and `function`, use this for mapping.
    internal var isFunctionLambdaComprehension: Bool {
      switch self {
      case .module,
           .class:
        return false
      case .function,
           .asyncFunction,
           .lambda,
           .comprehension:
        return true
      }
    }
  }

  // MARK: - Names

  /// Predefined scope names.
  internal enum Names {
    /// Name of the `AST` scope.
    internal static let top = "top"
    /// Name of the `lambda` scope.
    internal static let lambda = "lambda"

    enum Comprehension {
      /// Name of the `list` comprehension scope.
      internal static let list = "listcomp"
      /// Name of the `set` comprehension scope.
      internal static let set = "setcomp"
      /// Name of the `dict` comprehension scope.
      internal static let dictionary = "dictcomp"
      /// Name of the generator expression scope.
      internal static let generatorExpression = "genexpr"
    }
  }

  // MARK: - SymbolByName

  /// Ordered dictionary that holds `Symbol` instances.
  ///
  /// It will remember the order in which symbols were inserted.
  public struct SymbolByName: Sequence {

    // This is a very unsophisticated implementation of ordered dictionary,
    // but it is enough.
    private var dict = [MangledName: SymbolInfo]()
    private var list = [MangledName]()

    public var count: Int {
      assert(self.dict.count == self.list.count)
      return self.list.count
    }

    public var isEmpty: Bool {
      assert(self.dict.count == self.list.count)
      return self.list.isEmpty
    }

    public internal(set) subscript(name: MangledName) -> SymbolInfo? {
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

    public typealias Element = (key: MangledName, info: SymbolInfo)
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
  /// Type of the scope.
  ///
  /// Does not directly map to `CPython` values, they have only
  /// `module`, `class` and `function`. We have more.
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

  /// Argument used for `init` function.
  internal enum InitArg {
    case module
    case function(name: String)
    case asyncFunction(name: String)
    case `class`(name: String)
    case lambda
    case comprehension(CodeObject.ComprehensionKind)

    internal var isFunctionLambdaComprehension: Bool {
      let (_, kind) = SymbolScope.getNameAndKind(arg: self)
      return kind.isFunctionLambdaComprehension
    }
  }

  // CPython also contains:
  // - ste_directives - locations of global and nonlocal statements
  //                    we don't need it because we store location of each variable
  // - ste_free       - true if block has free variables - not used
  // - ste_child_free - true if a child block has free vars,
  //                    including free refs to globals - not used

  // `internal` so, that we can't instantiate it outside of this module.
  internal init(kind arg: InitArg, isNested: Bool) {
    let (name, kind) = Self.getNameAndKind(arg: arg)
    self.name = name
    self.kind = kind
    self.isNested = isNested
  }

  private static func getNameAndKind(arg: InitArg) -> (String, Kind) {
    switch arg {
    case .module:
      return (Names.top, .module)

    case .class(let name):
      return (name, .class)

    case .function(let name):
      return (name, .function)
    case .asyncFunction(let name):
      return (name, .asyncFunction)
    case .lambda:
      return (Names.lambda, .lambda)

    case .comprehension(.list):
      return (Names.Comprehension.list, .comprehension(.list))
    case .comprehension(.set):
      return (Names.Comprehension.set, .comprehension(.set))
    case .comprehension(.dictionary):
      return (Names.Comprehension.dictionary, .comprehension(.dictionary))
    case .comprehension(.generator):
      return (Names.Comprehension.generatorExpression, .comprehension(.generator))
    }
  }
}
