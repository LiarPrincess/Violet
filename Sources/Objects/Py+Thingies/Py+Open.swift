import VioletCore
import Foundation

// In CPython:
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3.7/library/io.html

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

  internal func open(source: FileSource,
                     mode: FileMode) -> PyResult<FileDescriptorType> {

    switch source {
    case let .fileDescriptor(fd):
      return self.fileSystem.open(fd: fd, mode: mode)

    case let .string(path):
      return self.fileSystem.open(path: path, mode: mode)

    case let .bytes(bytes):
      guard let path = self.toString(bytes: bytes) else {
        return .valueError("bytes cannot interpreted as path")
      }

      return self.fileSystem.open(path: path, mode: mode)
    }
  }

  private func toString(bytes: Data) -> String? {
    return PyBytesData(bytes).string
  }
}
