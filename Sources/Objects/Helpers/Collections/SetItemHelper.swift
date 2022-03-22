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
  static func getElementToSetAtIntIndex(_ py: Py, object: PyObject) -> PyResultGen<Target.Element>

  /// When the index is `slice` we will call this function to get (multiple)
  /// values to set in collection.
  static func getElementsToSetAtSliceIndices(_ py: Py, object: PyObject) -> PyResultGen<SliceSource>
}

extension SetItemHelper {

  // MARK: - PyObject index

  internal static func setItem(_ py: Py,
                               target: inout Target,
                               index: PyObject,
                               value: PyObject) -> PyResult {
    switch IndexHelper.int(py, object: index, onOverflow: .indexError) {
    case .value(let int):
      return Self.setItem(py, target: &target, index: int, value: value)
    case .notIndex:
      break // Try other
    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case .error(let e):
      return .error(e)
    }

    if let slice = py.cast.asSlice(index) {
      return Self.setItem(py, target: &target, slice: slice, value: value)
    }

    let message = "indices must be integers or slices, not \(index.typeName)"
    return .typeError(py, message: message)
  }

  // MARK: - Int index

  internal static func setItem(_ py: Py,
                               target: inout Target,
                               index: Int,
                               value: PyObject) -> PyResult {
    var index = index

    if index < 0 {
      index += target.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= index && index < target.count else {
      let message = "assignment index out of range"
      return .indexError(py, message: message)
    }

    switch Self.getElementToSetAtIntIndex(py, object: value) {
    case let .value(v):
      target[index] = v
      return .none(py)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Slice

  internal static func setItem(_ py: Py,
                               target: inout Target,
                               slice: PySlice,
                               value: PyObject) -> PyResult {
    var indices: PySlice.AdjustedIndices
    switch slice.unpack(py) {
    case let .value(u): indices = u.adjust(toCount: target.count)
    case let .error(e): return .error(e)
    }

    if indices.step == 1 {
      return Self.setContinuousItems(py,
                                     target: &target,
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
    switch Self.getElementsToSetAtSliceIndices(py, object: value) {
    case let .value(s):
      source = s
    case let .error(e):
      return .error(e)
    }

    guard source.count == indices.count else {
      let message = "attempt to assign sequence of size \(source.count) " +
                "to extended slice of size \(indices.count)"
      return .valueError(py, message: message)
    }

    if indices.isEmpty {
      return .none(py)
    }

    var sourceIndex = 0
    for index in stride(from: indices.start, to: indices.stop, by: indices.step) {
      target[index] = source[sourceIndex]
      sourceIndex += 1
    }

    return .none(py)
  }

  // static int
  // list_ass_slice(PyListObject *a, Py_ssize_t ilow, Py_ssize_t ihigh, PyObject *v)
  private static func setContinuousItems(_ py: Py,
                                         target: inout Target,
                                         start: Int,
                                         stop: Int,
                                         value: PyObject) -> PyResult {
    let source: SliceSource
    switch Self.getElementsToSetAtSliceIndices(py, object: value) {
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
    return .none(py)
  }
}
