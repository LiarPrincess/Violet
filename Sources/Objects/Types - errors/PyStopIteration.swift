import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = StopIteration, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public final class PyStopIteration: PyException {

  // sourcery: pytypedoc
  internal static let stopIterationDoc = "Signal the end from iterator.__next__()."

  // MARK: - Properties

  private var value: PyObject

  // MARK: - Init

  /// Type to set in `init`.
  override internal class var pythonTypeToSetInInit: PyType {
    return Py.errorTypes.stopIteration
  }

  internal convenience init(value: PyObject?,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    let args = Py.newTuple(value ?? Py.none)
    let type = Self.pythonTypeToSetInInit
    self.init(type: type,
              args: args,
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext)
  }

  override internal init(type: PyType,
                         args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = false) {
    self.value = Self.extractValue(args: args.elements)
    super.init(type: type,
               args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext)
  }

  private static func extractValue(args: [PyObject]) -> PyObject {
    return args.first ?? Py.none
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func getClass(stopIteration: PyStopIteration) -> PyType {
    return stopIteration.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func getDict(stopIteration: PyStopIteration) -> PyDict {
    return stopIteration.__dict__
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
    let result = PyMemory.newStopIteration(type: type, args: argsTuple)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pyStopIterationInit(args: [PyObject],
                                    kwargs: PyDict?) -> PyResult<PyNone> {
    self.value = Self.extractValue(args: args)
    return self.pyExceptionInit(args: args, kwargs: kwargs)
  }
}
