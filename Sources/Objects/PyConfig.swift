public struct PyConfig {

  /// First part of 128 bit `SipHash` key.
  /// Default key it is 'VioletEvergarden' in ASCII.
  public var hashKey0: UInt64 = 0x56696f6c65744576
  /// Second part of 128 bit `SipHash` key.
  /// Default key it is 'VioletEvergarden' in ASCII.
  public var hashKey1: UInt64 = 0x657267617264656e

  /// Default stream to read from.
  public var standardInput: FileDescriptorType
  /// Default stream to print to.
  public var standardOutput: FileDescriptorType
  /// Default stream for printing errors.
  public var standardError: FileDescriptorType

  public init(standardInput: FileDescriptorType,
              standardOutput: FileDescriptorType,
              standardError: FileDescriptorType) {
    self.standardInput = standardInput
    self.standardOutput = standardOutput
    self.standardError = standardError
  }
}
