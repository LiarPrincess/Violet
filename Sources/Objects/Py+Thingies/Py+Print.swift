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

extension PyInstance {

  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  ///
  /// - Warning:
  /// Swift function has different parameter order!
  ///
  /// - Parameters:
  ///   - arg: Object to print
  public func print(arg: PyObject,
                    file: PyObject?,
                    separator: PyObject? = nil,
                    end: PyObject? = nil,
                    flush: PyObject? = nil) -> PyResult<PyNone> {
    return self.print(args: [arg],
                      file: file,
                      separator: separator,
                      end: end,
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
  public func print(args: [PyObject],
                    file: PyObject?,
                    separator: PyObject? = nil,
                    end: PyObject? = nil,
                    flush: PyObject? = nil) -> PyResult<PyNone> {
    let textFile: PyTextFile
    switch self.getTextFile(file: file) {
    case let .value(t): textFile = t
    case let .error(e): return .error(e)
    }

    let sep: PyString?
    switch self.getSeparator(argName: "sep", object: separator) {
    case let .value(s): sep = s
    case let .error(e): return .error(e)
    }

    let ending: PyString?
    switch self.getSeparator(argName: "end", object: end) {
    case let .value(s): ending = s
    case let .error(e): return .error(e)
    }

    return self.print(args: args,
                      separator: sep,
                      end: ending,
                      file: textFile,
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
  public func print(args: [PyObject],
                    stream: Sys.OutputStream?,
                    separator: PyString? = nil,
                    end: PyString? = nil,
                    flush: PyObject? = nil) -> PyResult<PyNone> {
    let stream = stream ?? defaultStream

    switch stream.getFile() {
    case let .value(file):
      return self.print(args: args,
                        separator: separator,
                        end: end,
                        file: file,
                        flush: flush)
    case let .error(e):
      return .error(e)
    }
  }

  private func print(args: [PyObject],
                     separator: PyString?,
                     end: PyString?,
                     file: PyTextFile,
                     flush: PyObject?) -> PyResult<PyNone> {
    for (index, object) in args.enumerated() {
      if index > 0 {
        let separator = separator?.value ?? " "
        switch file.write(string: separator) {
        case .value: break
        case .error(let e): return .error(e)
        }
      }

      let string: String
      switch self.strString(object: object) {
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

  // MARK: - File

  private func getTextFile(file: PyObject?) -> PyResult<PyTextFile> {
    guard let file = file, !PyCast.isNone(file) else {
      return defaultStream.getFile()
    }

    guard let textFile = PyCast.asTextFile(file) else {
      return .error(Py.newAttributeError(object: file, hasNoAttribute: "write"))
    }

    return .value(textFile)
  }

  // MARK: - Separator

  private func getSeparator(argName: String,
                            object: PyObject?) -> PyResult<PyString?> {
    guard let object = object else {
      return .value(.none)
    }

    if PyCast.isNone(object) {
      return .value(.none)
    }

    guard let string = PyCast.asString(object) else {
      let msg = "\(argName) must be None or a string, not \(object.typeName)"
      return .typeError(msg)
    }

    return .value(string)
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
