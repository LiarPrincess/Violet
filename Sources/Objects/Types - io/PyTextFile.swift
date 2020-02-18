import Foundation

// In CPython:
// Modules -> _io -> textio.c
// Python -> codecs.c
// https://docs.python.org/3.7/library/io.html

// sourcery: pytype = TextFile, default, hasGC, hasFinalize
/// We don't have `_io` module.
/// Instead we have our own `TextFile` type based on `_io.TextIOWrapper`.
///
/// `TextIOWrapper` is a Python class for reading and writing files.
/// It is also used as `sys.stdin` and `sys.stdout`.
///
/// Differences between our `TextFile` and `_io.TextIOWrapper`:
/// - some methods are missing
/// - it is in` builtins` module (because we are too lazy to introduce a new one)
/// - class hierarchy is missing
public class PyTextFile: PyObject {

  internal static let doc = """
    Type used to read/write file-thingies.

    encoding gives the name of the encoding that the stream will be
    decoded or encoded with. It defaults to locale.getpreferredencoding(False).

    errors determines the strictness of encoding and decoding (see
    help(codecs.Codec) or the documentation for codecs.register) and
    defaults to "strict".
    """

  internal let name: String?
  internal let fd: FileDescriptorType
  internal let encoding: PyStringEncoding
  internal let errors: PyStringErrorHandler

  internal let mode: FileMode
  internal let closeOnDealloc: Bool

  override public var description: String {
    let name = self.name ?? "?"
    return "PyTextFile(name: \(name), fd: \(self.fd.raw), mode: \(self.mode)"
  }

  // MARK: - Init

  internal convenience init(fd: FileDescriptorType,
                            mode: FileMode,
                            encoding: PyStringEncoding,
                            errors: PyStringErrorHandler,
                            closeOnDealloc: Bool) {
    self.init(name: nil,
              fd: fd,
              mode: mode,
              encoding: encoding,
              errors: errors,
              closeOnDealloc: closeOnDealloc)
  }

  internal init(name: String?,
                fd: FileDescriptorType,
                mode: FileMode,
                encoding: PyStringEncoding,
                errors: PyStringErrorHandler,
                closeOnDealloc: Bool) {
    self.name = name
    self.fd = fd
    self.encoding = encoding
    self.errors = errors
    self.mode = mode
    self.closeOnDealloc = closeOnDealloc
    super.init(type: Py.types.textFile)
  }

  // MARK: - Deinit

  deinit {
    // Remember that during 'deinit' we are not allowed to call any other
    // 'Py' function as the whole 'Py' may be deinitializing.

    if self.closeOnDealloc {
      // Regardles of whether it succeded/failed we will ignore result.
      // (we could use '_ = self.closeRaw()', but we want to be explicit)
      switch self.closeRaw() {
      case .ok: break
      case .error: break
      }
    }
  }

   // MARK: - String

   // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.hasReprLock {
      return .value("<TextFile - reentrant call>")
    }

    return self.withReprLock {
      var result = "<TextFile"

      if let name = self.name {
        result += " name=\(name)"
      }

      result += " mode=\(self.mode.flag)"
      result += " encoding=\(self.encoding)"
      result += ">"

      return .value(result)
    }
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Read

  // sourcery: pymethod = readable
  internal func isReadable() -> Bool {
    switch self.mode {
    case .read,
         .update: return true
    case .write,
         .create,
         .append: return false
    }
  }

  // sourcery: pymethod = read
  /// static PyObject *
  /// _io_TextIOWrapper_read_impl(textio *self, Py_ssize_t n)
  internal func read(size: PyObject) -> PyResult<PyString> {
    if size is PyNone {
      return self.read(size: -1)
    }

    if let pyInt = size as? PyInt {
      let int = Int(exactly: pyInt.value) ?? Int.max
      return self.read(size: int)
    }

    return .typeError("read size must be int or none, not \(size.typeName)")
  }

  internal func read(size: Int) -> PyResult<PyString> {
    return self.readRaw(size: size).map(Py.newString(_:))
  }

  internal func readRaw(size: Int) -> PyResult<String> {
    guard !self.isClosed() else {
      return .valueError("I/O operation on closed file.")
    }

    guard self.isReadable() else {
      return .error(self.modeError("not readable"))
    }

    if size == 0 {
      return .value("")
    }

    do {
      let data = size > 0 ?
        try self.fd.read(upToCount: size) :
        try self.fd.readToEnd()

      return self.encoding.decode(data: data, errors: self.errors)
    } catch {
      return .error(self.osError(from: error))
    }
  }

  // MARK: - Write

  // sourcery: pymethod = writable
  internal func isWritable() -> Bool {
    switch self.mode {
    case .write,
         .create,
         .append,
         .update: return true
    case .read: return true
    }
  }

  // sourcery: pymethod = write
  /// static PyObject *
  /// _io_TextIOWrapper_write_impl(textio *self, Py_ssize_t n)
  internal func write(object: PyObject) -> PyResult<PyNone> {
    guard let str = object as? PyString else {
      return .typeError("write() argument must be str, not \(object.typeName)")
    }

    return self.write(string: str.value)
  }

  internal func write(string: String) -> PyResult<PyNone> {
    guard !self.isClosed() else {
      return .valueError("I/O operation on closed file.")
    }

    guard self.isWritable() else {
      return .error(self.modeError("not writable"))
    }

    switch self.encoding.encode(string: string, errors: self.errors) {
    case let .value(data):
      do {
        try self.fd.write(contentsOf: data)
        return .value(Py.none)
      } catch {
        return .error(self.osError(from: error))
      }

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Close

  // sourcery: pymethod = closed
  internal func isClosed() -> Bool {
    return self.fd.raw < 0
  }

  // sourcery: pymethod = close
  /// Idempotent
  internal func close() -> PyResult<PyNone> {
    switch self.closeRaw() {
    case .ok:
      return .value(Py.none)
    case .error(let e):
      return .error(self.osError(from: e))
    }
  }

  private enum CloseRawResult {
    case ok
    case error(Error)
  }

  private func closeRaw() -> CloseRawResult {
    guard !self.isClosed() else {
      return .ok
    }

    do {
      try self.fd.close()
      return .ok
    } catch {
      return .error(error)
    }
  }

  // MARK: - Del

  // sourcery: pymethod = __del__
  internal func del() -> PyResult<PyNone> {
    // Example when this matters:
    // 1) stdout - 'closeOnDealloc' should be 'false'
    //    We need to to allow printing after Violet context is destroyed.
    // 2) file - 'closeOnDealloc' should be 'true'
    //    We need to free descriptor.
    //    Note:
    //    Number of available descriptors is limited by kernel.
    //    This is why you should never rely on garbage collector to free resources.
    //    This is also why .Net has 'IDisposable' and why you should never
    //    use 'Object.finalize' to free resources in Java.
    //    Anyway...

    guard self.closeOnDealloc else {
      return .value(Py.none)
    }

    // 'self.close' is (or at least should be) idempotent
    return self.close()
  }

  // MARK: - Helpers

  private func osError(from error: Error) -> PyBaseException {
    let descriptorError = error as? FileDescriptor.Error
    let msg = descriptorError?.str ?? "unknown IO error"

    return Py.newOSError(msg: msg)
  }

  private func modeError(_ msg: String) -> PyBaseException {
    // It should be 'io.UnsupportedOperation', but we don't have it,
    // so we will use 'OSError' instead.
    return Py.newOSError(msg: msg)
  }
}
