public struct PyConfig {

  /// First part of 128 bit `SipHash` key.
  /// Default key it is 'VioletEvergarden' in ASCII.
  public var hashKey0: UInt64 = 0x56696f6c65744576
  /// Second part of 128 bit `SipHash` key.
  /// Default key it is 'VioletEvergarden' in ASCII.
  public var hashKey1: UInt64 = 0x657267617264656e

  /// Command line arguments
  public var arguments: Arguments
  /// These environment variables influence Python’s behavior,
  /// they are processed before the command-line switches other than `-E` or `-I`.
  ///
  /// It is customary that command-line switches override environmental variables
  /// where there is a conflict.
  public var environment: Environment

  /// Default stream to read from.
  public var standardInput: FileDescriptorType
  /// Default stream to print to.
  public var standardOutput: FileDescriptorType
  /// Default stream for printing errors.
  public var standardError: FileDescriptorType

  public init(
    arguments: Arguments,
    environment: Environment,
    standardInput: FileDescriptorType,
    standardOutput: FileDescriptorType,
    standardError: FileDescriptorType
  ) {
    self.arguments = arguments
    self.environment = environment
    self.standardInput = standardInput
    self.standardOutput = standardOutput
    self.standardError = standardError
  }
}
