// swiftlint:disable yoda_condition

internal enum GetItemResult<Element> {
  case single(Element)
  case slice([Element])
  case error(PyBaseException)
}

/// Shared code for `__getitem__` method.
/// Mostly because... well slices are hard.
internal protocol GetItemHelper {

  associatedtype Collection where
    Collection: RandomAccessCollection,
    Collection.Index == Int
}

extension GetItemHelper {

  internal static func getItem(
    collection: Collection,
    index: PyObject
  ) -> GetItemResult<Collection.Element> {
    switch IndexHelper.intMaybe(index) {
    case .value(let index):
      switch Self.getItem(collection: collection, index: index) {
      case let .value(v): return .single(v)
      case let .error(e): return .error(e)
      }
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      switch Self.getItem(collection: collection, slice: slice) {
      case let .value(v): return .slice(v)
      case let .error(e): return .error(e)
      }
    }

    let msg = "indices must be integers or slices, not \(index.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  // MARK: - Int index

  internal static func getItem(collection: Collection,
                               index: Int) -> PyResult<Collection.Element> {
    var index = index
    if index < 0 {
      index += collection.count
    }

    guard 0 <= index && index < collection.count else {
      return .indexError("index out of range")
    }

    let result = collection[index]
    return .value(result)
  }

  // MARK: - Slice

  internal static func getItem(collection: Collection,
                               slice: PySlice) -> PyResult<[Collection.Element]> {
    let indices: PySlice.AdjustedIndices
    switch slice.unpack() {
    case let .value(u): indices = u.adjust(toCount: collection.count)
    case let .error(e): return .error(e)
    }

    // swiftlint:disable:next empty_count
    if indices.count <= 0 {
      return .value([])
    }

    if indices.step == 0 {
      return .valueError("slice step cannot be zero")
    }

    if indices.step == 1 {
      let result = collection.dropFirst(indices.start).prefix(indices.count)
      return .value(Array(result))
    }

    var result = [Collection.Element]()
    for i in 0..<indices.count {
      let index = indices.start + i * indices.step

      guard 0 <= index && index < collection.count else {
        return .value(result)
      }

      result.append(collection[index])
    }

    return .value(result)
  }
}
