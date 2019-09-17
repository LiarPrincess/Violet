import Core

public enum CodeObjectType {
  case module
  case `class`
  case function
  case asyncFunction
  case lambda
  case comprehension
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

  /// Type of the code object.
  /// Possible values are: module, class, (async)function, lambda and comprehension.
  public let type: CodeObjectType
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
  public let varNames: [MangledName]
  /// List of free variable names (from SymbolTable).
  public let freeVars: [MangledName]
  /// List of cell variable names (from SymbolTable).
  public let cellVars: [MangledName]

  public init(name: String,
              qualifiedName: String,
              type: CodeObjectType,
              varNames: [MangledName],
              freeVars: [MangledName],
              cellVars: [MangledName],
              firstLine: SourceLine) {
    self.name = name
    self.qualifiedName = qualifiedName
    self.type = type
    self.varNames = varNames
    self.freeVars = freeVars
    self.cellVars = cellVars
    self.firstLine = firstLine
  }
}
