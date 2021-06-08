import Foundation
import BigInt
import VioletCore

// In CPython:
// Objects -> codeobject.c // cSpell:disable-line

// (Unofficial) docs:
// https://tech.blog.aknin.name/2010/07/03/pythons-innards-code-objects/

/// Bytecode container.
///
/// Use `CodeObjectBuilder` for creation.
public final class CodeObject: Equatable {

  // MARK: - Kind

  public enum Kind: CustomStringConvertible {
    case module
    case `class`
    case function
    case asyncFunction
    case lambda
    case comprehension

    public var description: String {
      switch self {
      case .module: return "Module"
      case .class: return "Class"
      case .function: return "Function"
      case .asyncFunction: return "Async function"
      case .lambda: return "Lambda"
      case .comprehension: return "Comprehension"
      }
    }
  }

  // MARK: - Flags

  public struct Flags: OptionSet, CustomStringConvertible {
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

    public var description: String {
      var flags = ""

      func appendIfSet(_ flag: Flags, name: String) {
        if self.contains(flag) {
          if flags.any {
            flags += ", "
          }

          flags.append(name)
        }
      }

      appendIfSet(.optimized, name: "optimized")
      appendIfSet(.newLocals, name: "newLocals")
      appendIfSet(.varArgs, name: "varArgs")
      appendIfSet(.varKeywords, name: "varKeywords")
      appendIfSet(.nested, name: "nested")
      appendIfSet(.generator, name: "generator")
      appendIfSet(.noFree, name: "noFree")
      appendIfSet(.coroutine, name: "coroutine")
      appendIfSet(.iterableCoroutine, name: "iterableCoroutine")
      appendIfSet(.asyncGenerator, name: "asyncGenerator")

      return "FunctionFlags(\(flags))"
    }


    public init(rawValue: UInt16) {
      self.rawValue = rawValue
    }
  }

  // MARK: - Constant

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

  // MARK: - Label

  /// Index of jump target in `CodeObject.labels`.
  ///
  /// Basically a wrapper around array index for additional type safety (otherwise
  /// we would have to use `Int` which can be mistaken with any other `int`).
  ///
  /// - Important:
  /// Labels can only be used inside a single block!
  public struct Label: Equatable, CustomStringConvertible {

    /// Invalid Label
    public static let notAssigned = Label(jumpAddress: -1)

    /// Index in `CodeObject.labels`
    public internal(set) var jumpAddress: Int

    public var description: String {
      return "Label(jumpAddress: \(jumpAddress))"
    }

    /// Check if this label has assigned value.
    ///
    /// Label without assigned value is not valid jump address.
    internal var isAssigned: Bool {
      return self.jumpAddress >= 0
    }
  }

  // MARK: - Names

  /// Predefined names to use for `CodeObjects`.
  public enum Names {
    public static let module = "<module>"
    public static let lambda = "<lambda>"
    public static let generatorExpression = "<genexpr>"
    public static let listComprehension = "<listcomp>"
    public static let setComprehension = "<setcomp>"
    public static let dictionaryComprehension = "<dictcomp>"
  }

  // MARK: - Properties

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
  /// First line in the source code.
  public let firstLine: SourceLine

  /// Instruction opcodes.
  /// CPython: `co_code`.
  public let instructions: [Instruction]
  /// Instruction locations.
  /// CPython: `co_lnotab` <- but not exactly the same.
  public let instructionLines: [SourceLine]

  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  /// CPython: `co_consts`.
  public let constants: [Constant]
  /// Names which aren’t covered by any of the other fields (they are not local
  /// variables, they are not free variables, etc) used by the bytecode.
  /// This includes names deemed to be in the global or builtin namespace
  /// as well as attributes (i.e., if you do foo.bar in a function, bar will
  /// be listed in its code object’s names).
  ///
  /// E.g. `LoadName 5` loads `self.names[5]` value.
  /// CPython: `co_names`.
  public let names: [String]
  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public let labels: [Label]

  /// Names of the local variables (including arguments).
  ///
  /// In the ‘richest’ case, `variableNames` contains (in order):
  /// - positional argument names (including optional ones)
  /// - keyword only argument names (again, both required and optional)
  /// - varargs argument name (i.e., *args)
  /// - keyword argument name (i.e., **kwargs)
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

  // MARK: - Init

  internal init(name: String,
                qualifiedName: String,
                filename: String,
                kind: Kind,
                flags: Flags,
                firstLine: SourceLine,
                instructions: [Instruction],
                instructionLines: [SourceLine],
                constants: [Constant],
                names: [String],
                labels: [Label],
                variableNames: [MangledName],
                freeVariableNames: [MangledName],
                cellVariableNames: [MangledName],
                argCount: Int,
                kwOnlyArgCount: Int) {
    self.name = name
    self.qualifiedName = qualifiedName
    self.filename = filename
    self.kind = kind
    self.flags = flags
    self.firstLine = firstLine
    self.instructions = instructions
    self.instructionLines = instructionLines
    self.constants = constants
    self.names = names
    self.labels = labels
    self.variableNames = variableNames
    self.freeVariableNames = freeVariableNames
    self.cellVariableNames = cellVariableNames
    self.argCount = argCount
    self.kwOnlyArgCount = kwOnlyArgCount
  }
}
