import Foundation
import BigInt
import VioletCore

// In CPython:
// Objects -> codeobject.c

// (Unofficial) docs:
// https://tech.blog.aknin.name/2010/07/03/pythons-innards-code-objects/

public final class CodeObject: CustomStringConvertible {

  // MARK: - Types

  public enum Kind {
    case module
    case `class`
    case function
    case asyncFunction
    case lambda
    case comprehension
  }

  public struct Flags: OptionSet {
    public let rawValue: UInt16

    public static let optimized = Flags(rawValue: 0x0001)
    public static let newLocals = Flags(rawValue: 0x0002)
    public static let varArgs = Flags(rawValue: 0x0004)
    public static let varKeywords = Flags(rawValue: 0x0008)
    public static let nested = Flags(rawValue: 0x0010)
    public static let generator = Flags(rawValue: 0x0020)
    public static let noFree = Flags(rawValue: 0x0040)
    public static let coroutine = Flags(rawValue: 0x0080)
    public static let iterableCoroutine = Flags(rawValue: 0x0100)
    public static let asyncGenerator = Flags(rawValue: 0x0200)

    public init(rawValue: UInt16) {
      self.rawValue = rawValue
    }
  }

  public enum Constant: CustomStringConvertible {
    case `true`
    case `false`
    case none
    case ellipsis
    case integer(BigInt)
    case float(Double)
    case complex(real: Double, imag: Double)
    case string(String)
    case bytes(Data)
    case code(CodeObject)
    case tuple([Constant])

    public var description: String {
      switch self {
      case .true: return "true"
      case .false: return "false"
      case .none: return "none"
      case .ellipsis: return "ellipsis"
      case let .integer(i): return "integer(\(i))"
      case let .float(f): return "float(\(f))"
      case let .complex(r, i): return "complex(real: \(r), imag: \(i))"
      case let .string(s): return "string(\(s))"
      case let .bytes(b): return "bytes(\(b))"
      case let .code(c): return "code(\(c))"
      case let .tuple(t): return "tuple(\(t))"
      }
    }
  }

  // MARK: - Properties

  public static let moduleName = "<module>"
  public static let lambdaName = "<lambda>"
  public static let generatorExpressionName = "<genexpr>"
  public static let listComprehensionName = "<listcomp>"
  public static let setComprehensionName = "<setcomp>"
  public static let dictionaryComprehensionName = "<dictcomp>"

  /// Non-unique name of this code object.
  ///
  /// It will be:
  /// - module -> \<module\>
  /// - class -> class name
  /// - function -> function name
  /// - lambda -> \<lambda\>
  /// - generator -> \<genexpr\>
  /// - list comprehension -> \<listcomp\>
  /// - set comprehension -> \<setcomp\>
  /// - dictionary comprehension -> \<dictcomp\>
  public let name: String
  /// Unique dot-separated qualified name.
  ///
  /// For example:
  /// ```c
  /// class frozen: <- qualified name: frozen
  ///   def elsa:   <- qualified name: frozen.elsa
  ///     pass
  /// ```
  public let qualifiedName: String
  /// The filename from which the code was compiled.
  /// Will be `<stdin>` for code entered in the interactive interpreter
  /// or whatever name is given as the second argument to `compile`
  /// for code objects created with `compile`.
  public let filename: String

  /// Type of the code object.
  /// Possible values are: module, class, (async)function, lambda and comprehension.
  public let kind: Kind
  /// Various flags used during the compilation process.
  public let flags: Flags
  /// First source line number.
  public let firstLine: SourceLine

  /// Instruction opcodes.
  /// CPython: `co_code`.
  public internal(set) var instructions = [Instruction]()
  /// Instruction locations.
  /// CPython: `co_lnotab` <- but not exactly the same.
  public internal(set) var instructionLines = [SourceLine]()

  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  /// CPython: `co_consts`.
  public internal(set) var constants = [Constant]()
  /// Names which aren’t covered by any of the other fields (they are not local
  /// variables, they are not free variables, etc) used by the bytecode.
  /// This includes names deemed to be in the global or builtin namespace
  /// as well as attributes (i.e., if you do foo.bar in a function, bar will
  /// be listed in its code object’s names).
  ///
  /// E.g. `LoadName 5` loads `self.names[5]` value.
  /// CPython: `co_names`.
  public internal(set) var names = [String]()
  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public internal(set) var labels = [Int]()

  /// Names of the local variables (including arguments).
  ///
  /// In the ‘richest’ case, `variableNames` contains (in order):
  /// - positional argument names (including optional ones)
  /// - keyword only argument names (again, both required and optional)
  /// - varargs argument name (i.e., *args)
  /// - kwds argument name (i.e., **kwargs)
  /// - any other local variable names.
  ///
  /// So you need to look at `argCount`, `kwOnlyArgCount` and `codeFlags`
  /// to fully interpret this
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_varnames`.
  public let variableNames: [MangledName]
  /// List of free variable names.
  ///
  /// 'Free variable' means a variable which is referenced by an expression
  /// but isn’t defined in it.
  /// In our case, it means a variable that is referenced in this code object
  /// but was defined and will be dereferenced to a cell in another code object
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_freevars`.
  public let freeVariableNames: [MangledName]
  /// List of cell variable names.
  /// Cell = source for 'free' variable.
  ///
  /// [See docs.](https://docs.python.org/3/c-api/cell.html)
  ///
  /// This value is taken directly from the SymbolTable.
  /// New entries should not be added after `init`.
  /// CPython: `co_cellvars`.
  public let cellVariableNames: [MangledName]

  /// Argument count (excluding `*args`).
  /// CPython: `co_argcount`.
  public let argCount: Int
  /// Keyword only argument count.
  /// CPython: `co_kwonlyargcount`.
  public let kwOnlyArgCount: Int

  public var description: String {
    let name = self.qualifiedName.isEmpty ? "(empty)" : self.qualifiedName
    return "CodeObject(qualifiedName: \(name))"
  }

  // MARK: - Init

  public init(name: String,
              qualifiedName: String,
              filename: String,
              kind: Kind,
              flags: Flags,
              variableNames: [MangledName],
              freeVariableNames: [MangledName],
              cellVariableNames: [MangledName],
              argCount: Int,
              kwOnlyArgCount: Int,
              firstLine: SourceLine) {
    self.name = name
    self.qualifiedName = qualifiedName
    self.filename = filename
    self.kind = kind
    self.flags = flags
    self.variableNames = variableNames
    self.freeVariableNames = freeVariableNames
    self.cellVariableNames = cellVariableNames
    self.argCount = argCount
    self.kwOnlyArgCount = kwOnlyArgCount
    self.firstLine = firstLine
  }
}
