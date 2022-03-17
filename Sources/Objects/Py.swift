import Foundation
import BigInt
import FileSystem
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore longobject

/// `Py` represents a `Python` context.
///
/// You can use it to interact with `Python` objects.
/// For example: to call `getattr` function on `elsa` object you call
/// `Py.getAttribute(object: elsa, name: "let_it_go")`.
public final class Py {

  // MARK: - Builtins

  /// Interned `true` value.
  public private(set) var `true`: PyBool!
  /// Interned `false` value.
  public private(set) var `false`: PyBool!
  /// Interned `None` value.
  public private(set) var none: PyNone!
  /// Interned `NotImplemented` value.
  public private(set) var notImplemented: PyNotImplemented!
  /// Interned `ellipsis (...)` value.
  public private(set) var ellipsis: PyEllipsis!
  /// Interned empty `tuple` value (because `tuple` is immutable).
  public private(set) var emptyTuple: PyTuple!
  /// Interned empty `str` value (because `str` is immutable).
  public private(set) var emptyString: PyString!
  /// Interned empty `bytes` value (because `bytes` are immutable).
  public private(set) var emptyBytes: PyBytes!
  /// Interned empty `frozenset` value (because `frozenset` is immutable).
  public private(set) var emptyFrozenSet: PyFrozenSet!

  /// Cached `int` instances, so that we don't create `0/1/2` etc. multiple times.
  private var internedInts: [PyInt]!
  /// Cached `str` instances, so that we don't create common instances multiple times.
  private var internedStrings = [UseScalarsToHashString: PyString]()

  // MARK: - Modules

  /// Python `builtins` module.
  public private(set) var builtins: Builtins!
  /// Python `sys` module.
  public private(set) var sys: Sys!
  /// Python `_imp` module.
  public private(set) var _imp: UnderscoreImp!
  /// Python `_warnings` module.
  public private(set) var _warnings: UnderscoreWarnings!
  /// Python `_os` module.
  public private(set) var _os: UnderscoreOS!

  /// `self.builtins` but as a Python module (`PyModule`).
  public private(set) var builtinsModule: PyModule!
  /// `self.sys` but as a Python module (`PyModule`).
  public private(set) var sysModule: PyModule!
  /// `self._imp` but as a Python module (`PyModule`).
  public private(set) var _impModule: PyModule!
  /// `self._warnings` but as a Python module (`PyModule`).
  public private(set) var _warningsModule: PyModule!
  /// `self._os` but as a Python module (`PyModule`).
  public private(set) var _osModule: PyModule!

  // MARK: - Types

  /// Container for all of the non-error Python types (as `PyType` instances).
  public private(set) var types: Py.Types
  /// Container for all of the error Python types (as `PyType` instances).
  public private(set) var errorTypes: Py.ErrorTypes

  // MARK: - Config, delegate, hasher

  public let config: PyConfig
  public let delegate: PyDelegate
  public let fileSystem: PyFileSystem

  public let memory: PyMemory
  internal let hasher: Hasher
  public private(set) var cast: PyCast!

  // MARK: - Init

  public init(config: PyConfig,
              delegate: PyDelegate,
              fileSystem: PyFileSystem) {
    checkInvariants()
    self.config = config
    self.delegate = delegate
    self.fileSystem = fileSystem

    self.memory = PyMemory()
    self.hasher = Hasher(key0: config.hashKey0, key1: config.hashKey1)

    // At this point everything should be initialized,
    // which means that from now on we are able to create PyObjects.
    // Since every object contains a pointer to its 'type',
    // the first thing that we have to do is to create a type hierarchy
    // (but only hierarchy, we will fill '__dict__' later):
    self.types = Types(memory: self.memory)
    self.errorTypes = ErrorTypes(memory: self.memory,
                                 typeType: self.types.type,
                                 objectType: self.types.object)

    // Now since we have all types in place we can start creating some more
    // interesting instances, for example docs/methods/properties on those types:
    self.types.fill__dict__(self)
    self.errorTypes.fill__dict__(self)

    // Since we have types we can start doing unholy things to them:
    self.cast = PyCast(types: self.types, errorTypes: self.errorTypes)

    // Predefined commonly used '__dict__' keys:
//    IdString.initialize()

    let types = self.types
    self.true = self.memory.newBool(self, type: types.bool, value: true)
    self.false = self.memory.newBool(self, type: types.bool, value: false)
    self.none = self.memory.newNone(self, type: types.none)
    self.notImplemented = self.memory.newNotImplemented(self, type: types.notImplemented)
    self.ellipsis = self.memory.newEllipsis(self, type: types.ellipsis)
    self.emptyTuple = self.memory.newTuple(self, type: types.tuple, elements: [])
    self.emptyString = self.memory.newString(self, type: types.str, value: "")
    self.emptyBytes = self.memory.newBytes(self, type: types.bytes, elements: .init())
    self.emptyFrozenSet = self.memory.newFrozenSet(self, type: types.frozenset, elements: .init())

    self.internedInts = Self.internedIntRange.map { int in
      self.memory.newInt(self, type: types.int, value: BigInt(int))
    }

    self.builtins = Builtins(self)
    self.sys = Sys(self)
    self._imp = UnderscoreImp(self)
    self._warnings = UnderscoreWarnings(self)
    self._os = UnderscoreOS(self)

    self.builtinsModule = self.builtins.createModule()
    self.sysModule = self.sys.createModule()
    self._impModule = self._imp.createModule()
    self._warningsModule = self._warnings.createModule()
    self._osModule = self._os.createModule()

    self.sys.setBuiltinModules(modules: [
      self.builtinsModule,
      self.sysModule,
      self._impModule,
      self._warningsModule,
      self._osModule
    ])
  }

  // MARK: - Destroy

  /// Destroy a `Py` instance.
  ///
  /// After calling this method nothing will work! (And that 'ok'.)
  public func destroy() { }

  // MARK: - Intern integers

  private static let internedIntRange = -10...255

  /// Get cached `int`.
  ///
  /// Note that not all of the `ints` are interned.
  /// Only some of them, from a very narrow range.
  internal func getInterned(int: BigInt) -> PyInt? {
    guard let int = Int(exactly: int) else {
      return nil
    }

    return self.getInterned(int: int)
  }

  /// Get cached `int`.
  ///
  /// Note that not all of the `ints` are interned.
  /// Only some of them, from a very narrow range.
  internal func getInterned(int: Int) -> PyInt? {
    guard Self.internedIntRange.contains(int) else {
      return nil
    }

    let index = int + Swift.abs(Self.internedIntRange.lowerBound)
    return self.internedInts[index]
  }

  // MARK: - Intern strings

  /// Get cached `PySString` value for given `String`.
  public func getInterned(string: String) -> PyString? {
    // Note that most of the time when it is invoked in the code (by us)
    // it is called on SHORT string.
    // So, even if later it has to be hashed again
    // (first for Swift dict, and then later to be used as key in 'PyDict')
    // the performance hit should be negligible
    // (also the whole string will already be in CPU cache, maybe, probably…).
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
  public func intern(path: Path) -> PyString {
    self.intern(string: path.string)
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
    self.internedStrings[key] = str
    return str
  }
}
