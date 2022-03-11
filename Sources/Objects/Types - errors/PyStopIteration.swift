import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = StopIteration, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PyStopIteration: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let stopIterationDoc = "Signal the end from iterator.__next__()."

  // sourcery: includeInLayout
  internal var value: PyObject { self.valuePtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           value: PyObject,
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
    self.valuePtr.initialize(to: value)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyStopIteration(ptr: ptr)
    return "PyStopIteration(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

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

  // sourcery: pyproperty = value, setter
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

*/
