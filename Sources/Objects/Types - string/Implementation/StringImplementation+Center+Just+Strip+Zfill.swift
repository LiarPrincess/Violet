import Foundation

// swiftlint:disable empty_count

extension StringImplementation {

  // MARK: - Center

  internal static func center(scalars: UnicodeScalars,
                              width: PyObject,
                              fillChar: PyObject?) -> PyResult<String> {
    return Self.justTemplate(typeName: Self.scalarsTypeName,
                             fnName: "center",
                             collection: scalars,
                             width: width,
                             fillChar: fillChar,
                             using: StringBuilder.self,
                             defaultFillChar: Self.scalarsDefaultFill,
                             getCollection: Self.getScalars(object:),
                             justFn: Self.center(collection:width:fillChar:using:))
  }

  internal static func center(data: Data,
                              width: PyObject,
                              fillChar: PyObject?) -> PyResult<Data> {
    return Self.justTemplate(typeName: Self.scalarsTypeName,
                             fnName: "center",
                             collection: data,
                             width: width,
                             fillChar: fillChar,
                             using: BytesBuilder.self,
                             defaultFillChar: Self.dataDefaultFill,
                             getCollection: Self.getData(object:),
                             justFn: Self.center(collection:width:fillChar:using:))
  }

  private static func center<C: Collection, B: StringBuilderType>(
    collection: C,
    width: Int,
    fillChar: C.Element,
    using: B.Type
  ) -> B.Result where C.Element == B.Element {
    let count = width - collection.count
    var builder = B()

    guard count > 0 else {
      builder.append(contentsOf: collection)
      return builder.result
    }

    let leftCount = count / 2 + (count & width & 1)
    let rightCount = count - leftCount

    builder.append(element: fillChar, repeated: leftCount)
    builder.append(contentsOf: collection)
    builder.append(element: fillChar, repeated: rightCount)
    return builder.result
  }

  // MARK: - Left just

  internal static func ljust(scalars: UnicodeScalars,
                             width: PyObject,
                             fillChar: PyObject?) -> PyResult<String> {
    return Self.justTemplate(typeName: Self.scalarsTypeName,
                             fnName: "ljust",
                             collection: scalars,
                             width: width,
                             fillChar: fillChar,
                             using: StringBuilder.self,
                             defaultFillChar: Self.scalarsDefaultFill,
                             getCollection: Self.getScalars(object:),
                             justFn: Self.ljust(collection:width:fillChar:using:))
  }

  internal static func ljust(data: Data,
                             width: PyObject,
                             fillChar: PyObject?) -> PyResult<Data> {
    return Self.justTemplate(typeName: Self.scalarsTypeName,
                             fnName: "ljust",
                             collection: data,
                             width: width,
                             fillChar: fillChar,
                             using: BytesBuilder.self,
                             defaultFillChar: Self.dataDefaultFill,
                             getCollection: Self.getData(object:),
                             justFn: Self.ljust(collection:width:fillChar:using:))
  }

  private static func ljust<C: Collection, B: StringBuilderType>(
    collection: C,
    width: Int,
    fillChar: C.Element,
    using: B.Type
  ) -> B.Result where C.Element == B.Element {
    let count = width - collection.count
    var builder = B()

    guard count > 0 else {
      builder.append(contentsOf: collection)
      return builder.result
    }

    builder.append(contentsOf: collection)
    builder.append(element: fillChar, repeated: count)
    return builder.result
  }

  // MARK: - Right just

  internal static func rjust(scalars: UnicodeScalars,
                             width: PyObject,
                             fillChar: PyObject?) -> PyResult<String> {
    return Self.justTemplate(typeName: Self.scalarsTypeName,
                             fnName: "rjust",
                             collection: scalars,
                             width: width,
                             fillChar: fillChar,
                             using: StringBuilder.self,
                             defaultFillChar: Self.scalarsDefaultFill,
                             getCollection: Self.getScalars(object:),
                             justFn: Self.rjust(collection:width:fillChar:using:))
  }

  internal static func rjust(data: Data,
                             width: PyObject,
                             fillChar: PyObject?) -> PyResult<Data> {
    return Self.justTemplate(typeName: Self.scalarsTypeName,
                             fnName: "rjust",
                             collection: data,
                             width: width,
                             fillChar: fillChar,
                             using: BytesBuilder.self,
                             defaultFillChar: Self.dataDefaultFill,
                             getCollection: Self.getData(object:),
                             justFn: Self.rjust(collection:width:fillChar:using:))
  }

