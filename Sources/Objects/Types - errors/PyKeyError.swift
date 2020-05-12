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

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pymethod = __str__
  override public func str() -> PyResult<String> {
    // If args is a tuple of exactly one item, apply repr to args[0].
    // This is done so that e.g. the exception raised by {{}}[''] prints
    //     KeyError: ''
    // rather than the confusing
    //     KeyError
    // alone.  The downside is that if KeyError is raised with an explanatory
    // string, that string will be displayed in quotes.  Too bad.
    // If args is anything else, use the default BaseException__str__().

    let args = self.getArgs()

    switch args.getLength() {
    case 1:
      let first = args.elements[0]
      return Py.repr(object: first)
    default:
      return super.str()
    }
  }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyKeyError(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyNone> {
    return super.pyInit(args: args, kwargs: kwargs)
  }
}
