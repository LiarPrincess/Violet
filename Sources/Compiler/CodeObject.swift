import Core
import Parser
import Bytecode

// TODO: To struct
public class CodeObject {

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
  public var names = [MangledName]()
  /// Absolute jump targets.
  /// E.g. label `5` will move us to instruction at `self.labels[5]` index.
  public var labels = [Int]()

  /// Names of positional arguments
  public var argNames = [String]()
  /// *args or *
  public var varargs = Vararg.none
  /// Names of keyword only arguments
  public var kwOnlyArgNames = [String]()
  /// **kwargs or **
  public var varKeywords = Vararg.none

  public init(name: String) {
    self.name = name
  }
}
