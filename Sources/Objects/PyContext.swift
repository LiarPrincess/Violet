import Core
import Foundation

// MARK: - Config

public struct PyContextConfig {
  // Default hash key is 'VioletEvergarden' in ASCII
  public var hashKey0: UInt64 = 0x56696f6c65744576
  public var hashKey1: UInt64 = 0x657267617264656e

  public var stdout: StandardOutput = FileHandle.standardOutput

  public init() { }
}

public protocol PyContextDelegate: class {
  func open(file: String, mode: FileMode, type: FileType) -> PyResult<FileDescriptor>
  func open(fileno: Int32, mode: FileMode, type: FileType) -> PyResult<FileDescriptor>
}

// MARK: - Context

public class PyContext {

  internal let stdout: StandardOutput
  internal let hasher: Hasher

  public private(set) lazy var builtins = Builtins(context: self)
  public private(set) lazy var sys = Sys(context: self)

  private weak var _delegate: PyContextDelegate?
  internal var delegate: PyContextDelegate {
    if let d = self._delegate { return d }
    fatalError("Python context delegate was deallocated!")
  }

  public init(config: PyContextConfig, delegate: PyContextDelegate) {
    self.stdout = config.stdout
    self.hasher = Hasher(key0: config.hashKey0, key1: config.hashKey1)
    self._delegate = delegate

    // This is hack, but we can access `self.builtins` here because they are
    // annotated as `lazy` (even though they need `PyContext` in ctor).
    self.builtins.onContextFullyInitailized()
    self.sys.onContextFullyInitailized()
  }

  deinit {
    self.builtins.onContextDeinit()
    self.sys.onContextDeinit()
  }

  // MARK: - Intern ints

  private static let smallIntRange = -10...255

  private lazy var smallInts = PyContext.smallIntRange.map { PyInt(self, value: $0) }

  /// Get cached `int`.
  internal func getInterned(_ value: BigInt) -> PyInt? {
    guard let int = Int(exactly: value) else {
      return nil
    }

    return self.getInterned(int)
  }

  /// Get cached `int`.
  internal func getInterned(_ value: Int) -> PyInt? {
    guard PyContext.smallIntRange.contains(value) else {
      return nil
    }

    let index = value + Swift.abs(PyContext.smallIntRange.lowerBound)
    return self.smallInts[index]
  }

  // MARK: - Intern strings

  private lazy var internedStrings = [String:PyString]()

  /// Cache `str` representing given value.
  internal func intern(_ value: String) -> PyString {
    let object = PyString(self, value: value)
    self.internedStrings[value] = object
    return object
  }

  /// Get cached `str`.
  internal func getInterned(_ value: String) -> PyString? {
    return self.internedStrings[value]
  }
}
