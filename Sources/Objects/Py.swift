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
public struct Py {

  // MARK: - Builtins

  // sourcery: storedProperty
  /// Interned `true` value.
  public var `true`: PyBool { self.truePtr.pointee }
  // sourcery: storedProperty
  /// Interned `false` value.
  public var `false`: PyBool { self.falsePtr.pointee }
  // sourcery: storedProperty
  /// Interned `None` value.
  public var none: PyNone { self.nonePtr.pointee }
  // sourcery: storedProperty
  /// Interned `NotImplemented` value.
  public var notImplemented: PyNotImplemented { self.notImplementedPtr.pointee }
  // sourcery: storedProperty
  /// Interned `ellipsis (...)` value.
  public var ellipsis: PyEllipsis { self.ellipsisPtr.pointee }
  // sourcery: storedProperty
  /// Interned empty `tuple` value (because `tuple` is immutable).
  public var emptyTuple: PyTuple { self.emptyTuplePtr.pointee }
  // sourcery: storedProperty
  /// Interned empty `str` value (because `str` is immutable).
  public var emptyString: PyString { self.emptyStringPtr.pointee }
  // sourcery: storedProperty
  /// Interned empty `bytes` value (because `bytes` are immutable).
  public var emptyBytes: PyBytes { self.emptyBytesPtr.pointee }
  // sourcery: storedProperty
  /// Interned empty `frozenset` value (because `frozenset` is immutable).
  public var emptyFrozenSet: PyFrozenSet { self.emptyFrozenSetPtr.pointee }

  // sourcery: storedProperty
  /// Cached `int` instances, so that we don't create `0/1/2` etc. multiple times.
  private var internedInts: [PyInt] { self.internedIntsPtr.pointee }
  // sourcery: storedProperty
  /// Cached `str` instances, so that we don't create common instances multiple times.
  private var internedStrings: [UseScalarsToHashString: PyString] {
    get { self.internedStringsPtr.pointee }
    nonmutating set { self.internedStringsPtr.pointee = newValue }
  }

  // MARK: - Modules

  // sourcery: storedProperty
  /// Python `builtins` module.
  public var builtins: Builtins { self.builtinsPtr.pointee }
  // sourcery: storedProperty
  /// Python `sys` module.
  public var sys: Sys { self.sysPtr.pointee }
  // sourcery: storedProperty
  /// Python `_imp` module.
  public var _imp: UnderscoreImp { self._impPtr.pointee }
  // sourcery: storedProperty
  /// Python `_warnings` module.
  public var _warnings: UnderscoreWarnings { self._warningsPtr.pointee }
  // sourcery: storedProperty
  /// Python `_os` module.
  public var _os: UnderscoreOS { self._osPtr.pointee }

  // sourcery: storedProperty
  /// `self.builtins` but as a Python module (`PyModule`).
  public var builtinsModule: PyModule { self.builtinsModulePtr.pointee }
  // sourcery: storedProperty
  /// `self.sys` but as a Python module (`PyModule`).
  public var sysModule: PyModule { self.sysModulePtr.pointee }
  // sourcery: storedProperty
  /// `self._imp` but as a Python module (`PyModule`).
  public var _impModule: PyModule { self._impModulePtr.pointee }
  // sourcery: storedProperty
  /// `self._warnings` but as a Python module (`PyModule`).
  public var _warningsModule: PyModule { self._warningsModulePtr.pointee }
  // sourcery: storedProperty
  /// `self._os` but as a Python module (`PyModule`).
  public var _osModule: PyModule { self._osModulePtr.pointee }

  // MARK: - Types

  // sourcery: storedProperty
  /// Container for all of the non-error Python types (as `PyType` instances).
  public var types: Py.Types { self.typesPtr.pointee }
  // sourcery: storedProperty
  /// Container for all of the error Python types (as `PyType` instances).
  public var errorTypes: Py.ErrorTypes { self.errorTypesPtr.pointee }

  // MARK: - Config, delegate, hasher

