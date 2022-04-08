import Foundation

// cSpell:ignore textio

// In CPython:
// Modules -> _io -> textio.c
// Modules -> _io -> iobase.c
// Python -> codecs.c
// https://docs.python.org/3.7/library/io.html

// sourcery: pytype = TextFile, isDefault, hasGC, hasFinalize
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
public struct PyTextFile: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    Type used to read/write file-thingies.

    encoding gives the name of the encoding that the stream will be
    decoded or encoded with. It defaults to locale.getpreferredencoding(False).

    errors determines the strictness of encoding and decoding (see
    help(codecs.Codec) or the documentation for codecs.register) and
    defaults to "strict".
    """

  // MARK: - Properties

  // sourcery: storedProperty
  internal var name: String? { self.namePtr.pointee }
  // sourcery: storedProperty
  internal var fd: PyFileDescriptorType { self.fdPtr.pointee }
  // sourcery: storedProperty
  internal var mode: FileMode { self.modePtr.pointee }
  // sourcery: storedProperty
  internal var encoding: PyString.Encoding { self.encodingPtr.pointee }
  // sourcery: storedProperty
  internal var errorHandling: PyString.ErrorHandling { self.errorHandlingPtr.pointee }

  private static let closeOnDeallocFlag = PyObject.Flags.custom0

  /// Should we close the file when deallocating?
  internal var closeOnDealloc: Bool {
    get { self.flags.isSet(Self.closeOnDeallocFlag) }
    nonmutating set { self.flags.set(Self.closeOnDeallocFlag, value: newValue) }
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  // swiftlint:disable:next function_parameter_count
  internal func initialize(_ py: Py,
                           type: PyType,
                           name: String?,
                           fd: PyFileDescriptorType,
                           mode: FileMode,
                           encoding: PyString.Encoding,
                           errorHandling: PyString.ErrorHandling,
                           closeOnDealloc: Bool) {
    self.initializeBase(py, type: type)
    self.namePtr.initialize(to: name)
    self.fdPtr.initialize(to: fd)
    self.modePtr.initialize(to: mode)
    self.encodingPtr.initialize(to: encoding)
    self.errorHandlingPtr.initialize(to: errorHandling)
    self.closeOnDealloc = closeOnDealloc
  }

  internal func beforeDeinitialize(_ py: Py) {
    // Remember that during 'deinit' we are not allowed to call any other
    // 'Python' function as the whole context may be deinitializing.

    if self.closeOnDealloc {
      // Regardless of whether it succeeded/failed we will ignore result.
      _ = self.closeIfNotAlreadyClosed(py)
    }
  }

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyTextFile(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "name", value: zelf.name as Any, includeInDescription: true)
    result.append(name: "fd", value: zelf.fd.raw, includeInDescription: true)
    result.append(name: "mode", value: zelf.mode, includeInDescription: true)
    result.append(name: "encoding", value: zelf.encoding)
    result.append(name: "errorHandling", value: zelf.errorHandling)
    return result
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    if zelf.hasReprLock {
      return PyResult(py, interned: "<TextFile - reentrant call>")
    }

    return zelf.withReprLock {
      var result = "<TextFile"

      if let n = zelf.name {
        result.append(" name=")
        result.append(n)
      }

      result.append(" mode=")
      result.append(zelf.mode.flag)
      result.append(" encoding=")
      result.append(zelf.encoding.description)
      result.append(">")
      return PyResult(py, result)
    }
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Read

  public var isReadable: Bool {
    switch self.mode {
    case .read,
         .update:
      return true
    case .write,
         .create,
         .append:
      return false
    }
  }

  // sourcery: pymethod = readable
  internal static func readable(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "readable")
    }

    let result = zelf.isReadable
    return PyResult(py, result)
  }

  // sourcery: pymethod = readline
  internal static func readline(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "readline")
    }

    let result = zelf.readLine(py)
    return PyResult(py, result)
  }

  public func readLine(_ py: Py) -> PyResultGen<String> {
    if let e = self.assertFileIsOpenAndReadable(py) {
      return .error(e)
    }

    switch self.fd.readLine(py) {
    case let .value(data):
      return self.encoding.decodeOrError(py, data: data, onError: self.errorHandling)
    case let .error(e):
      return .error(e)
    }
  }

  // sourcery: pymethod = read
  /// static PyObject *
  /// _io_TextIOWrapper_read_impl(textio *self, Py_ssize_t n)
  internal static func read(_ py: Py,
                            zelf _zelf: PyObject,
                            size: PyObject?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "read")
    }

    guard let size = size else {
      let result = zelf.read(py, size: -1)
      return PyResult(result)
    }

    if py.cast.isNone(size) {
      let result = zelf.read(py, size: -1)
      return PyResult(result)
    }

    if let pyInt = py.cast.asInt(size) {
      let int = Int(exactly: pyInt.value) ?? Int.max
      let result = zelf.read(py, size: int)
      return PyResult(result)
    }

    let message = "read size must be int or none, not \(size.typeName)"
    return .typeError(py, message: message)
  }

  public func read(_ py: Py, size: Int) -> PyResultGen<PyString> {
    if let e = self.assertFileIsOpenAndReadable(py) {
      return .error(e)
    }

    if size == 0 {
      let result = py.emptyString
      return .value(result)
    }

    let readResult = size > 0 ?
      self.fd.read(py, count: size) :
      self.fd.readToEnd(py)

    let data: Data
    switch readResult {
    case let .value(d): data = d
    case let .error(e): return .error(e)
    }

    let string: String
    switch self.encoding.decodeOrError(py, data: data, onError: self.errorHandling) {
    case let .value(s): string = s
    case let .error(e): return .error(e)
    }

    let result = py.newString(string)
    return .value(result)
  }

  private func assertFileIsOpenAndReadable(_ py: Py) -> PyBaseException? {
    if self.isClosed {
      let error = py.newValueError(message: "I/O operation on closed file.")
      return error.asBaseException
    }

    if !self.isReadable {
      return Self.modeError(py, message: "not readable")
    }

    return nil
  }

  // MARK: - Write

  public var isWritable: Bool {
    switch self.mode {
    case .write,
         .create,
         .append,
         .update:
      return true
    case .read:
      return true
    }
  }

  // sourcery: pymethod = writable
  internal static func writable(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "writable")
    }

    let result = zelf.isWritable
    return PyResult(py, result)
  }

  // sourcery: pymethod = write
  /// static PyObject *
  /// _io_TextIOWrapper_write_impl(textio *self, Py_ssize_t n)
  internal static func write(_ py: Py,
                             zelf _zelf: PyObject,
                             object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "write")
    }

    if let e = zelf.write(py, object: object) {
      return .error(e)
    }

    return .none(py)
  }

  public func write(_ py: Py, object: PyObject) -> PyBaseException? {
    guard let str = py.cast.asString(object) else {
      let message = "write() argument must be str, not \(object.typeName)"
      let error = py.newTypeError(message: message)
      return error.asBaseException
    }

    return self.write(py, string: str.value)
  }

  public func write(_ py: Py, string: String) -> PyBaseException? {
    if self.isClosed {
      let error = py.newValueError(message: "I/O operation on closed file.")
      return error.asBaseException
    }

    if !self.isWritable {
      return Self.modeError(py, message: "not writable")
    }

    switch self.encoding.encodeOrError(py, string: string, onError: self.errorHandling) {
    case let .value(data):
      return self.fd.write(py, data: data)
    case let .error(e):
      return e
    }
  }

  // MARK: - Flush

  // sourcery: pymethod = flush
  internal static func flush(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "flush")
    }

    if let error = zelf.flush(py) {
      return .error(error)
    }

    return .none(py)
  }

  public func flush(_ py: Py) -> PyBaseException? {
    return self.fd.flush(py)
  }

  // MARK: - Close

  public var isClosed: Bool {
    return self.fd.raw < 0
  }

  // sourcery: pymethod = closed
  internal static func closed(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "closed")
    }

    let result = zelf.isClosed
    return PyResult(py, result)
  }

  // sourcery: pymethod = close
  internal static func close(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "close")
    }

    if let error = zelf.close(py) {
      return .error(error)
    }

    return .none(py)
  }

  /// Idempotent
  public func close(_ py: Py) -> PyBaseException? {
    return self.closeIfNotAlreadyClosed(py)
  }

  private func closeIfNotAlreadyClosed(_ py: Py) -> PyBaseException? {
    if !self.isClosed {
      return self.fd.close(py)
    }

    return nil
  }

  // MARK: - Del

  // sourcery: pymethod = __del__
  internal static func __del__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__del__")
    }

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

    guard zelf.closeOnDealloc else {
      return .none(py)
    }

    // 'self.close' is (or at least should be) idempotent
    if let error = zelf.close(py) {
      return .error(error)
    }

    return .none(py)
  }

  // MARK: - Context manager

  // Those things are defined in IOBase

  // sourcery: pymethod = __enter__
  internal static func __enter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__enter__")
    }

    // 'FileDescriptorType' is responsible for actually opening file.
    // Also: we need to return self because result of '__enter__' will be bound
    // to 'f' in 'open('elsa') as f'.
    return PyResult(zelf)
  }

  // sourcery: pymethod = __exit__
  internal static func __exit__(_ py: Py,
                                zelf _zelf: PyObject,
                                exceptionType: PyObject,
                                exception: PyObject,
                                traceback: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__exit__")
    }

    // Remember that if we return 'truthy' value (yes, we JavasScript now)
    // then the exception will be suppressed (and we don't want this).
    // So we return 'None' which is 'falsy'.
    if let error = zelf.close(py) {
      return .error(error)
    }

    return .none(py)
  }

  // MARK: - Helpers

  private static func modeError(_ py: Py, message: String) -> PyBaseException {
    // It should be 'io.UnsupportedOperation', but we don't have it,
    // so we will use 'OSError' instead.
    let error = py.newOSError(message: message)
    return error.asBaseException
  }
}
