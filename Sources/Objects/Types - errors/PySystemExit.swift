import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = SystemExit, pybase = BaseException, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PySystemExit: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let systemExitDoc = "Request to exit from the interpreter."

  // sourcery: includeInLayout
  internal var code: PyObject? { self.codePtr.pointee } //

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           code: PyObject?,
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
    self.codePtr.initialize(to: code)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PySystemExit(ptr: ptr)
    return "PySystemExit(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func getClass(systemExit: PySystemExit) -> PyType {
    return systemExit.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func getDict(systemExit: PySystemExit) -> PyDict {
    return systemExit.__dict__
  }

  // MARK: - Code

  // sourcery: pyproperty = code, setter
  internal func getCode() -> PyObject? {
    return self.code
  }

  internal func setCode(_ value: PyObject?) -> PyResult<Void> {
    self.code = value
    return .value()
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pySystemExitNew(type: PyType,
                                       args: [PyObject],
                                       kwargs: PyDict?) -> PyResult<PySystemExit> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyMemory.newSystemExit(type: type, args: argsTuple)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  internal func pySystemExitInit(args: [PyObject],
                                 kwargs: PyDict?) -> PyResult<PyNone> {
    switch args.count {
    case 0:
      self.code = nil
    case 1:
      self.code = args[0]
    default:
      // Check if 'self.code' is already this tuple (to avoid allocation).
      if !self.isCodeEqual(to: args) {
        self.code = Py.newTuple(elements: args)
      }
    }

    return self.pyBaseExceptionInit(args: args, kwargs: kwargs)
  }

  private func isCodeEqual(to args: [PyObject]) -> Bool {
    let codeOrNil = self.code.flatMap(PyCast.asTuple(_:))
    guard let code = codeOrNil else {
      return false
    }

    let codeElements = code.elements
    return codeElements.count == args.count
      && zip(codeElements, args).allSatisfy { $0.0 === $0.1 }
  }
}

*/
