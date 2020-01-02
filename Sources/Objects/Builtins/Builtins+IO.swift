import Core
import Foundation

// In CPython:
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3.7/library/io.html

// MARK: - Builtins

extension Builtins {

  // MARK: - Print

  internal var stdout: StandardOutput {
    return self.context.stdout
  }

  public func print(value: PyObject, raw: Bool) -> PyResult<PyNone> {
    let stringResult = raw ? self.strValue(value) : self.repr(value)
    switch stringResult {
    case let .value(s):
      self.stdout.write(s)
      return .value(self.none)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Open

  private static let openArguments = ArgumentParser.createOrFatal(
    arguments: [
      "file", "mode", "buffering",
      "encoding", "errors", "newline",
      "closefd", "opener"
    ],
    format: "O|sizzziO:open"
  )

  // sourcery: pymethod: open
  /// open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None,
  ///            closefd=True, opener=None)
  /// See [this](https://docs.python.org/3/library/functions.html#open)
  public func open(args: [PyObject], kwargs: PyObject?) -> PyResult<PyObject> {
    switch Builtins.openArguments.parse(args: args, kwargs: kwargs) {
    case let .value(bind):
      assert(
        1 <= bind.count && bind.count <= 8,
        "Invalid argument count returned from parser."
      )

      return self.open(file: bind[0],
                       mode: bind.count >= 2 ? bind[1] : nil,
                       buffering: bind.count >= 3 ? bind[2] : nil,
                       encoding: bind.count >= 4 ? bind[3] : nil,
                       errors: bind.count >= 5 ? bind[4] : nil,
                       newline: bind.count >= 6 ? bind[5] : nil,
                       closefd: bind.count >= 7 ? bind[6] : nil,
                       opener: bind.count >= 8 ? bind[7] : nil)
    case let .error(e):
      return .error(e)
    }
  }

  public func open(file fileArg: PyObject,
                   mode modeArg: PyObject? = nil,
                   buffering bufferingArg: PyObject? = nil,
                   encoding encodingArg: PyObject? = nil,
                   errors errorsArg: PyObject? = nil,
                   newline newlineArg: PyObject? = nil,
                   closefd closefdArg: PyObject? = nil,
                   opener openerArg: PyObject? = nil) -> PyResult<PyObject> {
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

    guard type == .text else {
      return .valueError("only text mode is currently supported")
    }

    let fd: FileDescriptor
    switch self.open(source: source, mode: mode, type: type) {
    case let .value(f): fd = f
    case let .error(e): return .error(e)
    }

    // We will ignore 'buffering', 'newline', 'closefd' and 'opener'
    // because we are lazy.

    let encoding: FileEncoding
    switch FileEncoding.from(encodingArg) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errors: FileErrorHandler
    switch FileErrorHandler.from(errorsArg) {
    case let .value(e): errors = e
    case let .error(e): return .error(e)
    }

    let result = PyFile(self.context, fd: fd, encoding: encoding, errors: errors)
    return .value(result)
  }

  private func open(source: FileSource,
                    mode: FileMode,
                    type: FileType) -> PyResult<FileDescriptor> {
    let delegate = self.context.delegate

    switch source {
    case let .fileDescriptor(fd):
      return delegate.open(fileno: fd, mode: mode, type: type)

    case let .string(path):
      return delegate.open(file: path, mode: mode, type: type)

    case let .bytes(bytes):
      let data = PyBytesData(bytes)
      guard let path = data.string else {
        return .valueError("bytes cannot interpreted as path")
      }

      return delegate.open(file: path, mode: mode, type: type)
    }
  }
}
