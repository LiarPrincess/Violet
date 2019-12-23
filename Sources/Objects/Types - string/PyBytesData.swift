import Core
import Foundation

// swiftlint:disable file_length
// swiftlint:disable yoda_condition

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

  internal private(set) var values: Data

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

  internal func capitalize() -> Data {
    let string = self.capitalizeString()
    return self.asData(string)
  }

  // MARK: - Append

  internal mutating func append(_ value: PyObject) -> PyResult<()> {
    switch PyBytesData.asByte(value) {
    case let .value(b):
      self.values.append(b)
      return .value()
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Insert

  internal mutating func insert(at index: PyObject,
                                item: PyObject) -> PyResult<()> {
    let parsedIndex: Int
    switch IndexHelper.int(index) {
    case let .value(i): parsedIndex = i
    case let .error(e): return .error(e)
    }

    let byte: UInt8
    switch PyBytesData.asByte(item) {
    case let .value(b): byte = b
    case let .error(e): return .error(e)
    }

    return self.insert(at: parsedIndex, item: byte)
  }

  internal mutating func insert(at index: Int,
                                item: UInt8) -> PyResult<()> {
    self.values.insert(item, at: index)
    return .value()
  }

  // MARK: - Remove

  // sourcery: pymethod = pop
  internal mutating func remove(_ value: PyObject) -> PyResult<()> {
    switch PyBytesData.asByte(value) {
    case let .value(b):
      guard let index = self.values.firstIndex(of: b) else {
        return .valueError("value not found in bytearray")
      }

      self.values.remove(at: index)
      return .value()

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Pop

  // sourcery: pymethod = pop
  internal mutating func pop(index: PyObject?) -> PyResult<UInt8> {
    switch self.parsePopIndex(from: index) {
    case let .value(int):
      return self.pop(index: int)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func pop(index: Int) -> PyResult<UInt8> {
    if self.isEmpty {
      return .indexError("pop from empty bytearray")
    }

    var index = index
    if index < 0 {
      index += self.count
    }

    guard 0 <= index && index < self.count else {
      return .indexError("pop index out of range")
    }

    let result = self.values.remove(at: index)
    return .value(result)
  }

  private func parsePopIndex(from index: PyObject?) -> PyResult<Int> {
    guard let index = index else {
      return .value(-1)
    }

    return IndexHelper.int(index)
  }

  // MARK: - Set/del item

  internal mutating func setItem(at index: PyObject,
                                 to value: PyObject) -> PyResult<()> {
    // Setting slice is not (yet) implemented

    let parsedIndex: Int
    switch IndexHelper.int(index) {
    case let .value(i): parsedIndex = i
    case let .error(e): return .error(e)
    }

    let byte: UInt8
    switch PyBytesData.asByte(value) {
    case let .value(b): byte = b
    case let .error(e): return .error(e)
    }

    self.values[parsedIndex] = byte
    return .value()
  }

  internal mutating func delItem(at index: PyObject) -> PyResult<()> {
    let parsedIndex: Int
    switch IndexHelper.int(index) {
    case let .value(i): parsedIndex = i
    case let .error(e): return .error(e)
    }

    _ = self.values.remove(at: parsedIndex)
    return .value()
  }

  // MARK: - Clear

  internal mutating func clear() {
    self.values = Data()
  }

  // MARK: - Reverse

  internal mutating func reverse() {
    self.values.reverse()
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

  // MARK: - New

  /// Helper for `__new__` method.
  ///
  ///```
  /// >>> help(bytes)
  /// class bytes(object)
  /// |  bytes(iterable_of_ints) -> bytes
  /// |  bytes(string, encoding[, errors]) -> bytes
  /// |  bytes(bytes_or_buffer) -> immutable copy of bytes_or_buffer
  /// |  bytes(int) -> bytes object of size given by the parameter initialized with null bytes
  /// |  bytes() -> empty bytes object
  /// ```
  internal static func handleNewArgs(object: PyObject?,
                                     encoding: PyObject?,
                                     errors: PyObject?) -> PyResult<Data> {
    guard let object = object else {
      return .value(Data())
    }

    guard encoding == nil && errors == nil else {
      fatalError("Violet currently does not support 'encoding' and 'errors' parameters")
    }

    if let bytes = object as? PyBytesType {
      return .value(bytes.data.values)
    }

    switch PyBytesData.newFromCount(object: object) {
    case .bytes(let data): return .value(data)
    case .tryOther: break
    case .error(let e): return .error(e)
    }

    switch PyBytesData.newFromIterable(object: object) {
    case .bytes(let data): return .value(data)
    case .tryOther: break
    case .error(let e): return .error(e)
    }

    return .typeError("cannot convert '\(object.typeName)' object to bytes")
  }

  private enum NewFromResult {
    case bytes(Data)
    case tryOther
    case error(PyErrorEnum)
  }

  private static func newFromCount(object: PyObject) -> NewFromResult {
    switch IndexHelper.tryInt(object) {
    case .value(let count):
      // swiftlint:disable:next empty_count
      guard count >= 0 else {
        return .error(.valueError("negative count"))
      }

      return .bytes(Data(repeating: 0, count: count))

    case .notIndex:
      return .tryOther

    case .error(let e):
      return .error(e)
    }
  }

  private static func newFromIterable(object: PyObject) -> NewFromResult {
    let builtins = object.builtins

    guard builtins.hasIter(object: object) else {
      return .tryOther
    }

    let acc = builtins.reduce(iterable: object, into: Data()) { data, object in
      switch PyBytesData.asByte(object) {
      case let .value(byte):
        data.append(byte)
        return .goToNextElement
      case let .error(e):
        return .error(e)
      }
    }

    switch acc {
    case let .value(data):
      return .bytes(data)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Helpers

  internal static func asByte(_ value: PyObject) -> PyResult<UInt8> {
    let int: Int
    switch IndexHelper.int(value) {
    case let .value(i): int = i
    case let .error(e): return .error(e)
    }

    guard let byte = UInt8(exactly: int) else {
      return .valueError("byte must be in range(0, 256)")
    }

    return .value(byte)
  }
}
