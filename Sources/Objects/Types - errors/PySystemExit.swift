import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = SystemExit, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public final class PySystemExit: PyBaseException {

  // sourcery: pytypedoc
  internal static let systemExitDoc = "Request to exit from the interpreter."

  // MARK: - Properties

  private var code: PyObject?

  // MARK: - Init

  /// Type to set in `init`.
  override internal class var pythonTypeToSetInInit: PyType {
    return Py.errorTypes.systemExit
  }

  internal convenience init(code: PyObject?,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    var argsElements = [PyObject]()
    if let c = code {
      argsElements.append(c)
    }

    let args = Py.newTuple(elements: argsElements)
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
    switch args.count {
    case 0:
      self.code = nil
    case 1:
      self.code = args.elements[0]
    default:
      self.code = args
    }

    super.init(type: type,
               args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext)
  }

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

  // sourcery: pyproperty = code, setter = setCode
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
