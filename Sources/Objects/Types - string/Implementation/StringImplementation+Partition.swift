import Foundation

extension StringImplementation {

  internal enum PartitionResult<C: Collection> {
    /// Separator was found.
    case separatorFound(before: C.SubSequence, separator: C, after: C.SubSequence)
    /// Separator was not found
    case separatorNotFound
    case error(PyBaseException)
  }

  internal static func partition(scalars: UnicodeScalars,
                                 separator: PyObject) -> PartitionResult<UnicodeScalars> {
    return Self.template(collection: scalars,
                         separator: separator,
                         getCollection: Self.getScalars(object:),
                         findSeparator: Self.findRaw(collection:element:))
  }

  internal static func partition(data: Data,
                                 separator: PyObject) -> PartitionResult<Data> {
    return Self.template(collection: data,
                         separator: separator,
                         getCollection: Self.getData(object:),
                         findSeparator: Self.findRaw(collection:element:))
  }

  internal static func rpartition(scalars: UnicodeScalars,
                                  separator: PyObject) -> PartitionResult<UnicodeScalars> {
    return Self.template(collection: scalars,
                         separator: separator,
                         getCollection: Self.getScalars(object:),
                         findSeparator: Self.rfindRaw(collection:element:))
  }

  internal static func rpartition(data: Data,
                                  separator: PyObject) -> PartitionResult<Data> {
    return Self.template(collection: data,
                         separator: separator,
                         getCollection: Self.getData(object:),
                         findSeparator: Self.rfindRaw(collection:element:))
  }

  private static func template<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    collection: C,
    separator separatorObject: PyObject,
    getCollection: ObjectToCollectionFn<C>,
    findSeparator: (C, C) -> FindResult<C.Index>
  ) -> PartitionResult<C> {
    let separator: C
    switch getCollection(separatorObject) {
    case .value(let s):
      separator = s
    case .notCollection:
      let msg = "sep must be string, not \(separatorObject.typeName)"
      return .error(Py.newTypeError(msg: msg))
    case .error(let e):
      return .error(e)
    }

    if separator.isEmpty {
      return .error(Py.newValueError(msg: "empty separator"))
    }

    let findResult = findSeparator(collection, separator)
    switch findResult {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let separatorCount = separator.count
      let index2 = collection.index(index1,
                                    offsetBy: separatorCount,
                                    limitedBy: collection.endIndex)

      let before = Self.substring(collection: collection, end: index1)
      let after = Self.substring(collection: collection, start: index2)
      return .separatorFound(before: before, separator: separator, after: after)

    case .notFound:
      return .separatorNotFound
    }
  }
}
