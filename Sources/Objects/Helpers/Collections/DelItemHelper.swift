// swiftlint:disable yoda_condition

/// Shared code for `__setitem__` method.
/// Mostly because… well slices are hard.
internal protocol DelItemHelper {

  associatedtype Target where
    Target: MutableCollection,
    Target: RangeReplaceableCollection,
    Target.Index == Int
}

extension DelItemHelper {

  internal static func delItem(target: inout Target,
                               index: PyObject) -> PyResult<PyNone> {
    switch IndexHelper.int(index, onOverflow: .indexError) {
    case .value(let int):
      return Self.delItem(target: &target, index: int)
    case .notIndex:
      break // Try slice
    case .error(let e),
         .overflow(_, let e):
      return .error(e)
    }

    if let slice = PyCast.asSlice(index) {
      return Self.delSlice(target: &target, slice: slice)
    }

    let msg = "indices must be integers or slices, not \(index.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  // MARK: - Int index

  internal static func delItem(target: inout Target,
                               index: Int) -> PyResult<PyNone> {
    var index = index

    if index < 0 {
      index += target.count
    }

    guard 0 <= index && index < target.count else {
      let msg = "assignment index out of range"
      return .error(Py.newIndexError(msg: msg))
    }

    _ = target.remove(at: index)
    return .value(Py.none)
  }

  // MARK: - Slice

  internal static func delSlice(target: inout Target,
                                slice: PySlice) -> PyResult<PyNone> {
    var indices: PySlice.AdjustedIndices
    switch slice.unpack() {
    case let .value(u): indices = u.adjust(toCount: target.count)
    case let .error(e): return .error(e)
    }

    if indices.step == 1 {
      let range = indices.start..<indices.stop
      target.replaceSubrange(range, with: [])
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
    var result = [Target.Element]()
    result.reserveCapacity(target.count - indices.count)

    for index in stride(from: indices.start, to: indices.stop, by: indices.step) {
      let elements = target[groupStart..<index]
      result.append(contentsOf: elements)
      groupStart = index + 1 // +1 to skip 'index'
    }

    // Include final group
    if groupStart < target.count {
      let elements = target[groupStart..<target.count]
      result.append(contentsOf: elements)
    }

    target.replaceSubrange(target.startIndex..., with: result)
    return .value(Py.none)
  }
}
