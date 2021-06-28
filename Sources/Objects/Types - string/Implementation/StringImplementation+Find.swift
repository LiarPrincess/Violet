import Foundation
import BigInt

extension StringImplementation {

  // MARK: - FindResult

  internal enum FindResult<Index> {
    case index(index: Index, position: BigInt)
    case notFound
  }

  // MARK: - Find

  internal static func find(scalars: UnicodeScalars,
                            element: PyObject,
                            start: PyObject? = nil,
                            end: PyObject? = nil) -> PyResult<BigInt> {
    return Self.template(typeName: Self.scalarsTypeName,
                         collection: scalars,
                         element: element,
                         start: start,
                         end: end,
                         getCollection: Self.getScalars(object:),
                         findInSubSequence: Self.findRaw(collection:element:))
  }

  internal static func find(data: Data,
                            element: PyObject,
                            start: PyObject? = nil,
                            end: PyObject? = nil) -> PyResult<BigInt> {
    return Self.template(typeName: Self.dataTypeName,
                         collection: data,
                         element: element,
                         start: start,
                         end: end,
                         getCollection: Self.getData(object:),
                         findInSubSequence: Self.findRaw(collection:element:))
  }

  /// Helper method to use for all of the `find` needs.
  internal static func findRaw<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess,
    E: Collection
  >(
    collection: C,
    element: E
  ) -> FindResult<C.Index> where C.Element == E.Element, C.Element: Equatable {
    if collection.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    // Eh… whatever…
    var position = BigInt(0)
    var index = collection.startIndex

    while index != collection.endIndex {
      // Subscript is 'O(1)', but the usage is 'O(n)'
      let substring = collection[index...]
      if substring.starts(with: element) {
        return .index(index: index, position: position)
      }

      position += 1
      collection.formIndex(after: &index)
    }

    return .notFound
  }

  // MARK: - RFind

  internal static func rfind(scalars: UnicodeScalars,
                             element: PyObject,
                             start: PyObject? = nil,
                             end: PyObject? = nil) -> PyResult<BigInt> {
    return Self.template(typeName: Self.scalarsTypeName,
                         collection: scalars,
                         element: element,
                         start: start,
                         end: end,
                         getCollection: Self.getScalars(object:),
                         findInSubSequence: Self.rfindRaw(collection:element:))
  }

  internal static func rfind(data: Data,
                             element: PyObject,
                             start: PyObject? = nil,
                             end: PyObject? = nil) -> PyResult<BigInt> {
    return Self.template(typeName: Self.dataTypeName,
                         collection: data,
                         element: element,
                         start: start,
                         end: end,
                         getCollection: Self.getData(object:),
                         findInSubSequence: Self.rfindRaw(collection:element:))
  }

  /// Helper method to use for all of the `rfind` needs.
  internal static func rfindRaw<C: BidirectionalCollection, E: Collection>(
    collection: C,
    element: E
  ) -> FindResult<C.Index> where
    C.Element == E.Element,
    C.Element: Equatable,
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess {

    if collection.isEmpty {
      return .notFound
    }

    // There are many good substring algorithms, and we went with this?
    // Eh… whatever…
    var position = collection.count - 1
    var index = collection.endIndex

    // `endIndex` is AFTER the collection
    collection.formIndex(before: &index)

    while index != collection.startIndex {
      // Subscript is 'O(1)', but the usage is 'O(n)'
      let substring = collection[index...]
      if substring.starts(with: element) {
        return .index(index: index, position: BigInt(position))
      }

      position -= 1
      collection.formIndex(before: &index)
    }

    // Check if maybe we start with it (it was not checked inside the loop!)
    if collection.starts(with: element) {
      return .index(index: index, position: 0)
    }

    return .notFound
  }

  // MARK: - Template

  // swiftlint:disable:next function_parameter_count
  private static func template<C: BidirectionalCollection>(
    typeName: String,
    collection: C,
    element elementObject: PyObject,
    start: PyObject?,
    end: PyObject?,
    getCollection: ObjectToCollectionFn<C>,
    findInSubSequence: (C.SubSequence, C) -> FindResult<C.Index>
  ) -> PyResult<BigInt> where
    C.Element: Equatable,
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess {

    let elementCollection: C
    switch getCollection(elementObject) {
    case .value(let c):
      elementCollection = c
    case .notCollection:
      let t = elementObject.typeName
      return .typeError("find arg must be \(typeName), not \(t)")
    case .error(let e):
      return .error(e)
    }

    let subSequence: IndexedSubSequence<C>
    switch self.substring(collection: collection, start: start, end: end) {
    case let .value(s): subSequence = s
    case let .error(e): return .error(e)
    }

    let result = findInSubSequence(subSequence.value, elementCollection)
    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = subSequence.start?.adjustedInt ?? 0
      return .value(BigInt(start) + position)
    case .notFound:
      // Python convention of returning '-1'.
      return .value(-1)
    }
  }
}
