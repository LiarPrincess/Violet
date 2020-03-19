import Core
import Foundation

public private(set) var Py = PyInstance()

public class PyInstance: BuiltinFunctions {

  // MARK: - Builtins

  public private(set) lazy var `true`  = PyBool(value: true)
  public private(set) lazy var `false` = PyBool(value: false)
  public private(set) lazy var none  = PyNone()
  public private(set) lazy var ellipsis = PyEllipsis()
  public private(set) lazy var emptyTuple = PyTuple(elements: [])
  public private(set) lazy var emptyString = PyString(value: "")
  public private(set) lazy var emptyBytes = PyBytes(value: Data())
  public private(set) lazy var emptyFrozenSet = PyFrozenSet()
  public private(set) lazy var notImplemented = PyNotImplemented()

  // MARK: - Modules

  /// Python `builtins` module.
  public private(set) lazy var builtins: Builtins = {
    self.ensureInitialized()
    return Builtins()
  }()

  /// Python `sys` module.
  public private(set) lazy var sys: Sys = {
    self.ensureInitialized()
    return Sys()
  }()

  /// Python `_imp` module.
  public private(set) lazy var _imp: UnderscoreImp = {
    self.ensureInitialized()
    return UnderscoreImp()
  }()

  /// `self.builtins` but as a Python module (`PyModule`).
  public private(set) lazy var builtinsModule =
    ModuleFactory.createBuiltins(from: self.builtins)

  /// `self.sys` but as a Python module (`PyModule`).
  public private(set) lazy var sysModule =
    ModuleFactory.createSys(from: self.sys)

  /// `self._imp` but as a Python module (`PyModule`).
  public private(set) lazy var _impModule =
    ModuleFactory.createUnderscoreImp(from: self._imp)

  // MARK: - Types

  public private(set) lazy var types: BuiltinTypes = {
    self.ensureInitialized()
    return BuiltinTypes()
  }()

  public private(set) lazy var errorTypes: BuiltinErrorTypes = {
    self.ensureInitialized()
    return BuiltinErrorTypes()
  }()

  // MARK: - Hasher

  internal lazy var hasher = Hasher(key0: self.config.hashKey0,
                                    key1: self.config.hashKey1)

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

  // MARK: - Init/deinit

  fileprivate init() { }

  deinit {
    // Clean circular references.
    // This is VERY IMPORTANT because:
    // 1. 'type' inherits from 'object'
    //    both 'type' and 'object' are instances of 'type'
    // 2. 'Type' type has 'BuiltinFunction' attributes which reference 'Type'.
    for type in self.types.all {
      type.gcClean()
    }

    for type in self.errorTypes.all {
      type.gcClean()
    }

    // Ids:
    IdString.gcClean()

    // And also modules:
    self.builtinsModule.gcClean()
    self.sysModule.gcClean()
    self._impModule.gcClean()
  }

  // MARK: - Initialize

  private var isInitialized: Bool {
    return self._config != nil && self._delegate != nil
  }

  /// Configure `Py` instance.
  ///
  /// This function **has** to be called before any other call!
  public func initialize(config: PyConfig, delegate: PyDelegate) {
    precondition(!self.isInitialized, "Py was already initialized.")

    self._config = config
    self._delegate = delegate

    // At this point everything should be initialized,
    // which means that from now on we are able to create PyObjects.
    // So let start with finishing our type hierarchy:
    self.types.fill__dict__()
    self.errorTypes.fill__dict__()

    // Now finish modules:
    self.sys.setBuiltinModules(modules:
      self.builtinsModule,
      self.sysModule,
      self._impModule
    )
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

  // MARK: - Destroy

  /// Destroy `Py` instance.
  ///
  /// You don't actually need to call this method.
  /// `Py` will be destroyed when the program exists.
  ///
  /// But....
  /// You can use this to reinitialize `Py` (note that you will have to call
  /// `Py.initialize(config:,delegate:)` again).
  public func destroy() {
    // Assigning new instance will 'deinit' old one.
    Py = PyInstance()
  }

  // MARK: - Intern integers

  private static let smallIntRange = -10...255

  private lazy var smallInts = PyInstance.smallIntRange.map { PyInt(value: $0) }

  /// Get cached `int`.
  internal func getInterned(_ value: BigInt) -> PyInt? {
    guard let int = Int(exactly: value) else {
      return nil
    }

    return self.getInterned(int)
  }

  /// Get cached `int`.
  internal func getInterned(_ value: Int) -> PyInt? {
    guard PyInstance.smallIntRange.contains(value) else {
      return nil
    }

    let index = value + Swift.abs(PyInstance.smallIntRange.lowerBound)
    return self.smallInts[index]
  }

  // MARK: - Intern strings

  private var internedString = [String:PyString]()

  public func getInterned(_ value: String) -> PyString {
    if let interned = self.internedString[value] {
      return interned
    }

    let str = self.newString(value)
    internedString[value] = str
    return str
  }
}
