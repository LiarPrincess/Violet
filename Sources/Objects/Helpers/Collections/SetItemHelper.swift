/// Shared code for `__setitem__` method.
/// Mostly because... well slices are hard.
internal protocol SetItemHelper {

  associatedtype Collection where
    Collection: MutableCollection,
    Collection: RandomAccessCollection,
    Collection: RangeReplaceableCollection,
    Collection.Index == Int

  /// When the index is proper `Python` index we will call this function
  /// to get the value to set in collection.
  static func getElement(object: PyObject) -> PyResult<Collection.Element>

  /// When the index is `Python` slice we will call this function
  /// to get the values to set in collection.
  static func getElements(object: PyObject) -> PyResult<[Collection.Element]>
}

extension SetItemHelper {

  internal static func setItem(collection: inout Collection,
                               index: PyObject,
                               value: PyObject) -> PyResult<PyNone> {
    switch IndexHelper.intMaybe(index) {
    case .value(let int):
      return self.setItem(collection: &collection, index: int, value: value)
    case .notIndex:
      break // Try other
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      return self.setItem(collection: &collection, slice: slice, value: value)
    }

    let t = index.typeName
    let msg = "indices must be integers or slices, not \(t)"
    return .error(Py.newTypeError(msg: msg))
  }

  // MARK: - Int

  internal static func setItem(collection: inout Collection,
                               index: Int,
                               value: PyObject) -> PyResult<PyNone> {
    var index = index

    if index < 0 {
      index += collection.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= index && index < collection.count else {
      let msg = "assignment index out of range"
      return .error(Py.newIndexError(msg: msg))
    }

    switch Self.getElement(object: value) {
    case let .value(v):
      collection[index] = v
      return .value(Py.none)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Slice

  internal static func setItem(collection: inout Collection,
                               slice: PySlice,
                               value: PyObject) -> PyResult<PyNone> {
    var indices: PySlice.AdjustedIndices
    switch slice.unpack() {
    case let .value(u): indices = u.adjust(toCount: collection.count)
    case let .error(e): return .error(e)
    }

    if indices.step == 1 {
      return self.setContinuousItems(collection: &collection,
                                     start: indices.start,
                                     stop: indices.stop,
                                     value: value)
    }

    // Make sure s[5:2] = [..] inserts at the right place: before 5, not before 2.
    if (indices.step < 0 && indices.start < indices.stop) ||
       (indices.step > 0 && indices.start > indices.stop) {
      indices.stop = indices.start
    }

    let newElements: [Collection.Element]
    switch Self.getElements(object: value) {
    case let .value(e):
      newElements = e
    case let .error(e):
      return .error(e)
    }

    guard newElements.count == indices.count else {
      let msg = "attempt to assign sequence of size \(newElements.count) " +
                "to extended slice of size \(indices.count)"
      return .valueError(msg)
    }

    // swiftlint:disable:next empty_count
    if indices.count == 0 {
      return .value(Py.none)
    }

    var newElementsIndex = 0
    for index in stride(from: indices.start, to: indices.stop, by: indices.step) {
      collection[index] = newElements[newElementsIndex]
      newElementsIndex += 1
    }

    return .value(Py.none)
  }

  // static int
  // list_ass_slice(PyListObject *a, Py_ssize_t ilow, Py_ssize_t ihigh, PyObject *v)
  private static func setContinuousItems(collection: inout Collection,
                                         start: Int,
                                         stop: Int,
                                         value: PyObject) -> PyResult<PyNone> {
    let newElements: [Collection.Element]
    switch Self.getElements(object: value) {
    case let .value(e):
      newElements = e
    case let .error(e):
      return .error(e)
    }

    let low = min(max(start, 0), collection.count)
    let high = min(max(stop, low), collection.count)

    let newElementsCount = high - low
    assert(newElementsCount >= 0)

    collection.replaceSubrange(low..<high, with: newElements)
    return .value(Py.none)
  }
}
