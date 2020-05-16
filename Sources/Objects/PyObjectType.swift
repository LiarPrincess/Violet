import Foundation
import VioletCore

// In CPython:
// Objects -> typeobject.c

// sourcery: default, baseType
/// Container for things attached to `object` type
/// (root of `Python` type hierarchy).
internal enum PyObjectType {

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
  internal static func hash(zelf: PyObject) -> HashResult {
    let id = ObjectIdentifier(zelf)
    return .value(Py.hasher.hash(id))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func repr(zelf: PyObject) -> PyResult<String> {
    switch zelf.type.getModuleRaw() {
    case .builtins:
      return .value("<\(zelf.typeName) object at \(zelf.ptr)>")
    case .module(let module):
      return .value("<\(module).\(zelf.typeName) object at \(zelf.ptr)>")
    case .error(let e):
      return .error(e)
    }
  }

  // sourcery: pymethod = __str__
  internal static func str(zelf: PyObject) -> PyResult<String> {
    // If '__str__' is not implemented then we will use '__repr__'.
    return Py.repr(object: zelf)
  }

  // sourcery: pymethod = __format__
  internal static func format(zelf: PyObject, spec: PyObject) -> PyResult<String> {
    if let spec = spec as? PyString, spec.value.isEmpty {
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
    if Self.excessArgs(args: args, kwargs: kwargs) {
      if Self.hasOverriden__new__(type: type) {
        let msg = "object.__new__() takes exactly one argument " +
                  "(the type to instantiate)"
        return .typeError(msg)
      }

      if !Self.hasOverriden__init__(type: type) {
        let typeName = type.getNameRaw()
        return .typeError("\(typeName) takes no arguments")
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
        let typeName = zelf.type.getNameRaw()
        let msg = "\(typeName).__init__() takes exactly one argument " +
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
      let t = type.getNameRaw()
      let fn = name.value.value
      trap("Uh... oh... So '\(fn)' lookup on \(t) failed to find anything. " +
           "It should not be possible sice every type derieves from 'object', " +
           "(which has this method) but here we are..."
      )
    }

    let owner = lookup.type
    let hasFromObject = owner === Py.types.object
    return !hasFromObject
  }
}
