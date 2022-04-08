import BigInt
import FileSystem
import VioletCore

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = SyntaxError, pybase = Exception, isDefault, isBaseType, hasGC
// sourcery: isBaseExceptionSubclass, instancesHave__dict__
public struct PySyntaxError: PyErrorMixin {

  // sourcery: pytypedoc
  internal static let syntaxErrorDoc = "Invalid syntax."

  // sourcery: storedProperty
  internal var msg: PyObject? {
    get { self.msgPtr.pointee }
    nonmutating set { self.msgPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var filename: PyObject? {
    get { self.filenamePtr.pointee }
    nonmutating set { self.filenamePtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var lineno: PyObject? {
    get { self.linenoPtr.pointee }
    nonmutating set { self.linenoPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var offset: PyObject? {
    get { self.offsetPtr.pointee }
    nonmutating set { self.offsetPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var text: PyObject? {
    get { self.textPtr.pointee }
    nonmutating set { self.textPtr.pointee = newValue }
  }

  // sourcery: storedProperty
  internal var printFileAndLine: PyObject? {
    get { self.printFileAndLinePtr.pointee }
    nonmutating set { self.printFileAndLinePtr.pointee = newValue }
  }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // Wow, this is a lot of arguments!
  // But who cares?
  // Not me!

  // swiftlint:disable:next function_parameter_count
  internal func initialize(
    _ py: Py,
    type: PyType,
    msg: PyObject?,
    filename: PyObject?,
    lineno: PyObject?,
    offset: PyObject?,
    text: PyObject?,
    printFileAndLine: PyObject?,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyBaseException.defaultSuppressContext
  ) {
    // Only 'msg' goes to args
    var argsElements = [PyObject]()
    if let msg = msg {
      argsElements.append(msg)
    }

    let args = py.newTuple(elements: argsElements)
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)

    self.msgPtr.initialize(to: msg)
    self.filenamePtr.initialize(to: filename)
    self.linenoPtr.initialize(to: lineno)
    self.offsetPtr.initialize(to: offset)
    self.textPtr.initialize(to: text)
    self.printFileAndLinePtr.initialize(to: printFileAndLine)
  }

  internal func initialize(
    _ py: Py,
    type: PyType,
    args: PyTuple,
    traceback: PyTraceback? = nil,
    cause: PyBaseException? = nil,
    context: PyBaseException? = nil,
    suppressContext: Bool = PyBaseException.defaultSuppressContext
  ) {
    self.initializeBase(py,
                        type: type,
                        args: args,
                        traceback: traceback,
                        cause: cause,
                        context: context,
                        suppressContext: suppressContext)
    self.msgPtr.initialize(to: nil)
    self.filenamePtr.initialize(to: nil)
    self.linenoPtr.initialize(to: nil)
    self.offsetPtr.initialize(to: nil)
    self.textPtr.initialize(to: nil)
    self.printFileAndLinePtr.initialize(to: nil)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PySyntaxError(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    PyBaseException.fillDebug(zelf: zelf.asBaseException, debug: &result)
    result.append(name: "msg", value: zelf.msg as Any)
    result.append(name: "filename", value: zelf.filename as Any)
    result.append(name: "lineno", value: zelf.lineno as Any)
    result.append(name: "offset", value: zelf.offset as Any)
    result.append(name: "text", value: zelf.text as Any)
    result.append(name: "printFileAndLine", value: zelf.printFileAndLine as Any)
    return result
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func __dict__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__dict__")
    }

    let result = zelf.asBaseException.getDict(py)
    return PyResult(result)
  }

  // MARK: - String

  // sourcery: pymethod = __str__
  internal static func __str__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__str__")
    }

    let filenameOrNil: Filename? = {
      let pyStringOrNil = zelf.filename.flatMap(py.cast.asString(_:))
      guard let pyString = pyStringOrNil, !pyString.isEmpty else {
        return nil
      }

      let path = Path(string: pyString.value)
      return py.fileSystem.basename(path: path)
    }()

    let linenoOrNil: BigInt? = {
      let linenoPyInt = zelf.lineno.flatMap(py.cast.asInt(_:))
      return linenoPyInt?.value
    }()

    let msg: String
    let msgObject = zelf.msg?.asObject ?? py.none.asObject
    switch py.strString(msgObject) {
    case let .value(m): msg = m
    case let .error(e): return .error(e)
    }

    if let filename = filenameOrNil, let lineno = linenoOrNil {
      return PyResult(py, "\(msg) (\(filename), line \(lineno))")
    }

    if let filename = filenameOrNil {
      return PyResult(py, "\(msg) (\(filename))")
    }

    if let lineno = linenoOrNil {
      return PyResult(py, "\(msg) (line \(lineno))")
    }

    return PyResult(py, msg)
  }

  // MARK: - Msg

  // sourcery: pyproperty = msg, setter
  internal static func msg(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "msg")
    }

    return PyResult(py, zelf.msg)
  }

  internal static func msg(_ py: Py,
                           zelf _zelf: PyObject,
                           value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "msg")
    }

    zelf.msg = value
    return .none(py)
  }

  // MARK: - Filename

  // sourcery: pyproperty = filename, setter
  internal static func filename(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "filename")
    }

