import Foundation
import VioletCore

// swiftlint:disable function_parameter_count

// In CPython:
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3.7/library/io.html

// MARK: - Source

/// Where to find file?
private enum FileSource {
  /// We already have it.
  case fileDescriptor(Int32)
  /// Path.
  case string(String)
  /// Encoded path.
  case bytes(Data)
}

// MARK: - Open

extension PyInstance {

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
    // We will ignore 'buffering', 'newline', and 'opener' because we are lazy.

    let source: FileSource
    switch self.parseFileSource(object: fileArg) {
    case let .value(f): source = f
    case let .error(e): return .error(e)
    }

    let mode: FileMode
    let fileType: FileType
    switch FileModeParser.parse(modeArg) {
    case let .value(p):
      mode = p.mode ?? .default
      fileType = p.type ?? .default
    case let .error(e):
      return .error(e)
    }

    let encoding: PyString.Encoding
    switch PyString.Encoding.from(object: encodingArg) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errorHandling: PyString.ErrorHandling
    switch PyString.ErrorHandling.from(object: errorsArg) {
    case let .value(e): errorHandling = e
    case let .error(e): return .error(e)
    }

    let closeOnDealloc: Bool
    switch self.isTrueBool(closefdArg ?? self.true) {
    case let .value(b): closeOnDealloc = b
    case let .error(e): return .error(e)
    }

    // Delay `open` syscall until the end of the method,
    // so that we don't have to deal with dangling handles.
    return self.open(source: source,
                     mode: mode,
                     fileType: fileType,
                     encoding: encoding,
                     errorHandling: errorHandling,
                     closeOnDealloc: closeOnDealloc)
  }

  private func open(source: FileSource,
                    mode: FileMode,
                    fileType: FileType,
                    encoding: PyString.Encoding,
                    errorHandling: PyString.ErrorHandling,
                    closeOnDealloc: Bool) -> PyResult<PyObject> {
    switch fileType {
    case .binary:
      return .valueError("only text mode is currently supported in Violet")

    case .text:
      switch self.openFileDescriptor(source: source, mode: mode) {
      case let .value(fd):
        let result = PyTextFile(name: fd.path,
                                fd: fd.value,
                                mode: mode,
                                encoding: encoding,
                                errorHandling: errorHandling,
                                closeOnDealloc: closeOnDealloc)
        return .value(result)

      case let .error(e):
        return .error(e)
      }
    }
  }

  private struct OpenedFileDescriptor {
    let path: String?
    let value: FileDescriptorType
  }

  private func openFileDescriptor(
    source: FileSource,
    mode: FileMode
  ) -> PyResult<OpenedFileDescriptor> {
    switch source {
    case let .fileDescriptor(fdInt):
      let fd = self.fileSystem.open(fd: fdInt, mode: mode)
      return fd.map { OpenedFileDescriptor(path: nil, value: $0) }

    case let .string(path):
      let fd = self.fileSystem.open(path: path, mode: mode)
      return fd.map { OpenedFileDescriptor(path: path, value: $0) }

    case let .bytes(data):
      guard let path = Py.getString(data: data) else {
        return .valueError("bytes cannot interpreted as path")
      }

      let fd = self.fileSystem.open(path: path, mode: mode)
      return fd.map { OpenedFileDescriptor(path: path, value: $0) }
    }
  }

  // MARK: - File source

  private func parseFileSource(object: PyObject) -> PyResult<FileSource> {
    if let int = PyCast.asInt(object),
       let fd = Int32(exactly: int.value) {
      return .value(.fileDescriptor(fd))
    }

    if let string = PyCast.asString(object) {
      return .value(.string(string.value))
    }

    if let bytes = PyCast.asAnyBytes(object) {
      return .value(.bytes(bytes.elements))
    }

    let repr = Py.reprOrGeneric(object: object)
    return .typeError("invalid file: \(repr)")
  }
}
