import Foundation

extension StringImplementation {

  internal static func join(scalars: UnicodeScalars,
                            iterable: PyObject) -> PyResult<String> {
    return Self.template(typeName: Self.scalarsTypeName,
                         collection: scalars,
                         iterable: iterable,
                         using: StringBuilder.self,
                         getCollection: Self.getScalars(object:))
  }

  internal static func join(data: Data, iterable: PyObject) -> PyResult<Data> {
    return Self.template(typeName: Self.dataTypeName,
                         collection: data,
                         iterable: iterable,
                         using: BytesBuilder.self,
                         getCollection: Self.getData(object:))
  }

  // >>> '@'.join(['A', 'B', 'C'])
  // 'A@B@C'
  private static func template<C: Collection, B: StringBuilderType>(
    typeName: String,
    collection: C,
    iterable: PyObject,
    using: B.Type,
    getCollection: ObjectToCollectionFn<C>
  ) -> PyResult<B.Result> where C.Element == B.Element {
    var index = 0
    var builder = B()

    let reduceError = Py.reduce(iterable: iterable, into: &builder) { acc, object in
      if index > 0 {
        acc.append(contentsOf: collection) // @ in '@'.join(['A', 'B', 'C'])
      }

      switch getCollection(object) {
      case .value(let objectCollection):
        acc.append(contentsOf: objectCollection)
        index += 1
        return .goToNextElement
      case .notCollection:
        let t = object.typeName
        let msg = "sequence item \(index): expected a \(typeName)-like object, \(t) found"
        return .error(Py.newTypeError(msg: msg))
      case .error(let e):
        return .error(e)
      }
    }

    if let e = reduceError {
      return .error(e)
    }

    let result = builder.result
    return .value(result)
  }
}
