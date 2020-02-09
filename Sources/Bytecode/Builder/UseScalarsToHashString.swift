/// Very specific case when 2 strings are equal according to Swift,
/// but they are different in Python.
///
/// For example:
/// - Swift:  "é" == "e\u{0301}" -> true
/// - Python: "é" == "e\u0301" -> False
///
/// If we used Swift version of equal and a dictionary based cache then we would
/// emit the same value for both of them.
///
/// This would fail following test:
/// ```py
/// assert len("é") == 1
/// assert len("é") == 2 <-- it would say 1, because it would use cached 'é'.
/// ```
internal struct UseScalarsToHashString: Equatable, Hashable {

  private let value: String

  internal init(_ value: String) {
    self.value = value
  }

  func hash(into hasher: inout Hasher) {
    for scalar in value.unicodeScalars {
      hasher.combine(scalar)
    }
  }

  internal static func == (lhs: Self, rhs: Self) -> Bool {
    // Do not use 'count'!
    // It may be O(n) and which would iterate string 2 times!

    var lhsIter = lhs.value.unicodeScalars.makeIterator()
    var rhsIter = rhs.value.unicodeScalars.makeIterator()

    while let l = lhsIter.next(), let r = rhsIter.next() {
      if l != r {
        return false
      }
    }

    let isLhsEnd = lhsIter.next() == nil
    let isRhsEnd = rhsIter.next() == nil
    return isLhsEnd && isRhsEnd
  }
}
