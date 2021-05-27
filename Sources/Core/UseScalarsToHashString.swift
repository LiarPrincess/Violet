/// Very specific case when 2 strings are equal according to Swift,
/// but they are different in Python.
///
/// For example:
/// - Swift:  "é" == "e\u{0301}" -> true
/// - Python: "é" == "e\u0301" -> False
///
/// ```py
/// assert len("é") == 1
/// assert len("e\u0301") == 2
/// ```
///
/// This may matter:
/// If we used Swift version as a dictionary key we would get invalid value.
public struct UseScalarsToHashString: Equatable, Hashable, CustomStringConvertible {

  private let value: String

  public var description: String {
    return self.value
  }

  public init(_ value: String) {
    self.value = value
  }

  // MARK: - Hashable

  public func hash(into hasher: inout Hasher) {
    return Self.hash(value: self.value, into: &hasher)
  }

  public static func hash(value: String, into hasher: inout Hasher) {
    for scalar in value.unicodeScalars {
      hasher.combine(scalar.value)
    }
  }

  // MARK: - Equatable

  public static func == (lhs: Self, rhs: Self) -> Bool {
    return Self.isEqual(lhs: lhs.value, rhs: rhs.value)
  }

  public static func isEqual(lhs: String, rhs: String) -> Bool {
    // Do not use 'xxx.value.unicodeScalars.count'!
    // It may be O(n) which would iterate string 2 times!
    var lhsIter = lhs.unicodeScalars.makeIterator()
    var rhsIter = rhs.unicodeScalars.makeIterator()

    var lhsValue = lhsIter.next()
    var rhsValue = rhsIter.next()

    while let l = lhsValue, let r = rhsValue {
      if l != r {
        return false
      }

      lhsValue = lhsIter.next()
      rhsValue = rhsIter.next()
    }

    let isLhsEnd = lhsValue == nil
    let isRhsEnd = rhsValue == nil
    return isLhsEnd && isRhsEnd
  }
}
