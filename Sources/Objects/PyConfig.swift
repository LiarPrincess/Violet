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

  /// A string giving the absolute path of the executable binary for the Python
  /// interpreter.
  ///
  /// Used for `sys.executable` and `sys.path`.
  public var executablePath: String

  /// Default stream to read from.
  public var standardInput: FileDescriptorType
  /// Default stream to print to.
  public var standardOutput: FileDescriptorType
  /// Default stream for printing errors.
  public var standardError: FileDescriptorType

  public init(
    arguments: Arguments,
    environment: Environment,
    executablePath: String,
    standardInput: FileDescriptorType,
    standardOutput: FileDescriptorType,
    standardError: FileDescriptorType
  ) {
    self.arguments = arguments
    self.environment = environment
    self.executablePath = executablePath
    self.standardInput = standardInput
    self.standardOutput = standardOutput
    self.standardError = standardError
  }
}
