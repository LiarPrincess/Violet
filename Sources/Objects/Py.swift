import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length

/// `Py` represents a `Python` context.
///
/// You can use it to interact with `Python` objects.
/// For example: to call `getattr` function on `elsa` instance you call
/// `Py.getattr(object: elsa, name: "let_it_go")`.
///
/// # Global variable
/// `Py` is a global variable .
/// Yes, we know it is bad (at least that's whay they say in every programming
/// book/manual).
/// The thing is that it is way easier to use than alternative.
///
/// And the alternative would be to pass additional `py` parameter to every
/// function that needs to act on context.
/// The thing is: 95% of our functions (in `Objects` module) need to call some
/// `Python` function (directly on indirectly).
/// And having this artificial parameter would be a pure boilerplate
/// (in addition to our usual error handling boilerplate).
///
/// I would argue that at this point just making it global is an acceptable
/// trade-off/simplification.
///
/// Btw. in some early version of `Objects` we actually had `PyContext` type
/// that we passed to every function (or injected in `ctor`).
/// The user/programmer experience was... not that great.
/// Most notably in functions which had 2 `PyObject` arguments that could
/// potentially come from 2 different `PyContexts`. In such case we had to decide
/// if we want to allocate result object (think `3` in `1 + 2 = 3`)
/// in context of object `1` or `2`. Now we just use global `Py` context.
///
/// # Instance vs static
/// `Py` is heap-allocated instance of `PyInstance` class.
/// There is an interesting aternative of making `Py` static:
/// ```Swift
/// public enum Py {
///   public static func getattr() { thingies... }
/// ).
/// ```
///
/// So, lets talk about this  (spoiler: both models are 'ok', we use instance
/// because we started this way, we may transition to `static` at some point).
///
/// ## Instance (current model)
/// Pros:
/// - we can have multiple `PyInstances` at the same time (for example 1 per thread)
/// - encapsulation? object-orientation fetish? (because we need to have dem
///   instances?)
///
/// We use it mostly because in early days we had `PyContext` instance passed
/// to every function (or injected in `ctor`).
/// Then we moved to global `Py`, so naturally we made `Py` also an instance.
/// Making it static would require bigger mental-leap.
///
/// And about that 'multiple `PyInstances`', we can do following:
/// ```Swift
/// public var Py: PyInstance {
///   // get `PyInstance` from thread local storage (TLS) or something, idk...
/// }
/// ```
///
/// That would allow us to have `Py` per thread.
/// Not really sure what we would use this for, but we can.
/// (maybe multi-threaded testing? but we can just `fork` to run each test in
/// separate process, we don't really  have app domains from `.Net`.).
///
/// ## Static
/// Pros:
/// - easier mental model
/// - faster? - but we don't care about this
///
/// That would require us to make some code changes.
/// Not only in `Py` but also in other types.
///
/// For example we could make `BuiltinTypes` an `enum` a with static property for
/// each type.
/// For source compatibility we would make `Py.types` property an `typealias`.
/// Note that, even though `BuiltinTypes` will be `static`, the types itself will
/// still be allocated on a heap (although semantic-wise types are reference types,
/// so it kind of makes sense).
///
/// ## Note about 'heap types'
/// (this is partially connected to 'Instance vs static' debate)
///
/// Heap type is a type created by user with 'class' statement
/// (see 'Generated/HeapTypes.swift' for more details).
///
/// This name comes from `CPython`.
/// Opposite of 'heap type' is 'builtin type' that uses static allocation
/// (I'm talking about core `CPython` and not about extensions).
/// Example (for `int` type defined in 'Objects/longobject.c'):
/// ```C
/// PyTypeObject PyLong_Type = {
///   PyVarObject_HEAD_INIT(&PyType_Type, 0)
///   "int",                                      /* tp_name */
///   ... (and so on...)
/// }
/// ```
///
/// In `Violet` all of the types are heap-allocated (even builtin ones).
/// But, we will still use 'heap-type' name with the same meaning as in `CPython`.
/// Partially because they leak 'heap-type' implementation-detail in error
/// messages, so we assume that this is part of the lingo.
public private(set) var Py = PyInstance()

/// Read `Py` documentation.
public final class PyInstance {

  // MARK: - Builtins

  /// Interned `true` value.
  public private(set) lazy var `true` = PyBool(value: true)
  /// Interned `false` value.
  public private(set) lazy var `false` = PyBool(value: false)
  /// Interned `None` value.
  public private(set) lazy var none = PyNone()
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

