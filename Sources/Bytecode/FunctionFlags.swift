public struct FunctionFlags: OptionSet, Equatable {

  public let rawValue: UInt8

  /// 0x01
  public static let hasPositionalArgDefaults = FunctionFlags(rawValue: 0x01)
  /// 0x02
  public static let hasKwOnlyArgDefaults = FunctionFlags(rawValue: 0x02)
  /// 0x04
  public static let hasAnnotations = FunctionFlags(rawValue: 0x04)
  /// 0x08
  public static let hasFreeVariables = FunctionFlags(rawValue: 0x08)

  public init(rawValue: UInt8) {
    self.rawValue = rawValue
  }
}
