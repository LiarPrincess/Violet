import Foundation
import VioletCore

// swiftlint:disable function_parameter_count
// cSpell:ignore xrwa

// In CPython:
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3.7/library/io.html

extension PyInstance {

  /// open(file, mode='r', buffering=-1, encoding=None, errors=None, newline=None,
  ///            closefd=True, opener=None)
  /// See [this](https://docs.python.org/3/library/functions.html#open)
  public func open(file fileArg: PyObject,
                   mode modeArg: PyObject? = nil,
                   buffering: PyObject? = nil,
                   encoding encodingArg: PyObject? = nil,
                   errors errorsArg: PyObject? = nil,
                   newline: PyObject? = nil,
                   closefd closefdArg: PyObject? = nil,
                   opener: PyObject? = nil) -> PyResult<PyObject> {
    // We will ignore 'buffering', 'newline', and 'opener' because we are lazy.

    let source: Source
    switch self.parseFileSource(object: fileArg) {
    case let .value(f): source = f
    case let .error(e): return .error(e)
    }

    let mode: FileMode
    let type: FileType
    switch self.parseModeAndType(object: modeArg) {
    case let .value(p):
      mode = p.mode ?? .default
      type = p.type ?? .default
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
                     type: type,
                     encoding: encoding,
                     errorHandling: errorHandling,
                     closeOnDealloc: closeOnDealloc)
  }

  private func open(source: Source,
                    mode: FileMode,
                    type: FileType,
                    encoding: PyString.Encoding,
                    errorHandling: PyString.ErrorHandling,
                    closeOnDealloc: Bool) -> PyResult<PyObject> {
    switch type {
    case .binary:
      return .valueError("only text mode is currently supported in Violet")

    case .text:
      switch self.openFileDescriptor(source: source, mode: mode) {
      case let .value(fd):
        let result = PyMemory.newTextFile(name: fd.path,
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
    source: Source,
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

  // MARK: - Source

  /// Where to find file?
  private enum Source {
    /// We already have it.
    case fileDescriptor(Int32)
    /// Path.
    case string(String)
    /// Encoded path.
    case bytes(Data)
  }

  private func parseFileSource(object: PyObject) -> PyResult<Source> {
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

  // MARK: - Mode and type

  /// Binary or text.
  private enum FileType {
    /// `b` - binary mode
    case binary
    /// `t` - text mode (default)
    case text

    internal static let `default` = FileType.text
  }

  private struct ModeAndType {

    fileprivate private(set) var mode: FileMode?
    fileprivate private(set) var type: FileType?

    fileprivate init() {
      self.mode = nil
      self.type = nil
    }

    fileprivate mutating func setMode(mode: FileMode) -> PyBaseException? {
      if self.mode == mode {
        return nil
      }

      guard self.mode == nil else {
        let msg = "must have exactly one of create/read/write/append mode"
        return Py.newValueError(msg: msg)
      }

      self.mode = mode
      return nil
    }

    fileprivate mutating func setType(type: FileType) -> PyBaseException? {
      if self.type == type {
        return nil
      }

      guard self.type == nil else {
        let msg = "can't have text and binary mode at once"
        return Py.newValueError(msg: msg)
      }

      self.type = type
      return nil
    }
  }

  /// Parser for `xrwa+tb` string (2nd argument of `open`).
  private func parseModeAndType(object: PyObject?) -> PyResult<ModeAndType> {
    guard let object = object else {
      return .value(ModeAndType())
    }

    guard let string = PyCast.asString(object) else {
      return .typeError("mode must be str, not \(object.typeName)")
    }

    return self.parseModeAndType(string: string.value)
  }

  /// Parser for `xrwa+tb` string (2nd argument of `open`).
  private func parseModeAndType(string: String) -> PyResult<ModeAndType> {
    var result = ModeAndType()
    var preventDuplicates = Set<UnicodeScalar>()

    for s in string.unicodeScalars {
      if preventDuplicates.contains(s) {
        return .valueError("invalid mode: '\(string)'")
      }

      preventDuplicates.insert(s)

      switch s {
      case "x": if let e = result.setMode(mode: .create) { return .error(e) }
      case "r": if let e = result.setMode(mode: .read) { return .error(e) }
      case "w": if let e = result.setMode(mode: .write) { return .error(e) }
      case "a": if let e = result.setMode(mode: .append) { return .error(e) }
      case "+": if let e = result.setMode(mode: .update) { return .error(e) }
      case "t": if let e = result.setType(type: .text) { return .error(e) }
      case "b": if let e = result.setType(type: .binary) { return .error(e) }
      case "U":
        if let e = Py.warn(type: .deprecation, msg: "'U' mode is deprecated") {
          return .error(e)
        }
      default:
        return .valueError("invalid mode: '\(string)'")
      }
    }

    return .value(result)
  }
}
