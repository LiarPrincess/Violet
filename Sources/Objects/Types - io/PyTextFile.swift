import Foundation

// cSpell:ignore textio
// swiftlint:disable file_length

// In CPython:
// Modules -> _io -> textio.c
// Modules -> _io -> iobase.c
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

  private static let closeOnDeallocFlag = PyObject.Flags.custom0

  // sourcery: pytypedoc
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
  internal let mode: FileMode
  internal let encoding: PyString.Encoding
  internal let errorHandling: PyString.ErrorHandling

  /// Should we close the file when deallocating?
  internal var closeOnDealloc: Bool {
    get { self.flags.isSet(Self.closeOnDeallocFlag) }
    set { self.flags.set(Self.closeOnDeallocFlag, to: newValue) }
  }

  override public var description: String {
    let name = self.name ?? "?"
    return "PyTextFile(name: \(name), fd: \(self.fd.raw), mode: \(self.mode)"
  }

  // MARK: - Init

  internal convenience init(fd: FileDescriptorType,
                            mode: FileMode,
                            encoding: PyString.Encoding,
                            errorHandling: PyString.ErrorHandling,
                            closeOnDealloc: Bool) {
    self.init(name: nil,
              fd: fd,
              mode: mode,
              encoding: encoding,
              errorHandling: errorHandling,
              closeOnDealloc: closeOnDealloc)
  }

  internal init(name: String?,
                fd: FileDescriptorType,
                mode: FileMode,
                encoding: PyString.Encoding,
                errorHandling: PyString.ErrorHandling,
                closeOnDealloc: Bool) {
    self.name = name
    self.fd = fd
    self.encoding = encoding
    self.errorHandling = errorHandling
    self.mode = mode
    super.init(type: Py.types.textFile)
    self.closeOnDealloc = closeOnDealloc
  }

  // MARK: - Deinit

  deinit {
    // Remember that during 'deinit' we are not allowed to call any other
    // 'Py' function as the whole 'Py' may be deinitializing.

    if self.closeOnDealloc {
      // Regardless of whether it succeeded/failed we will ignore result.
      _ = self.closeIfNotAlreadyClosed()
    }
  }

   // MARK: - String

   // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
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
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Read

  // sourcery: pymethod = readable
  public func isReadable() -> Bool {
    switch self.mode {
    case .read,
         .update: return true
    case .write,
         .create,
         .append: return false
    }
  }

  // sourcery: pymethod = readline
  public func readLine() -> PyResult<String> {
    if let e = self.assertFileIsOpenAndReadable() {
      return .error(e)
    }

    let readLineResult = self.fd.readLine()
    switch readLineResult {
    case let .value(data):
      return self.encoding.decodeOrError(data: data, onError: self.errorHandling)
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = read
  /// static PyObject *
  /// _io_TextIOWrapper_read_impl(textio *self, Py_ssize_t n)
  public func read(size: PyObject? = nil) -> PyResult<PyString> {
    guard let size = size else {
      return self.read(size: -1)
    }

    if size.isNone {
      return self.read(size: -1)
    }

    if let pyInt = PyCast.asInt(size) {
      let int = Int(exactly: pyInt.value) ?? Int.max
      return self.read(size: int)
    }

    return .typeError("read size must be int or none, not \(size.typeName)")
  }

  public func read(size: Int) -> PyResult<PyString> {
    if let e = self.assertFileIsOpenAndReadable() {
      return .error(e)
    }

    if size == 0 {
      return .value(Py.emptyString)
    }

    let readResult = size > 0 ?
      self.fd.read(upToCount: size) :
      self.fd.readToEnd()

    let data: Data
    switch readResult {
    case let .value(d): data = d
    case let .error(e): return .error(e)
    }

    let string: String
    switch self.encoding.decodeOrError(data: data, onError: self.errorHandling) {
    case let .value(s): string = s
    case let .error(e): return .error(e)
    }

    let result = Py.newString(string)
    return .value(result)
  }

  private func assertFileIsOpenAndReadable() -> PyBaseException? {
    guard !self.isClosed() else {
      return Py.newValueError(msg: "I/O operation on closed file.")
    }

    guard self.isReadable() else {
      return self.modeError("not readable")
    }

    return nil
  }

  // MARK: - Write

  // sourcery: pymethod = writable
  public func isWritable() -> Bool {
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
  public func write(object: PyObject) -> PyResult<PyNone> {
    guard let str = PyCast.asString(object) else {
      return .typeError("write() argument must be str, not \(object.typeName)")
    }

    return self.write(string: str.value)
  }

  public func write(string: String) -> PyResult<PyNone> {
    guard !self.isClosed() else {
      return .valueError("I/O operation on closed file.")
    }

    guard self.isWritable() else {
      return .error(self.modeError("not writable"))
    }

    switch encoding.encodeOrError(string: string, onError: self.errorHandling) {
    case let .value(data):
      return self.fd.write(contentsOf: data)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Flush

  // sourcery: pymethod = flush
  public func flush() -> PyResult<PyNone> {
    let result = self.fd.flush()
    return result
  }

  // MARK: - Close

  // sourcery: pymethod = closed
  public func isClosed() -> Bool {
    return self.fd.raw < 0
  }

  // sourcery: pymethod = close
  /// Idempotent
  public func close() -> PyResult<PyNone> {
    return self.closeIfNotAlreadyClosed()
  }

  private func closeIfNotAlreadyClosed() -> PyResult<PyNone> {
    guard !self.isClosed() else {
      return .value(Py.none)
    }

    return self.fd.close()
  }

  // MARK: - Del

  // sourcery: pymethod = __del__
  public func del() -> PyResult<PyNone> {
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
    //    Anyway…

    guard self.closeOnDealloc else {
      return .value(Py.none)
    }

    // 'self.close' is (or at least should be) idempotent
    return self.close()
  }

  // MARK: - Context manager

  // This things are defined in IOBase

  // sourcery: pymethod = __enter__
  public func enter() -> PyResult<PyObject> {
    // 'FileDescriptorType' is responsible for actually opening file.
    // Also: we need to return self because result of '__enter__' will be bound
    // to 'f' in 'open('elsa') as f'.
    return .value(self)
  }

  // sourcery: pymethod = __exit__
  public func exit(exceptionType: PyObject,
                   exception: PyObject,
                   traceback: PyObject) -> PyResult<PyObject> {
    // Remember that if we return 'truthy' value (yes, we JavasScript now)
    // then the exception will be suppressed (and we don't want this).
    // So we return 'None' which is 'falsy'.
    let result = self.closeIfNotAlreadyClosed()
    return result.map { $0 as PyObject }
  }

  // MARK: - Helpers

  private func modeError(_ msg: String) -> PyBaseException {
    // It should be 'io.UnsupportedOperation', but we don't have it,
    // so we will use 'OSError' instead.
    return Py.newOSError(msg: msg)
  }
}
