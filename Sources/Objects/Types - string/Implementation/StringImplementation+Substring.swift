import Foundation

extension StringImplementation {

  // MARK: - IndexedSubSequence

  /// Substring that remembers it's `start` and `end` index.
  internal struct IndexedSubSequence<C: Collection> {

    // swiftlint:disable:next nesting
    internal struct Index {
      internal let value: C.Index
      /// `Int` value exactly as provided by the user.
      /// For example: `0, 1, -5` etc.
      internal let int: Int
      /// `Int` value adjusted to the collection length.
      /// For example: `-5` was replaced by valid index (like `42`).
      internal let adjustedInt: Int
    }

    internal let value: C.SubSequence
    /// Substring start. `nil` it it was not given.
    internal let start: Index?
    /// Substring end. `nil` it it was not given.
    internal let end: Index?
  }

  // MARK: - Substring

  internal static func substring(
    scalars: UnicodeScalars,
    start: PyObject,
    end: PyObject
  ) -> PyResult<IndexedSubSequence<UnicodeScalars>> {
    return Self.substring(collection: scalars, start: start, end: end)
  }

  internal static func substring(
    data: Data,
    start: PyObject,
    end: PyObject
  ) -> PyResult<IndexedSubSequence<Data>> {
    return Self.substring(collection: data, start: start, end: end)
  }

  internal static func substring<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    collection: C,
    start: PyObject?,
    end: PyObject?
  ) -> PyResult<IndexedSubSequence<C>> {
    let startIndex: IndexedSubSequence<C>.Index?
    switch Self.extractIndex(collection: collection, from: start) {
    case .value(nil): startIndex = nil
    case .value(let i): startIndex = i
    case .error(let e): return .error(e)
    }

    let endIndex: IndexedSubSequence<C>.Index?
    switch Self.extractIndex(collection: collection, from: end) {
    case .value(nil): endIndex = nil
    case .value(let i): endIndex = i
    case .error(let e): return .error(e)
    }

    let startInt = startIndex?.adjustedInt ?? Int.min
    let endInt = endIndex?.adjustedInt ?? Int.max

    // Something like 'elsa'[1000:5] -> empty
    if startInt >= endInt {
      let start = collection.startIndex
      let empty = collection[start..<start]
      let result = IndexedSubSequence(value: empty,
                                      start: startIndex,
                                      end: endIndex)
      return .value(result)
    }

    let value = Self.substring(
      collection: collection,
      start: startIndex?.value ?? collection.startIndex,
      end: endIndex?.value ?? collection.endIndex
    )

    let result = IndexedSubSequence(value: value,
                                    start: startIndex,
                                    end: endIndex)

    return .value(result)
  }

  internal static func substring<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    collection: C,
    start: C.Index? = nil,
    end: C.Index? = nil
  ) -> C.SubSequence {
    let s = start ?? collection.startIndex
    let e = end ?? collection.endIndex
    // This is `O(1)` even without `RandomAccessCollection`,
    // but we will require it anyway.
    return collection[s..<e]
  }

  // MARK: - Extract index

  private static func extractIndex<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    collection: C,
    from indexObject: PyObject?
  ) -> PyResult<IndexedSubSequence<C>.Index?> {
    guard let indexObject = indexObject else {
      return .value(nil)
    }

    if indexObject.isNone {
      return .value(nil)
    }

    switch IndexHelper.int(indexObject, onOverflow: .indexError) {
    case let .value(int):
      var adjustedInt = int
      if adjustedInt < 0 {
        adjustedInt += collection.count

        // >>> 'elsa'[-1234:2]
        // 'el'
        if adjustedInt < 0 {
          adjustedInt = 0
        }
      }

      // This requires 'RandomAccessCollection' to be 'O(1)'
      let index = collection.index(collection.startIndex,
                                   offsetBy: adjustedInt,
                                   limitedBy: collection.endIndex)

      let result = IndexedSubSequence<C>.Index(
        value: index ?? collection.endIndex,
        int: int,
        adjustedInt: adjustedInt
      )

      return .value(result)

    case let .error(e),
         let .notIndex(e),
         let .overflow(_, e):
      return .error(e)
    }
  }
}
