import Foundation
import VioletCore

// cSpell:ignore typeobject

// In CPython:
// Objects -> typeobject.c

// sourcery: isDefault, isBaseType, subclassInstancesHave__dict__
/// Top of the `Python` type hierarchy.
public struct PyObject: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    object()
    --

    The most base type
    """

  // MARK: - Layout

  internal enum Layout {
    internal static let size = SizeOf.objectHeader
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  internal func initialize(type: PyType) {
    self.header.initialize(type: type)
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyObject(ptr: ptr)
    zelf.header.deinitialize()
  }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyObject(ptr: ptr)
    return "PyObject(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER
internal enum PyObjectType {

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal static func isEqual(zelf: PyObject,
                               other: PyObject) -> CompareResult {
    if zelf === other {
      return .value(true)
    }

    return .notImplemented
  }

  // sourcery: pymethod = __ne__
  internal static func isNotEqual(zelf: PyObject,
                                  other: PyObject) -> CompareResult {
    return PyObjectType.isEqual(zelf: zelf, other: other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal static func isLess(zelf: PyObject,
                              other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal static func isLessEqual(zelf: PyObject,
                                   other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal static func isGreater(zelf: PyObject,
                                 other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal static func isGreaterEqual(zelf: PyObject,
                                      other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func hash(zelf: PyObject) -> PyHash {
    let id = ObjectIdentifier(zelf)
    return Py.hasher.hash(id)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func repr(zelf: PyObject) -> PyResult<String> {
    switch zelf.type.getModuleString() {
    case .builtins:
      return .value("<\(zelf.typeName) object at \(zelf.ptr)>")
    case .string(let module):
      return .value("<\(module).\(zelf.typeName) object at \(zelf.ptr)>")
    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __str__
  internal static func str(zelf: PyObject) -> PyResult<String> {
    // If '__str__' is not implemented then we will use '__repr__'.
    return Py.reprString(object: zelf)
  }

  // sourcery: pymethod = __format__
  internal static func format(zelf: PyObject, spec: PyObject) -> PyResult<String> {
    if let spec = PyCast.asString(spec), spec.isEmpty {
      return PyObjectType.str(zelf: zelf)
    }

    let msg = "unsupported format string passed to \(zelf.typeName).__format__"
    return .typeError(msg)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func getClass(zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  internal static func dir(zelf: PyObject) -> PyResult<DirResult> {
    let result = DirResult()

    // If we have dict then use it to fill 'dir'
    var error: PyBaseException?
    if let dict = Py.get__dict__(object: zelf) {
      if let dirFn = dict.get(id: .__dir__) {
        switch Py.call(callable: dirFn) {
        case .value(let o):
          error = result.append(elementsFrom: o)
        case let .notCallable(e),
             let .error(e):
          error = e
        }
      } else {
        // Otherwise just fill it with keys
        error = result.append(keysFrom: dict)
      }
    }

    if let e = error {
      return .error(e)
    }

    // 'Dir' from our type
    switch zelf.type.dir() {
    case let .value(dir):
      result.append(contentsOf: dir)
    case let .error(e):
      return .error(e)
    }

    return .value(result)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func getAttribute(zelf: PyObject,
                                    name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: zelf, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal static func setAttribute(zelf: PyObject,
                                    name: PyObject,
                                    value: PyObject?) -> PyResult<PyNone> {
    return AttributeHelper.setAttribute(on: zelf, name: name, to: value)
  }

  // sourcery: pymethod = __delattr__
  internal static func delAttribute(zelf: PyObject,
                                    name: PyObject) -> PyResult<PyNone> {
    return AttributeHelper.delAttribute(on: zelf, name: name)
  }

  // MARK: - Subclasshook

  // sourcery: pyclassmethod = __subclasshook__
  /// Abstract classes can override this to customize issubclass().
  /// This is invoked early on by abc.ABCMeta.__subclasscheck__().
  /// It should return True, False or NotImplemented.  If it returns
  /// NotImplemented, the normal algorithm is used.  Otherwise, it
  /// overrides the normal algorithm (and the outcome is cached).
  internal static func subclasshook(args: [PyObject],
                                    kwargs: PyDict?) -> PyResult<PyObject> {
    // This can be called with any number of arguments:
    // >>> type(object).__subclasshook__(1,2)
    // NotImplemented
    // >>> type(object).__subclasshook__(1,2,4,5,6,7)
    // NotImplemented
    //
    // https://docs.python.org/3/library/abc.html#abc.ABCMeta.__subclasshook__
    return .value(Py.notImplemented)
  }

  // MARK: - Init subclass

  // sourcery: pymethod = __init_subclass__
  /// This method is called when a class is subclassed.
  /// The default implementation does nothing.
  /// It may be overridden to extend subclasses.
  internal static func initSubclass(zelf: PyObject) -> PyResult<PyObject> {
    return .value(Py.none)
  }

  // MARK: - Python new

  // There is a long comment in 'Objects -> typeobject.c' about '__new__'
  // and '__init'.

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
    if Self.hasExcessArgs(args: args, kwargs: kwargs) {
      if Self.hasOverridden__new__(type: type) {
        let msg = "object.__new__() takes exactly one argument " +
                  "(the type to instantiate)"
        return .typeError(msg)
      }

      if !Self.hasOverridden__init__(type: type) {
        let typeName = type.getNameString()
        return .typeError("\(typeName) takes no arguments")
      }
    }

    let result = PyMemory.newObject(type: type)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyObject,
                              args: [PyObject],
                              kwargs: PyDict?) -> PyResult<PyNone> {
    if Self.hasExcessArgs(args: args, kwargs: kwargs) {
      if Self.hasOverridden__init__(type: zelf.type) {
        let msg = "object.__init__() takes exactly one argument " +
                  "(the instance to initialize)"
        return .typeError(msg)
      }

      if !Self.hasOverridden__new__(type: zelf.type) {
        let typeName = zelf.type.getNameString()
        let msg = "\(typeName).__init__() takes exactly one argument " +
                  "(the instance to initialize)"
        return .typeError(msg)
      }
    }

    return .value(Py.none)
  }

  /// static int
  /// excess_args(PyObject *args, PyObject *kwds)
  private static func hasExcessArgs(args: [PyObject], kwargs: PyDict?) -> Bool {
    let noArgs = args.isEmpty && (kwargs?.elements.isEmpty ?? true)
    return !noArgs
  }

  private static func hasOverridden__new__(type: PyType) -> Bool {
    return self.hasOverridden(type: type, name: .__new__)
  }

  private static func hasOverridden__init__(type: PyType) -> Bool {
    return self.hasOverridden(type: type, name: .__init__)
  }

  private static func hasOverridden(type: PyType, name: IdString) -> Bool {
    guard let lookup = type.mroLookup(name: name) else {
      let t = type.getNameString()
      let fn = name.value.value
      trap("Uh… oh… So '\(fn)' lookup on \(t) failed to find anything. " +
           "It should not be possible since every type derives from 'object', " +
           "(which has this method) but here we are..."
      )
    }

    let owner = lookup.type
    let isFromObject = owner === Py.types.object
    return !isFromObject
  }
}

*/
