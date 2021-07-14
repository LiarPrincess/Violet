import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = StopIteration, default, baseType, hasGC, baseExceptionSubclass
public final class PyStopIteration: PyException {

  // sourcery: pytypedoc
  internal static let stopIterationDoc = "Signal the end from iterator.__next__()."

  override public var description: String {
    return self.createDescription(typeName: "PyStopIteration")
  }

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.stopIteration
  }

  // MARK: - Properties

  private var value: PyObject

  // MARK: - Init

  internal convenience init(value: PyObject?,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    let args = Py.newTuple(value ?? Py.none)
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
    self.value = Self.extractValue(args: args.elements)
    super.init(args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext,
               type: type)
  }

  private static func extractValue(args: [PyObject]) -> PyObject {
    return args.first ?? Py.none
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  override internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  override internal func getDict() -> PyDict {
    return self.__dict__
  }

  // MARK: - Value

  // sourcery: pyproperty = value, setter = setValue
  internal func getValue() -> PyObject {
    return self.value
  }

  internal func setValue(_ value: PyObject) -> PyResult<Void> {
    self.value = value
    return .value()
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyStopIterationNew(type: PyType,
                                          args: [PyObject],
                                          kwargs: PyDict?) -> PyResult<PyStopIteration> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyStopIteration(args: argsTuple, type: type)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyStopIterationInit(args: [PyObject],
                                    kwargs: PyDict?) -> PyResult<PyNone> {
    self.value = Self.extractValue(args: args)
    return super.pyExceptionInit(args: args, kwargs: kwargs)
  }
}
