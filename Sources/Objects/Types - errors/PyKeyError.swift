import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = KeyError, pybase = LookupError, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyKeyError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let keyErrorDoc = "Mapping key not found."

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           args: PyTuple,
                           traceback: PyTraceback? = nil,
                           cause: PyBaseException? = nil,
                           context: PyBaseException? = nil,
                           suppressContext: Bool = PyErrorHeader.defaultSuppressContext) {
    self.errorHeader.initialize(py,
                                type: type,
                                args: args,
                                traceback: traceback,
                                cause: cause,
                                context: context,
                                suppressContext: suppressContext)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyKeyError(ptr: ptr)
    return "PyKeyError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__dict__")
    }

    return PyResult(zelf.__dict__)
  }

  // MARK: - String

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf: PyObject) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__str__")
    }

    // Why this is static? See comment in 'PyBaseException.str'.

    // If args is a tuple of exactly one item, apply repr to args[0].
    // This is done so that e.g. the exception raised by {{}}[''] prints
    //     KeyError: ''
    // rather than the confusing
    //     KeyError
    // alone.  The downside is that if KeyError is raised with an explanatory
    // string, that string will be displayed in quotes.  Too bad.
    // If args is anything else, use the default BaseException__str__().

    let args = zelf.args

    switch args.count {
    case 1:
      let first = args.elements[0]
      let result = py.repr(object: first)
      return PyResult(result)
    default:
      let zelfAsBase = zelf.asBaseException
      return PyBaseException.str(py, zelf: zelfAsBase)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyObject> {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newKeyError(
      py,
      type: type,
      args: argsTuple,
      traceback: nil,
      cause: nil,
      context: nil,
      suppressContext: PyErrorHeader.defaultSuppressContext
    )

    return PyResult(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal static func __init__(_ py: Py,
                                zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyObject> {
    guard let zelf = Self.downcast(py, zelf) else {
      return Self.invalidZelfArgument(py, zelf, "__init__")
    }

    let zelfAsObject = zelf.asObject
    return PyLookupError.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs)
  }
}
