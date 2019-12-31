import Core

// MARK: - String builder

internal struct StringBuilder: StringBuilderType {

  internal typealias Element = UnicodeScalar
  internal typealias Result = String

  internal private(set) var result = ""

  internal init() { }

  internal mutating func append(_ value: UnicodeScalar) {
    self.result.unicodeScalars.append(value)
  }

  internal mutating func append<C: Sequence>(contentsOf other: C)
    where C.Element == UnicodeScalar {

    self.result.unicodeScalars.append(contentsOf: other)
  }
}

// MARK: - String data

/// Basically `PyString` that does not require `PyContext`.
///
/// We work on scalars (Unicode code points) instead of graphemes because:
/// - len("Cafe\u0301") = 5 (Swift: "Cafe\u{0301}".unicodeScalars.count)
/// - len("Café")       = 4 (Swift: "Café".unicodeScalars.count)
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

  internal static func toScalar(_ element: UnicodeScalar) -> UnicodeScalar {
    return element
  }

  internal static func extractSelf(from object: PyObject) -> PyStringData? {
    let string = object as? PyString
    return string?.data
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
}