  // sourcery: storedProperty
  public var config: PyConfig { self.configPtr.pointee }
  // sourcery: storedProperty
  public var delegate: PyDelegate { self.delegatePtr.pointee }
  // sourcery: storedProperty
  public var fileSystem: PyFileSystem { self.fileSystemPtr.pointee }

  // sourcery: storedProperty
  public var memory: PyMemory { self.memoryPtr.pointee }
  // sourcery: storedProperty
  public var cast: PyCast { self.castPtr.pointee }
  // sourcery: storedProperty
  internal var hasher: Hasher { self.hasherPtr.pointee }

  // MARK: - Init

  public let ptr: RawPtr

  public init(config: PyConfig,
              delegate: PyDelegate,
              fileSystem: PyFileSystem) {
    checkInvariants()

    let memory = PyMemory()
    self.ptr = memory.allocatePy()
    
    self.configPtr.initialize(to: config)
    self.delegatePtr.initialize(to: delegate)
    self.fileSystemPtr.initialize(to: fileSystem)

    let hasher = Hasher(key0: config.hashKey0, key1: config.hashKey1)
    self.memoryPtr.initialize(to: memory)
    self.hasherPtr.initialize(to: hasher)

    // At this point everything should be initialized,
    // which means that from now on we are able to create PyObjects.
    // Since every object contains a pointer to its 'type',
    // the first thing that we have to do is to create a type hierarchy
    // (but only hierarchy, we will fill '__dict__' later):
    let types = Types(self)
    self.typesPtr.initialize(to: types)

    let errorTypes = ErrorTypes(self, typeType: types.type, objectType: types.object)
    self.errorTypesPtr.initialize(to: errorTypes)

    // Now since we have all types in place we can start creating some more
    // interesting instances, for example docs/methods/properties on those types:
    self.types.fill__dict__(self)
    self.errorTypes.fill__dict__(self)

    // Since we have types we can start doing unholy things to them:
    let cast = PyCast(types: self.types, errorTypes: self.errorTypes)
    self.castPtr.initialize(to: cast)

    // Predefined commonly used '__dict__' keys:
//    IdString.initialize()

    // Basic instances:
    self.truePtr.initialize(to: memory.newBool(self, type: types.bool, value: true))
    self.falsePtr.initialize(to: memory.newBool(self, type: types.bool, value: false))
    self.nonePtr.initialize(to: memory.newNone(self, type: types.none))
    self.notImplementedPtr.initialize(to: memory.newNotImplemented(self, type: types.notImplemented))
    self.ellipsisPtr.initialize(to: memory.newEllipsis(self, type: types.ellipsis))
    self.emptyTuplePtr.initialize(to: memory.newTuple(self, type: types.tuple, elements: []))
    self.emptyStringPtr.initialize(to: memory.newString(self, type: types.str, value: ""))
    self.emptyBytesPtr.initialize(to: memory.newBytes(self, type: types.bytes, elements: Data()))
    self.emptyFrozenSetPtr.initialize(to: memory.newFrozenSet(self, type: types.frozenset, elements: .init()))

    let internedInts = Self.internedIntRange.map { int in
      memory.newInt(self, type: types.int, value: BigInt(int))
    }
    self.internedIntsPtr.initialize(to: internedInts)

    // Modules:
    self.builtinsPtr.initialize(to: Builtins(self))
    self.sysPtr.initialize(to: Sys(self))
    self._impPtr.initialize(to: UnderscoreImp(self))
    self._warningsPtr.initialize(to: UnderscoreWarnings(self))
    self._osPtr.initialize(to: UnderscoreOS(self))

    self.builtinsModulePtr.initialize(to: self.builtins.createModule())
    self.sysModulePtr.initialize(to: self.sys.createModule())
    self._impModulePtr.initialize(to: self._imp.createModule())
    self._warningsModulePtr.initialize(to: self._warnings.createModule())
    self._osModulePtr.initialize(to: self._os.createModule())

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
  public func destroy() {
    let memory = self.memory
    memory.destroyPy(self) // Bye!
  }

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
