import Foundation

extension StringImplementation {

  internal static func replace(scalars: UnicodeScalars,
                               old: PyObject,
                               new: PyObject,
                               count: PyObject?) -> PyResult<String> {
    return Self.replace(typeName: Self.scalarsTypeName,
                        collection: scalars,
                        old: old,
                        new: new,
                        count: count,
                        using: StringBuilder.self,
                        getCollection: Self.getScalars(object:))
  }

  internal static func replace(data: Data,
                               old: PyObject,
                               new: PyObject,
                               count: PyObject?) -> PyResult<Data> {
    return Self.replace(typeName: Self.dataTypeName,
                        collection: data,
                        old: old,
                        new: new,
                        count: count,
                        using: BytesBuilder.self,
                        getCollection: Self.getData(object:))
  }

  // swiftlint:disable:next function_parameter_count
  private static func replace<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess,
    B: StringBuilderType
  >(
    typeName: String,
    collection: C,
    old: PyObject,
    new: PyObject,
    count countObject: PyObject?,
    using: B.Type,
    getCollection: ObjectToCollectionFn<C>
  ) -> PyResult<B.Result> where C.Element: Equatable, C.Element == B.Element {
    let oldElements: C
    switch getCollection(old) {
    case .value(let c):
      oldElements = c
    case .notCollection:
      return .typeError("old must be \(typeName), not \(old.typeName)")
    case .error(let e):
      return .error(e)
    }

    let newElements: C
    switch getCollection(new) {
    case .value(let c):
      newElements = c
    case .notCollection:
      return .typeError("new must be \(typeName), not \(new.typeName)")
    case .error(let e):
      return .error(e)
    }

    var count: Int
    switch Self.parseCount(count: countObject) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    let result = Self.replace(collection: collection,
                              old: oldElements,
                              new: newElements,
                              count: count,
                              using: B.self)

    return .value(result)
  }

  private static func replace<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess,
    B: StringBuilderType
  >(
    collection: C,
    old: C,
    new: C,
    count: Int,
    using: B.Type
  ) -> B.Result where C.Element: Equatable, C.Element == B.Element {
    var builder = B()

    // swiftlint:disable:next empty_count
    if count == 0 {
      builder.append(contentsOf: collection)
      return builder.result
    }

    var index = collection.startIndex
    var remainingCount = count

    while index != collection.endIndex {
      let s = collection[index...]
      let startsWithOld = s.starts(with: old)

      if startsWithOld {
        builder.append(contentsOf: new)
        index = collection.index(index, offsetBy: old.count)

        remainingCount -= 1
        if remainingCount <= 0 {
          builder.append(contentsOf: collection[index...])
          break
        }
      } else {
        let element = collection[index]
        builder.append(element)

        collection.formIndex(after: &index)
      }
    }

    return builder.result
  }

  private static func parseCount(count: PyObject?) -> PyResult<Int> {
    guard let count = count else {
      return .value(Int.max)
    }

    guard let pyInt = PyCast.asInt(count) else {
      return .typeError("count must be int, not \(count.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("count is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }
}
