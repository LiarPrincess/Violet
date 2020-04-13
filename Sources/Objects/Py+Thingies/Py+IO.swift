import Core
import Foundation

// In CPython:
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3.7/library/io.html

// MARK: - Print

extension PyInstance {

  /// print(*objects, sep=' ', end='\n', file=sys.stdout, flush=False)
  /// See [this](https://docs.python.org/3/library/functions.html#print)
  ///
  /// - Parameters:
  ///   - args: Objects to print
  public func print(args: [PyObject] = [],
                    sep: PyObject? = nil,
                    end: PyObject? = nil,
                    file: PyObject? = nil,
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

  public func print(args: [PyObject],
                    sep: PyString? = nil,
                    end: PyString? = nil,
                    file fileRaw: PyTextFile? = nil,
                    flush: PyObject? = nil) -> PyResult<PyNone> {
    let file: PyTextFile
    switch self.getTextFile(file: fileRaw) {
    case let .value(f): file = f
    case let .error(e): return .error(e)
    }

    for (index, object) in args.enumerated() {
      if index > 0 {
        let separator = sep?.value ?? " "
        switch file.write(string: separator) {
        case .value: break
        case .error(let e): return .error(e)
        }
      }

      let raw = Py.strValue(object)
      switch raw.flatMap(file.write(string:)) {
      case .value: break
      case .error(let e): return .error(e)
      }
    }

    let ending = end?.value ?? "\n"
    switch file.write(string: ending) {
    case .value: break
    case .error(let e): return .error(e)
    }

    // We do not support 'flush' at the moment.
    return .value(Py.none)
  }

  private func getTextFile(file: PyObject?) -> PyResult<PyTextFile> {
    guard let file = file else {
      return Py.sys.getStdout()
    }

    if file.isNone {
      return Py.sys.getStdout()
    }

    guard let textFile = file as? PyTextFile else {
      let msg = "'\(file.typeName)' object has no attribute 'write'"
      return .attributeError(msg)
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

    guard let string = object as? PyString else {
      let msg = "\(argName) must be None or a string, not \(object.typeName)"
      return .typeError(msg)
    }

    return .value(string)
  }
}

// MARK: - Open

extension PyInstance {

  // swiftlint:disable function_body_length
  /// open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None,
  ///            closefd=True, opener=None)
  /// See [this](https://docs.python.org/3/library/functions.html#open)
  public func open(file fileArg: PyObject,
                   mode modeArg: PyObject? = nil,
                   buffering bufferingArg: PyObject? = nil,
                   encoding encodingArg: PyObject? = nil,
                   errors errorsArg: PyObject? = nil,
                   newline newlineArg: PyObject? = nil,
                   closefd closefdArg: PyObject? = nil,
                   opener openerArg: PyObject? = nil) -> PyResult<PyObject> {
    // swiftlint:enable function_body_length
    // We will ignore 'buffering', 'newline', and 'opener' because we are lazy.

    let source: FileSource
    switch FileSource.from(fileArg) {
    case let .value(f): source = f
    case let .error(e): return .error(e)
    }

    let mode: FileMode
    let type: FileType
    switch FileModeParser.parse(modeArg) {
    case let .value(p):
      mode = p.mode ?? .default
      type = p.type ?? .default
    case let .error(e):
      return .error(e)
    }

    let encoding: PyStringEncoding
    switch PyStringEncoding.from(encodingArg) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errors: PyStringErrorHandler
    switch PyStringErrorHandler.from(errorsArg) {
    case let .value(e): errors = e
    case let .error(e): return .error(e)
    }

    let closeOnDealloc: Bool
    switch self.isTrueBool(closefdArg ?? Py.true) {
    case let .value(b): closeOnDealloc = b
    case let .error(e): return .error(e)
    }

    // Delay `open` syscall untill the end of the method,
    // so that we don't have to deal with dangling handles.
    switch type {
    case .binary:
      return .valueError("only text mode is currently supported")
    case .text:
      return self.open(source: source, mode: mode)
        .map { PyTextFile(name: self.path(source: source),
                          fd: $0,
                          mode: mode,
                          encoding: encoding,
                          errors: errors,
                          closeOnDealloc: closeOnDealloc)
        }
    }
  }

  private func path(source: FileSource) -> String? {
    switch source {
    case .fileDescriptor: return nil
    case .string(let s): return s
    case .bytes(let b): return self.toString(bytes: b)
    }
  }

  private func open(source: FileSource,
                    mode: FileMode) -> PyResult<FileDescriptorType> {

    switch source {
    case let .fileDescriptor(fd):
      return Py.fileSystem.open(fd: fd, mode: mode)

    case let .string(path):
      return Py.fileSystem.open(path: path, mode: mode)

    case let .bytes(bytes):
      guard let path = self.toString(bytes: bytes) else {
        return .valueError("bytes cannot interpreted as path")
      }

      return Py.fileSystem.open(path: path, mode: mode)
    }
  }

  private func toString(bytes: Data) -> String? {
    return PyBytesData(bytes).string
  }
}
