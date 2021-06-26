import BigInt
import VioletCore

// MARK: - Find

internal enum StringFindResult<Index> {
  case index(index: Index, position: BigInt)
  case notFound
}

extension PyStringImpl {

  internal func find(_ element: PyObject,
                     start: PyObject? = nil,
                     end: PyObject? = nil) -> PyResult<BigInt> {
    let elementString: Self
    switch Self.extractSelf(from: element) {
    case .value(let e):
      elementString = e
    case .notSelf:
      return .typeError("find arg must be \(Self.typeName), not \(element.typeName)")
    case .error(let e):
      return .error(e)
    }

    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self.findRaw(in: substring.value, value: elementString)
    return self.getFindResult(substring: substring, result: result)
  }

  /// Helper method to use for all of the `find` needs.
  internal func findRaw<C: Collection>(
    in container: C,
    value: Self
  ) -> StringFindResult<C.Index> where C.Element == Self.Element {
    return self.findRaw(in: container, scalars: value.scalars)
  }

  /// Helper method to use for all of the `find` needs.
  internal func findRaw<C: Collection>(
    in container: C,
    scalars: Scalars
  ) -> StringFindResult<C.Index> where C.Element == Self.Element {

    if container.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    var position = BigInt(0)
    var index = container.startIndex

    while index != container.endIndex {
      let substring = container[index...]
      if substring.starts(with: scalars) {
        return .index(index: index, position: position)
      }

      position += 1
      container.formIndex(after: &index)
    }

    return .notFound
  }

  internal func rfind(_ element: PyObject,
                      start: PyObject? = nil,
                      end: PyObject? = nil) -> PyResult<BigInt> {
    let elementString: Self
    switch Self.extractSelf(from: element) {
    case .value(let e):
      elementString = e
    case .notSelf:
      return .typeError("rfind arg must be \(Self.typeName), not \(element.typeName)")
    case .error(let e):
      return .error(e)
    }

    let substring: IndexedSubSequence
    switch self.substring(start: start, end: end) {
    case let .value(s): substring = s
    case let .error(e): return .error(e)
    }

    let result = self.rfindRaw(in: substring.value, value: elementString)
    return self.getFindResult(substring: substring, result: result)
  }

  /// Helper method to use for all of the `rfind` needs.
  internal func rfindRaw<C: BidirectionalCollection>(
    in container: C,
    value: Self
  ) -> StringFindResult<C.Index> where C.Element == Self.Element {
    return self.rfindRaw(in: container, scalars: value.scalars)
  }

  /// Helper method to use for all of the `rfind` needs.
  internal func rfindRaw<C: BidirectionalCollection>(
    in container: C,
    scalars: Scalars
  ) -> StringFindResult<C.Index> where C.Element == Self.Element {

    if container.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    var position = container.count - 1
    var index = container.endIndex

    // `endIndex` is AFTER the collection
    container.formIndex(before: &index)

    while index != container.startIndex {
      let substring = container[index...]
      if substring.starts(with: scalars) {
        return .index(index: index, position: BigInt(position))
      }

      position -= 1
      container.formIndex(before: &index)
    }

    // Check if maybe we start with it (it was not checked inside the loop!)
    if container.starts(with: scalars) {
      return .index(index: index, position: 0)
    }

    return .notFound
  }

  private func getFindResult(substring: IndexedSubSequence,
                             result: StringFindResult<Index>) -> PyResult<BigInt> {
    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = substring.start?.adjustedInt ?? 0
      return .value(BigInt(start) + position)
    case .notFound:
      // Python convention of returning '-1'.
      return .value(-1)
    }
  }
}
