import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = KeyError, default, baseType, hasGC, baseExceptionSubclass
public final class PyKeyError: PyLookupError {

  override internal class var doc: String {
    return "Mapping key not found."
  }

  override public var description: String {
    return self.createDescription(typeName: "PyKeyError")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.keyError
  }

  // MARK: - Class

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

  // MARK: - Dict

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // MARK: - String

  override public func str() -> PyResult<String> {
    let result = Self.str(keyError: self)
    return result.flatMap(Py.strString(object:))
  }

  // sourcery: pymethod = __str__
  internal static func str(keyError zelf: PyKeyError) -> PyResult<PyObject> {
    // Why this is static? See comment in 'PyBaseException.str'.

    // If args is a tuple of exactly one item, apply repr to args[0].
    // This is done so that e.g. the exception raised by {{}}[''] prints
    //     KeyError: ''
    // rather than the confusing
    //     KeyError
    // alone.  The downside is that if KeyError is raised with an explanatory
    // string, that string will be displayed in quotes.  Too bad.
    // If args is anything else, use the default BaseException__str__().

    let args = zelf.getArgs()

    switch args.getLength() {
    case 1:
      let first = args.elements[0]
      return Py.reprObject(object: first)
    default:
      return PyBaseException.str(baseException: zelf)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal class func pyKeyErrorNew(type: PyType,
                                    args: [PyObject],
                                    kwargs: PyDict?) -> PyResult<PyKeyError> {
    let argsTuple = Py.newTuple(elements: args)
    return .value(PyKeyError(args: argsTuple, type: type))
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyKeyErrorInit(args: [PyObject],
                               kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyLookupErrorInit(args: args, kwargs: kwargs)
  }
}
