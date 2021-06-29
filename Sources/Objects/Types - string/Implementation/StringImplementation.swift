import Foundation
import VioletCore

/// (Almost) all of the `str` methods.
/// Everything here is 'best-effort' because strings are hard.
///
/// Note that we will use the same implementation for `str` and `bytes`.
internal enum StringImplementation {

  // MARK: - Types

  /// `String.UnicodeScalarView`
  internal typealias UnicodeScalars = String.UnicodeScalarView
  /// `UnicodeScalars.SubSequence`
  internal typealias UnicodeScalarsSub = UnicodeScalars.SubSequence

  // MARK: - Constants

  /// Name of the Python type used in 'scalar' versions of our methods.
  internal static let scalarsTypeName = "str"
  internal static let scalarsDefaultFill: UnicodeScalar = " "
  internal static let scalarsZFill: UnicodeScalar = "0"

  /// Name of the Python type used in 'data' versions of our methods.
  ///
  /// Python uses `bytes` for both `bytes` and `bytearray`.
  internal static let dataTypeName = "bytes"
  internal static let dataDefaultFill: UInt8 = 0x20 // space
  internal static let dataZFill: UInt8 = 0x30 // 0

  // MARK: - Object -> type conversion

  /// Given a `PyObject` we try to extract valid collection to use in function.
  internal typealias ObjectToCollectionFn<C> = (PyObject) -> GetCollectionResult<C>

  /// Given a `PyObject` we try to extract valid collection to use in function.
  internal enum GetCollectionResult<T> {
    case value(T)
    case notCollection
    case error(PyBaseException)
  }

  internal static func getScalars(object: PyObject) -> GetCollectionResult<UnicodeScalars> {
    if let string = PyCast.asString(object) {
      return .value(string.value.unicodeScalars)
    }

    return .notCollection
  }

  internal static func getData(object: PyObject) -> GetCollectionResult<Data> {
    if let bytes = object as? PyBytesType {
      return .value(bytes.data.scalars)
    }

    // Most of the `bytes` functions also accept `int`.
    // For example: `49 in b'123'`.
    if let pyInt = PyCast.asInt(object) {
      guard let byte = UInt8(exactly: pyInt.value) else {
        let msg = "byte must be in range(0, 256)"
        return .error(Py.newValueError(msg: msg))
      }

      let data = Data([byte])
      return .value(data)
    }

    return .notCollection
  }

  // MARK: - String -> Data

  internal static func toData(string: String) -> Data {
    let encoding = Py.sys.defaultEncoding
    if let result = string.data(using: encoding.swift) {
      return result
    }

    let msg = "Violet error: Sometimes we convert 'bytes' to 'string' and back " +
      "(mostly when we really need string, for example to check for whitespaces). " +
      "Normally it works, but this time conversion back to bytes failed."

    trap(msg)
  }
}
