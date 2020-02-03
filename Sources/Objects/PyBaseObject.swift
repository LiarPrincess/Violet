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
    return PyBaseObject.repr(zelf: zelf)
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

      if let dirFunc = dict.get(key: "__dir__") {
        let dir = Py.callDir(dirFunc, args: [])
        result.append(contentsOf: dir)
      } else {
        result.append(contentsOf: dict.keys)
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

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
    if PyBaseObject.excessArgs(args: args, kwargs: kwargs) {
      return .typeError("\(type.getName()) takes no arguments")
    }

    let result = PyObject(type: type)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func pyInit(zelf: PyObject,
                              args: [PyObject],
                              kwargs: PyDictData?) -> PyResult<PyNone> {
    let isObject = zelf.type === Py.types.object
    let hasArgs = args.any || (kwargs?.any ?? false)

    if isObject && hasArgs {
      return .typeError(
        "object.__init__() takes exactly one argument (the instance to initialize)"
      )
    }

    return .value(Py.none)
  }

  /// static int
  /// excess_args(PyObject *args, PyObject *kwds)
  private static func excessArgs(args: [PyObject], kwargs: PyDictData?) -> Bool {
    let noKwargs = kwargs?.isEmpty ?? true
    let noArgs = args.isEmpty && noKwargs
    return !noArgs
  }
}
