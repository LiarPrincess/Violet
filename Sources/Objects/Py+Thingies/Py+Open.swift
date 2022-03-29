import Foundation
import FileSystem
import VioletCore

// swiftlint:disable function_parameter_count
// cSpell:ignore xrwa

// In CPython:
// Modules -> _io -> _iomodule.c
// https://docs.python.org/3.7/library/io.html

extension Py {

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
                   opener: PyObject? = nil) -> PyResultGen<PyTextFile> {
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
    switch PyString.Encoding.from(self, object: encodingArg) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errorHandling: PyString.ErrorHandling
    switch PyString.ErrorHandling.from(self, object: errorsArg) {
    case let .value(e): errorHandling = e
    case let .error(e): return .error(e)
    }

    let closeOnDealloc: Bool
    switch self.isTrueBool(object: closefdArg ?? self.true.asObject) {
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
                    closeOnDealloc: Bool) -> PyResultGen<PyTextFile> {
    switch type {
    case .binary:
      return .valueError(self, message: "only text mode is currently supported in Violet")

    case .text:
      switch self.openFileDescriptor(source: source, mode: mode) {
      case let .value(fd):
        let result = self.newTextFile(name: fd.path?.string,
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

  public func newTextFile(name: String?,
                          fd: PyFileDescriptorType,
                          mode: FileMode,
                          encoding: PyString.Encoding,
                          errorHandling: PyString.ErrorHandling,
                          closeOnDealloc: Bool) -> PyTextFile {
    let type = self.types.textFile
    return self.memory.newTextFile(type: type,
                                   name: name,
                                   fd: fd,
                                   mode: mode,
                                   encoding: encoding,
                                   errorHandling: errorHandling,
                                   closeOnDealloc: closeOnDealloc)
  }

  private struct OpenedFileDescriptor {
    let path: Path?
    let value: PyFileDescriptorType
  }

  private func openFileDescriptor(
    source: Source,
    mode: FileMode
  ) -> PyResultGen<OpenedFileDescriptor> {
    func _open(string: String) -> PyResultGen<OpenedFileDescriptor> {
      let path = Path(string: string)
      let fd = self.fileSystem.open(self, path: path, mode: mode)
      return fd.map { OpenedFileDescriptor(path: path, value: $0) }
    }

    switch source {
    case let .fileDescriptor(fdInt):
      let fd = self.fileSystem.open(self, fd: fdInt, mode: mode)
      return fd.map { OpenedFileDescriptor(path: nil, value: $0) }

    case let .string(string):
      return _open(string: string)

    case let .bytes(data):
      guard let string = self.getString(data: data, encoding: .default) else {
        return .valueError(self, message: "bytes cannot interpreted as path")
      }

      return _open(string: string)
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

  private func parseFileSource(object: PyObject) -> PyResultGen<Source> {
    if let int = self.cast.asInt(object),
       let fd = Int32(exactly: int.value) {
      return .value(.fileDescriptor(fd))
    }

    if let string = self.cast.asString(object) {
      return .value(.string(string.value))
    }

    if let bytes = self.cast.asAnyBytes(object) {
      return .value(.bytes(bytes.elements))
    }

    let repr = self.reprOrGenericString(object)
    return .typeError(self, message: "invalid file: \(repr)")
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

    private let py: Py
    fileprivate private(set) var mode: FileMode?
    fileprivate private(set) var type: FileType?

    fileprivate init(_ py: Py) {
      self.py = py
      self.mode = nil
      self.type = nil
    }

    fileprivate mutating func setMode(mode: FileMode) -> PyBaseException? {
      if self.mode == mode {
        return nil
      }

      guard self.mode == nil else {
        let message = "must have exactly one of create/read/write/append mode"
        let error = self.py.newValueError(message: message)
        return error.asBaseException
      }

      self.mode = mode
      return nil
    }

    fileprivate mutating func setType(type: FileType) -> PyBaseException? {
      if self.type == type {
        return nil
      }

      guard self.type == nil else {
        let message = "can't have text and binary mode at once"
        let error = self.py.newValueError(message: message)
        return error.asBaseException
      }

      self.type = type
      return nil
    }
  }

  /// Parser for `xrwa+tb` string (2nd argument of `open`).
  private func parseModeAndType(object: PyObject?) -> PyResultGen<ModeAndType> {
    guard let object = object else {
      let result = ModeAndType(self)
      return .value(result)
    }

    guard let string = self.cast.asString(object) else {
      return .typeError(self, message: "mode must be str, not \(object.typeName)")
    }

    return self.parseModeAndType(string: string.value)
  }

  /// Parser for `xrwa+tb` string (2nd argument of `open`).
  private func parseModeAndType(string: String) -> PyResultGen<ModeAndType> {
    var result = ModeAndType(self)
    var preventDuplicates = Set<UnicodeScalar>()

    for s in string.unicodeScalars {
      if preventDuplicates.contains(s) {
        return .valueError(self, message: "invalid mode: '\(string)'")
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
        if let e = self.warn(type: .deprecation, message: "'U' mode is deprecated") {
          return .error(e)
        }
      default:
        return .valueError(self, message: "invalid mode: '\(string)'")
      }
    }

    return .value(result)
  }
}
