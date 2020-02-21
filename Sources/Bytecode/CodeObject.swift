import Core

public enum CodeObjectType {
  case module
  case `class`
  case function
  case asyncFunction
  case lambda
  case comprehension
}

public struct CodeObjectFlags: OptionSet {
  public let rawValue: UInt16

  public static let optimized   = CodeObjectFlags(rawValue: 0x0001)
  public static let newLocals   = CodeObjectFlags(rawValue: 0x0002)
  public static let varArgs     = CodeObjectFlags(rawValue: 0x0004)
  public static let varKeywords = CodeObjectFlags(rawValue: 0x0008)
  public static let nested      = CodeObjectFlags(rawValue: 0x0010)
  public static let generator   = CodeObjectFlags(rawValue: 0x0020)
  public static let noFree      = CodeObjectFlags(rawValue: 0x0040)
  public static let coroutine         = CodeObjectFlags(rawValue: 0x0080)
  public static let iterableCoroutine = CodeObjectFlags(rawValue: 0x0100)
  public static let asyncGenerator    = CodeObjectFlags(rawValue: 0x0200)

  public init(rawValue: UInt16) {
    self.rawValue = rawValue
  }
}

public final class CodeObject {

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
  /// Name of the file that this code object was loaded from.
  public let filename: String

  /// Type of the code object.
  /// Possible values are: module, class, (async)function, lambda and comprehension.
  public let type: CodeObjectType
  /// Various flags used during the compilation process.
  public let flags: CodeObjectFlags
  /// First source line number
  public let firstLine: SourceLine

  /// Instruction opcodes.
  public internal(set) var instructions = [Instruction]()
  /// Instruction locations.
  public internal(set) var instructionLines = [SourceLine]()

  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  public internal(set) var constants = [Constant]()
  /// List of strings (names used).
  /// E.g. `LoadName 5` loads `self.names[5]` value.
  public internal(set) var names = [String]()
  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public internal(set) var labels = [Int]()

  /// List of local variable names (from SymbolTable).
  public internal(set) var varNames: [MangledName]
  /// List of free variable names (from SymbolTable).
  public let freeVars: [MangledName]
  /// List of cell variable names (from SymbolTable).
  public let cellVars: [MangledName]

  /// Arguments, except `*args`.
  /// CPython: `co_argcount`.
  public let argCount: Int
  /// Keyword only arguments.
  /// CPython: `co_kwonlyargcount`.
  public let kwOnlyArgCount: Int

  public init(name: String,
              qualifiedName: String,
              filename: String,
              type: CodeObjectType,
              flags: CodeObjectFlags,
              varNames: [MangledName],
              freeVars: [MangledName],
              cellVars: [MangledName],
              argCount: Int,
              kwOnlyArgCount: Int,
              firstLine: SourceLine) {
    self.name = name
    self.qualifiedName = qualifiedName
    self.filename = filename
    self.type = type
    self.flags = flags
    self.varNames = varNames
    self.freeVars = freeVars
    self.cellVars = cellVars
    self.argCount = argCount
    self.kwOnlyArgCount = kwOnlyArgCount
    self.firstLine = firstLine
  }
}
