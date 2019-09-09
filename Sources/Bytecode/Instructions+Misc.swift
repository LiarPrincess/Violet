extension Instruction {

  public static let byteSize = 2

  /// Maximum argument for an single instruction.
  public static let maxArgument = 0xff // (the same value as UInt8.max)

  /// Maximum argument for an instruction with 1x `extendedArg` before it.
  public static let maxExtendedArgument1 = 0xffff

  /// Maximum argument for an instruction with 2x `extendedArg` before it.
  public static let maxExtendedArgument2 = 0xff_ffff

  /// Maximum argument for an instruction with 3x `extendedArg` before it.
  public static let maxExtendedArgument3 = 0xffff_ffff
}
