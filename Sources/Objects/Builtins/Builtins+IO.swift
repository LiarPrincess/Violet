import Core
import Foundation

// In CPython:
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3.7/library/io.html

// MARK: - Builtins

extension Builtins {

  // MARK: - Print

  public func print(value: PyObject, raw: Bool) -> PyResult<PyNone> {
    let string = raw ? self.strValue(value) : self.repr(value)
    return string.flatMap(self.sys.stdout.write(string:))
  }

  // MARK: - Open

  private static let openArguments = ArgumentParser.createOrTrap(
    arguments: [
      "file", "mode", "buffering",
      "encoding", "errors", "newline",
      "closefd", "opener"
    ],
    format: "O|sizzziO:open"
  )

  public func open(args: [PyObject], kwargs: PyObject?) -> PyResult<PyObject> {
    return ArgumentParser.unpackKwargsDict(kwargs: kwargs)
      .flatMap { self.open(args: args, kwargs: $0) }
  }

  // sourcery: pymethod = open
  /// open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None,
  ///            closefd=True, opener=None)
  /// See [this](https://docs.python.org/3/library/functions.html#open)
  internal func open(args: [PyObject], kwargs: PyDictData?) -> PyResult<PyObject> {
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

  // swiftlint:disable:next function_body_length
  public func open(file fileArg: PyObject,
                   mode modeArg: PyObject? = nil,
                   buffering bufferingArg: PyObject? = nil,
                   encoding encodingArg: PyObject? = nil,
                   errors errorsArg: PyObject? = nil,
                   newline newlineArg: PyObject? = nil,
                   closefd closefdArg: PyObject? = nil,
                   opener openerArg: PyObject? = nil) -> PyResult<PyObject> {
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

    let closeOnDealloc: Bool
    switch self.isTrueBool(closefdArg ?? self.true) {
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
    let delegate = self.context.delegate

    switch source {
    case let .fileDescriptor(fd):
      return delegate.open(fileno: fd, mode: mode)

    case let .string(path):
      return delegate.open(file: path, mode: mode)

    case let .bytes(bytes):
      guard let path = self.toString(bytes: bytes) else {
        return .valueError("bytes cannot interpreted as path")
      }

      return delegate.open(file: path, mode: mode)
    }
  }

  private func toString(bytes: Data) -> String? {
    return PyBytesData(bytes).string
  }
}
