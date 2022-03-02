import VioletCore

/// Initial section of every Python object in memory.
///
/// Guaranteed to be word aligned.
public struct PyObjectHeader {

  internal enum Layout {
    internal static let typeOffset = 0
    internal static let typeSize = SizeOf.object

    internal static let __dict__Offset = typeOffset + typeSize
    internal static let __dict__Size = SizeOf.optionalObject

    internal static let flagsOffset = __dict__Offset + __dict__Size
    internal static let flagsSize = Flags.size

    internal static let size = AlignmentOf.roundUp(
      Layout.flagsOffset + Layout.flagsSize,
      to: AlignmentOf.word
    )

    internal static let alignment = AlignmentOf.word
  }

  // MARK: - Properties

  private var typePtr: Ptr<PyType> { self.ptr[Layout.typeOffset] }
  private var __dict__Ptr: Ptr<PyObjectHeader.LazyDict> { self.ptr[Layout.__dict__Offset] }
  private var flagsPtr: Ptr<Flags> { self.ptr[Layout.flagsOffset] }

  /// Also known as `klass`, but we are using CPython naming convention.
  public var type: PyType { self.typePtr.pointee }

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
      // Lazy property written by hand.
      let pointee = self.__dict__Ptr.pointee
      switch pointee {
      case .thereIsNoDict:
        let typeName = self.type.name
        trap("\(typeName) does not even '__dict__'.")
      case .lazyNotCreated(let py):
        let value = py.newDict()
        self.__dict__Ptr.pointee = LazyDict.created(value)
        return value
      case .created(let value):
        return value
      }
    }
    nonmutating set {
      assert(self.type.typeFlags.instancesHave__dict__)
      self.__dict__Ptr.pointee = LazyDict.created(newValue)
    }
  }

  private enum LazyDict {
    /// There is no spoon... (aka. `self.type` does not allow `__dict__`)
    case thereIsNoDict
    /// `__dict__` is available, but not yet created
    case lazyNotCreated(Py)
    case created(PyDict)
  }

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

  // MARK: - Initialize

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

    self.__dict__Ptr.initialize(to: lazy__dict__)
  }

  internal func deinitialize() {
    self.typePtr.deinitialize()
    self.__dict__Ptr.deinitialize()
    self.flagsPtr.deinitialize() // Trivial
  }
}