  private static func rjust<C: Collection, B: StringBuilderType>(
    collection: C,
    width: Int,
    fillChar: C.Element,
    using: B.Type
  ) -> B.Result where C.Element == B.Element {
    let count = width - collection.count
    var builder = B()

    guard count > 0 else {
      builder.append(contentsOf: collection)
      return builder.result
    }

    builder.append(element: fillChar, repeated: count)
    builder.append(contentsOf: collection)
    return builder.result
  }

  // MARK: - ZFill

  internal static func zFill(scalars: UnicodeScalars,
                             width: PyObject) -> PyResult<String> {
    return Self.zfill(collection: scalars,
                      width: width,
                      zFill: Self.scalarsZFill,
                      using: StringBuilder.self)
  }

  internal static func zFill(data: Data, width: PyObject) -> PyResult<Data> {
    return Self.zfill(collection: data,
                      width: width,
                      zFill: Self.dataZFill,
                      using: BytesBuilder.self)
  }

  private static func zfill<C: Collection, B: StringBuilderType>(
    collection: C,
    width widthObject: PyObject,
    zFill: C.Element,
    using: B.Type
  ) -> PyResult<B.Result> where C.Element == B.Element, C.Element: UnicodeScalarConvertible {
    guard let widthInt = PyCast.asInt(widthObject) else {
      return .typeError("width must be int, not \(widthObject.typeName)")
    }

    guard let width = Int(exactly: widthInt.value) else {
      return .overflowError("width is too big")
    }

    let result = self.zfill(collection: collection,
                            width: width,
                            zFill: zFill,
                            using: B.self)

    return .value(result)
  }

  private static func zfill<C: Collection, B: StringBuilderType>(
    collection: C,
    width: Int,
    zFill: C.Element,
    using: B.Type
  ) -> B.Result where C.Element == B.Element, C.Element: UnicodeScalarConvertible {
    var builder = B()

    let fillCount = width - collection.count
    guard fillCount > 0 else {
      builder.append(contentsOf: collection)
      return builder.result
    }

    let padding = Array(repeating: zFill, count: fillCount)
    guard let first = collection.first else {
      builder.append(contentsOf: padding)
      return builder.result
    }

    let firstScalar = first.asUnicodeScalar
    let hasSign = firstScalar == "+" || firstScalar == "-"

    if hasSign {
      builder.append(first)
    }

    builder.append(contentsOf: padding)

    if hasSign {
      builder.append(contentsOf: collection.dropFirst())
    } else {
      builder.append(contentsOf: collection)
    }

    return builder.result
  }

  // MARK: - Just template

  // swiftlint:disable:next function_parameter_count
  private static func justTemplate<C: Collection, B: StringBuilderType>(
    typeName: String,
    fnName: String,
    collection: C,
    width widthObject: PyObject,
    fillChar fillCharObject: PyObject?,
    using: B.Type,
    defaultFillChar: C.Element,
    getCollection: ObjectToCollectionFn<C>,
    justFn: (C, Int, C.Element, B.Type) -> B.Result
  ) -> PyResult<B.Result> where C.Element == B.Element {
    let width: Int
    switch Self.parseWidth(fnName: fnName, width: widthObject) {
    case let .value(w): width = w
    case let .error(e): return .error(e)
    }

    let fillChar: C.Element
    let fillCharResult = Self.parseFillChar(typeName: typeName,
                                            fnName: fnName,
                                            fillChar: fillCharObject,
                                            getCollection: getCollection)
    switch fillCharResult {
    case .default:  fillChar = defaultFillChar
    case .value(let s): fillChar = s
    case .error(let e): return .error(e)
    }

    let result = justFn(collection, width, fillChar, B.self)
    return .value(result)
  }

  private static func parseWidth(fnName: String, width: PyObject) -> PyResult<Int> {
    guard let pyInt = PyCast.asInt(width) else {
      return .typeError("\(fnName) width arg must be int, not \(width.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("\(fnName) width is too large")
    }

    return .value(int)
  }

  private enum FillChar<T> {
    case `default`
    case value(T)
    case error(PyBaseException)
  }

  private static func parseFillChar<C: Collection>(
    typeName: String,
    fnName: String,
    fillChar: PyObject?,
    getCollection: ObjectToCollectionFn<C>
  ) -> FillChar<C.Element> {
    guard let fillChar = fillChar else {
      return .default
    }

    switch getCollection(fillChar) {
    case .value(let c):
      if let first = c.first, c.count == 1 {
        return .value(first)
      }
    // Else: error below
    case .notCollection:
      break // Error below
    case .error(let e):
      return .error(e)
    }

    let t = fillChar.typeName
    let msg = "\(fnName) fillchar arg must be \(typeName) of length 1, not \(t)"
    return .error(Py.newTypeError(msg: msg))
  }
}
