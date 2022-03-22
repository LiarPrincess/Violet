// swiftlint:disable yoda_condition

internal enum GetItemResult<Element, SliceBuilderResult> {
  case single(Element)
  case slice(SliceBuilderResult)
  case error(PyBaseException)
}

/// This type will be used when `GetItemImpl.getItem` gets called with slice.
internal protocol GetItemSliceBuilderType {

  /// Type from which we are getting elements.
  associatedtype Source: Collection
  /// Type of the final result (probably some collection of `Elements`).
  associatedtype Result

  /// If slice has step '1' then we will just assign `Source` subsequence.
  ///
  /// This may be faster than assigning each element separately.
  static func whenStepIs1(subsequence: Source.SubSequence) -> Result

  init(capacity: Int)

  mutating func append(element: Source.Element)
  func finalize() -> Result
}

/// Shared code for `__getitem__` methods.
/// Mostly because… well slices are hard.
internal protocol GetItemHelper {

  /// Type from which we are getting elements.
  associatedtype Source where
    Source: RandomAccessCollection,
    Source.Index == Int

  /// Type used to accumulate slice values.
  associatedtype SliceBuilder: GetItemSliceBuilderType where SliceBuilder.Source == Source
}

extension GetItemHelper {

  // MARK: - PyObject index

  internal static func getItem(
    _ py: Py,
    source: Source,
    index: PyObject
  ) -> GetItemResult<Source.Element, SliceBuilder.Result> {
    switch IndexHelper.int(py, object: index, onOverflow: .indexError) {
    case .value(let index):
      switch Self.getItem(py, source: source, index: index) {
      case let .value(v): return .single(v)
      case let .error(e): return .error(e)
      }

    case .notIndex:
      break // Try slice

    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)

    case .error(let e):
      return .error(e)
    }

    if let slice = py.cast.asSlice(index) {
      switch Self.getSlice(py, source: source, slice: slice) {
      case let .value(result):
        return .slice(result)
      case let .error(e):
        return .error(e)
      }
    }

    let message = "indices must be integers or slices, not \(index.typeName)"
    let error = py.newTypeError(message: message)
    return .error(error.asBaseException)
  }

  // MARK: - Int index

  internal static func getItem(_ py: Py,
                               source: Source,
                               index: Int) -> PyResultGen<Source.Element> {
    var index = index
    if index < 0 {
      index += source.count
    }

    guard 0 <= index && index < source.count else {
      return .indexError(py, message: "index out of range")
    }

    let result = source[index]
    return .value(result)
  }

  // MARK: - Slice

  internal static func getSlice(_ py: Py,
                                source: Source,
                                slice: PySlice) -> PyResultGen<SliceBuilder.Result> {
    let indices: PySlice.AdjustedIndices
    switch slice.unpack(py) {
    case let .value(u): indices = u.adjust(toCount: source.count)
    case let .error(e): return .error(e)
    }

    // swiftlint:disable:next empty_count
    if indices.count <= 0 {
      let builder = SliceBuilder(capacity: 0)
      let result = builder.finalize()
      return .value(result)
    }

    if indices.step == 0 {
      return .valueError(py, message: "slice step cannot be zero")
    }

    if indices.step == 1 {
      let subsequence = source.dropFirst(indices.start).prefix(indices.count)
      let result = SliceBuilder.whenStepIs1(subsequence: subsequence)
      return .value(result)
    }

    var builder = SliceBuilder(capacity: indices.count)
    for i in 0..<indices.count {
      let index = indices.start + i * indices.step

      guard 0 <= index && index < source.count else {
        break // Out of range? -> End
      }

      let element = source[index]
      builder.append(element: element)
    }

    let result = builder.finalize()
    return .value(result)
  }
}
