import Foundation

extension StringImplementation {

  // MARK: - Add

  internal static func add(lhs: UnicodeScalars, rhs: PyObject) -> PyResult<String> {
    return Self.add(typeName: Self.scalarsTypeName,
                    lhs: lhs,
                    rhs: rhs,
                    using: StringBuilder.self,
                    getCollection: Self.getScalars(object:))
  }

  internal static func add(lhs: Data, rhs: PyObject) -> PyResult<Data> {
    return Self.add(typeName: Self.dataTypeName,
                    lhs: lhs,
                    rhs: rhs,
                    using: BytesBuilder.self,
                    getCollection: Self.getData(object:))
  }

  private static func add<C: Collection, B: StringBuilderType>(
    typeName: String,
    lhs: C,
    rhs: PyObject,
    using: B.Type,
    getCollection: ObjectToCollectionFn<C>
  ) -> PyResult<B.Result> where C.Element == B.Element {
    switch getCollection(rhs) {
    case .value(let rhsCollection):
      let result = Self.add(lhs: lhs, rhs: rhsCollection, using: B.self)
      return .value(result)
    case .notCollection:
      let rhsType = rhs.typeName
      let msg = "can only concatenate \(typeName) (not '\(rhsType)') to \(typeName)"
      return .typeError(msg)
    case .error(let e):
      return .error(e)
    }
  }

  private static func add<C: Collection, B: StringBuilderType>(
    lhs: C,
    rhs: C,
    using: B.Type
  ) -> B.Result where C.Element == B.Element {
    var builder = B()
    builder.append(contentsOf: lhs)
    builder.append(contentsOf: rhs)
    return builder.result
  }

  // MARK: - Mul

  internal static func mul(scalars: UnicodeScalars,
                           count: PyObject) -> PyResult<String> {
    return Self.mul(typeName: Self.scalarsTypeName,
                    collection: scalars,
                    count: count,
                    using: StringBuilder.self)
  }

  internal static func mul(data: Data, count: PyObject) -> PyResult<Data> {
    return Self.mul(typeName: Self.dataTypeName,
                    collection: data,
                    count: count,
                    using: BytesBuilder.self)
  }

  private static func mul<C: Collection, B: StringBuilderType>(
    typeName: String,
    collection: C,
    count countObject: PyObject,
    using: B.Type
  ) -> PyResult<B.Result> where C.Element == B.Element {
    guard let pyCount = PyCast.asInt(countObject) else {
      let countType = countObject.typeName
      let msg = "can only multiply \(typeName) and int (not '\(countType)')"
      return .typeError(msg)
    }

    guard let count = Int(exactly: pyCount.value) else {
      return .overflowError("repeated string is too long")
    }

    let result = Self.mul(collection: collection, count: count, using: B.self)
    return .value(result)
  }

  private static func mul<C: Collection, B: StringBuilderType>(
    collection: C,
    count: Int,
    using: B.Type
  ) -> B.Result where C.Element == B.Element {
    var builder = B()

    if collection.isEmpty {
      return builder.result
    }

    for _ in 0..<max(count, 0) {
      builder.append(contentsOf: collection)
    }

    return builder.result
  }

  // MARK: - RMul

  internal static func rmul(scalars: UnicodeScalars,
                            count: PyObject) -> PyResult<String> {
    return Self.mul(scalars: scalars, count: count)
  }

  internal static func rmul(data: Data, count: PyObject) -> PyResult<Data> {
    return Self.mul(data: data, count: count)
  }
}
