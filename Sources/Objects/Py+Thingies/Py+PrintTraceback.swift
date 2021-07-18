import Foundation
import BigInt
import VioletCore

// cSpell:ignore printinternal displayline

// In CPython:
// Python -> pythonrun.c
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3/library/functions.html
// https://docs.python.org/3.7/library/io.html

/// CPython: `TB_RECURSIVE_CUTOFF`
private let recursiveCutoff = 3

extension PyInstance {

  /// int
  /// PyTraceBack_Print(PyObject *v, PyObject *f)
  public func print(traceback: PyTraceback,
                    file: PyTextFile) -> PyBaseException? {
    func clampToInt(bigInt: BigInt) -> Int {
      if let int = Int(exactly: bigInt) {
        return int
      }

      return bigInt < 0 ? Int.min : Int.max
    }

    switch self.sys.getTracebackLimit() {
    case let .value(i):
      let limit: Int = clampToInt(bigInt: i.value)
      return self.print(traceback: traceback, file: file, limit: limit)
    case let .error(e):
      return e
    }
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
        if let e = self.displayLine(file: file, traceback: tb) {
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
    let msgCount = count - recursiveCutoff
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

  // MARK: - Write

  private func write(file: PyTextFile, string: String) -> PyBaseException? {
    switch file.write(string: string) {
    case .value:
      return nil
    case .error(let e):
      return e
    }
  }
}
