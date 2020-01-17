import Core
import Foundation

// MARK: - Config

public struct PyContextConfig {
  // Default hash key is 'VioletEvergarden' in ASCII
  public var hashKey0: UInt64 = 0x56696f6c65744576
  public var hashKey1: UInt64 = 0x657267617264656e

  public var standardInput: FileDescriptorType = FileDescriptor.standardInput
  public var standardOutput: FileDescriptorType = FileDescriptor.standardOutput
  public var standardError: FileDescriptorType = FileDescriptor.standardError

  public init() { }
}

// MARK: - Delegate

public protocol PyContextDelegate: AnyObject {
  /// Extension point for opening files.
  func open(fileno: Int32, mode: FileMode) -> PyResult<FileDescriptorType>
  /// Extension point for opening files.
  func open(file: String, mode: FileMode) -> PyResult<FileDescriptorType>
}

// MARK: - Context

public class PyContext {

  internal let config: PyContextConfig
  internal private(set) lazy var hasher = Hasher(key0: self.config.hashKey0,
                                                 key1: self.config.hashKey1)

  public private(set) lazy var builtins = Builtins()
  public private(set) lazy var sys = Sys()

  /// `self.builtins` but as a Python module (`PyModule`).
  public private(set)
  lazy var builtinsModule = ModuleFactory.createBuiltins(from: self.builtins)
  /// `self.sys` but as a Python module (`PyModule`).
  public private(set)
  lazy var sysModule = ModuleFactory.createSys(from: self.sys)

  private weak var _delegate: PyContextDelegate?
  internal var delegate: PyContextDelegate {
    if let d = self._delegate { return d }
    trap("Python context delegate was deallocated!")
  }

  public init(config: PyContextConfig, delegate: PyContextDelegate) {
    self.config = config
    self._delegate = delegate
  }
}
