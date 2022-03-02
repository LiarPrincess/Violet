import VioletCore

/// Initial section of every Python object in memory.
///
/// Guaranteed to be word aligned.
public struct PyObjectHeader {

  // MARK: - Type

  // sourcery: includeInLayout
  /// Also known as `klass`, but we are using CPython naming convention.
  public var type: PyType {
    return self.typePtr.pointee
  }

  // MARK: - __dict__

  /// Lazy property written by hand.
  internal enum LazyDict {
    /// There is no spoon... (aka. `self.type` does not allow `__dict__`)
    case thereIsNoDict
    /// `__dict__` is available, but not yet created
    case lazyNotCreated(Py)
    case created(PyDict)
  }

  // sourcery: includeInLayout
  private var lazy__dict__: PyObjectHeader.LazyDict {
    get { return self.lazy__dict__Ptr.pointee }
    nonmutating set { self.lazy__dict__Ptr.pointee = newValue }
  }

  /// Internal dictionary of attributes for the specific instance.
  ///
  /// We will reserve space for `PyDict` reference on EVERY object, even though
  /// not all of them can actually use it:
  /// ``` py
  /// >>> (1).__dict__
  /// Traceback (most recent call last):
  ///   File "<stdin>", line 1, in <module>
  /// AttributeError: 'int' object has no attribute '__dict__'
  /// ```
  ///
  /// Whether the object has access to `__dict__` or not is controlled by
  /// `has__dict__` flag.
  ///
  /// - Important:
  /// Accessing `__dict__` on object that does not have it will trap!
  /// Use `Py.get__dict__` instead.
  public internal(set) var __dict__: PyDict {
    get {
      switch self.lazy__dict__ {
      case .thereIsNoDict:
        let typeName = self.type.name
        trap("\(typeName) does not even '__dict__'.")
      case .lazyNotCreated(let py):
        let value = py.newDict()
        self.lazy__dict__ = LazyDict.created(value)
        return value
      case .created(let value):
        return value
      }
    }
    nonmutating set {
      assert(self.type.typeFlags.instancesHave__dict__)
      self.lazy__dict__ = LazyDict.created(newValue)
    }
  }

  // MARK: - Flags

  // sourcery: includeInLayout
  /// Various flags that describe the current state of the `PyObject`.
  ///
  /// It can also be used to store `Bool` properties (via `custom` flags).
  public var flags: Flags {
    get { self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  // MARK: - Init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  internal func initialize(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    self.typePtr.initialize(to: type)

    let flags = PyObjectHeader.Flags()
    self.flagsPtr.initialize(to: flags)

    let lazy__dict__: LazyDict
    if let value = __dict__ {
      lazy__dict__ = .created(value)
    } else if type.typeFlags.instancesHave__dict__ {
      lazy__dict__ = .lazyNotCreated(py)
    } else {
      lazy__dict__ = .thereIsNoDict
    }

    self.lazy__dict__Ptr.initialize(to: lazy__dict__)
  }

  internal func deinitialize() {
    self.typePtr.deinitialize()
    self.lazy__dict__Ptr.deinitialize()
    self.flagsPtr.deinitialize() // Trivial
  }
}
