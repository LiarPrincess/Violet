// swiftlint:disable yoda_condition

internal enum GetItemResult<Element, SliceBuilderResult> {
  case single(Element)
  case slice(SliceBuilderResult)
  case error(PyBaseException)
}

/// This type will be used when `GetItemImpl.getItem` gets called with slice.
internal protocol GetItemSliceBuilderType {

  /// Type of the element that we will be appending.
  associatedtype Element
  /// If slice has step '1' then we will just assign `Source` subsequence.
  associatedtype SourceSubsequence: Collection where
    SourceSubsequence.Element == Element
  /// Type of the final result (probably some collection of `Elements`).
  associatedtype Result

  init(capacity: Int)
  init(sourceSubsequenceWhenStepIs1: SourceSubsequence)

  mutating func append(element: Element)
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
  associatedtype SliceBuilder: GetItemSliceBuilderType where
    SliceBuilder.SourceSubsequence == Source.SubSequence
}

extension GetItemHelper {

  internal static func getItem(
    source: Source,
    index: PyObject
  ) -> GetItemResult<Source.Element, SliceBuilder.Result> {
    switch IndexHelper.int(index, onOverflow: .indexError) {
    case .value(let index):
      switch Self.getItem(source: source, index: index) {
      case let .value(v): return .single(v)
      case let .error(e): return .error(e)
      }

    case .notIndex:
      break // Try slice

    case .error(let e),
         .overflow(_, let e):
      return .error(e)
    }

    if let slice = PyCast.asSlice(index) {
      switch Self.getSlice(source: source, slice: slice) {
      case let .value(result):
        return .slice(result)
      case let .error(e):
        return .error(e)
      }
    }

    let msg = "indices must be integers or slices, not \(index.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  // MARK: - Int index

  internal static func getItem(source: Source,
                               index: Int) -> PyResult<Source.Element> {
    var index = index
    if index < 0 {
      index += source.count
    }

    guard 0 <= index && index < source.count else {
      return .indexError("index out of range")
    }

    let result = source[index]
    return .value(result)
  }

  // MARK: - Slice

  internal static func getSlice(source: Source,
                                slice: PySlice) -> PyResult<SliceBuilder.Result> {
    let indices: PySlice.AdjustedIndices
    switch slice.unpack() {
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
      return .valueError("slice step cannot be zero")
    }

    if indices.step == 1 {
      let subsequence = source.dropFirst(indices.start).prefix(indices.count)
      let builder = SliceBuilder(sourceSubsequenceWhenStepIs1: subsequence)
      let result = builder.finalize()
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
