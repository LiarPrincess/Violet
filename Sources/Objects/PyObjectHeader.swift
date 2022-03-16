import VioletCore

/// Initial section of every Python object in memory.
///
/// Guaranteed to be word aligned.
public struct PyObjectHeader {

  // MARK: - Property - type

  // sourcery: storedProperty
  /// Also known as `klass`, but we are using CPython naming convention.
  public var type: PyType {
    return self.typePtr.pointee
  }

  // MARK: - Property - __dict__

  /// Lazy property written by hand.
  internal enum Lazy__dict__ {
    /// There is no spoon... (aka. `self.type` does not allow `__dict__`)
    case noDict
    /// `__dict__` is available, but not yet created
    case notCreated
    case created(PyDict)

    internal mutating func get(_ py: Py) -> PyDict? {
      switch self {
      case .noDict:
        return nil
      case .notCreated:
        let value = py.newDict()
        self = .created(value)
        return value
      case .created(let value):
        return value
      }
    }

    internal mutating func set(_ value: PyDict) {
      self = .created(value)
    }
  }

  // sourcery: storedProperty
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
  /// `has__dict__` flag on type.
  ///
  /// - Important:
  /// Use `Py.get__dict__` instead.
  internal var __dict__: PyObjectHeader.Lazy__dict__ {
    get { return self.__dict__Ptr.pointee }
    nonmutating set {
      assert(self.type.typeFlags.instancesHave__dict__)
      self.__dict__Ptr.pointee = newValue
    }
  }

  // MARK: - Property - flags

  // sourcery: storedProperty
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

    let flags = Flags()
    self.flagsPtr.initialize(to: flags)

    let lazy__dict__: Lazy__dict__
    if let value = __dict__ {
      lazy__dict__ = .created(value)
    } else if type.typeFlags.instancesHave__dict__ {
      lazy__dict__ = .notCreated
    } else {
      lazy__dict__ = .noDict
    }

    self.__dict__Ptr.initialize(to: lazy__dict__)
  }

  internal func deinitialize() {
    self.typePtr.deinitialize()
    self.__dict__Ptr.deinitialize()
    self.flagsPtr.deinitialize() // Trivial
  }
}
