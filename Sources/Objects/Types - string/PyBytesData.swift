import Foundation
import BigInt
import VioletCore

// swiftlint:disable file_length
// swiftlint:disable yoda_condition

/// Protocol implemented by both `bytes` and `bytearray`.
internal protocol PyBytesType: PyObject {
  var data: PyBytesData { get }

  /// Is this builtin `bytes/bytearray` type?
  ///
  /// Will return `false` if this is a subclass.
  func checkExact() -> Bool
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

  // MARK: - Factory

  internal static func from(iterable: PyObject) -> PyResult<PyBytesData> {
    // Fast path: bytes
    switch Self.extractSelf(from: iterable) {
    case .value(let bytesData):
      return .value(bytesData)
    case .notSelf:
      break // Try other
    case .error(let e):
      return .error(e)
    }

    // Slow path: iterable
    var result = PyBytesData()
    let reduceError = Py.reduce(iterable: iterable, into: &result) { acc, object in
      switch acc.append(object: object) {
      case .value: return .goToNextElement
      case .error(let e): return .error(e)
      }
    }

    if let e = reduceError {
      return .error(e)
    }

    return .value(result)
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

    if let bytes = object as? PyBytesType {
      return .value(bytes.data)
    }

    return .notSelf
  }

  // MARK: - Equatable

  internal func isEqual(_ other: PyObject) -> CompareResult {
    // Homo
    if let homo = self.compare(other) {
      return CompareResult(homo == .equal)
    }

    // Hetero
    // static PyObject*
    // bytes_richcompare(PyBytesObject *a, PyBytesObject *b, int op)

    if other is PyInt {
      let msg = "Comparison between bytes and int"
      if let e = Py.warnBytesIfEnabled(msg: msg) {
        return .error(e)
      }
    }

    if other is PyString {
      let msg = "Comparison between bytes and string"
      if let e = Py.warnBytesIfEnabled(msg: msg) {
        return .error(e)
      }
    }

    return .notImplemented
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> CompareResult {
    let raw = self.compare(other)
    let result = raw.map { $0 == .less }
    return CompareResult(result)
  }

  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    let raw = self.compare(other)
    let result = raw.map { $0 == .less || $0 == .equal }
    return CompareResult(result)
  }

