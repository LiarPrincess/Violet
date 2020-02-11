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
/// assert len("e\u0301") == 2 <-- it would say 1, because it would use cached 'é'.
/// ```
internal struct UseScalarsToHashString: Equatable, Hashable {

  private let value: String

  internal init(_ value: String) {
    self.value = value
  }

  func hash(into hasher: inout Hasher) {
    for scalar in self.value.unicodeScalars {
      hasher.combine(scalar.value)
    }
  }

  internal static func == (lhs: Self, rhs: Self) -> Bool {
    // Do not use 'xxx.value.unicodeScalars.count'!
    // It may be O(n) which would iterate string 2 times!

    var lhsIter = lhs.value.unicodeScalars.makeIterator()
    var rhsIter = rhs.value.unicodeScalars.makeIterator()

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