    return PyResult(py, zelf.filename)
  }

  internal static func filename(_ py: Py,
                                zelf _zelf: PyObject,
                                value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "filename")
    }
    zelf.filename = value
    return .none(py)
  }

  // MARK: - Lineno

  // sourcery: pyproperty = lineno, setter
  internal static func lineno(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "lineno")
    }

    return PyResult(py, zelf.lineno)
  }

  internal static func lineno(_ py: Py,
                              zelf _zelf: PyObject,
                              value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "lineno")
    }

    zelf.lineno = value
    return .none(py)
  }

  // MARK: - Offset

  // sourcery: pyproperty = offset, setter
  internal static func offset(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "offset")
    }

    return PyResult(py, zelf.offset)
  }

  internal static func offset(_ py: Py,
                              zelf _zelf: PyObject,
                              value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "offset")
    }

    zelf.offset = value
    return .none(py)
  }

  // MARK: - Text

  // sourcery: pyproperty = text, setter
  internal static func text(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "text")
    }

    return PyResult(py, zelf.text)
  }

  internal static func text(_ py: Py,
                            zelf _zelf: PyObject,
                            value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "text")
    }

    zelf.text = value
    return .none(py)
  }

  // MARK: - Print file and line

  // sourcery: pyproperty = print_file_and_line, setter
  internal static func print_file_and_line(_ py: Py,
                                           zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "print_file_and_line")
    }

    return PyResult(py, zelf.printFileAndLine)
  }

  internal static func print_file_and_line(_ py: Py,
                                           zelf _zelf: PyObject,
                                           value: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "print_file_and_line")
    }
    zelf.printFileAndLine = value
    return .none(py)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    let argsTuple = py.newTuple(elements: args)
    let result = py.memory.newSyntaxError(type: type, args: argsTuple)
    return PyResult(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  // static int
  // SyntaxError_init(PySyntaxErrorObject *self, PyObject *args, PyObject *kwds)
  internal static func __init__(_ py: Py,
                                zelf _zelf: PyObject,
                                args: [PyObject],
                                kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__init__")
    }

    // Run 'super.pyInit' before our custom code, to avoid situation where
    // 'super.pyInit' errors but we already mutated entity.
    let zelfAsObject = zelf.asObject
    switch PyException.__init__(py, zelf: zelfAsObject, args: args, kwargs: kwargs) {
    case .value: break
    case .error(let e): return .error(e)
    }

    switch Self.unpackInitArgs(py, args: args) {
    case let .value(i):
      zelf.msg = i.msg
      zelf.filename = i.filename
      zelf.lineno = i.lineno
      zelf.offset = i.offset
      zelf.text = i.text
    case let .error(e):
      return .error(e)
    }

    return .none(py)
  }

  private struct InitArgs {
    fileprivate var msg: PyObject?
    fileprivate var filename: PyObject?
    fileprivate var lineno: PyObject?
    fileprivate var offset: PyObject?
    fileprivate var text: PyObject?
    fileprivate var count = 0
  }

  private static func unpackInitArgs(_ py: Py, args: [PyObject]) -> PyResultGen<InitArgs> {
    var result = InitArgs()

    if args.count >= 1 {
      result.msg = args[0]
    }

    if args.count == 2 {
      let e = py.reduce(iterable: args[1], into: &result) { acc, object in
        if acc.filename == nil {
          acc.filename = object
        } else if acc.lineno == nil {
          acc.lineno = object
        } else if acc.offset == nil {
          acc.offset = object
        } else if acc.text == nil {
          acc.text = object
        }

        acc.count += 1
        return .goToNextElement
      }

      if let e = e {
        return .error(e)
      }

      guard result.count == 4 else {
        return .indexError(py, message: "tuple index out of range")
      }

      assert(result.filename != nil)
      assert(result.lineno != nil)
      assert(result.offset != nil)
      assert(result.text != nil)
    }

    return .value(result)
  }
}
