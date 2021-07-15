import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = KeyError, default, baseType, hasGC, baseExceptionSubclass
public final class PyKeyError: PyLookupError {

  // sourcery: pytypedoc
  internal static let keyErrorDoc = "Mapping key not found."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.keyError
  }

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

  // This is for `__str__Owner` protocol
  override internal func str() -> PyResult<String> {
    let result = Self.str(keyError: self)
    return result.map { $0.value }
  }

  // sourcery: pymethod = __str__
  internal static func str(keyError: PyKeyError) -> PyResult<PyString> {
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
      return Py.repr(object: first)
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
    let result = PyMemory.newKeyError(args: argsTuple, type: type)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyKeyErrorInit(args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyNone> {
    return self.pyLookupErrorInit(args: args, kwargs: kwargs)
  }
}
