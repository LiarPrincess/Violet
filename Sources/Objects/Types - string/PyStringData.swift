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
/// Everything here is 'best-efford'
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

  internal static let defaultFill: UnicodeScalar = " "
  internal static let zFill: UnicodeScalar = "0"

  internal static func toScalar(_ element: UnicodeScalar) -> UnicodeScalar {
    return element
  }

  internal static func toElement(_ scalar: UnicodeScalar) -> UnicodeScalar {
    return scalar
  }

  internal static func extractSelf(from object: PyObject) -> PyResult<PyStringData> {
    if let str = object as? PyString {
      return .value(str.data)
    }

    return .typeError("a str object is required, not '\(object.typeName)'")
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
    var result = ""
    var isPreviousCased = false

    for scalar in self.scalars {
      let properties = scalar.properties

      switch properties.generalCategory {
      case .lowercaseLetter:
        if isPreviousCased {
          result.append(properties.titlecaseMapping)
        } else {
          result.append(scalar)
        }
        isPreviousCased = true

      case .uppercaseLetter, .titlecaseLetter:
        if isPreviousCased {
          result.append(properties.lowercaseMapping)
        } else {
          result.append(scalar)
        }
        isPreviousCased = true

      default:
        isPreviousCased = false
        result.append(scalar)
      }
    }

    return result
  }

  internal func swapCase() -> String {
    var result = ""
    for scalar in self.scalars {
      let properties = scalar.properties
      if properties.isLowercase {
        result.append(properties.uppercaseMapping)
      } else if properties.isUppercase {
        result.append(properties.lowercaseMapping)
      } else {
        result.append(scalar)
      }
    }
    return result
  }

  internal func caseFold() -> String {
    var result = ""
    for scalar in self.scalars {
      if let mapping = Unicode.caseFoldMapping[scalar.value] {
        result.append(mapping)
      } else {
        result.append(scalar)
      }
    }
    return result
  }

  internal func capitalize() -> String {
    // Capitalize only first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    guard let first = self.scalars.first else {
      return self.value
    }

    let head = first.properties.titlecaseMapping
    let tail = String(self.scalars.dropFirst()).lowercased()
    return head + tail
  }

  // MARK: - Add

  internal func add(_ other: PyStringData) -> String {
    if self.isEmpty {
      return other.value
    }

    if other.isEmpty {
      return self.value
    }

    return String(self.scalars + other.scalars)
  }

  // MARK: - Mul

  internal func mul(_ n: Int) -> String {
    if self.isEmpty || n == 1 {
      return self.value
    }

    var result = String.UnicodeScalarView()
    for _ in 0..<max(n, 0) {
      result.append(contentsOf: self.scalars)
    }

    return String(result)
  }
}
