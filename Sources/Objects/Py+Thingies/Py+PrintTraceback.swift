import Foundation
import BigInt
import FileSystem
import UnicodeData
import VioletCore

// cSpell:ignore printinternal displayline

// In CPython:
// Python -> pythonrun.c
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3/library/functions.html
// https://docs.python.org/3.7/library/io.html

/// CPython: `TB_RECURSIVE_CUTOFF`
private let recursiveCutoff = 3

extension Py {

  /// int
  /// PyTraceBack_Print(PyObject *v, PyObject *f)
  public func print(file: PyTextFile, traceback: PyTraceback) -> PyBaseException? {
    func clampToInt(bigInt: BigInt) -> Int {
      if let int = Int(exactly: bigInt) {
        return int
      }

      return bigInt < 0 ? Int.min : Int.max
    }

    switch self.sys.getTracebackLimit() {
    case let .value(i):
      let limit: Int = clampToInt(bigInt: i.value)
      return self.print(file: file, traceback: traceback, limit: limit)
    case let .error(e):
      return e
    }
  }

  /// static int
  /// tb_printinternal(PyTracebackObject *tb, PyObject *f, long limit)
  public func print(file: PyTextFile,
                    traceback: PyTraceback,
                    limit: Int) -> PyBaseException? {
    // From 'https://docs.python.org/3.7/library/sys.html#sys.tracebacklimit':
    // When set to 0 or less, all traceback information is suppressed
    // and only the exception type and value are printed.
    guard limit > 0 else {
      return nil
    }

    let header = "Traceback (most recent call last):\n"
    if let e = file.write(self, string: header) {
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
      if !self.hasEqualFileLineAndName(current: tb, previous: previous) {
        if recursiveCount > recursiveCutoff {
          if let e = self.printLineRepeated(file: file, count: recursiveCount) {
            return e
          }
        }

        previous = current
        recursiveCount = 0
      }

      recursiveCount += 1

      if recursiveCount <= recursiveCutoff {
        if let e = self.printLine(file: file, traceback: tb) {
          return e
        }
      }

      current = tb.getNext()
    }

    if recursiveCount > recursiveCutoff {
      if let e = self.printLineRepeated(file: file, count: recursiveCount) {
        return e
      }
    }

    return nil
  }

  // MARK: - Limit

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

  // MARK: - Equal file, line and name

  private func hasEqualFileLineAndName(current: PyTraceback,
                                       previous: PyTraceback?) -> Bool {
    // No previous -> definitely not equal
    guard let previous = previous else {
      return false
    }

    // Start with line, because it has the biggest probability to be different
    // (and also 'int' is easier to compare than 'str').
    guard current.getLineNo() == previous.getLineNo() else {
      return false
    }

    let code = current.getFrame().code
    let previousCode = previous.getFrame().code
    return code.filename.isEqual(previousCode.filename)
        && code.name.isEqual(previousCode.name)
  }

  // MARK: - Line repeated X times

  /// static int
  /// tb_print_line_repeated(PyObject *f, long cnt)
  private func printLineRepeated(file: PyTextFile,
                                 count: Int) -> PyBaseException? {
    let msgCount = count - recursiveCutoff
    assert(msgCount > 0)

    let string = msgCount > 1 ?
      "  [Previous line repeated \(msgCount) more times]\n" :
      "  [Previous line repeated \(msgCount) more time]\n"

    return file.write(self, string: string)
  }

  // MARK: - Print line

  /// static int
  /// tb_displayline(PyObject *f, PyObject *filename, int lineno, PyObject *name)
  private func printLine(file: PyTextFile, traceback: PyTraceback) -> PyBaseException? {
    let frame = traceback.getFrame()
    let code = frame.code

    let filename = code.filename.value
    let lineno = traceback.getLineNo().value
    let name = code.name.value

    let string = "  File \"\(filename)\", line \(lineno), in \(name)\n"
    if let e = file.write(self, string: string) {
      return e
    }

    let filenamePath = Path(string: filename)
    switch self.getLine(path: filenamePath, lineno: lineno) {
    case .value(let code):
      let line = "    \(code)\n"
      return file.write(self, string: line)
    case .fileNotFound:
      return nil
    case .error(let e):
      return e
    }
  }

