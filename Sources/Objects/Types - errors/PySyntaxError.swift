import BigInt
import FileSystem
import VioletCore

// swiftlint:disable file_length

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

  // sourcery: includeInLayout
  internal var msg: PyObject? { self.msgPtr.pointee }
  // sourcery: includeInLayout
  internal var filename: PyObject? { self.filenamePtr.pointee }
  // sourcery: includeInLayout
  internal var lineno: PyObject? { self.linenoPtr.pointee }
  // sourcery: includeInLayout
  internal var offset: PyObject? { self.offsetPtr.pointee }
  // sourcery: includeInLayout
  internal var text: PyObject? { self.textPtr.pointee }
  // sourcery: includeInLayout
  internal var printFileAndLine: PyObject? { self.printFileAndLinePtr.pointee }

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // Wow, this is a lot of arguments!
  // But who cares?
  // Not me!

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           msg: PyObject?,
                           filename: PyObject?,
                           lineno: PyObject?,
                           offset: PyObject?,
                           text: PyObject?,
                           printFileAndLine: PyObject?,
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
    self.msgPtr.initialize(to: msg)
    self.filenamePtr.initialize(to: filename)
    self.linenoPtr.initialize(to: lineno)
    self.offsetPtr.initialize(to: offset)
    self.textPtr.initialize(to: text)
    self.printFileAndLinePtr.initialize(to: printFileAndLine)
  }

  // Nothing to do here.
  internal func beforeDeinitialize() { }

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PySyntaxError(ptr: ptr)
    return "PySyntaxError(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func getClass(syntaxError: PySyntaxError) -> PyType {
    return syntaxError.type
  }

  // MARK: - Dict

  // sourcery: pyproperty = __dict__
  internal static func getDict(syntaxError: PySyntaxError) -> PyDict {
    return syntaxError.__dict__
  }

  // MARK: - String

  // sourcery: pymethod = __str__
  internal static func str(syntaxError: PySyntaxError) -> PyResult<String> {
    // Why this is static? See comment in 'PyBaseException.str'.

    let filenameOrNil: Filename? = {
      let pyStringOrNil = syntaxError.filename.flatMap(PyCast.asString(_:))
      guard let pyString = pyStringOrNil, !pyString.isEmpty else {
        return nil
      }

      let path = Path(string: pyString.value)
      return Py.fileSystem.basename(path: path)
    }()

    let linenoOrNil: BigInt? = {
      let linenoPyInt = syntaxError.lineno.flatMap(PyCast.asInt(_:))
      return linenoPyInt?.value
    }()

    let msg: String
    switch Py.strString(object: syntaxError.msg ?? Py.none) {
    case let .value(m): msg = m
    case let .error(e): return .error(e)
    }

    if let filename = filenameOrNil, let lineno = linenoOrNil {
      return .value("\(msg) (\(filename), line \(lineno))")
    }

    if let filename = filenameOrNil {
      return .value("\(msg) (\(filename))")
    }

    if let lineno = linenoOrNil {
      return .value("\(msg) (line \(lineno))")
    }

    return .value(msg)
  }

  // MARK: - Msg

  // sourcery: pyproperty = msg, setter
  internal func getMsg() -> PyObject? {
    return self.msg
  }

  internal func setMsg(_ value: PyObject?) -> PyResult<Void> {
    self.msg = value
    return .value()
  }

  // MARK: - Filename

  // sourcery: pyproperty = filename, setter
  internal func getFilename() -> PyObject? {
    return self.filename
  }

  internal func setFilename(_ value: PyObject?) -> PyResult<Void> {
    self.filename = value
    return .value()
  }

  // MARK: - Lineno

  // sourcery: pyproperty = lineno, setter
  internal func getLineno() -> PyObject? {
    return self.lineno
  }

  internal func setLineno(_ value: PyObject?) -> PyResult<Void> {
    self.lineno = value
    return .value()
  }

  // MARK: - Offset

  // sourcery: pyproperty = offset, setter
  internal func getOffset() -> PyObject? {
    return self.offset
  }

  internal func setOffset(_ value: PyObject?) -> PyResult<Void> {
    self.offset = value
    return .value()
  }

  // MARK: - Text

  // sourcery: pyproperty = text, setter
  internal func getText() -> PyObject? {
    return self.text
  }

  internal func setText(_ value: PyObject?) -> PyResult<Void> {
    self.text = value
    return .value()
  }

  // MARK: - Print file and line

  // sourcery: pyproperty = print_file_and_line, setter
  internal func getPrintFileAndLine() -> PyObject? {
    return self.printFileAndLine
  }

  internal func setPrintFileAndLine(_ value: PyObject?) -> PyResult<Void> {
    self.printFileAndLine = value
    return .value()
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pySyntaxErrorNew(type: PyType,
                                        args: [PyObject],
                                        kwargs: PyDict?) -> PyResult<PySyntaxError> {
    let argsTuple = Py.newTuple(elements: args)
    let result = PyMemory.newSyntaxError(type: type, args: argsTuple)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
  // static int
  // SyntaxError_init(PySyntaxErrorObject *self, PyObject *args, PyObject *kwds)
  internal func pySyntaxErrorInit(args: [PyObject],
                                  kwargs: PyDict?) -> PyResult<PyNone> {
    // Run 'super.pyInit' before our custom code, to avoid situation where
    // 'super.pyInit' errors but we already mutated entity.
    switch self.pyExceptionInit(args: args, kwargs: kwargs) {
    case .value:
      break
    case .error(let e):
      return .error(e)
    }

    self.fillMsgFromArgs(args: args)

    if args.count == 2 {
      switch self.unpackInitArgs(iterable: args[1]) {
      case let .value(i):
        self.filename = i.filename
        self.lineno = i.lineno
        self.offset = i.offset
        self.text = i.text
      case let .error(e):
        return .error(e)
      }
    }

    return .value(Py.none)
  }

  private struct InitArgs {
    fileprivate var filename: PyObject?
    fileprivate var lineno: PyObject?
    fileprivate var offset: PyObject?
    fileprivate var text: PyObject?
    fileprivate var count = 0
  }

  private func unpackInitArgs(iterable: PyObject) -> PyResult<InitArgs> {
    var result = InitArgs()
    let e = Py.reduce(iterable: iterable, into: &result) { acc, object in
      acc.count += 1

      if acc.filename == nil {
        acc.filename = object
      } else if acc.lineno == nil {
        acc.lineno = object
      } else if acc.offset == nil {
        acc.offset = object
      } else if acc.text == nil {
        acc.text = object
      }

      return .goToNextElement
    }

    if let e = e {
      return .error(e)
    }

    guard result.count == 4 else {
      return .indexError("tuple index out of range")
    }

    assert(result.filename != nil)
    assert(result.lineno != nil)
    assert(result.offset != nil)
    assert(result.text != nil)
    return .value(result)
  }
}

*/
