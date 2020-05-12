// sourcery: pyerrortype = StopIteration, default, baseType, hasGC, baseExceptionSubclass
public final class PyStopIteration: PyException {

  override internal class var doc: String {
    return "Signal the end from iterator.__next__()."
  }

  override public var description: String {
    return self.createDescription(typeName: "PyStopIteration")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.stopIteration
  }

  private var value: PyObject

  internal convenience init(value: PyObject,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    let args = Py.newTuple(value)
    self.init(args: args,
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext,
              type: type)
  }

  override internal init(args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = false,
                         type: PyType? = nil) {
    self.value = args.elements.first ?? Py.none
    super.init(args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext,
               type: type)
  }

   // sourcery: pyproperty = __class__
   override public func getClass() -> PyType {
     return self.type
   }

   // sourcery: pyproperty = __dict__
   override public func getDict() -> PyDict {
     return self.__dict__
   }

  // sourcery: pyproperty = value, setter = setValue
  public func getValue() -> PyObject {
    return self.value
  }

  public func setValue(_ value: PyObject) -> PyResult<Void> {
    self.value = value
    return .value()
  }

  // sourcery: pystaticmethod = __new__
  override internal class func pyNew(type: PyType,
                                     args: [PyObject],
                                     kwargs: PyDict?) -> PyResult<PyBaseException> {
    let argsTuple = Py.newTuple(args)
    return .value(PyStopIteration(args: argsTuple, type: type))
  }

  // sourcery: pymethod = __init__
  override internal func pyInit(args: [PyObject],
                                kwargs: PyDict?) -> PyResult<PyNone> {
    self.value = args.first ?? Py.none
    return super.pyInit(args: args, kwargs: kwargs)
  }
}
