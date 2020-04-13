import Core
import Foundation

public private(set) var Py = PyInstance()

public final class PyInstance {

  // MARK: - Builtins

  /// Interned `true` value.
  public private(set) lazy var `true`  = PyBool(value: true)
  /// Interned `false` value.
  public private(set) lazy var `false` = PyBool(value: false)
  /// Interned `None` value.
  public private(set) lazy var none  = PyNone()
  /// Interned `ellipsis (...)` value.
  public private(set) lazy var ellipsis = PyEllipsis()
  /// Interned empty `tuple` value (because `tuple` is immutable).
  public private(set) lazy var emptyTuple = PyTuple(elements: [])
  /// Interned empty `str` value (because `str` is immutable).
  public private(set) lazy var emptyString = PyString(value: "")
  /// Interned empty `bytes` value (because `bytes` are immutable).
  public private(set) lazy var emptyBytes = PyBytes(value: Data())
  /// Interned empty `frozenset` value (because `frozenset` is immutable).
  public private(set) lazy var emptyFrozenSet = PyFrozenSet()
  /// Interned `NotImplemented` value.
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

  /// Python `_warnings` module.
  public private(set) lazy var _warnings: UnderscoreWarnings = {
    self.ensureInitialized()
    return UnderscoreWarnings()
  }()

  /// Python `_os` module.
  public private(set) lazy var _os: UnderscoreOS = {
    self.ensureInitialized()
    return UnderscoreOS()
  }()

  /// `self.builtins` but as a Python module (`PyModule`).
  public private(set) lazy var builtinsModule = self.builtins.createModule()

  /// `self.sys` but as a Python module (`PyModule`).
  public private(set) lazy var sysModule = self.sys.createModule()

  /// `self._imp` but as a Python module (`PyModule`).
  public private(set) lazy var _impModule = self._imp.createModule()

  /// `self._warnings` but as a Python module (`PyModule`).
  public private(set) lazy var _warningsModule = self._warnings.createModule()

  /// `self._os` but as a Python module (`PyModule`).
  public private(set) lazy var _osModule = self._os.createModule()

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
  public var config: PyConfig {
    if let c = self._config { return c }
    self.trapUninitialized()
  }

  private weak var _delegate: PyDelegate?
  public var delegate: PyDelegate {
    if let d = self._delegate { return d }
    if self.isInitialized { trap("Py.delegate was deallocated!") }
    self.trapUninitialized()
  }

  private weak var _fileSystem: PyFileSystem?
  public var fileSystem: PyFileSystem {
    if let c = self._fileSystem { return c }
    if self.isInitialized { trap("Py.fileSystem was deallocated!") }
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
    self._warningsModule.gcClean()
    self._osModule.gcClean()
  }

  // MARK: - Initialize

  private var isInitialized: Bool {
    return self._config != nil && self._delegate != nil
  }

  /// Configure `Py` instance.
  ///
  /// This function **has** to be called before any other call!
  public func initialize(
    config: PyConfig,
    delegate: PyDelegate,
    fileSystem: PyFileSystem
  ) {
    precondition(!self.isInitialized, "Py was already initialized.")

    self._config = config
    self._delegate = delegate
    self._fileSystem = fileSystem

    // At this point everything should be initialized,
    // which means that from now on we are able to create PyObjects.
    // So let start with finishing our type hierarchy:
    self.types.fill__dict__()
    self.errorTypes.fill__dict__()

    // And now modules.
    // Note that property getter will create module which will also fill '__dict__'
    // (because we now can - we have basic types).
    self.sys.setBuiltinModules(
      self.builtinsModule,
      self.sysModule,
      self._impModule,
      self._warningsModule,
      self._osModule
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
    // TODO: Uncomment this when we have GC.
    // weak var old = Py
    // weak var builtins = Py.builtinsModule
    // weak var sys = Py.sysModule

    // Assigning new instance will 'deinit' old one.
    Py = PyInstance()

    // assert(old == nil, "Memory leak!")
    // assert(builtins == nil, "Memory leak!")
    // assert(sys == nil, "Memory leak!")
  }

  // MARK: - Intern integers

  private static let smallIntRange = -10...255

  private lazy var smallInts = PyInstance.smallIntRange.map { PyInt(value: $0) }

  /// Get cached `int`.
  /// Note that not all of the `ints` are interned.
  /// Only some of them, from a verry narrow range.
  internal func getInterned(_ value: BigInt) -> PyInt? {
    guard let int = Int(exactly: value) else {
      return nil
    }

    return self.getInterned(int)
  }

  /// Get cached `int`.
  /// Note that not all of the `ints` are interned.
  /// Only some of them, from a verry narrow range.
  internal func getInterned(_ value: Int) -> PyInt? {
    guard PyInstance.smallIntRange.contains(value) else {
      return nil
    }

    let index = value + Swift.abs(PyInstance.smallIntRange.lowerBound)
    return self.smallInts[index]
  }

  // MARK: - Intern strings

  private var internedStrings = [UseScalarsToHashString:PyString]()

  /// Get cached `PySString` value for given `String`.
  public func getInterned(_ value: String) -> PyString? {
    // Note that most of the time when it is invoked in the code (by us)
    // it is called on SHORT string.
    // So, even if later it has to be hashed again
    // (first for Swift dict, and then later to be used as key in 'PyDict')
    // the performance hit should be negligible
    // (also the whole string will already be in CPU cache, maybe, probably...).
    let key = UseScalarsToHashString(value)
    return self.internedStrings[key]
  }

  /// Cache given string and return it.
  ///
  /// If it is already in cache then it will return interned value.
  public func intern(_ value: String) -> PyString {
    if let interned = self.getInterned(value) {
      return interned
    }

    let str = self.newString(value)
    let key = UseScalarsToHashString(value)
    internedStrings[key] = str
    return str
  }
}
