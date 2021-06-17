import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore printinternal displayline

// In CPython:
// Python -> builtinmodule.c
// Python -> pythonrun.c
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3/library/functions.html
// https://docs.python.org/3.7/library/io.html

extension PyInstance {

  // MARK: - Print

  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  ///
  /// - Warning:
  /// Swift function has different parameter order!
  ///
  /// - Parameters:
  ///   - args: Objects to print
  public func print(args: [PyObject],
                    file: PyObject?,
                    sep: PyObject? = nil,
                    end: PyObject? = nil,
                    flush: PyObject? = nil) -> PyResult<PyNone> {
    let textFile: PyTextFile
    switch self.getTextFile(file: file) {
    case let .value(t): textFile = t
    case let .error(e): return .error(e)
    }

    let separator: PyString?
    switch self.getSeparator(argName: "sep", object: sep) {
    case let .value(s): separator = s
    case let .error(e): return .error(e)
    }

    let ending: PyString?
    switch self.getSeparator(argName: "end", object: end) {
    case let .value(s): ending = s
    case let .error(e): return .error(e)
    }

    return self.print(args: args,
                      sep: separator,
                      end: ending,
                      file: textFile,
                      flush: flush)
  }

  private var defaultPrintStream: Sys.OutputStream {
    return .stdout
  }

  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  ///
  /// - Warning:
  /// Swift function has different parameter order!
  ///
  /// - Parameters:
  ///   - args: Objects to print
  public func print(args: [PyObject],
                    stream: Sys.OutputStream?,
                    sep: PyString? = nil,
                    end: PyString? = nil,
                    flush: PyObject? = nil) -> PyResult<PyNone> {
    let stream = stream ?? self.defaultPrintStream

    switch stream.getFile() {
    case let .value(file):
      return self.print(args: args,
                        sep: sep,
                        end: end,
                        file: file,
                        flush: flush)
    case let .error(e):
      return .error(e)
    }
  }

  private func print(args: [PyObject],
                     sep: PyString?,
                     end: PyString?,
                     file: PyTextFile,
                     flush: PyObject?) -> PyResult<PyNone> {
    for (index, object) in args.enumerated() {
      if index > 0 {
        let separator = sep?.value ?? " "
        switch file.write(string: separator) {
        case .value: break
        case .error(let e): return .error(e)
        }
      }

      let string: String
      switch self.strValue(object: object) {
      case let .value(s): string = s
      case let .error(e): return .error(e)
      }

      if let e = self.write(file: file, string: string) {
        return .error(e)
      }
    }

    let ending = end?.value ?? "\n"
    if let e = self.write(file: file, string: ending) {
      return .error(e)
    }

    // We do not support 'flush' at the moment.
    return .value(self.none)
  }

  private func getTextFile(file: PyObject?) -> PyResult<PyTextFile> {
    guard let file = file, !file.isNone else {
      return self.defaultPrintStream.getFile()
    }

    guard let textFile = PyCast.asTextFile(file) else {
      return .error(Py.newAttributeError(object: file, hasNoAttribute: "write"))
    }

    return .value(textFile)
  }

  private func getSeparator(argName: String,
                            object: PyObject?) -> PyResult<PyString?> {
    guard let object = object else {
      return .value(.none)
    }

    if object.isNone {
      return .value(.none)
    }

    guard let string = PyCast.asString(object) else {
      let msg = "\(argName) must be None or a string, not \(object.typeName)"
      return .typeError(msg)
    }

    return .value(string)
  }

  private func write(file: PyTextFile, string: String) -> PyBaseException? {
    switch file.write(string: string) {
    case .value:
      return nil
    case .error(let e):
      return e
    }
  }

  // MARK: - Print error

  /// This function will swallow any error and continue printing!
  ///
  /// static void
  /// print_exception_recursive(PyObject *f, PyObject *value, PyObject *seen)
  public func printRecursive(error: PyBaseException, file: PyTextFile) {
    var alreadyPrinted = Set<ObjectIdentifier>()
    self.printRecursive(error: error,
                        file: file,
                        alreadyPrinted: &alreadyPrinted)
  }

  private var causeMsg: String {
    return """

    The above exception was the direct cause of the following exception:


    """
  }

  private var contextMsg: String {
    return """

    During handling of the above exception, another exception occurred:


    """
  }