  private enum GetLineResult {
    case value(Substring)
    case fileNotFound
    case error(PyBaseException)
  }

  /// int
  /// _Py_DisplaySourceLine(PyObject *f, PyObject *filename, int lineno, int indent)
  private func getLine(path: Path, lineno: BigInt) -> GetLineResult {
    let source: String
    switch self.readSourceFileForTraceback(path: path) {
    case .value(let s):
      source = s
    case .notFound:
      return .fileNotFound
    case .decodingError(let e),
         .error(let e):
      return .error(e)
    }

    switch self.getLine(source: source, lineno: lineno) {
    case let .value(l):
      return .value(l)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Print line - read file

  private enum SourceFile {
    case value(String)
    case notFound
    /// File exists, but can't be read.
    case decodingError(PyBaseException)
    case error(PyBaseException)
  }

  private func readSourceFileForTraceback(path: Path) -> SourceFile {
    switch self.readSourceFile(path: path) {
    case .value(let s): return .value(s)
    case .decodingError(let e): return .decodingError(e)
    case .readError: break // File may not exit, try 'sys.path'
    }

    let basename = self.fileSystem.basename(path: path)

    let sysPath: PyList
    switch self.sys.getPath() {
    case let .value(l): sysPath = l
    case let .error(e): return .error(e)
    }

    enum Result {
      case value(String)
      case decodingError(PyBaseException)
      case notFound
    }

    let sysPathObject = sysPath.asObject
    let result = self.reduce(iterable: sysPathObject, initial: Result.notFound) { _, object in
      guard let dir = self.cast.asString(object) else {
        return .goToNextElement
      }

      let dirPath = Path(string: dir.value)
      let filePath = self.fileSystem.join(path: dirPath, element: basename)

      switch self.readSourceFile(path: filePath) {
      case .value(let s): return .finish(.value(s))
      case .decodingError(let e): return .finish(.decodingError(e))
      case .readError: return .goToNextElement // File may not exit, ignore
      }
    }

    switch result {
    case .value(.value(let s)): return .value(s)
    case .value(.decodingError(let e)): return .decodingError(e)
    case .value(.notFound): return .notFound
    case .error(let e): return .error(e) // Iteration error
    }
  }

  // MARK: - Print line - n-th line

  /// PyObject *
  /// PyFile_GetLine(PyObject *f, int n)
  private func getLine(source: String,
                       lineno requestedLineNumber: BigInt) -> PyResultGen<Substring> {
    guard let requestedLineNumber = Int(exactly: requestedLineNumber),
          requestedLineNumber >= 0 else {
      return .eofError(self, message: "EOF when reading a line")
    }

    let scalars = source.unicodeScalars

    var lineNumber = 1 // Lines in editor start from 1, not from 0!
    var index = scalars.startIndex
    var lineStartIndex = index

    // 'while' check will also handle empty string
    while index != scalars.endIndex {
      let scalar = scalars[index]
      let isLineBreak = UnicodeData.isLineBreak(scalar)

      if isLineBreak {
        let isRequestedLine = lineNumber == requestedLineNumber
        if isRequestedLine {
          let line = source[lineStartIndex..<index]
          let lineTrim = self.trim(substring: line)
          return .value(lineTrim)
        }

        lineNumber += 1
        lineStartIndex = index

        // Consume CRLF as one
        self.advanceIfCRLF(scalars: scalars, index: &index)
      }

      scalars.formIndex(after: &index)
    }

    return .eofError(self, message: "EOF when reading a line")
  }

  private func trim(substring: Substring) -> Substring {
    var result = substring.drop { $0.isWhitespace }
    result = result.dropLast { $0.isWhitespace }
    return result
  }

  private func advanceIfCRLF(scalars: String.UnicodeScalarView,
                             index: inout String.Index) {
    let scalar = scalars[index]
    let isCarriageReturn = scalar.value == 0x0d
    guard isCarriageReturn else {
      return
    }

    let indexAfter = scalars.index(after: index)
    guard indexAfter != scalars.endIndex else {
      return
    }

    let scalarAfter = scalars[indexAfter]
    let isLineFeedAfter = scalarAfter.value == 0x0a
    if isLineFeedAfter {
      scalars.formIndex(after: &index)
    }
  }
}
