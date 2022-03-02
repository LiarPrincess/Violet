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
                           traceback: PyTraceback?,
                           cause: PyBaseException?,
                           context: PyBaseException?,
                           suppressContext: Bool) {
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
}

/* MARKER

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func getClass(keyError: PyKeyError) -> PyType {
    return keyError.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func getDict(keyError: PyKeyError) -> PyDict {
    return keyError.__dict__
  }

  // MARK: - String

  // sourcery: pymethod = __str__
  internal static func str(keyError: PyKeyError) -> PyResult<String> {
    // Why this is static? See comment in 'PyBaseException.str'.

    // If args is a tuple of exactly one item, apply repr to args[0].
    // This is done so that e.g. the exception raised by {{}}[''] prints
    //     KeyError: ''
    // rather than the confusing
    //     KeyError
    // alone.  The downside is that if KeyError is raised with an explanatory
    // string, that string will be displayed in quotes.  Too bad.
    // If args is anything else, use the default BaseException__str__().

    let args = keyError.getArgs()

    switch args.getLength() {
    case 1:
      let first = args.elements[0]
      return Py.reprString(object: first)
    default:
      return Self.str(baseException: keyError)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyKeyErrorNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyKeyError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyMemory.newKeyError(type: type, args: argsTuple)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyKeyErrorInit(args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyNone> {
    return self.pyLookupErrorInit(args: args, kwargs: kwargs)
  }
}

*/