  internal func isGreater(_ other: PyObject) -> CompareResult {
    let raw = self.compare(other)
    let result = raw.map { $0 == .greater }
    return CompareResult(result)
  }

  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    let raw = self.compare(other)
    let result = raw.map { $0 == .greater || $0 == .equal }
    return CompareResult(result)
  }

  private func compare(_ other: PyObject) -> StringCompareResult? {
    if let bytes = other as? PyBytesType {
      return self.compare(to: bytes.data)
    }

    return nil
  }

  // MARK: - Repr

  internal func createRepr() -> String {
    let quote: UnicodeScalar = "'"
    var result = String(quote)
    result.reserveCapacity(self.count)

    for element in self.scalars {
      let scalar = Self.toUnicodeScalar(element)
      switch scalar {
      case quote, "\\":
        result.append("\\")
        result.append(scalar)
      case "\n":
        result.append("\\n")
      case "\t":
        result.append("\\t")
      case "\r":
        result.append("\\r")
      default:
        let space = 0x20
        let lastAscii = 0x7f

        if element == 0 {
          result.append("\\x00")
        } else if space <= element && element < lastAscii {
          result.append(scalar)
        } else {
          result.append("\\x")
          result.append(self.hex((element >> 4) & 0xf))
          result.append(self.hex((element >> 0) & 0xf))
        }
      }
    }
    result.append(quote)

    return result
  }

  private func hex(_ value: UInt8) -> String {
    return String(value, radix: 16, uppercase: false)
  }

  // MARK: - String

  /// static PyObject *
  /// bytes_str(PyObject *op)
  internal func strWarnIfNeeded() -> PyBaseException? {
    return Py.warnBytesIfEnabled(msg: "str() on a bytes instance")
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

  internal mutating func append(object: PyObject) -> PyResult<PyNone> {
    switch PyBytesData.asByte(object) {
    case let .value(byte):
      self.append(element: byte)
      return .value(Py.none)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func append(element: UInt8) {
    self.values.append(element)
  }

  // MARK: - Extend

  internal mutating func extend(with iterable: PyObject) -> PyResult<PyNone> {
    // Do not modify `self.values` until we finished iteration.
    let dataResult = PyBytesData.from(iterable: iterable)
    switch dataResult {
    case let .value(data):
      self.extend(with: data)
      return .value(Py.none)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func extend(with data: PyBytesData) {
    self.values.append(data.scalars)
  }

  // MARK: - Insert

  internal mutating func insert(index: PyObject, item: PyObject) -> PyResult<Void> {
    let unwrappedIndex = IndexHelper.int(
      index,
      onOverflow: .overflowError(msg: "cannot add more objects to \(Self.typeName)")
    )

    let parsedIndex: Int
    switch unwrappedIndex {
    case let .value(i):
      parsedIndex = i
    case let .error(e),
         let .notIndex(e),
         let .overflow(_, e):
      return .error(e)
    }

    let byte: UInt8
    switch PyBytesData.asByte(item) {
    case let .value(b): byte = b
    case let .error(e): return .error(e)
    }

    return self.insert(index: parsedIndex, item: byte)
  }

  internal mutating func insert(index: Int, item: UInt8) -> PyResult<Void> {
    var index = index

    if index < 0 {
      index += self.values.count
      if index < 0 {
        index = 0
      }
    }

    if index > self.values.count {
      index = self.values.count
    }

    self.values.insert(item, at: index)
    return .value()
  }

  // MARK: - Remove

  internal mutating func remove(_ value: PyObject) -> PyResult<Void> {
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

    let unwrappedIndex = IndexHelper.int(
      index,
      onOverflow: .indexError(msg: "pop index out of range")
    )

    switch unwrappedIndex {
    case let .value(int):
      return .value(int)
    case let .error(e),
          let .notIndex(e),
          let .overflow(_, e):
      return .error(e)
    }
  }

  // MARK: - Set item

  private enum SetItemImpl: SetItemHelper {

    // swiftlint:disable:next nesting
    fileprivate typealias Collection = Data

    fileprivate static func getElement(object: PyObject) -> PyResult<UInt8> {
      return PyBytesData.asByte(object)
    }

    fileprivate static func getElements(object: PyObject) -> PyResult<[UInt8]> {
      var result = [UInt8]()

      let reduceError = Py.reduce(iterable: object, into: &result) { acc, object in
        switch SetItemImpl.getElement(object: object) {
        case let .value(i):
          acc.append(i)
          return .goToNextElement
        case let .error(e):
          return .error(e)
        }
      }

      if let e = reduceError {
        return .error(e)
      }

      return .value(result)
    }
  }

  internal mutating func setItem(index: PyObject,
                                 value: PyObject) -> PyResult<PyNone> {
    return SetItemImpl.setItem(collection: &self.values,
                               index: index,
                               value: value)
  }

  internal mutating func setItem(index: Int,
                                 value: PyObject) -> PyResult<PyNone> {
    return SetItemImpl.setItem(collection: &self.values,
                               index: index,
                               value: value)
  }

  internal mutating func setItem(slice: PySlice,
                                 value: PyObject) -> PyResult<PyNone> {
    return SetItemImpl.setItem(collection: &self.values,
                               slice: slice,
                               value: value)
  }

  // MARK: - Del item

  private enum DelItemImpl: DelItemHelper {
    // swiftlint:disable:next nesting
    fileprivate typealias Collection = Data
  }

  internal mutating func delItem(index: PyObject) -> PyResult<PyNone> {
    DelItemImpl.delItem(collection: &self.values, index: index)
  }

  internal mutating func delItem(index: Int) -> PyResult<PyNone> {
    DelItemImpl.delItem(collection: &self.values, index: index)
  }

  internal mutating func delItem(slice: PySlice) -> PyResult<PyNone> {
    DelItemImpl.delItem(collection: &self.values, slice: slice)
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

  // MARK: - New

  /// Helper for `__new__` method.
  ///
  /// ```
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

    guard let string = PyCast.asString(object) else {
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
    switch IndexHelper.int(object, onOverflow: .overflowError) {
    case .value(let count):
      // swiftlint:disable:next empty_count
      guard count >= 0 else {
        return .error(Py.newValueError(msg: "negative count"))
      }

      return .bytes(Data(repeating: 0, count: count))

    case .notIndex:
      return .tryOther

    case .error(let e),
         .overflow(_, let e):
      return .error(e)
    }
  }

  private static func new(fromIterable iterable: PyObject) -> NewFromResult {
    guard Py.hasIter(object: iterable) else {
      return .tryOther
    }

    if let bytes = iterable as? PyBytesType, bytes.checkExact() {
      return .bytes(bytes.data.values)
    }

    var result = Data()

    let reduceError = Py.reduce(iterable: iterable, into: &result) { acc, object in
      switch PyBytesData.asByte(object) {
      case let .value(byte):
        acc.append(byte)
        return .goToNextElement
      case let .error(e):
        return .error(e)
      }
    }

    if let e = reduceError {
      return .error(e)
    }

    return .bytes(result)
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
