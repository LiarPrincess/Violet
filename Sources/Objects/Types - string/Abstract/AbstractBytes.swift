import Foundation
import BigInt
import VioletCore

// MARK: - ASCII

// Use 'man ascii', but also this:
// http://html-codes.info/ascii/standard/

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

// MARK: - AbstractBytes

/// Shared code between `PyBytes` and `PyBytesArray`.
///
/// Anyway, if you are looking for something it is probably in `AbstractString`
/// and not here.
protocol AbstractBytes: AbstractString where Builder == BytesBuilder2 {
  // Builder constraint will also solve 'Elements' and 'Element'
  //
  // We could also 'extension AbstractString where Builder == BytesBuilder'
  // but having new name is more self-describing.
}

extension AbstractBytes {

  internal static var _pythonTypeName: String { return "bytes" }
  internal static var _defaultFill: UInt8 { return ascii_space }
  internal static var _zFill: UInt8 { return ascii_zero }

  internal static func _getElements(object: PyObject) -> Data? {
    if let bytes = object as? PyBytesType {
      return bytes.data.scalars
    }

    return nil
  }

  internal static func _getElementsForFindCountContainsIndexOf(
    object: PyObject
  ) -> AbstractString_ElementsForFindCountContainsIndexOf<Data> {
    if let bytes = object as? PyBytesType {
      return .value(bytes.data.scalars)
    }

    // For example: `49 in b'123'`.
    if let pyInt = PyCast.asInt(object) {
      guard let byte = UInt8(exactly: pyInt.value) else {
        let msg = "byte must be in range(0, 256)"
        return .error(Py.newValueError(msg: msg))
      }

      let data = Data([byte])
      return .value(data)
    }

    return .invalidObjectType
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal static func _asUnicodeScalar(element: UInt8) -> UnicodeScalar {
    return UnicodeScalar(element)
  }
}

// MARK: - Methods

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
    if let bytes = other as? PyBytesType {
      let result = self._isEqual(other: bytes.data.scalars)
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
    result.reserveCapacity(self.elements.count)

    for element in self.elements {
      switch element {
      case ascii_apostrophe, ascii_slash:
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

  // MARK: - Case

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _lowerCaseBytes() -> SwiftType {
    let string = self._lowerCase()
    return self._encode(string)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _upperCaseBytes() -> SwiftType {
    let string = self._upperCase()
    return self._encode(string)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _titleCaseBytes() -> SwiftType {
    let string = self._titleCase()
    return self._encode(string)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _swapCaseBytes() -> SwiftType {
    let string = self._swapCase()
    return self._encode(string)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _caseFoldBytes() -> SwiftType {
    let string = self._caseFold()
    return self._encode(string)
  }

  /// DO NOT USE! This is a part of `AbstractBytes` implementation.
  internal func _capitalizeBytes() -> SwiftType {
    let string = self._capitalize()
    return self._encode(string)
  }

  private func _encode(_ string: String) -> SwiftType {
    let encoding = Py.sys.defaultEncoding
    if let data = string.data(using: encoding.swift) {
      let result = Self._toObject(result: data)
      return result
    }

    let msg = "Violet error: Sometimes we convert 'bytes' to 'string' and back " +
      "(mostly when we really need string, for example to check for whitespaces). " +
      "Normally it works, but this time conversion back to bytes failed."
    trap(msg)
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
