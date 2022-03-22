import Foundation
import BigInt
import VioletCore

// In CPython:
// Python -> builtinmodule.c
// Python -> pythonrun.c
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3/library/functions.html
// https://docs.python.org/3.7/library/io.html

private let defaultStream = Sys.OutputStream.stdout

extension Py {

  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  ///
  /// - Warning:
  /// Swift function has different parameter order!
  ///
  /// - Parameters:
  ///   - arg: Object to print
  public func print(file: PyObject?,
                    arg: PyObject,
                    end: PyObject? = nil,
                    flush: PyObject? = nil) -> PyBaseException? {
    let _file: PyTextFile
    switch self.getTextFile(file: file) {
    case let .value(t): _file = t
    case let .error(e): return e
    }

    let _end: PyString?
    switch self.parseEnd(object: end) {
    case let .value(s): _end = s
    case let .error(e): return e
    }

    return self.printCommon(file: _file, arg: arg, end: _end, flush: flush)
  }

  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  ///
  /// - Warning:
  /// Swift function has different parameter order!
  ///
  /// - Parameters:
  ///   - args: Objects to print
  public func print(file: PyObject?,
                    args: [PyObject],
                    separator: PyObject? = nil,
                    end: PyObject? = nil,
                    flush: PyObject? = nil) -> PyBaseException? {
    let _file: PyTextFile
    switch self.getTextFile(file: file) {
    case let .value(t): _file = t
    case let .error(e): return e
    }

    let _separator: PyString?
    switch self.parseSeparator(object: separator) {
    case let .value(s): _separator = s
    case let .error(e): return e
    }

    let _end: PyString?
    switch self.parseEnd(object: end) {
    case let .value(s): _end = s
    case let .error(e): return e
    }

    return self.printCommon(file: _file,
                            args: args,
                            separator: _separator,
                            end: _end,
                            flush: flush)
  }

  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  ///
  /// - Warning:
  /// Swift function has different parameter order!
  ///
  /// - Parameters:
  ///   - args: Objects to print
  public func print(stream: Sys.OutputStream?,
                    args: [PyObject],
                    separator: PyString? = nil,
                    end: PyString? = nil,
                    flush: PyObject? = nil) -> PyBaseException? {
    let stream = stream ?? defaultStream

    switch self.sys.getFile(stream: stream) {
    case let .value(file):
      return self.printCommon(file: file,
                              args: args,
                              separator: separator,
                              end: end,
                              flush: flush)
    case let .error(e):
      return e
    }
  }

  // MARK: - Common

  /// Actual printing function.
  private func printCommon(file: PyTextFile,
                           arg: PyObject,
                           end: PyString?,
                           flush: PyObject?) -> PyBaseException? {
    if let error = self.printSingle(file: file, object: arg) {
      return error
    }

    if let error = self.printEnd(file: file, end: end) {
      return error
    }

    return self.flush(file: file, object: flush)
  }

  /// Actual printing function.
  private func printCommon(file: PyTextFile,
                           args: [PyObject],
                           separator: PyString?,
                           end: PyString?,
                           flush: PyObject?) -> PyBaseException? {
    for (index, object) in args.enumerated() {
      if index > 0 {
        let separator = separator?.value ?? " "
        if let error = file.write(self, string: separator) {
          return error.asBaseException
        }
      }

      if let error = self.printSingle(file: file, object: object) {
        return error
      }
    }

    if let error = self.printEnd(file: file, end: end) {
      return error
    }

    return self.flush(file: file, object: flush)
  }

  private func printSingle(file: PyTextFile, object: PyObject) -> PyBaseException? {
    let string: String
    switch self.strString(object) {
    case let .value(s): string = s
    case let .error(e): return e
    }

    return file.write(self, string: string)
  }

  private func printEnd(file: PyTextFile, end: PyString?) -> PyBaseException? {
    let string = end?.value ?? "\n"
    return file.write(self, string: string)
  }

  private func flush(file: PyTextFile, object: PyObject?) -> PyBaseException? {
    // We do not support 'flush' at the moment.
    return nil
  }

  // MARK: - File

  private func getTextFile(file: PyObject?) -> PyResultGen<PyTextFile> {
    guard let file = file, !self.cast.isNone(file) else {
      return self.sys.getFile(stream: defaultStream)
    }

    guard let textFile = self.cast.asTextFile(file) else {
      let error = self.newAttributeError(object: file, hasNoAttribute: "write")
      return .error(error.asBaseException)
    }

    return .value(textFile)
  }

  // MARK: - Separator

  private func parseSeparator(object: PyObject?) -> PyResultGen<PyString?> {
    return self.parseSeparator(argName: "sep", object: object)
  }

  private func parseEnd(object: PyObject?) -> PyResultGen<PyString?> {
    return self.parseSeparator(argName: "end", object: object)
  }

  private func parseSeparator(argName: String,
                              object: PyObject?) -> PyResultGen<PyString?> {
    guard let object = object else {
      return .value(.none)
    }

    if self.cast.isNone(object) {
      return .value(.none)
    }

    guard let string = self.cast.asString(object) else {
      let message = "\(argName) must be None or a string, not \(object.typeName)"
      return .typeError(self, message: message)
    }

    return .value(string)
  }
}
