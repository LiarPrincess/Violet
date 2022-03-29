import Foundation
import VioletCore

// cSpell:ignore typeobject

// In CPython:
// Objects -> object.c
// Objects -> typeobject.c

// sourcery: pytype = object, isDefault, isBaseType
// sourcery: subclassInstancesHave__dict__
/// Top of the `Python` type hierarchy.
public struct PyObject: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    object()
    --

    The most base type
    """

  // MARK: - Property - type

  // sourcery: storedProperty
  /// Also known as `klass`, but we are using CPython naming convention.
  public var type: PyType {
    return self.typePtr.pointee
  }

  // MARK: - Property - memory info

  // sourcery: storedProperty, visibleOnlyOnPyObject
  /// Things that `PyMemory` asked us to hold.
  ///
  /// This is only visible on `PyObject`, the subclasses will have it (obviously)
  /// but the property will not be generated.
  internal var memoryInfo: PyMemory.ObjectHeader {
    get { return self.memoryInfoPtr.pointee }
    nonmutating set { self.memoryInfoPtr.pointee = newValue }
  }

  // MARK: - Property - __dict__

  /// Lazy property written by hand.
  internal enum Lazy__dict__ {
    /// There is no spoon… (aka. `self.type` does not allow `__dict__`)
    case noDict
    /// `__dict__` is available, but not yet created
    case notCreated
    case created(PyDict)
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
  /// `instancesHave__dict__` flag on type.
  ///
  /// - Important:
  /// Use `PyObject.get__dict__` or `Py.get__dict__` instead.
  internal var __dict__: PyObject.Lazy__dict__ {
    // We don't want 'nonmutating set' on this field!
    // See the comment above 'get__dict__' for details.
    return self.__dict__Ptr.pointee
  }

  // If we tried to be fancy and addeed 'mutating Lazy__dict__.get(_:Py)' then
  // every 'self.__dict__.get(py)' would also call 'SET self.__dict__' since
  // it would be a possible mutation because we are lazy-creating 'dict()'.
  // But Swift does not care about the 'possible' part, it would just call
  // 'SET' on every access (which is not optimal for performance).
  internal func get__dict__(_ py: Py) -> PyDict? {
    switch self.__dict__ {
    case .noDict:
      return nil
    case .notCreated:
      let value = py.newDict()
      self.__dict__Ptr.pointee = .created(value)
      return value
    case .created(let value):
      return value
    }
  }

  internal func set__dict__(_ value: PyDict) {
    assert(self.type.typeFlags.instancesHave__dict__)
    self.__dict__Ptr.pointee = .created(value)
  }

  // MARK: - Property - flags

  // sourcery: storedProperty
  /// Various flags that describe the current state of the `PyObject`.
  ///
  /// It can also be used to store `Bool` properties (via `custom` flags).
  public var flags: PyObject.Flags {
    get { return self.flagsPtr.pointee }
    nonmutating set { self.flagsPtr.pointee = newValue }
  }

  // MARK: - Initialize/deinitialize

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType, __dict__: PyDict? = nil) {
    self.typePtr.initialize(to: type)
    self.flagsPtr.initialize(to: .default)

    let lazy__dict__: Lazy__dict__
    if let value = __dict__ {
      lazy__dict__ = .created(value)
    } else if type.typeFlags.instancesHave__dict__ {
      lazy__dict__ = .notCreated
    } else {
      lazy__dict__ = .noDict
    }

    self.__dict__Ptr.initialize(to: lazy__dict__)

    // 'memoryInfo' was already initialized (all of the objects are allocated by
    // PyMemory which also is responsible for 'memoryInfo').
  }

  /// `type type` (type of all of the types) and `object type` are a bit special.
  ///
  /// They are the 1st python objects that we allocate and at the point of calling
  /// this methods they are UNINITIALIZED!
  internal static func initialize(typeType: PyType, objectType: PyType) {
    // Just a reminder:
    //             | Type     | Base       | MRO
    // object type | typeType | nil        | [self]
    // type type   | typeType | objectType | [self, objectType]
    // normal type | typeType | objectType | [self, (...), objectType]

    let type = PyObject(ptr: typeType.ptr)
    type.typePtr.initialize(to: typeType)
    type.flagsPtr.initialize(to: .default)
    type.__dict__Ptr.initialize(to: .notCreated)

    let object = PyObject(ptr: objectType.ptr)
    object.typePtr.initialize(to: typeType)
    object.flagsPtr.initialize(to: .default)
    object.__dict__Ptr.initialize(to: .notCreated)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  /// Custom `Mirror` with debug information.
  public struct DebugMirror {

    // swiftlint:disable:next nesting
    public struct Property {
      public let name: String
      public let value: Any
      public let includeInDescription: Bool
    }

    public let object: PyObject
    public let swiftType: String
    public private(set) var properties = [Property]()

    public init<T: PyObjectMixin>(object: T) {
      self.object = object.asObject
      self.swiftType = String(describing: T.self)
    }

    public mutating func append(name: String,
                                value: Any,
                                includeInDescription: Bool = false) {
      let property = Property(
        name: name,
        value: value,
        includeInDescription: includeInDescription
      )

      self.properties.append(property)
    }
  }

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyObject(ptr: ptr)
    return DebugMirror(object: zelf)
  }

  // MARK: - Equatable, Comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.isEqual(zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    let isEqual = Self.isEqual(zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqual(zelf: PyObject, other: PyObject) -> CompareResult {
    if zelf.ptr === other.ptr {
      return .value(true)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf: PyObject) -> HashResult {
    let result = py.hasher.hash(zelf.ptr)
    return .value(result)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult {
    let result = Self.reprString(py, zelf: zelf)
    return PyResult(py, result)
  }

  private static func reprString(_ py: Py, zelf: PyObject) -> PyResultGen<String> {
    switch zelf.type.getModuleName(py) {
    case .builtins:
      return .value("<\(zelf.typeName) object at \(zelf.ptr)>")
    case .string(let module):
      return .value("<\(module).\(zelf.typeName) object at \(zelf.ptr)>")
    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf: PyObject) -> PyResult {
    // If '__str__' is not implemented then we will use '__repr__'.
    let result = py.repr(zelf)
    return PyResult(result)
  }

  // sourcery: pymethod = __format__
  internal static func __format__(_ py: Py, zelf: PyObject, spec: PyObject) -> PyResult {
    if let spec = py.cast.asString(spec), spec.isEmpty {
      return Self.__str__(py, zelf: zelf)
    }

    let msg = "unsupported format string passed to \(zelf.typeName).__format__"
    return .typeError(py, message: msg)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  internal static func __dir__(_ py: Py, zelf: PyObject) -> PyResultGen<DirResult> {
    var result = DirResult()

    // If we have dict then use it to fill 'dir'
    var error: PyBaseException?
    if let dict = py.get__dict__(object: zelf) {
      if let dirFn = dict.get(py, id: .__dir__) {
        switch py.call(callable: dirFn) {
        case .value(let o):
          error = result.append(py, elementsFrom: o)
        case let .notCallable(e),
          let .error(e):
          error = e
        }
      } else {
        // Otherwise just fill it with keys
        error = result.append(py, keysFrom: dict)
      }
    }

    if let e = error {
      return .error(e)
    }

    // 'Dir' from our type
    switch zelf.type.dir(py) {
    case let .value(dir):
      result.append(contentsOf: dir)
    case let .error(e):
      return .error(e)
    }

    return .value(result)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult {
    return AttributeHelper.getAttribute(py, object: zelf, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult {
    return AttributeHelper.setAttribute(py, object: zelf, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject) -> PyResult {
    return AttributeHelper.delAttribute(py, object: zelf, name: name)
  }

  // MARK: - Subclasshook

  // sourcery: pyclassmethod = __subclasshook__
  /// Abstract classes can override this to customize issubclass().
  /// This is invoked early on by abc.ABCMeta.__subclasscheck__().
  /// It should return True, False or NotImplemented.  If it returns
  /// NotImplemented, the normal algorithm is used.  Otherwise, it
  /// overrides the normal algorithm (and the outcome is cached).
  internal static func __subclasshook__(_ py: Py,
                                        type: PyType,
                                        args: [PyObject],
                                        kwargs: PyDict?) -> PyResult {
    // This can be called with any number of arguments:
    // >>> type(object).__subclasshook__(1,2)
    // NotImplemented
    // >>> type(object).__subclasshook__(1,2,4,5,6,7)
    // NotImplemented
    //
    // https://docs.python.org/3/library/abc.html#abc.ABCMeta.__subclasshook__
    return .notImplemented(py)
  }

  // MARK: - Init subclass

  // sourcery: pymethod = __init_subclass__
  /// This method is called when a class is subclassed.
  /// The default implementation does nothing.
  /// It may be overridden to extend subclasses.
  internal static func __init_subclass__(_ py: Py,
                                         zelf: PyObject) -> PyResult {
    return .none(py)
  }

  // MARK: - Python new

  // There is a long comment in 'CPython/Objects/typeobject.c'
  // about '__new__' and '__init'.

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    if Self.hasExcessArgs(args: args, kwargs: kwargs) {
      if Self.hasOverridden__new__(py, type: type) {
        let msg = "object.__new__() takes exactly one argument " +
        "(the type to instantiate)"
        return .typeError(py, message: msg)
      }

      if !Self.hasOverridden__init__(py, type: type) {
        let typeName = type.getNameString()
        return .typeError(py, message: "\(typeName) takes no arguments")
      }
    }

    let result = py.memory.newObject(type: type)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    if Self.hasExcessArgs(args: args, kwargs: kwargs) {
      if Self.hasOverridden__init__(py, type: zelf.type) {
        let msg = "object.__init__() takes exactly one argument " +
        "(the instance to initialize)"
        return .typeError(py, message: msg)
      }

      if !Self.hasOverridden__new__(py, type: zelf.type) {
        let typeName = zelf.type.getNameString()
        let msg = "\(typeName).__init__() takes exactly one argument " +
        "(the instance to initialize)"
        return .typeError(py, message: msg)
      }
    }

    return .none(py)
  }

  /// static int
  /// excess_args(PyObject *args, PyObject *kwds)
  private static func hasExcessArgs(args: [PyObject], kwargs: PyDict?) -> Bool {
    let noArgs = args.isEmpty && (kwargs?.elements.isEmpty ?? true)
    return !noArgs
  }

  private static func hasOverridden__new__(_ py: Py, type: PyType) -> Bool {
    return self.hasOverridden(py, type: type, name: .__new__)
  }

  private static func hasOverridden__init__(_ py: Py, type: PyType) -> Bool {
    return self.hasOverridden(py, type: type, name: .__init__)
  }

  private static func hasOverridden(_ py: Py, type: PyType, name: IdString) -> Bool {
    guard let lookup = type.mroLookup(py, name: name) else {
      let t = type.getNameString()
      trap("Uh… oh… So '\(name)' lookup on \(t) failed to find anything. " +
           "It should not be possible since every type derives from 'object', " +
           "(which has this method) but here we are…"
      )
    }

    let owner = lookup.type
    let isFromObject = owner.ptr === py.types.object.ptr
    return !isFromObject
  }
}
