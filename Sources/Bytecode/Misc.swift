/// Used for implementing formatted literal strings (f-strings).
///
/// Our oparg encodes 2 pieces of information: the conversion
/// character, and whether or not a format_spec was provided.
///
/// Convert the conversion char to 2 bits:
/// ```c
/// None: 000  0x0  FVC_NONE
/// !s  : 001  0x1  FVC_STR
/// !r  : 010  0x2  FVC_REPR
/// !a  : 011  0x3  FVC_ASCII
/// ```
///
/// next bit is whether or not we have a format spec:
/// ```c
/// yes : 100  0x4
/// no  : 000  0x0
/// ```
public enum FormattedValueMasks {
  public static let conversionNone:  UInt8 = 0b000
  public static let conversionStr:   UInt8 = 0b001
  public static let conversionRepr:  UInt8 = 0b010
  public static let conversionASCII: UInt8 = 0b011
  public static let hasFormat:       UInt8 = 0b100
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