  /// This function will swallow any error and continue printing!
  ///
  /// static void
  /// print_exception_recursive(PyObject *f, PyObject *value, PyObject *seen)
  private func printRecursive(error: PyBaseException,
                              file: PyTextFile,
                              alreadyPrinted: inout Set<ObjectIdentifier>) {
    // Mark it as 'already printed' (even though it was not yet printed),
    // to prevent infinite recursion.
    let id = ObjectIdentifier(error)
    alreadyPrinted.insert(id)

    if let cause = error.getCause() {
      let causeId = ObjectIdentifier(cause)
      if !alreadyPrinted.contains(causeId) {
        self.printRecursive(error: cause,
                            file: file,
                            alreadyPrinted: &alreadyPrinted)
        _ = self.write(file: file, string: self.causeMsg) // swallow error
      }
    } else if let context = error.getContext(), !error.getSuppressContext() {
      let contextId = ObjectIdentifier(context)
      if !alreadyPrinted.contains(contextId) {
        self.printRecursive(error: context,
                            file: file,
                            alreadyPrinted: &alreadyPrinted)
        _ = self.write(file: file, string: self.contextMsg) // swallow error
      }
    }

    _ = self.print(error: error, file: file) // swallow error (again…)
  }

  /// static void
  /// print_exception(PyObject *f, PyObject *value)
  public func print(error: PyBaseException,
                    file: PyTextFile) -> PyBaseException? {
    // This is what we are going after:
    // >>> raise AnnaException('Then don\'t run into fire!')
    // Traceback (most recent call last):
    //   File "<frozen.py>", line 2, in <elsa_walks_into_fire_module>
    // AnnaException: Then don't run into fire
    //
    // Regular reminder that Elsa outfit at the beginning of Frozen 2 was AMAZING…
    // You know, the one before she ran into water.
    // Yeah, there may be a pattern here…
    //
    // Also:
    // We could totally use '??' as monadic bind for errors and write this whole
    // function as a single line with just 'return' statement.
    // But we are not monsters…

    if let traceback = error.getTraceback() {
      if let e = self.print(traceback: traceback, file: file) {
        return e
      }
    }

    if let e = self.printFileAndLine(error: error, file: file) {
      return e
    }

    if let e = self.printModuleDotClassName(error: error, file: file) {
      return e
    }

    let str: String = {
      switch self.strValue(object: error) {
      case .value(let s) where s.isEmpty:
        return "\n"
      case .value(let s):
        return ": " + s + "\n"
      case .error:
        return ": <exception str() failed>\n"
      }
    }()

    return self.write(file: file, string: str)
  }

  // MARK: - Print traceback

  /// int
  /// PyTraceBack_Print(PyObject *v, PyObject *f)
  public func print(traceback: PyTraceback,
                    file: PyTextFile) -> PyBaseException? {
    func asIntButUseMaxWhenOutOfRange(bigInt: BigInt) -> Int {
      if let int = Int(exactly: bigInt) {
        return int
      }

      return bigInt < 0 ? Int.min : Int.max
    }

    switch self.sys.getTracebackLimit() {
    case let .value(i):
      let limit: Int = asIntButUseMaxWhenOutOfRange(bigInt: i.value)
      return self.print(traceback: traceback, file: file, limit: limit)
    case let .error(e):
      return e
    }
  }

  /// CPython: `TB_RECURSIVE_CUTOFF`
  private var recursiveCutoff: Int {
    return 3
  }

  /// static int
  /// tb_printinternal(PyTracebackObject *tb, PyObject *f, long limit)
  public func print(traceback: PyTraceback,
                    file: PyTextFile,
                    limit: Int) -> PyBaseException? {
    // From 'https://docs.python.org/3.7/library/sys.html#sys.tracebacklimit':
    // When set to 0 or less, all traceback information is suppressed
    // and only the exception type and value are printed.
    guard limit > 0 else {
      return nil
    }

    let header = "Traceback (most recent call last):\n"
    if let e = self.write(file: file, string: header) {
      return e
    }

    // We could store tracebacks in array,
    // but that would be allocation and we don't know what caused error.

    // Keep previous, because we need to check for recurrence
    var recursiveCount = 0
    var previous: PyTraceback?
    var current: PyTraceback? = self.limit(traceback: traceback, to: limit)

    // This is 1:1 from CPython, because it is quite mind-bending:
    while let tb = current {
      let samePlace = self.hasEqualFileLineAndName(current: tb,
                                                   previous: previous)

      if !samePlace {
        if recursiveCount > self.recursiveCutoff {
          if let e = self.printLineRepeated(file: file, count: recursiveCount) {
            return e
          }
        }

        previous = current
        recursiveCount = 0
      }

      recursiveCount += 1

      if recursiveCount <= self.recursiveCutoff {
        if let e = self.displayLine(file: file, traceback: tb) {
          return e
        }
      }

      current = tb.getNext()
    }

    if recursiveCount > self.recursiveCutoff {
      if let e = self.printLineRepeated(file: file, count: recursiveCount) {
        return e
      }
    }

    return nil
  }

