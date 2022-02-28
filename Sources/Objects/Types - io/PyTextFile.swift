import Foundation

// cSpell:ignore textio
// swiftlint:disable file_length

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

  // MARK: - Layout

  internal enum Layout {
    internal static let nameOffset = SizeOf.objectHeader
    internal static let nameSize = SizeOf.optionalString

    internal static let fdOffset = nameOffset + nameSize
    internal static let fdSize = SizeOf.fileDescriptorType

    internal static let modeOffset = fdOffset + fdSize
    internal static let modeSize = SizeOf.fileMode

    internal static let encodingOffset = modeOffset + modeSize
    internal static let encodingSize = SizeOf.stringEncoding

    internal static let errorHandlingOffset = encodingOffset + encodingSize
    internal static let errorHandlingSize = SizeOf.stringErrorHandling

    internal static let size = errorHandlingOffset + errorHandlingSize
  }

  // MARK: - Properties

  private var namePtr: Ptr<String?> { Ptr(self.ptr, offset: Layout.nameOffset) }
  private var fdPtr: Ptr<FileDescriptorType> { Ptr(self.ptr, offset: Layout.fdOffset) }
  private var modePtr: Ptr<FileMode> { Ptr(self.ptr, offset: Layout.modeOffset) }
  private var encodingPtr: Ptr<PyString.Encoding> { Ptr(self.ptr, offset: Layout.encodingOffset) }
  private var errorHandlingPtr: Ptr<PyString.ErrorHandling> { Ptr(self.ptr, offset: Layout.errorHandlingOffset) }

  internal var name: String? { self.namePtr.pointee }
  internal var fd: FileDescriptorType { self.fdPtr.pointee }
  internal var mode: FileMode { self.modePtr.pointee }
  internal var encoding: PyString.Encoding { self.encodingPtr.pointee }
  internal var errorHandling: PyString.ErrorHandling { self.errorHandlingPtr.pointee }

  private static let closeOnDeallocFlag = PyObjectHeader.Flags.custom0

  /// Should we close the file when deallocating?
  internal var closeOnDealloc: Bool {
    get { self.flags.isSet(Self.closeOnDeallocFlag) }
    nonmutating set { self.flags.set(Self.closeOnDeallocFlag, to: newValue) }
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  // swiftlint:disable:next function_parameter_count
  internal func initialize(type: PyType,
                           name: String?,
                           fd: FileDescriptorType,
                           mode: FileMode,
                           encoding: PyString.Encoding,
                           errorHandling: PyString.ErrorHandling,
                           closeOnDealloc: Bool) {
    self.header.initialize(type: type)
    self.namePtr.initialize(to: name)
    self.fdPtr.initialize(to: fd)
    self.modePtr.initialize(to: mode)
    self.encodingPtr.initialize(to: encoding)
    self.errorHandlingPtr.initialize(to: errorHandling)
    self.closeOnDealloc = closeOnDealloc
  }

  internal static func deinitialize(ptr: RawPtr) {
    let zelf = PyTextFile(ptr: ptr)

    // Remember that during 'deinit' we are not allowed to call any other
    // 'Python' function as the whole context may be deinitializing.

    if zelf.closeOnDealloc {
      // Regardless of whether it succeeded/failed we will ignore result.
      _ = zelf.closeIfNotAlreadyClosed()
    }

    zelf.header.deinitialize()
    zelf.namePtr.deinitialize()
    zelf.fdPtr.deinitialize()
    zelf.modePtr.deinitialize()
    zelf.encodingPtr.deinitialize()
    zelf.errorHandlingPtr.deinitialize()
  }

  private func closeIfNotAlreadyClosed() -> Int { return 1 }

  // MARK: - Debug

  internal static func createDebugString(ptr: RawPtr) -> String {
    let zelf = PyTextFile(ptr: ptr)
    return "PyTextFile(type: \(zelf.typeName), flags: \(zelf.flags))"
  }
}

/* MARKER

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> String {
    if self.hasReprLock {
      return "<TextFile - reentrant call>"
    }

    return self.withReprLock {
      var result = "<TextFile"

      if let name = self.name {
        result += " name=\(name)"
      }

      result += " mode=\(self.mode.flag)"
      result += " encoding=\(self.encoding)"
      result += ">"

      return result
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

    if PyCast.isNone(size) {
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

    switch self.encoding.encodeOrError(string: string, onError: self.errorHandling) {
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
                   traceback: PyObject) -> PyResult<PyNone> {
    // Remember that if we return 'truthy' value (yes, we JavasScript now)
    // then the exception will be suppressed (and we don't want this).
    // So we return 'None' which is 'falsy'.
    return self.closeIfNotAlreadyClosed()
  }

  // MARK: - Helpers

  private func modeError(_ msg: String) -> PyBaseException {
    // It should be 'io.UnsupportedOperation', but we don't have it,
    // so we will use 'OSError' instead.
    return Py.newOSError(msg: msg)
  }
}

*/