  /// Container for all of the non-error Python types (as `PyType` instances).
  public private(set) lazy var types: BuiltinTypes = {
    self.ensureInitialized()
    return BuiltinTypes()
  }()

  /// Container for all of the error Python types (as `PyType` instances).
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
    if let f = self._fileSystem { return f }
    if self.isInitialized { trap("Py.fileSystem was deallocated!") }
    self.trapUninitialized()
  }

  // MARK: - Init

  fileprivate init() {}

  // MARK: - Initialize

  public var isInitialized: Bool {
    return self._config != nil
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
    assert(self.isInitialized)

    // At this point everything should be initialized,
    // which means that from now on we are able to create PyObjects.
    // So let start with creating our type hierarchy
    // (but only hierarchy, we will fill '__dict__' later):
    _ = self.types
    _ = self.errorTypes

    // Now we have 'Py.types.str' which means that we can create 'IdStrings'
    IdString.initialize()

    // Filling '__dict__' may use 'IdString', so there may be a dependency here
    // (probably, I don't know, it is safer to do it in this order).
    self.types.fill__dict__()
    self.errorTypes.fill__dict__()

    // And now modules.
    // Note that property getter will create module which will also fill '__dict__'
    // (because we now can - we have basic types).
    let builtinModules = [
      self.builtinsModule,
      self.sysModule,
      self._impModule,
      self._warningsModule,
      self._osModule
    ]

    self.sys.setBuiltinModules(modules: builtinModules)
  }

  private func ensureInitialized() {
    if !self.isInitialized {
      self.trapUninitialized()
    }
  }

  private func trapUninitialized() -> Never {
    let fn = "Py.initialize(config:delegate:fileSystem:)"
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
    // Clean circular references.
    // This is VERY IMPORTANT because:
    // 1. 'type' inherits from 'object'
    //     both 'type' and 'object' are instances of 'type'
    // 2. 'Type' type has 'BuiltinFunction' attributes which reference 'Type'.
    for type in self.types.all {
      type.gcClean()
    }

    for type in self.errorTypes.all {
      type.gcClean()
    }

    // And also modules:
    self.builtinsModule.gcClean()
    self.sysModule.gcClean()
    self._impModule.gcClean()
    self._warningsModule.gcClean()
    self._osModule.gcClean()

    // Ids:
    IdString.gcClean()

    // TODO: Uncomment this when we have GC.
    // weak var old = Py
    // weak var builtins = Py.builtinsModule
    // weak var sys = Py.sysModule

    // We always need an instance (even if uninitalized)
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
  internal func getInterned(int: BigInt) -> PyInt? {
    guard let int = Int(exactly: int) else {
      return nil
    }

    return self.getInterned(int: int)
  }

  /// Get cached `int`.
  /// Note that not all of the `ints` are interned.
  /// Only some of them, from a verry narrow range.
  internal func getInterned(int: Int) -> PyInt? {
    guard PyInstance.smallIntRange.contains(int) else {
      return nil
    }

    let index = int + Swift.abs(PyInstance.smallIntRange.lowerBound)
    return self.smallInts[index]
  }

  // MARK: - Intern strings

  private var internedStrings = [UseScalarsToHashString: PyString]()

  /// Get cached `PySString` value for given `String`.
  public func getInterned(string: String) -> PyString? {
    // Note that most of the time when it is invoked in the code (by us)
    // it is called on SHORT string.
    // So, even if later it has to be hashed again
    // (first for Swift dict, and then later to be used as key in 'PyDict')
    // the performance hit should be negligible
    // (also the whole string will already be in CPU cache, maybe, probably...).
    let key = UseScalarsToHashString(string)
    return self.getInterned(key: key)
  }

  private func getInterned(key: UseScalarsToHashString) -> PyString? {
    return self.internedStrings[key]
  }

  /// Cache given string and return it.
  ///
  /// If it is already in cache then it will return interned value.
  public func intern(scalar: UnicodeScalar) -> PyString {
    return self.intern(string: String(scalar))
  }

  /// Cache given string and return it.
  ///
  /// If it is already in cache then it will return interned value.
  public func intern(string: String) -> PyString {
    let key = UseScalarsToHashString(string)

    if let interned = self.getInterned(key: key) {
      return interned
    }

    let str = self.newString(string)
    internedStrings[key] = str
    return str
  }
}
