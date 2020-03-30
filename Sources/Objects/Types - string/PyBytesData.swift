import Core
import Foundation

// swiftlint:disable file_length
// swiftlint:disable yoda_condition

/// Protocol implemented by both `bytes` and `bytesarray`.
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
///
/// Anyway, if you are looking for something it is probably in `PyStringImpl`
/// and not here.
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

  internal static func toUnicodeScalar(_ element: UInt8) -> UnicodeScalar {
    return UnicodeScalar(element)
  }

  internal static func extractSelf(from object: PyObject) -> PyBytesData? {
    // Most of the `bytes` functions also accept `int`.
    // For example: `49 in b'123'`.
    if let pyInt = object as? PyInt,
       let byte = UInt8(exactly: pyInt.value) {

      return PyBytesData(Data([byte]))
    }

    let bytes = object as? PyBytesType
    return bytes?.data
  }

  // MARK: - Case

  internal func lowerCased() -> Data {
    let string = self.stringOrFatal.lowercased()
    return self.encode(string)
  }

  internal func upperCased() -> Data {
    let string = self.stringOrFatal.uppercased()
    return self.encode(string)
  }

  internal func titleCased() -> Data {
    let string = self.titleCasedString()
    return self.encode(string)
  }

  internal func swapCase() -> Data {
    let string = self.swapCaseString()
    return self.encode(string)
  }

  internal func capitalize() -> Data {
    let string = self.capitalizeString()
    return self.encode(string)
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

  // MARK: - Extend

  internal mutating func extend(iterable: PyObject) -> PyResult<()> {
    // Fast path: adding bytes
    if let bytes = Self.extractSelf(from: iterable) {
      self.values.append(contentsOf: bytes.scalars)
      return .value()
    }

    // Slow path: iterable
    // Do not modify `self.values` until we finished iteration.
    let d = Py.reduce(iterable: iterable, into: Data()) { acc, object in
      switch Self.asByte(object) {
      case let .value(byte):
        acc.append(byte)
        return .goToNextElement
      case let .error(e):
        return .error(e)
      }
    }

    switch d {
    case let .value(data):
      self.values.append(contentsOf: data)
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

  /// Decode `self` as string.
  ///
  /// Return `valueError` with following message if this fails:
  /// '\(fnName) bytes '\(bytes.ptrString)' cannot be interpreted as str'.
  internal var string: String? {
    let encoding = PyStringEncoding.default
    return String(data: self.values, encoding: encoding.swift)
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
    let encoding = PyStringEncoding.default
    if let result = string.data(using: encoding.swift) {
      return result
    }

    let msg = "Violet error: Sometimes we convert 'bytes' to 'string' and back " +
      "(mostly when we really need string, for example to check for whitespaces). " +
      "Normally it works, but this time conversion back to bytes failed."
    trap(msg)
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

    // Fast path when we don't have encoding and kwargs
    let hasEncoding = encoding != nil || errors != nil
    if let bytes = object as? PyBytesType, !hasEncoding {
      return .value(bytes.data.values)
    }

    if hasEncoding {
      return PyBytesData.new(encoded: object, encoding: encoding, errors: errors)
    }

    switch PyBytesData.new(fromCount: object) {
    case .bytes(let data): return .value(data)
    case .tryOther: break
    case .error(let e): return .error(e)
    }

    switch PyBytesData.new(fromIterable: object) {
    case .bytes(let data): return .value(data)
    case .tryOther: break
    case .error(let e): return .error(e)
    }

    return .typeError("cannot convert '\(object.typeName)' object to bytes")
  }

  private static func new(encoded object: PyObject,
                          encoding encodingObj: PyObject?,
                          errors errorObj: PyObject?) -> PyResult<Data> {
    let encoding: PyStringEncoding
    switch PyStringEncoding.from(encodingObj) {
    case let .value(e): encoding = e
    case let .error(e): return .error(e)
    }

    let errors: PyStringErrorHandler
    switch PyStringErrorHandler.from(errorObj) {
    case let .value(e): errors = e
    case let .error(e): return .error(e)
    }

    guard let string = object as? PyString else {
      return .typeError("encoding without a string argument")
    }

    return encoding.encode(string: string.value, errors: errors)
  }

  private enum NewFromResult {
    case bytes(Data)
    case tryOther
    case error(PyBaseException)
  }

  private static func new(fromCount object: PyObject) -> NewFromResult {
    switch IndexHelper.intMaybe(object) {
    case .value(let count):
      // swiftlint:disable:next empty_count
      guard count >= 0 else {
        return .error(Py.newValueError(msg: "negative count"))
      }

      return .bytes(Data(repeating: 0, count: count))

    case .notIndex:
      return .tryOther

    case .error(let e):
      return .error(e)
    }
  }

  private static func new(fromIterable object: PyObject) -> NewFromResult {
    guard Py.hasIter(object: object) else {
      return .tryOther
    }

    let acc = Py.reduce(iterable: object, into: Data()) { data, object in
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
