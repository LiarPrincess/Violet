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

  internal let fd: FileDescriptor
  internal let encoding: FileEncoding
  internal let errors: FileErrorHandler

  internal var mode: FileMode {
    return self.fd.mode
  }

  // MARK: - Init

  internal init(_ context: PyContext,
                fd: FileDescriptor,
                encoding: FileEncoding,
                errors: FileErrorHandler) {
    self.fd = fd
    self.encoding = encoding
    self.errors = errors
    super.init(type: context.builtins.types.textFile)
  }

   // MARK: - String

   // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    if self.hasReprLock {
      return .value("<TextFile - reentrant call>")
    }

    return self.withReprLock {
      var result = "<TextFile"

      if let name = self.fd.name {
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
    guard self.isReadable() else {
      return .osError("not readable")
    }

    if size == 0 {
      return self.decode(data: Data())
    }

    let data = size > 0 ?
      self.fd.readData(ofLength: size) :
      self.fd.readDataToEndOfFile()

    return self.decode(data: data)
  }

  // MARK: - Dealloc

  // __dealloc__
  // Type objects get a new tp_finalize slot to which __del__ methods are mapped.
  // https://www.python.org/dev/peps/pep-0442/#c-level-changes

  // MARK: - Encoding

  private func decode(data: Data) -> PyResult<PyString> {
    let encoding = self.encoding.swift
    guard let string = String(data: data, encoding: encoding) else {
      return self.decodeError(data: data)
    }

    let result = self.builtins.newString(string)
    return .value(result)
  }

  /// static int _PyCodecRegistry_Init(void)
  private func decodeError(data: Data) -> PyResult<PyString> {
    switch self.errors {
    case .strict:
      return .unicodeDecodeError(encoding: self.encoding, data: data)
    case .ignore:
      return .value(self.builtins.emptyString)
    }
  }
}
