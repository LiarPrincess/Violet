import Foundation
import BigInt

// MARK: - ASCII

/// \t
private let ascii_horizontal_tab: UInt8 = 9
/// LF, \n
private let ascii_line_feed: UInt8 = 10
/// CR, \r
private let ascii_carriage_return: UInt8 = 13
/// '
private let ascii_apostrophe: UInt8 = 39
private let ascii_slash: UInt8 = 47
private let ascii_backslash: UInt8 = 92
private let ascii_space: UInt8 = 32
private let ascii_zero: UInt8 = 48
private let ascii_endIndex: UInt8 = 127

// MARK: - AbstractBytesElementsFromIterable

internal enum AbstractBytesElementsFromIterable {
  case bytes(Data)
  case notIterable
  case error(PyBaseException)
}

// MARK: - AbstractBytes

/// Shared code between `PyBytes` and `PyBytesArray`.
///
/// Anyway, if you are looking for something it is probably in `AbstractString`
/// and not here.
internal protocol AbstractBytes: AbstractString where Builder == BytesBuilder {
  // Builder constraint will also solve 'Elements' and 'Element'
  //
  // We could also 'extension AbstractString where Builder == BytesBuilder'
  // but having new name ('AbstractBytes') is more self-describing.
}

extension AbstractBytes {

  // MARK: - Is equal

  /// static PyObject*
  /// bytes_richcompare(PyBytesObject *a, PyBytesObject *b, int op)
  internal static func abstract__eq__bytes(_ py: Py,
                                           zelf _zelf: PyObject,
                                           other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return Self.isEqualBytes(py, zelf: zelf, other: other)
  }

  internal static func abstract__ne__bytes(_ py: Py,
                                           zelf _zelf: PyObject,
                                           other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = Self.isEqualBytes(py, zelf: zelf, other: other)
    return isEqual.not
  }

  private static func isEqualBytes(_ py: Py, zelf: Self, other: PyObject) -> CompareResult {
    if zelf.ptr === other.ptr {
      return .value(true)
    }

    // Homo - both bytes/bytearray
    if let bytes = py.cast.asAnyBytes(other) {
      let result = Self.abstractIsEqual(zelf: zelf, other: bytes.elements)
      return CompareResult(result)
    }

    // Hetero - bytes and something
    if py.cast.isInt(other) {
      let message = "Comparison between bytes and int"
      if let e = py.warnBytesIfEnabled(message: message) {
        return .error(e)
      }
    }

    if py.cast.isString(other) {
      let message = "Comparison between bytes and string"
      if let e = py.warnBytesIfEnabled(message: message) {
        return .error(e)
      }
    }

    return .notImplemented
  }

  // MARK: - Repr, str

  internal static func abstract__repr__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        prefix: String,
                                        suffix: String) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    return Self.toString(py, zelf: zelf, prefix: prefix, suffix: suffix)
  }

  /// static PyObject *
  /// bytes_str(PyObject *op)
  internal static func abstract__str__(_ py: Py,
                                       zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__str__")
    }

    if let e = py.warnBytesIfEnabled(message: "str() on a bytes instance") {
      return .error(e)
    }

    return Self.toString(py, zelf: zelf, prefix: "", suffix: "")
  }

  private static func toString(_ py: Py,
                               zelf: Self,
                               prefix: String,
                               suffix: String) -> PyResult {
    var result = prefix + "'"
    result.reserveCapacity(zelf.count + 1 + suffix.count)

    for element in zelf.elements {
      switch element {
      case ascii_apostrophe,
           ascii_slash:
        result.append("\\")
        result.append(UnicodeScalar(element))
      case ascii_line_feed:
        result.append("\\n")
      case ascii_carriage_return:
        result.append("\\r")
      case ascii_horizontal_tab:
        result.append("\\t")
      default:
        if element == 0 {
          result.append("\\x00")
        } else if ascii_space <= element && element < ascii_endIndex {
          result.append(UnicodeScalar(element))
        } else {
          result.append("\\x")
          result.append(Self.hex((element >> 4) & 0xf))
          result.append(Self.hex((element >> 0) & 0xf))
        }
      }
    }

    result.append("'")
    result.append(suffix)
    return PyResult(py, result)
  }

  private static func hex(_ value: UInt8) -> String {
    return String(value, radix: 16, uppercase: false)
  }

  // MARK: - Elements from iterable

  internal static func getElementsFromIterable(
    _ py: Py,
    iterable: PyObject
  ) -> AbstractBytesElementsFromIterable {
    if let bytes = py.cast.asExactlyAnyBytes(iterable) {
      return .bytes(bytes.elements)
    }

    guard py.hasIter(object: iterable) else {
      return .notIterable
    }

    var result = Data()
    if let int = Self.abstractApproximateCount(py, iterable: iterable) {
      result.reserveCapacity(int)
    }

    let reduceError = py.reduce(iterable: iterable, into: &result) { acc, object in
      switch Self.asByte(py, object: object) {
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

  // MARK: - As byte

  /// Helper for extracting a single byte.
  internal static func asByte(_ py: Py, object: PyObject) -> PyResultGen<UInt8> {
    let pyInt: PyInt

    switch IndexHelper.pyInt(py, object: object) {
    case let .value(i):
      pyInt = i
    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .error(e):
      return .error(e)
    }

    guard let byte = UInt8(exactly: pyInt.value) else {
      return .valueError(py, message: "byte must be in range(0, 256)")
    }

    return .value(byte)
  }
}
