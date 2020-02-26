import Foundation
import Core

// In CPython:
// Objects -> typeobject.c

// sourcery: default, baseType
/// Root of the Python object hierarchy (kind of important thingie).
internal enum PyBaseObject {

  internal static let doc: String = """
    object()
    --

    The most base type
    """

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
    return PyBaseObject.isEqual(zelf: zelf, other: other).not
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
  internal static func hash(zelf: PyObject) -> HashResult {
    let id = ObjectIdentifier(zelf)
    return .value(Py.hasher.hash(id))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func repr(zelf: PyObject) -> PyResult<String> {
    switch zelf.type.getModuleRaw() {
    case .builtins:
      return .value("<\(zelf.typeName) object at \(zelf.ptrString)>")
    case .module(let module):
      return .value("<\(module).\(zelf.typeName) object at \(zelf.ptrString)>")
    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __str__
  internal static func str(zelf: PyObject) -> PyResult<String> {
    // If '__str__' is not implemented then we will use '__repr__'.
    return Py.repr(zelf)
  }

  // sourcery: pymethod = __format__
  internal static func format(zelf: PyObject, spec: PyObject) -> PyResult<String> {
    if let spec = spec as? PyString, spec.value.isEmpty {
      return PyBaseObject.str(zelf: zelf)
    }

    let msg = "unsupported format string passed to \(zelf.typeName).__format__"
    return .typeError(msg)
  }

  // MARK: - Class

  // sourcery: pymethod = __class__
  internal static func getClass(zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dir

  // sourcery: pymethod = __dir__
  internal static func dir(zelf: PyObject) -> DirResult {
    var result = DirResult()

    if let attribOwner = zelf as? __dict__GetterOwner {
      let dict = attribOwner.getDict()

      if let dirFunc = dict.get(id: .__dir__) {
        let dir = Py.callDir(dirFunc, args: [])
        result.append(contentsOf: dir)
      } else {
        result.append(contentsOf: dict)
      }
    }

    result.append(contentsOf: zelf.type.dir())
    return result
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

  // sourcery: pymethod = __subclasshook__
  /// Abstract classes can override this to customize issubclass().
  /// This is invoked early on by abc.ABCMeta.__subclasscheck__().
  /// It should return True, False or NotImplemented.  If it returns
  /// NotImplemented, the normal algorithm is used.  Otherwise, it
  /// overrides the normal algorithm (and the outcome is cached).
  internal static func subclasshook(zelf: PyObject) -> PyResult<PyObject> {
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

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyObject> {
    if Self.excessArgs(args: args, kwargs: kwargs) {
      if Self.hasOverriden__new__(type: type) {
        let msg = "object.__new__() takes exactly one argument " +
                  "(the type to instantiate)"
        return .typeError(msg)
      }

      if !Self.hasOverriden__init__(type: type) {
        return .typeError("\(type.getName()) takes no arguments")
      }
    }

    let isBuiltin = type === Py.types.object
    let result = isBuiltin ? PyObject(type: type) : PyObjectHeap(type: type)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyObject,
                              args: [PyObject],
                              kwargs: PyDict?) -> PyResult<PyNone> {
    if Self.excessArgs(args: args, kwargs: kwargs) {
      if Self.hasOverriden__init__(type: zelf.type) {
        let msg = "object.__init__() takes exactly one argument " +
                  "(the instance to initialize)"
        return .typeError(msg)
      }

      if !Self.hasOverriden__new__(type: zelf.type) {
        let t = zelf.type.getName()
        let msg = "\(t).__init__() takes exactly one argument " +
                  "(the instance to initialize)"
        return .typeError(msg)
      }
    }

    return .value(Py.none)
  }

  /// static int
  /// excess_args(PyObject *args, PyObject *kwds)
  private static func excessArgs(args: [PyObject], kwargs: PyDict?) -> Bool {
    let noArgs = args.isEmpty && (kwargs?.data.isEmpty ?? true)
    return !noArgs
  }

  private static func hasOverriden__new__(type: PyType) -> Bool {
    return self.hasOverriden(type: type, name: .__new__)
  }

  private static func hasOverriden__init__(type: PyType) -> Bool {
    return self.hasOverriden(type: type, name: .__init__)
  }

  private static func hasOverriden(type: PyType, name: IdString) -> Bool {
    guard let lookup = type.lookupWithType(name: name) else {
      let t = type.getName()
      let fn = name.value.value
      trap("Uh... oh... So '\(fn)' lookup on \(t) failed to find anything. " +
           "It should not be possible sice every type derieves from 'object', " +
           "(which has this method) but here we are..."
      )
    }

    let owner = lookup.owner
    let hasFromObject = owner === Py.types.object
    return !hasFromObject
  }
}
