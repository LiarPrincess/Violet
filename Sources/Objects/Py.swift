import Foundation
import BigInt
import FileSystem
import VioletCore

// cSpell:ignore longobject

/// `Py` represents a `Python` context.
///
/// You can use it to interact with `Python` objects.
/// For example: to call `getattr` function on `elsa` object you call
/// `Py.getAttribute(object: elsa, name: "let_it_go")`.
public struct Py: CustomStringConvertible {

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
  // Predefined commonly used '__dict__' keys:
  private var idStrings: IdString.Collection { self.idStringsPtr.pointee }
  // sourcery: storedProperty
  /// Cached `int` instances, so that we don't create `0/1/2` etc. multiple times.
  private var internedInts: [PyInt] { self.internedIntsPtr.pointee }
  // sourcery: storedProperty
  /// Cached `str` instances, so that we don't create common values multiple times.
  private var internedStrings: [UseScalarsToHashString: PyString] {
    // We could go with the usual 'nonmutating _modify/set' dance,
    // but we will going to mutate it in only 1 place, so it is not worth it.
    self.internedStringsPtr.pointee
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
  public var delegate: PyDelegateType { self.delegatePtr.pointee }
  // sourcery: storedProperty
  public var fileSystem: PyFileSystemType { self.fileSystemPtr.pointee }

  // sourcery: storedProperty
  public var memory: PyMemory { self.memoryPtr.pointee }
  // sourcery: storedProperty
  public var cast: PyCast { self.castPtr.pointee }
  // sourcery: storedProperty
  internal var hasher: Hasher { self.hasherPtr.pointee }

  public var description: String {
    return Sys.version
  }

  // MARK: - Init

  public let ptr: RawPtr

  // swiftlint:disable:next function_body_length
  public init(config: PyConfig, delegate: PyDelegateType, fileSystem: PyFileSystemType) {
    checkInvariants()

    self.ptr = PyMemory.allocatePy()

    self.configPtr.initialize(to: config)
    self.delegatePtr.initialize(to: delegate)
    self.fileSystemPtr.initialize(to: fileSystem)

    let memory = PyMemory(self)
    let hasher = Hasher(key0: config.hashKey0, key1: config.hashKey1)
    self.memoryPtr.initialize(to: memory)
    self.hasherPtr.initialize(to: hasher)

    // =======================
    // === Basic instances ===
    // =======================

    // Every object contains a pointer to its 'type', so the first thing that
    // we have to do is to create a type hierarchy
    // (but only hierarchy, we will fill '__dict__' later):
    let types = Types(self)
    self.typesPtr.initialize(to: types)

    let errorTypes = ErrorTypes(self, typeType: types.type, objectType: types.object)
    self.errorTypesPtr.initialize(to: errorTypes)

    // Since we have types we can start doing unholy things to them:
    let cast = PyCast(types: self.types, errorTypes: self.errorTypes)
    self.castPtr.initialize(to: cast)

    // Common objects.
    // We will create those objects with valid 'type' pointers, but the type
    // itself not filled (no methods in '__dict__' etc).
    // Disable 'redundantSelf' otherwise it would insert 'value: self.true'.
    // swiftformat:disable redundantSelf
    self.truePtr.initialize(to: memory.newBool(type: types.bool, value: true))
    self.falsePtr.initialize(to: memory.newBool(type: types.bool, value: false))
    self.nonePtr.initialize(to: memory.newNone(type: types.none))
    self.notImplementedPtr.initialize(to: memory.newNotImplemented(type: types.notImplemented))
    self.ellipsisPtr.initialize(to: memory.newEllipsis(type: types.ellipsis))
    self.emptyTuplePtr.initialize(to: memory.newTuple(type: types.tuple, elements: []))
    self.emptyStringPtr.initialize(to: memory.newString(type: types.str, value: ""))
    self.emptyBytesPtr.initialize(to: memory.newBytes(type: types.bytes, elements: Data()))
    self.emptyFrozenSetPtr
      .initialize(to: memory.newFrozenSet(type: types.frozenset, elements: OrderedSet()))
    // swiftformat:enable redundantSelf

    // Predefined commonly used '__dict__' keys:
    let idStrings = IdString.Collection(self)
    self.idStringsPtr.initialize(to: idStrings)

    // When filling 'type.__dict__' we will also start interning values:
    let internedInts = Self.internedIntRange.map { int in
      memory.newInt(type: types.int, value: BigInt(int))
    }

    self.internedIntsPtr.initialize(to: internedInts)
    self.internedStringsPtr.initialize(to: [:])

    for id in self.idStrings {
      let str = self.resolve(id: id)
      _ = self.intern(string: str)
    }

    // ===========================
    // === Fill types __dict__ ===
    // ===========================

    // And finally we can add docs/methods/properties on types:
    self.types.fill__dict__(self)
    self.errorTypes.fill__dict__(self)

    // ===============
    // === Modules ===
    // ===============

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
  /// After calling this method nothing will work! (And that's 'ok'.)
  public func destroy() {
    PyMemory.destroyPy(self) // Bye!
  }

  // MARK: - Id strings

  public func resolve(id: IdString) -> PyString {
    return self.idStrings[id]
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
    self.internedStringsPtr.pointee[key] = str
    return str
  }

  /// Cache given string and return it.
  ///
  /// If it is already in cache then it will return interned value.
  public func intern(string: PyString) -> PyString {
    let key = UseScalarsToHashString(string.value)

    if let interned = self.getInterned(key: key) {
      return interned
    }

    self.internedStringsPtr.pointee[key] = string
    return string
  }
}
