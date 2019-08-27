import Core
import Parser
import Bytecode

// TODO: Use struct InstructionLocation = (index, line) - Objects/lnotab_notes
public struct CodeObject {

  /// Name of the class if the code is for a class.
  /// Name of the function if the code is for a function.
  /// Otherwise 'top'.
  public let name: String

  /// Instruction opcodes.
  public var instructions = [Instruction]()
  /// Instruction locations.
  public var instructionLines = [SourceLine]()

  /// Constants used.
  /// E.g. constant `5` has `constants[5]` value.
  public var constants = SmallArray<Constant>()
  /// List of strings (names used)
  public var names = SmallArray<String>()
  /// Absolute jump targets.
  /// E.g. label `5` will move us to `labels[5]` instruction.
  public var labels = SmallArray<Int>()

  /// Names of positional arguments
  public var argNames = [String]()
  /// *args or *
  public var varargs = Vararg.none
  public var kwonlyArgNames = [String]()
  /// **kwargs or **
  public var varKeywords = Vararg.none

  public init(name: String) {
    self.name = name
  }
}
