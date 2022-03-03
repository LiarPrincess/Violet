import Foundation
import VioletCore

// cSpell:ignore typeobject
// swiftlint:disable file_length

// In CPython:
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

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  internal func initialize(_ py: Py, type: PyType) {
    self.header.initialize(py, type: type)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyObject(ptr: ptr)
    return "PyObject(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py,
                              zelf: PyObject,
                              other: PyObject) -> PyResult<PyObject> {
    let result = Self.isEqual(zelf: zelf, other: other)
    return result.toResult(py)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py,
                              zelf: PyObject,
                              other: PyObject) -> PyResult<PyObject> {
    let result = Self.isEqual(zelf: zelf, other: other)
    return result.not.toResult(py)
  }

  private static func isEqual(zelf: PyObject, other: PyObject) -> CompareResult {
    if zelf.ptr === other.ptr {
      return .value(true)
    }

    return .notImplemented
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py,
                              zelf: PyObject,
                              other: PyObject) -> PyResult<PyObject> {
    return .notImplemented(py)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py,
                              zelf: PyObject,
                              other: PyObject) -> PyResult<PyObject> {
    return .notImplemented(py)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py,
                              zelf: PyObject,
                              other: PyObject) -> PyResult<PyObject> {
    return .notImplemented(py)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py,
                              zelf: PyObject,
                              other: PyObject) -> PyResult<PyObject> {
    return .notImplemented(py)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf: PyObject) -> PyHash {
    let int = Int(bitPattern: zelf.ptr)
    return py.hasher.hash(int)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    let result = Self.reprString(py, zelf: zelf)
    return result.asObject(py)
  }

  private static func reprString(_ py: Py, zelf: PyObject) -> PyResult<String> {
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
  internal static func __str__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    // If '__str__' is not implemented then we will use '__repr__'.
    let result = py.repr(object: zelf)
    return result.asObject
  }

  // sourcery: pymethod = __format__
  internal static func __format__(_ py: Py,
                                  zelf: PyObject,
                                  spec: PyObject) -> PyResult<PyObject> {
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
  internal static func __dir__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    var dir = DirResult()

    // If we have dict then use it to fill 'dir'
    var error: PyBaseException?
    if let dict = py.get__dict__(object: zelf) {
      if let dirFn = dict.get(id: .__dir__) {
        switch py.call(callable: dirFn) {
        case .value(let o):
          error = dir.append(py, elementsFrom: o)
        case let .notCallable(e),
          let .error(e):
          error = e
        }
      } else {
        // Otherwise just fill it with keys
        error = dir.append(py, keysFrom: dict)
      }
    }

    if let e = error {
      return .error(e)
    }

    // 'Dir' from our type
    switch zelf.type.dir(py) {
    case let .value(typeDir):
      dir.append(contentsOf: typeDir)
    case let .error(e):
      return .error(e)
    }

    let result = dir.toResult(py)
    return result
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf: PyObject,
                                        name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(py, object: zelf, name: name)
  }

  // sourcery: pymethod = __setattr__
  internal static func __setattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject,
                                   value: PyObject?) -> PyResult<PyObject> {
    return AttributeHelper.setAttribute(py, object: zelf, name: name, value: value)
  }

  // sourcery: pymethod = __delattr__
  internal static func __delattr__(_ py: Py,
                                   zelf: PyObject,
                                   name: PyObject) -> PyResult<PyObject> {
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
                                        args: [PyObject],
                                        kwargs: PyDict?) -> PyResult<PyObject> {
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
                                         zelf: PyObject) -> PyResult<PyObject> {
    return .none(py)
  }

  // MARK: - Python new

  // There is a long comment in 'CPython/Objects/typeobject.c'
  // about '__new__' and '__init'.

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
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

    let result = py.newObject(type: type)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
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
    guard let lookup = type.mroLookup(name: name) else {
      let t = type.getNameString()
      let fn = name.value.value
      trap("Uh… oh… So '\(fn)' lookup on \(t) failed to find anything. " +
           "It should not be possible since every type derives from 'object', " +
           "(which has this method) but here we are..."
      )
    }

    let owner = lookup.type
    let isFromObject = owner.ptr === py.types.object.ptr
    return !isFromObject
  }
}
