import Foundation
import VioletCore

extension StringImplementation {

  internal enum CompareResult: Equatable {
    case less
    case greater
    case equal

    internal var isEqual: Bool { self == .equal }
    internal var isLess: Bool { self == .less }
    internal var isLessEqual: Bool { self == .less || self == .equal }
    internal var isGreater: Bool { self == .greater }
    internal var isGreaterEqual: Bool { self == .greater || self == .equal }
  }

  internal static func compare(lhs: UnicodeScalars,
                               rhs: UnicodeScalars) -> CompareResult {
    // We need to compare on scalars
    // "Cafe\u0301" (e + acute accent) == "Café" (e with acute) -> False
    // "Cafe\u0301" (e + acute accent) <  "Café" (e with acute) -> True
    return Self._compare(lhs: lhs, rhs: rhs)
  }

  internal static func compare(lhs: Data, rhs: Data) -> CompareResult {
    return Self._compare(lhs: lhs, rhs: rhs)
  }

  private static func _compare<C: Collection>(
    lhs: C,
    rhs: C
  ) -> CompareResult where C.Element: Comparable {
    var lhsIter = lhs.makeIterator()
    var rhsIter = rhs.makeIterator()

    var lhsValue = lhsIter.next()
    var rhsValue = rhsIter.next()

    while let l = lhsValue, let r = rhsValue {
      if l < r {
        return .less
      }

      if l > r {
        return .greater
      }

      lhsValue = lhsIter.next()
      rhsValue = rhsIter.next()
    }

    // One (or both) of the values is nil (which means that we arrived to end)
    switch (lhsValue, rhsValue) {
    case (nil, nil): return .equal // Both at end
    case (nil, _): return .less // Finished self, other has some remaining
    case (_, nil): return .greater // Finished other, self has some remaining
    default:
      // Not possible? See `while` condition.
      trap("Error when comparing '\(lhs)' and '\(rhs)'")
    }
  }
}
