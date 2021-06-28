import Foundation

extension StringImplementation {

  internal enum GetItemResult<Item, Slice> {
    case item(Item)
    case slice(Slice)
    case error(PyBaseException)
  }

  internal static func getItem(
    scalars: UnicodeScalars,
    index: PyObject
  ) -> GetItemResult<UnicodeScalar, String> {
    return Self.template(typeName: Self.scalarsTypeName,
                         collection: scalars,
                         index: index,
                         using: StringBuilder.self)
  }

  internal static func getItem(
    data: Data,
    index: PyObject
  ) -> GetItemResult<UInt8, Data> {
    return Self.template(typeName: Self.dataTypeName,
                         collection: data,
                         index: index,
                         using: BytesBuilder.self)
  }

  // MARK: - Template

  private static func template<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess,
    B: StringBuilderType
  >(
    typeName: String,
    collection: C,
    index: PyObject,
    using: B.Type
  ) -> GetItemResult<C.Element, B.Result> where C.Element == B.Element {
    switch IndexHelper.int(index, onOverflow: .indexError) {
    case .value(let index):
      switch Self.getItem(typeName: typeName, collection: collection, index: index) {
      case let .value(i): return .item(i)
      case let .error(e): return .error(e)
      }
    case .notIndex:
      break // Try slice
    case .error(let e),
         .overflow(_, let e):
      return .error(e)
    }

    if let slice = PyCast.asSlice(index) {
      switch Self.getSlice(collection: collection, slice: slice, using: B.self) {
      case let .value(r): return .slice(r)
      case let .error(e): return .error(e)
      }
    }

    let t = index.typeName
    let msg = "\(typeName) indices must be integers or slices, not \(t)"
    return .error(Py.newTypeError(msg: msg))
  }

  // MARK: - Item

  private static func getItem<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    typeName: String,
    collection: C,
    index: Int
  ) -> PyResult<C.Element> {
    var offset = index
    if offset < 0 {
      offset += collection.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= offset && offset < collection.count else {
      return .indexError("\(typeName) index out of range")
    }

    let indexOrNil = collection.index(collection.startIndex,
                                      offsetBy: offset,
                                      limitedBy: collection.endIndex)

    guard let index = indexOrNil else {
      return .indexError("\(typeName) index out of range")
    }

    let result = collection[index]
    return .value(result)
  }

  // MARK: - Slice

  private static func getSlice<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess,
    B: StringBuilderType
  >(
    collection: C,
    slice: PySlice,
    using: B.Type
  ) -> PyResult<B.Result> where C.Element == B.Element {
    switch slice.unpack() {
    case let .value(u):
      let indices = u.adjust(toCount: collection.count)
      return Self.getSlice(collection: collection,
                           start: indices.start,
                           step: indices.step,
                           count: indices.count,
                           using: B.self)

    case let .error(e):
      return .error(e)
    }
  }

  internal static func getSlice<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess,
    B: StringBuilderType
  >(
    collection: C,
    start: Int,
    step: Int,
    count: Int,
    using: B.Type
  ) -> PyResult<B.Result> where C.Element == B.Element {
    var builder = B()

    // swiftlint:disable:next empty_count
    if count <= 0 {
      return .value(builder.result)
    }

    if step == 0 {
      return .valueError("slice step cannot be zero")
    }

    if step == 1 {
      let result = collection.dropFirst(start).prefix(count)
      builder.append(contentsOf: result)
      return .value(builder.result)
    }

    guard var index = collection.index(collection.startIndex,
                                       offsetBy: start,
                                       limitedBy: collection.endIndex) else {
      return .value(builder.result)
    }

    let stepLimit = step > 0 ? collection.endIndex : collection.startIndex
    for _ in 0..<count {
      builder.append(collection[index])

      guard let newIndex = collection.index(index,
                                            offsetBy: step,
                                            limitedBy: stepLimit) else {
        return .value(builder.result)
      }

      index = newIndex
    }

    return .value(builder.result)
  }
}
