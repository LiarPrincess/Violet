import BigInt
import VioletCore

// swiftlint:disable file_length

// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
// https://www.python.org/dev/peps/pep-0415/#proposal

// sourcery: pyerrortype = SyntaxError, default, baseType, hasGC
// sourcery: baseExceptionSubclass, instancesHave__dict__
public class PySyntaxError: PyException {

  // sourcery: pytypedoc
  internal static let syntaxErrorDoc = "Invalid syntax."

  /// Type to set in `init`.
  override internal class var pythonType: PyType {
    return Py.errorTypes.syntaxError
  }

  // MARK: - Properties

  private var msg: PyObject?
  private var filename: PyObject?
  private var lineno: PyObject?
  private var offset: PyObject?
  private var text: PyObject?
  private var printFileAndLine: PyObject?

  // MARK: - Init

  // Wow, this is a lot of arguments!
  // But who cares?
  // Not me!

  internal convenience init(msg: String?,
                            filename: String?,
                            lineno: BigInt?,
                            offset: BigInt?,
                            text: String?,
                            printFileAndLine: PyObject?,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    let msg = msg.map(Py.newString(_:))
    let filename = filename.map(Py.newString(_:))
    let lineno = lineno.map(Py.newInt(_:))
    let offset = offset.map(Py.newInt(_:))
    let text = text.map(Py.newString(_:))
    let printFileAndLine = printFileAndLine

    self.init(msg: msg,
              filename: filename,
              lineno: lineno,
              offset: offset,
              text: text,
              printFileAndLine: printFileAndLine,
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext,
              type: type)
  }

  internal convenience init(msg: PyString?,
                            filename: PyString?,
                            lineno: PyInt?,
                            offset: PyInt?,
                            text: PyString?,
                            printFileAndLine: PyObject?,
                            traceback: PyTraceback? = nil,
                            cause: PyBaseException? = nil,
                            context: PyBaseException? = nil,
                            suppressContext: Bool = false,
                            type: PyType? = nil) {
    // Only 'msg' goes to args
    var argsElements = [PyObject]()
    if let m = msg {
      argsElements.append(m)
    }

    self.init(args: Py.newTuple(elements: argsElements),
              traceback: traceback,
              cause: cause,
              context: context,
              suppressContext: suppressContext,
              type: type)

    // 'self.msg' should be filled from args
    if msg != nil {
      assert(self.msg != nil)
    }

    self.filename = filename
    self.lineno = lineno
    self.offset = offset
    self.text = text
    self.printFileAndLine = printFileAndLine
  }

  /// Important: You have to manually fill `filename`, `lineno`, `offset`,
  /// `text` and `print_file_and_line` later!
  override internal init(args: PyTuple,
                         traceback: PyTraceback? = nil,
                         cause: PyBaseException? = nil,
                         context: PyBaseException? = nil,
                         suppressContext: Bool = false,
                         type: PyType? = nil) {
    super.init(args: args,
               traceback: traceback,
               cause: cause,
               context: context,
               suppressContext: suppressContext,
               type: type)

    self.fillMsgFromArgs(args: args.elements)
  }

  private func fillMsgFromArgs(args: [PyObject]) {
    if args.count >= 1 {
      self.msg = args[0]
    }
  }

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

  override internal func str() -> PyResult<String> {
    return Self.str(syntaxError: self)
  }

  // sourcery: pymethod = __str__
  internal static func str(syntaxError: PySyntaxError) -> PyResult<String> {
    // Why this is static? See comment in 'PyBaseException.str'.

    let filenameOrNil: String? = {
      let filenamePyString = syntaxError.filename.flatMap(PyCast.asString(_:))
      guard let path = filenamePyString, !path.isEmpty else {
        return nil
      }

      return Py.fileSystem.basename(path: path.value)
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

  // sourcery: pyproperty = msg, setter = setMsg
  internal func getMsg() -> PyObject? {
    return self.msg
  }

  internal func setMsg(_ value: PyObject?) -> PyResult<Void> {
    self.msg = value
    return .value()
  }

  // MARK: - Filename

  // sourcery: pyproperty = filename, setter = setFilename
  internal func getFilename() -> PyObject? {
    return self.filename
  }

  internal func setFilename(_ value: PyObject?) -> PyResult<Void> {
    self.filename = value
    return .value()
  }

  // MARK: - Lineno

  // sourcery: pyproperty = lineno, setter = setLineno
  internal func getLineno() -> PyObject? {
    return self.lineno
  }

  internal func setLineno(_ value: PyObject?) -> PyResult<Void> {
    self.lineno = value
    return .value()
  }

  // MARK: - Offset

  // sourcery: pyproperty = offset, setter = setOffset
  internal func getOffset() -> PyObject? {
    return self.offset
  }

  internal func setOffset(_ value: PyObject?) -> PyResult<Void> {
    self.offset = value
    return .value()
  }

  // MARK: - Text

  // sourcery: pyproperty = text, setter = setText
  internal func getText() -> PyObject? {
    return self.text
  }

  internal func setText(_ value: PyObject?) -> PyResult<Void> {
    self.text = value
    return .value()
  }

  // MARK: - Print file and line

  // sourcery: pyproperty = print_file_and_line, setter = setPrintFileAndLine
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
    let result = PyMemory.newSyntaxError(args: argsTuple, type: type)
    return .value(result)
  }

  // MARK: - Python init

  // sourcery: pymethod = __init__
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
      let info: [PyObject]
      switch Py.toArray(iterable: args[1]) {
      case let .value(i):
        info = i
      case let .error(e):
        return .error(e)
      }

      guard info.count == 4 else {
        return .indexError("tuple index out of range")
      }

      self.filename = info[0]
      self.lineno = info[1]
      self.offset = info[2]
      self.text = info[3]
    }

    return .value(Py.none)
  }
}
