import Foundation

// MARK: - PyAnyBytes

/// When you don't care whether the object is `bytes` or `bytearray`.
/// You just need `Data`.
internal struct PyAnyBytes: CustomStringConvertible {

  fileprivate enum Storage {
    case bytes(PyBytes)
    case bytearray(PyByteArray)
  }

  fileprivate let storage: Storage

  internal var description: String {
    switch self.storage {
    case let .bytes(s): return s.description
    case let .bytearray(s): return s.description
    }
  }

  internal var elements: Data {
    switch self.storage {
    case let .bytes(s): return s.elements
    case let .bytearray(s): return s.elements
    }
  }

  internal var asObject: PyObject {
    switch self.storage {
    case let .bytes(s): return s.asObject
    case let .bytearray(s): return s.asObject
    }
  }

  internal init(bytes: PyBytes) {
    self.storage = .bytes(bytes)
  }

  internal init(bytearray: PyByteArray) {
    self.storage = .bytearray(bytearray)
  }
}

// MARK: - PyCast

extension PyCast {

  /// Is this object a `bytes` or `bytearray` (or their subclass)?
  internal func isAnyBytes(_ object: PyObject) -> Bool {
    return self.isBytes(object) || self.isByteArray(object)
  }

  /// Is this object a `bytes` or `bytearray` (but not their subclass)?
  internal func isExactlyAnyBytes(_ object: PyObject) -> Bool {
    return self.isExactlyBytes(object) || self.isExactlyByteArray(object)
  }

  /// Is this object a `bytes` or `bytearray` (but not their subclass)?
  internal func isExactlyAnyBytes(_ bytes: PyAnyBytes) -> Bool {
    switch bytes.storage {
    case let .bytes(s):
      return self.isExactlyBytes(s.asObject)
    case let .bytearray(s):
      return self.isExactlyByteArray(s.asObject)
    }
  }

  /// Cast this object to `PyAnyBytes` if it is a `bytes` or `bytearray`
  /// (or their subclass).
  internal func asAnyBytes(_ object: PyObject) -> PyAnyBytes? {
    if let bytes = self.asBytes(object) {
      return PyAnyBytes(bytes: bytes)
    }

    if let bytearray = self.asByteArray(object) {
      return PyAnyBytes(bytearray: bytearray)
    }

    return nil
  }

  /// Cast this object to `PyAnyBytes` if it is a `bytes` or `bytearray`
  /// (but not their subclass).
  internal func asExactlyAnyBytes(_ object: PyObject) -> PyAnyBytes? {
    if let bytes = self.asExactlyBytes(object) {
      return PyAnyBytes(bytes: bytes)
    }

    if let bytearray = self.asExactlyByteArray(object) {
      return PyAnyBytes(bytearray: bytearray)
    }

    return nil
  }
}
