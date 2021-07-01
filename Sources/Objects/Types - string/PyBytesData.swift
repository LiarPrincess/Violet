import Foundation
import BigInt
import VioletCore

// MARK: - Bytes data

/// Shared code between `PyBytes` and `PyBytesArray`.
///
/// Anyway, if you are looking for something it is probably in `PyStringImpl`
/// and not here.
internal struct PyBytesData {

  internal private(set) var values: Data

  private var isEmpty: Bool {
    return self.values.isEmpty
  }

  private var count: Int {
    return self.values.count
  }

  internal init() {
    self.values = Data()
  }

  internal init(_ values: Data) {
    self.values = values
  }

  // MARK: PyStringImpl

  internal typealias Scalars = Data
  internal typealias Builder = BytesBuilder

  internal var scalars: Data {
    return self.values
  }

  internal static func toUnicodeScalar(_ element: UInt8) -> UnicodeScalar {
    return UnicodeScalar(element)
  }

  internal static func extractSelf(
    from object: PyObject
  ) -> PyStringImplExtractedSelf<Self> {
    // Most of the `bytes` functions also accept `int`.
    // For example: `49 in b'123'`.
    if let pyInt = PyCast.asInt(object) {
      guard let byte = UInt8(exactly: pyInt.value) else {
        let msg = "byte must be in range(0, 256)"
        return .error(Py.newValueError(msg: msg))
      }

      return .value(PyBytesData(Data([byte])))
    }

    if let bytes = PyCast.asAnyBytes(object) {
      return .value(PyBytesData(bytes.elements))
    }

    return .notSelf
  }

  // MARK: - String conversion

  private var encoding: PyStringEncoding {
    return Py.sys.defaultEncoding
  }

  /// Decode `self` as string.
  ///
  /// Return `valueError` with following message if this fails:
  /// '\(fnName) bytes '\(bytes.ptrString)' cannot be interpreted as str'.
  internal var string: String? {
    return String(data: self.values, encoding: self.encoding.swift)
  }

  private var stringOrFatal: String {
    if let s = self.string {
      return s
    }

    let msg = "Violet error: Sometimes we convert 'bytes' to 'string' " +
      "(mostly when we really need string, for example to check for whitespaces). " +
      "Normally it works, but this time conversion to string failed."
    trap(msg)
  }

  private func encode(_ string: String) -> Data {
    if let result = string.data(using: self.encoding.swift) {
      return result
    }

    let msg = "Violet error: Sometimes we convert 'bytes' to 'string' and back " +
      "(mostly when we really need string, for example to check for whitespaces). " +
      "Normally it works, but this time conversion back to bytes failed."
    trap(msg)
  }

  // MARK: - Helpers

  internal static func asByte(_ value: PyObject) -> PyResult<UInt8> {
    let bigInt: BigInt

    switch IndexHelper.bigInt(value) {
    case let .value(b):
      bigInt = b
    case let .error(e),
         let .notIndex(e):
      return .error(e)
    }

    guard let byte = UInt8(exactly: bigInt) else {
      return .valueError("byte must be in range(0, 256)")
    }

    return .value(byte)
  }
}
