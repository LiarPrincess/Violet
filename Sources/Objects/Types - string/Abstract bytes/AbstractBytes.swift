/* MARKER
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

// MARK: - AbstractBytes_ElementsFromIterable

// swiftlint:disable:next type_name
internal enum AbstractBytes_ElementsFromIterable {
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
  ///
  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _isEqualBytes(other: PyObject) -> CompareResult {
    if self === other {
      return .value(true)
    }

    // Homo - both bytes/bytearray
    if let bytes = PyCast.asAnyBytes(other) {
      let result = self._isEqual(other: bytes.elements)
      return CompareResult(result)
    }

    // Hetero - bytes and something
    if PyCast.isInt(other) {
      let msg = "Comparison between bytes and int"
      if let e = Py.warnBytesIfEnabled(msg: msg) {
        return .error(e)
      }
    }

    if PyCast.isString(other) {
      let msg = "Comparison between bytes and string"
      if let e = Py.warnBytesIfEnabled(msg: msg) {
        return .error(e)
      }
    }

    return .notImplemented
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _isNotEqualBytes(other: PyObject) -> CompareResult {
    return self._isEqualBytes(other: other).not
  }

  // MARK: - Repr

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _repr() -> String {
    var result = String("'")
    result.reserveCapacity(self.count)

    for element in self.elements {
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
          result.append(self._hex((element >> 4) & 0xf))
          result.append(self._hex((element >> 0) & 0xf))
        }
      }
    }
    result.append("'")

    return result
  }

  private func _hex(_ value: UInt8) -> String {
    return String(value, radix: 16, uppercase: false)
  }

  // MARK: - Str

  /// static PyObject *
  /// bytes_str(PyObject *op)
  ///
  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _str() -> PyResult<String> {
    if let e = Py.warnBytesIfEnabled(msg: "str() on a bytes instance") {
      return .error(e)
    }

    let repr = self._repr()
    return .value(repr)
  }

  // MARK: - Elements from iterable

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _getElementsFromIterable(
    iterable: PyObject
  ) -> AbstractBytes_ElementsFromIterable {
    if let bytes = PyCast.asExactlyAnyBytes(iterable) {
      return .bytes(bytes.elements)
    }

    guard Py.hasIter(object: iterable) else {
      return .notIterable
    }

    var result = Data()

    // If we can easily get the '__len__' then use it.
    // If not, then we can't call python method, because it may side-effect.
    if let bigInt = PyStaticCall.__len__(iterable), let int = Int(exactly: bigInt) {
      result.reserveCapacity(int)
    }

    let reduceError = Py.reduce(iterable: iterable, into: &result) { acc, object in
      switch Self._asByte(object: object) {
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
  ///
  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _asByte(object: PyObject) -> PyResult<UInt8> {
    let bigInt: BigInt

    switch IndexHelper.bigInt(object) {
    case let .value(b):
      bigInt = b
    case let .notIndex(lazyError):
      let e = lazyError.create()
      return .error(e)
    case let .error(e):
      return .error(e)
    }

    guard let byte = UInt8(exactly: bigInt) else {
      return .valueError("byte must be in range(0, 256)")
    }

    return .value(byte)
  }
}

*/