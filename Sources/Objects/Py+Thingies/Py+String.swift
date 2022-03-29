import Foundation
import FileSystem
import VioletCore

// cSpell:ignore uxxxx Uxxxxxxxx

// In CPython:
// Python -> builtinmodule.c
// https://docs.python.org/3/library/functions.html

extension Py {

  // MARK: - String

  public func newString(_ value: String) -> PyString {
    if value.isEmpty {
      return self.emptyString
    }

    let type = self.types.str
    return self.memory.newString(type: type, value: value)
  }

  public func newString(scalar: UnicodeScalar) -> PyString {
    // ASCII values are used quite often, so it does not make sense to allocate
    // a new object every time.
    if scalar.isASCII {
      return self.intern(scalar: scalar)
    }

    let string = String(scalar)
    return self.newString(string)
  }

  public func newString(_ value: String.UnicodeScalarView) -> PyString {
    if value.isEmpty {
      return self.emptyString
    }

    let string = String(value)
    return self.newString(string)
  }

  public func newString(_ value: String.UnicodeScalarView.SubSequence) -> PyString {
    if value.isEmpty {
      return self.emptyString
    }

    let string = String(value)
    return self.newString(string)
  }

  public func newString(_ value: CustomStringConvertible) -> PyString {
    let string = String(describing: value)
    return self.newString(string)
  }

  public func newString(_ value: Path) -> PyString {
    let string = value.string
    return self.newString(string)
  }

  public func newStringIterator(string: PyString) -> PyStringIterator {
    let type = self.types.str_iterator
    return self.memory.newStringIterator(type: type, string: string)
  }

  // MARK: - Bytes

  public func newBytes(_ elements: Data) -> PyBytes {
    if elements.isEmpty {
      return self.emptyBytes
    }

    let type = self.types.bytes
    return self.memory.newBytes(type: type, elements: elements)
  }

  public func newBytesIterator(bytes: PyBytes) -> PyBytesIterator {
    let type = self.types.bytes_iterator
    return self.memory.newBytesIterator(type: type, bytes: bytes)
  }

  // MARK: - Byte array

  public func newByteArray(_ elements: Data) -> PyByteArray {
    let type = self.types.bytearray
    return self.memory.newByteArray(type: type, elements: elements)
  }

  public func newByteArrayIterator(bytes: PyByteArray) -> PyByteArrayIterator {
    let type = self.types.bytearray_iterator
    return self.memory.newByteArrayIterator(type: type, bytes: bytes)
  }

  // MARK: - Get string

  internal enum GetStringEncoding {
    // `sys.defaultEncoding`
    case `default`
    case value(PyString.Encoding)
  }

  internal enum GetStringResult {
    case string(PyString, String)
    case bytes(PyAnyBytes, String)
    case byteDecodingError(PyAnyBytes)
    case notStringOrBytes
  }

  /// Converts `Object` -> `String` (if possible).
  ///
  /// Mostly targeted towards `str`, `bytes` and `bytearray`.
  internal func getString(object: PyObject,
                          encoding: GetStringEncoding) -> GetStringResult {
    if let str = self.cast.asString(object) {
      return .string(str, str.value)
    }

    if let bytes = self.cast.asAnyBytes(object) {
      if let string = self.getString(data: bytes.elements, encoding: encoding) {
        return .bytes(bytes, string)
      }

      return .byteDecodingError(bytes)
    }

    return .notStringOrBytes
  }

  /// Decode `bytes` as string.
  ///
  /// If this fails:
  /// - Option 1: return `valueError` with following message:
  /// '\(fnName) bytes '\(bytes.ptrString)' cannot be interpreted as str'.
  /// - Option 2: return `return .byteDecodingError(bytes)`
  internal func getString(bytes: PyAnyBytes, encoding: GetStringEncoding) -> String? {
    return self.getString(data: bytes.elements, encoding: encoding)
  }

  /// Decode `data` as string.
  ///
  /// If this fails:
  /// - Option 1: return `valueError` with following message:
  /// '\(fnName) bytes '\(bytes.ptrString)' cannot be interpreted as str'.
  /// - Option 2: return `return .byteDecodingError(bytes)`
  internal func getString(data: Data, encoding: GetStringEncoding) -> String? {
    let enc: PyString.Encoding
    switch encoding {
    case .default: enc = Sys.defaultEncoding
    case .value(let e): enc = e
    }

    return enc.decode(data: data)
  }

  // MARK: - Join

  /// _PyUnicode_JoinArray
  public func join(strings elements: [PyObject],
                   separator: PyObject) -> PyResultGen<PyString> {
    if elements.isEmpty {
      return .value(self.emptyString)
    }

    if elements.count == 1 {
      if let s = self.cast.asString(elements[0]) {
        return .value(s)
      }
    }

    guard let sep = self.cast.asString(separator) else {
      let message = "separator: expected str instance, \(separator.typeName) found"
      return .typeError(self, message: message)
    }

    let strings: [PyString]
    switch self.asStringArray(elements: elements) {
    case let .value(r): strings = r
    case let .error(e): return .error(e)
    }

    var result = ""
    for (index, string) in strings.enumerated() {
      result.append(string.value)

      let isLast = index == strings.count - 1
      if !isLast {
        result.append(sep.value)
      }
    }

    let resultObject = self.newString(result)
    return .value(resultObject)
  }

  private func asStringArray(elements: [PyObject]) -> PyResultGen<[PyString]> {
    var result = [PyString]()

    for (index, object) in elements.enumerated() {
      switch self.cast.asString(object) {
      case .some(let s):
        result.append(s)
      case .none:
        let msg = "sequence item \(index): expected str instance, \(object.typeName) found"
        return .typeError(self, message: msg)
      }
    }

    return .value(result)
  }
}
