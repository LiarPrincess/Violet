import Core
import Parser
import Bytecode

public enum VarargName {
  /// Separator for keyword arguments. Represented by just `*`.
  case unnamed
  case named(String)
}

// TODO: To struct
public final class CodeObject {

  /// Name of the class if the code is for a class.
  /// Name of the function if the code is for a function.
  /// Otherwise 'top'.
  public let name: String

  /// Instruction opcodes.
  public var instructions = [Instruction]()
  /// Instruction locations.
  public var instructionLines = [SourceLine]()
  // TODO: ^ Use struct InstructionLocation = (index, line) - Objects/lnotab_notes

  /// Constants used.
  /// E.g. `LoadConst 5` loads `self.constants[5]` value.
  public var constants = [Constant]()
  /// List of strings (names used).
  /// E.g. `LoadName 5` loads `self.names[5]` value.
  public var names = [String]()
  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public var labels = [Int]()

  /// Names of positional arguments
  public var argNames: [String]?
  /// *args or *
  public var varargs: VarargName?
  /// Names of keyword only arguments
  public var kwOnlyArgNames: [String]?
  /// **kwargs or ** (CPython: varKeywords)
  public var kwargs: String?

  public init(name: String) {
    self.name = name
  }
}
