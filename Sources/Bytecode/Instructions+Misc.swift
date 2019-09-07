extension Instruction {

  /// Maximum argument for an single instruction.
  public static let maxArgument = 0xff // (the same value as UInt8.max)

  /// Maximum argument for an instruction with 1x `extendedArg` before it.
  public static let maxExtendedArgument1 = 0xffff

  /// Maximum argument for an instruction with 2x `extendedArg` before it.
  public static let maxExtendedArgument2 = 0xff_ffff

  /// Maximum argument for an instruction with 3x `extendedArg` before it.
  public static let maxExtendedArgument3 = 0xffff_ffff
}

public struct FunctionFlags: OptionSet, Equatable {

  public let rawValue: UInt8

  public static let hasPositionalArgDefaults = FunctionFlags(rawValue: 0x01)
  public static let hasKwOnlyArgDefaults = FunctionFlags(rawValue: 0x02)
  public static let hasAnnotations = FunctionFlags(rawValue: 0x04)
  public static let hasFreeVariables = FunctionFlags(rawValue: 0x08)

  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }
}
