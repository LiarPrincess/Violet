import VioletCore

// MARK: - String builder

internal struct StringBuilder: StringBuilderType {

  internal typealias Element = UnicodeScalar
  internal typealias Result = String

  internal private(set) var result = ""

  internal init() {}

  internal mutating func append(_ value: UnicodeScalar) {
    self.result.unicodeScalars.append(value)
  }

  internal mutating func append<C: Sequence>(contentsOf other: C)
    where C.Element == UnicodeScalar {

    // This may be O(self.count + other.count), but I'm not sure.
    // For now it will stay as it is.
    self.result.unicodeScalars.append(contentsOf: other)
  }
}

// MARK: - String data

/// We work on scalars (Unicode code points) instead of graphemes because:
/// - len("Cafe\u0301") = 5 (Swift: "Cafe\u{0301}".unicodeScalars.count)
/// - len("Café")       = 4 (Swift: "Café".unicodeScalars.count)
/// See: https://www.python.org/dev/peps/pep-0393/
///
/// Anyway, if you are looking for something it is probably in `PyStringImpl`
/// and not here.
internal struct PyStringData: PyStringImpl, CustomStringConvertible {

  internal let value: String

  internal var description: String {
    return self.value
  }

  internal init(_ value: String) {
    self.value = value
  }

  // MARK: PyStringImpl

  internal typealias Scalars = String.UnicodeScalarView
  internal typealias Builder = StringBuilder

  internal var scalars: Scalars {
    return self.value.unicodeScalars
  }

  internal static let typeName = "str"
  internal static let defaultFill: UnicodeScalar = " "
  internal static let zFill: UnicodeScalar = "0"

  internal static func toUnicodeScalar(_ element: UnicodeScalar) -> UnicodeScalar {
    return element
  }

  internal static func extractSelf(from object: PyObject) -> PyStringData? {
    let string = object as? PyString
    return string?.data
  }

  // MARK: - Repr

  internal func createRepr() -> String {
    let quote = self.getReprQuoteChar()

    var result = String(quote)
    result.reserveCapacity(self.count)

    for element in self.scalars {
      switch element {
      case quote, "\\":
        result.append("\\")
        result.append(element)
      case "\n":
        result.append("\\n")
      case "\t":
        result.append("\\t")
      case "\r":
        result.append("\\r")
      default:
        if self.isPritable(scalar: element) {
          result.append(element)
        } else {
          let repr = self.createNonPrintableRepr(scalar: element)
          result.append(repr)
        }
      }
    }
    result.append(quote)

    return result
  }

  private func getReprQuoteChar() -> UnicodeScalar {
    var singleCount = 0
    var doubleCount = 0

    for element in self.scalars {
      switch element {
      case "'": singleCount += 1
      case "\"": doubleCount += 1
      default: break
      }
    }

    // Use single quote if equal
    return singleCount <= doubleCount ? "'" : "\""
  }

  private func createNonPrintableRepr(scalar: UnicodeScalar) -> String {
    var result = "\\"
    let value = scalar.value

    if value < 0xff {
      // Map 8-bit characters to '\xhh'
      result.append("x")
      result.append(self.hex((value >> 4) & 0xf))
      result.append(self.hex((value >> 0) & 0xf))
    } else if value < 0xffff {
      // Map 16-bit characters to '\uxxxx'
      result.append("u")
      result.append(self.hex((value >> 12) & 0xf))
      result.append(self.hex((value >> 8) & 0xf))
      result.append(self.hex((value >> 4) & 0xf))
      result.append(self.hex((value >> 0) & 0xf))
    } else {
      // Map 21-bit characters to '\U00xxxxxx'
      result.append("U")
      result.append(self.hex((value >> 28) & 0xf))
      result.append(self.hex((value >> 24) & 0xf))
      result.append(self.hex((value >> 20) & 0xf))
      result.append(self.hex((value >> 16) & 0xf))
      result.append(self.hex((value >> 12) & 0xf))
      result.append(self.hex((value >> 8) & 0xf))
      result.append(self.hex((value >> 4) & 0xf))
      result.append(self.hex((value >> 0) & 0xf))
    }

    return result
  }

  private func hex(_ value: UInt32) -> String {
    return String(value, radix: 16, uppercase: false)
  }

  // MARK: - Properties

  /// https://docs.python.org/3/library/stdtypes.html#str.isidentifier
  internal var isIdentifier: Bool {
    switch self.scalars.isValidIdentifier {
    case .yes:
      return true
    case .no, .emptyString:
      return false
    }
  }

  // MARK: - Case

  internal func lowerCased() -> String {
    return self.value.lowercased()
  }

  internal func upperCased() -> String {
    return self.value.uppercased()
  }

  internal func titleCased() -> String {
    return self.titleCasedString()
  }

  internal func swapCase() -> String {
    return self.swapCaseString()
  }

  internal func caseFold() -> String {
    return self.caseFoldString()
  }

  internal func capitalize() -> String {
    return self.capitalizeString()
  }

  // MARK: - Helpers

  /// Helper for commonly used path.
  internal func contains(_ value: String) -> Bool {
    let data = PyStringData(value)
    return self.contains(data)
  }
}