  private func limit(traceback: PyTraceback, to limit: Int) -> PyTraceback {
    assert(limit > 0)

    var depth = 0
    var goToTopIncrementingDepth: PyTraceback? = traceback

    while let n = goToTopIncrementingDepth {
      depth += 1
      goToTopIncrementingDepth = n.getNext()
    }

    assert(depth >= 1, "We totally executed while at least once, c'mon...")

    // We always count from 'main' to 'limit' and then stop.
    // Not the other way around: from 'traceback' to 'limit'.
    var result = traceback

    while depth > limit {
      guard let next = result.getNext() else {
        // CPython has to check for 'tb != NULL' because that is how they deal
        // with 'limit <= 0'.
        trap("'depth' was supposed to be > 'limit', so no idea how we arrived here")
      }

      depth -= 1
      result = next
    }

    return result
  }

  private func hasEqualFileLineAndName(current: PyTraceback,
                                       previous: PyTraceback?) -> Bool {
    // No previous -> definitely not equal
    guard let previous = previous else {
      return false
    }

    let code = current.getFrame().code
    let previousCode = previous.getFrame().code

    return code.filename.isEqual(previousCode.filename)
        && current.getLineNo().isEqual(previous.getLineNo())
        && code.name.isEqual(previousCode.name)
  }

  /// static int
  /// tb_print_line_repeated(PyObject *f, long cnt)
  private func printLineRepeated(file: PyTextFile,
                                 count: Int) -> PyBaseException? {
    let msgCount = count - self.recursiveCutoff
    assert(msgCount > 0)

    let string = msgCount > 1 ?
      "  [Previous line repeated \(msgCount) more times]\n" :
      "  [Previous line repeated \(msgCount) more time]\n"

    return self.write(file: file, string: string)
  }

  /// static int
  /// tb_displayline(PyObject *f, PyObject *filename, int lineno, PyObject *name)
  private func displayLine(file: PyTextFile,
                           traceback: PyTraceback) -> PyBaseException? {
    let frame = traceback.getFrame()
    let code = frame.code

    let filename = code.filename.value
    let lineno = traceback.getLineNo().value
    let name = code.name.value

    let string = "  File \"\(filename)\", line \(lineno), in \(name)\n"
    if let e = self.write(file: file, string: string) {
      return e
    }

    // TODO: Print line when printing traceback
    // (Remember that 'file' parameter is the file we are writing TO,
    //  not an actual file from which we have to print line! Use 'code' for this.)
    let line = "    ... (some code, probably, idk, not implemented)\n"
    return self.write(file: file, string: line)
  }

  // MARK: - File and line

  private func printFileAndLine(error: PyBaseException,
                                file: PyTextFile) -> PyBaseException? {
    let print_file_and_line = self.intern(string: "print_file_and_line")
    switch self.hasattr(object: error, name: print_file_and_line) {
    case .value(true): break
    case .value(false): return nil // Do nothing
    case .error(let e): return e // Ooops…
    }

    let filename: String
    switch self.getErrorAttribute(error: error, name: "filename") {
    case let .value(s): filename = s
    case let .error(e): return e
    }

    let lineno: String
    switch self.getErrorAttribute(error: error, name: "lineno") {
    case let .value(s): lineno = s
    case let .error(e): return e
    }

    let line = "  File \"\(filename)\", line \(lineno)\n"
    return self.write(file: file, string: line)
  }

  private func getErrorAttribute(error: PyBaseException,
                                 name: String) -> PyResult<String> {
    let key = self.intern(string: name)

    let object: PyObject
    switch self.getattr(object: error, name: key) {
    case let .value(o): object = o
    case let .error(e): return .error(e)
    }

    return self.strValue(object: object)
  }

  // MARK: - Module (dot) class

  private func printModuleDotClassName(error: PyBaseException,
                                       file: PyTextFile) -> PyBaseException? {
    let type = error.type
    assert(type.isException)

    // Module
    switch type.getModule() {
    case .module(let name):
      if let e = self.write(file: file, string: name + ".") {
        return e
      }

    case .builtins:
      break // do not write module

    case .error:
      if let e = self.write(file: file, string: "<unknown>.") {
        return e
      }
    }

    // Class name
    let className: String = {
      let typeName = type.getName()

      if let moduleEndIndex = typeName.firstIndex(of: ".") {
        let afterDot = typeName.index(after: moduleEndIndex)
        return String(typeName[afterDot...])
      }

      return typeName
    }()

    return self.write(file: file, string: className)
  }
}
