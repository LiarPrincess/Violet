import FileSystem

public struct PyConfig {

  /// First part of 128 bit `SipHash` key.
  /// Default key it is 'VioletEvergarden' in ASCII.
  public var hashKey0: UInt64 = 0x5669_6f6c_6574_4576
  /// Second part of 128 bit `SipHash` key.
  /// Default key it is 'VioletEvergarden' in ASCII.
  public var hashKey1: UInt64 = 0x6572_6761_7264_656e

  /// Command line arguments
  public var arguments: Arguments
  /// These environment variables influence Python’s behavior.
  ///
  /// It is customary that command-line switches override environmental variables
  /// where there is a conflict.
  public var environment: Environment

  /// A string giving the absolute path of the executable binary for the Python
  /// interpreter.
  ///
  /// Used for `sys.executable` and `sys.path`.
  public var executablePath: Path

  /// Default stream to read from.
  public var standardInput: PyFileDescriptorType
  /// Default stream to print to.
  public var standardOutput: PyFileDescriptorType
  /// Default stream to print errors to.
  public var standardError: PyFileDescriptorType

  public struct Sys {

    /// Value to use as initial `sys.path`.
    ///
    /// If `nil`: it will use default `Python` logic to obtain value.
    /// Example usage: avoid file system access in unit tests.
    public var path: [Path]?
    // swiftlint:disable:previous discouraged_optional_collection

    /// Value to use as initial `sys.prefix`.
    ///
    /// If `nil` it will use default `Python` logic to obtain value.
    /// Example usage: avoid file system access in unit tests.
    public var prefix: Path?
  }

  /// Values used when initializing `sys`.
  ///
  /// You can use it to override default logic.
  /// Example usage: avoid file system access in unit tests.
  public var sys = Sys()

  public init(
    arguments: Arguments,
    environment: Environment,
    executablePath: Path,
    standardInput: PyFileDescriptorType,
    standardOutput: PyFileDescriptorType,
    standardError: PyFileDescriptorType
  ) {
    self.arguments = arguments
    self.environment = environment
    self.executablePath = executablePath
    self.standardInput = standardInput
    self.standardOutput = standardOutput
    self.standardError = standardError
  }
}
