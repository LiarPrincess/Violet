public protocol FileSystemType {

  /// Open file with given `fileno`.
  func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType>
  /// Open file at given `path`.
  func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType>
}

public struct PyConfig {

  /// First part of 128 bit SipHash key.
  /// Default key it is 'VioletEvergarden' in ASCII.
  public var hashKey0: UInt64 = 0x56696f6c65744576
  /// Second part of 128 bit SipHash key.
  /// Default key it is 'VioletEvergarden' in ASCII.
  public var hashKey1: UInt64 = 0x657267617264656e

  public var standardInput: FileDescriptorType = FileDescriptor.standardInput
  public var standardOutput: FileDescriptorType = FileDescriptor.standardOutput
  public var standardError: FileDescriptorType = FileDescriptor.standardError

  public var fileSystem: FileSystemType

  public init(fileSystem: FileSystemType) {
    self.fileSystem = fileSystem
  }
}
