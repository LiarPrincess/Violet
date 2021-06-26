import BigInt
import VioletCore

// MARK: - Compare

internal enum StringCompareResult {
  case less
  case greater
  case equal
}

extension PyStringImpl {

  internal func compare<S: PyStringImpl>(to other: S) -> StringCompareResult
    where S.Element == Self.Element {

    // "Cafe\u0301" == "Café" (Caf\u00E9) -> False
    // "Cafe\u0301" <  "Café" (Caf\u00E9) -> True
    var selfIter = self.scalars.makeIterator()
    var otherIter = other.scalars.makeIterator()

    var selfValue = selfIter.next()
    var otherValue = otherIter.next()

    while let s = selfValue, let o = otherValue {
      if s < o {
        return .less
      }

      if s > o {
        return .greater
      }

      selfValue = selfIter.next()
      otherValue = otherIter.next()
    }

    // One (or both) of the values is nil (which means that we arrived to end)
    switch (selfValue, otherValue) {
    case (nil, nil): return .equal // Both at end
    case (nil, _): return .less // Finished self, other has some remaining
    case (_, nil): return .greater // Finished other, self has some remaining
    default:
      // Not possible? See `while` condition.
      trap("Error when comparing '\(self)' and '\(other)'")
    }
  }
}
