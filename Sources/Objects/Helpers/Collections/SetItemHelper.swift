// cSpell:ignore ilow ihigh

/// Shared code for `__setitem__` method.
/// Mostly because… well slices are hard.
internal protocol SetItemHelper {

  /// Type of the collection where we are setting value.
  associatedtype Target where
    Target: MutableCollection,
    Target: RandomAccessCollection,
    Target: RangeReplaceableCollection,
    Target.Index == Int

  associatedtype SliceSource where
    SliceSource: RandomAccessCollection,
    SliceSource.Element == Target.Element,
    SliceSource.Index == Int

  /// When the index is `int` we will call this function to get the value to set.
  static func getElementToSetAtIntIndex(object: PyObject) -> PyResult<Target.Element>

  /// When the index is `slice` we will call this function to get (multiple)
  /// values to set in collection.
  static func getElementsToSetAtSliceIndices(object: PyObject) -> PyResult<SliceSource>
}

extension SetItemHelper {

  internal static func setItem(target: inout Target,
                               index: PyObject,
                               value: PyObject) -> PyResult<PyNone> {
    switch IndexHelper.int(index, onOverflow: .indexError) {
    case .value(let int):
      return Self.setItem(target: &target, index: int, value: value)
    case .notIndex:
      break // Try other
    case .error(let e),
         .overflow(_, let e):
      return .error(e)
    }

    if let slice = PyCast.asSlice(index) {
      return Self.setItem(target: &target, slice: slice, value: value)
    }

    let t = index.typeName
    let msg = "indices must be integers or slices, not \(t)"
    return .error(Py.newTypeError(msg: msg))
  }

  // MARK: - Int index

  internal static func setItem(target: inout Target,
                               index: Int,
                               value: PyObject) -> PyResult<PyNone> {
    var index = index

    if index < 0 {
      index += target.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= index && index < target.count else {
      let msg = "assignment index out of range"
      return .error(Py.newIndexError(msg: msg))
    }

    switch Self.getElementToSetAtIntIndex(object: value) {
    case let .value(v):
      target[index] = v
      return .value(Py.none)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Slice

  internal static func setItem(target: inout Target,
                               slice: PySlice,
                               value: PyObject) -> PyResult<PyNone> {
    var indices: PySlice.AdjustedIndices
    switch slice.unpack() {
    case let .value(u): indices = u.adjust(toCount: target.count)
    case let .error(e): return .error(e)
    }

    if indices.step == 1 {
      return Self.setContinuousItems(target: &target,
                                     start: indices.start,
                                     stop: indices.stop,
                                     value: value)
    }

    // Make sure s[5:2] = [..] inserts at the right place: before 5, not before 2.
    if (indices.step < 0 && indices.start < indices.stop) ||
       (indices.step > 0 && indices.start > indices.stop) {
      indices.stop = indices.start
    }

    let source: SliceSource
    switch Self.getElementsToSetAtSliceIndices(object: value) {
    case let .value(s):
      source = s
    case let .error(e):
      return .error(e)
    }

    guard source.count == indices.count else {
      let msg = "attempt to assign sequence of size \(source.count) " +
                "to extended slice of size \(indices.count)"
      return .valueError(msg)
    }

    // swiftlint:disable:next empty_count
    if indices.count == 0 {
      return .value(Py.none)
    }

    var sourceIndex = 0
    for index in stride(from: indices.start, to: indices.stop, by: indices.step) {
      target[index] = source[sourceIndex]
      sourceIndex += 1
    }

    return .value(Py.none)
  }

  // static int
  // list_ass_slice(PyListObject *a, Py_ssize_t ilow, Py_ssize_t ihigh, PyObject *v)
  private static func setContinuousItems(target: inout Target,
                                         start: Int,
                                         stop: Int,
                                         value: PyObject) -> PyResult<PyNone> {
    let source: SliceSource
    switch Self.getElementsToSetAtSliceIndices(object: value) {
    case let .value(e):
      source = e
    case let .error(e):
      return .error(e)
    }

    let low = min(max(start, 0), target.count)
    let high = min(max(stop, low), target.count)

    let newElementsCount = high - low
    assert(newElementsCount >= 0)

    target.replaceSubrange(low..<high, with: source)
    return .value(Py.none)
  }
}
