import Core
import Foundation

/// Protocol implemented by both `bytes` and `bytesrray`.
internal protocol PyBytesType: PyObject {
  var data: PyBytesData { get }
}

// MARK: - Bytes builder

internal struct BytesBuilder: StringBuilderType {

  internal typealias Element = UInt8
  internal typealias Result = Data

  internal private(set) var result = Data()

  internal init() { }

  internal mutating func append(_ value: UInt8) {
    self.result.append(value)
  }

  internal mutating func append<C: Sequence>(contentsOf other: C)
    where C.Element == UInt8 {

    self.result.append(contentsOf: other)
  }
}

// MARK: - Bytes data

/// Shared code between `PyBytes` and `PyBytesArray`.
internal struct PyBytesData: PyStringImpl {

  internal let values: Data

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

  internal static let typeName = "bytes"
  internal static let defaultFill: UInt8 = 0x20 // space
  internal static let zFill: UInt8 = 0x30 // 0

  internal static func toScalar(_ element: UInt8) -> UnicodeScalar {
    return UnicodeScalar(element)
  }

  internal static func extractSelf(from object: PyObject) -> PyBytesData? {
    let bytes = object as? PyBytesType
    return bytes?.data
  }

  // MARK: - Case

  internal func lowerCased() -> Data {
    let string = self.asString.lowercased()
    return self.asData(string)
  }

  internal func upperCased() -> Data {
    let string = self.asString.uppercased()
    return self.asData(string)
  }

  internal func titleCased() -> Data {
    let string = self.titleCasedString()
    return self.asData(string)
  }

  internal func swapCase() -> Data {
    let string = self.swapCaseString()
    return self.asData(string)
  }

  internal func caseFold() -> Data {
    let string = self.caseFoldString()
    return self.asData(string)
  }

  internal func capitalize() -> Data {
    let string = self.capitalizeString()
    return self.asData(string)
  }

  // MARK: - String conversion

  private static let encoding = String.Encoding.ascii

  private var asString: String {
    if let result = String(data: self.values, encoding: PyBytesData.encoding) {
      return result
    }

    let msg = "Violet error: Sometimes we convert 'bytes' to 'string' " +
      "(mostly when we really need string, for example to check for whitespaces). " +
      "Normally it works, but this time conversion to string failed."
    fatalError(msg)
  }

  private func asData(_ string: String) -> Data {
    if let result = string.data(using: PyBytesData.encoding) {
      return result
    }

    let msg = "Violet error: Sometimes we convert 'bytes' to 'string' and back " +
      "(mostly when we really need string, for example to check for whitespaces). " +
      "Normally it works, but this time conversion back to bytes failed."
    fatalError(msg)
  }
}
