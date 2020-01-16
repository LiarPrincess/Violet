import Core
import Foundation

#warning("Remove this")
// swiftlint:disable:next implicitly_unwrapped_optional
private var fakeContext: PyContext!

// MARK: - Config

public struct PyConfig { }

// MARK: - Delegate

public protocol PyDelegate: AnyObject { }

// MARK: - Py

public let Py = PyInstance()

// swiftlint:disable:next type_name
public class PyInstance {

  // MARK: - Modules

  /// Python `builtins` module.
  public private(set) lazy var builtins: Builtins = {
    self.ensureInitialized()
    return Builtins(context: fakeContext)
  }()

  /// Python `sys` module.
  public private(set) lazy var sys: Sys = {
    self.ensureInitialized()
    return Sys(context: fakeContext)
  }()

  /// `self.builtins` but as a Python module (`PyModule`).
  public private(set) lazy var builtinsModule =
    ModuleFactory.createBuiltins(from: self.builtins)

  /// `self.sys` but as a Python module (`PyModule`).
  public private(set) lazy var sysModule =
    ModuleFactory.createSys(from: self.sys)

  // MARK: - Types

  public private(set) lazy var types: BuiltinTypes = {
    self.ensureInitialized()
    return BuiltinTypes(context: fakeContext)
  }()

  public private(set) lazy var errorTypes: BuiltinErrorTypes = {
    self.ensureInitialized()
    return BuiltinErrorTypes(context: fakeContext, types: self.types)
  }()

  // MARK: - Config & delegate

  private var _config: PyConfig?
  internal var config: PyConfig {
    if let c = self._config { return c }
    self.trapUninitialized()
  }

  private weak var _delegate: PyDelegate?
  internal var delegate: PyDelegate {
    if let d = self._delegate { return d }
    if self.isInitialized { trap("Py.delegate was deallocated!") }
    self.trapUninitialized()
  }

  // MARK: - Initialize

  private var isInitialized = false

  public func initialize(config: PyConfig, delegate: PyDelegate) {
    assert(!self.isInitialized, "Py was already initialized.")

    self._config = config
    self._delegate = delegate
    self.isInitialized = true

    // At this point everything should be initialized,
    // which means that from now on we are able to create PyObjects.
    // So let start with finishing our type hierarchy:
    self.types.fill__dict__()
    self.errorTypes.fill__dict__()
  }

  private func ensureInitialized() {
    if !self.isInitialized {
      self.trapUninitialized()
    }
  }

  private func trapUninitialized() -> Never {
    let fn = "Py.initialize(config:delegate:)"
    trap("Python context must first be initialized with '\(fn)'.")
  }
}
