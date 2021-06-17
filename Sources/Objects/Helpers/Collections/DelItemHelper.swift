// swiftlint:disable yoda_condition

/// Shared code for `__setitem__` method.
/// Mostly because… well slices are hard.
internal protocol DelItemHelper {

  associatedtype Collection where
    Collection: MutableCollection,
    Collection: RangeReplaceableCollection,
    Collection.Index == Int
}

extension DelItemHelper {

  internal static func delItem(collection: inout Collection,
                               index: PyObject) -> PyResult<PyNone> {
    switch IndexHelper.int(index, onOverflow: .indexError) {
    case .value(let int):
      return Self.delItem(collection: &collection, index: int)
    case .notIndex:
      break // Try slice
    case .error(let e),
         .overflow(_, let e):
      return .error(e)
    }

    if let slice = PyCast.asSlice(index) {
      return Self.delItem(collection: &collection, slice: slice)
    }

    let msg = "indices must be integers or slices, not \(index.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  // MARK: - Int index

  internal static func delItem(collection: inout Collection,
                               index: Int) -> PyResult<PyNone> {
    var index = index

    if index < 0 {
      index += collection.count
    }

    guard 0 <= index && index < collection.count else {
      let msg = "assignment index out of range"
      return .error(Py.newIndexError(msg: msg))
    }

    _ = collection.remove(at: index)
    return .value(Py.none)
  }

  // MARK: - Slice

  internal static func delItem(collection: inout Collection,
                               slice: PySlice) -> PyResult<PyNone> {
    var indices: PySlice.AdjustedIndices
    switch slice.unpack() {
    case let .value(u): indices = u.adjust(toCount: collection.count)
    case let .error(e): return .error(e)
    }

    if indices.step == 1 {
      let range = indices.start..<indices.stop
      collection.replaceSubrange(range, with: [])
      return .value(Py.none)
    }

    // Make sure s[5:2] = [..] inserts at the right place: before 5, not before 2.
    if (indices.step < 0 && indices.start < indices.stop) ||
       (indices.step > 0 && indices.start > indices.stop) {
      indices.stop = indices.start
    }

    // swiftlint:disable:next empty_count
    if indices.count <= 0 {
      return .value(Py.none)
    }

    // Fix the slice, so we can start from lower indices
    if indices.step < 0 {
      indices.stop = indices.start + 1
      indices.start = indices.stop + indices.step * (indices.count - 1) - 1
      indices.step = -indices.step
    }

    var groupStart = 0
    var result = [Collection.Element]()
    result.reserveCapacity(collection.count - indices.count)

    for index in stride(from: indices.start, to: indices.stop, by: indices.step) {
      let elements = collection[groupStart..<index]
      result.append(contentsOf: elements)
      groupStart = index + 1 // +1 to skip 'index'
    }

    // Include final group
    if groupStart < collection.count {
      let elements = collection[groupStart..<collection.count]
      result.append(contentsOf: elements)
    }

    collection.replaceSubrange(collection.startIndex..., with: result)
    return .value(Py.none)
  }
}
