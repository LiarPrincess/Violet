import Foundation

extension StringImplementation {

  // MARK: - Strip

  internal static func strip(scalars: UnicodeScalars,
                             chars: PyObject?) -> PyResult<UnicodeScalarsSub> {
    return Self.stripTemplate(
      typeName: Self.scalarsTypeName,
      fnName: "strip",
      scalars: scalars,
      chars: chars,
      getCollection: Self.getScalars(object:),
      onStripWhitespace: Self.stripWhitespace(collection:),
      onStripChars: Self.strip(collection:chars:)
    )
  }

  internal static func strip(data: Data, chars: PyObject?) -> PyResult<Data> {
    return Self.stripTemplate(
      typeName: Self.dataTypeName,
      fnName: "strip",
      scalars: data,
      chars: chars,
      getCollection: Self.getData(object:),
      onStripWhitespace: Self.stripWhitespace(collection:),
      onStripChars: Self.strip(collection:chars:)
    )
  }

  private static func strip<C: BidirectionalCollection>(
    collection: C,
    chars: Set<C.Element>
  ) -> C.SubSequence where C.Element: Hashable {
    let tmp = Self.lstrip(collection: collection, chars: chars)
    return Self.rstrip(collection: tmp, chars: chars)
  }

  // MARK: - Left strip

  internal static func lstrip(scalars: UnicodeScalars,
                              chars: PyObject?) -> PyResult<UnicodeScalarsSub> {
    return Self.stripTemplate(
      typeName: Self.scalarsTypeName,
      fnName: "lstrip",
      scalars: scalars,
      chars: chars,
      getCollection: Self.getScalars(object:),
      onStripWhitespace: Self.lstripWhitespace(collection:),
      onStripChars: Self.lstrip(collection:chars:)
    )
  }

  internal static func lstrip(data: Data, chars: PyObject?) -> PyResult<Data> {
    return Self.stripTemplate(
      typeName: Self.dataTypeName,
      fnName: "lstrip",
      scalars: data,
      chars: chars,
      getCollection: Self.getData(object:),
      onStripWhitespace: Self.lstripWhitespace(collection:),
      onStripChars: Self.lstrip(collection:chars:)
    )
  }

  private static func lstrip<C: Collection>(
    collection: C,
    chars: Set<C.Element>
  ) -> C.SubSequence where C.Element: Hashable {
    return collection.drop { chars.contains($0) }
  }

  // MARK: - Right strip

  internal static func rstrip(scalars: UnicodeScalars,
                              chars: PyObject?) -> PyResult<UnicodeScalarsSub> {
    return Self.stripTemplate(
      typeName: Self.scalarsTypeName,
      fnName: "rstrip",
      scalars: scalars,
      chars: chars,
      getCollection: Self.getScalars(object:),
      onStripWhitespace: Self.rstripWhitespace(collection:),
      onStripChars: Self.rstrip(collection:chars:)
    )
  }

  internal static func rstrip(data: Data, chars: PyObject?) -> PyResult<Data> {
    return Self.stripTemplate(
      typeName: Self.dataTypeName,
      fnName: "rstrip",
      scalars: data,
      chars: chars,
      getCollection: Self.getData(object:),
      onStripWhitespace: Self.rstripWhitespace(collection:),
      onStripChars: Self.rstrip(collection:chars:)
    )
  }

  private static func rstrip<C: BidirectionalCollection>(
    collection: C,
    chars: Set<C.Element>
  ) -> C.SubSequence where C.Element: Hashable {
    return collection.dropLast { chars.contains($0) }
  }

  // MARK: - Strip template

  // swiftlint:disable:next function_parameter_count
  private static func stripTemplate<C: BidirectionalCollection>(
    typeName: String,
    fnName: String,
    scalars: C,
    chars: PyObject?,
    getCollection: ObjectToCollectionFn<C>,
    onStripWhitespace: (C) -> C.SubSequence,
    onStripChars: (C, Set<C.Element>) -> C.SubSequence
  ) -> PyResult<C.SubSequence> where C.Element: Hashable {
    switch Self.parseChars(chars: chars) {
    case .whitespace:
      let result = onStripWhitespace(scalars)
      return .value(result)

    case .object(let charsObject):
      switch getCollection(charsObject) {
      case .value(let charsCollection):
        let charsSet = Set(charsCollection)
        let result = onStripChars(scalars, charsSet)
        return .value(result)

      case .notCollection:
        let charsType = charsObject.typeName
        let msg = "\(fnName) arg must be \(typeName) or None, not \(charsType)"
        return .error(Py.newTypeError(msg: msg))

      case .error(let e):
        return .error(e)
      }
    }
  }

  private enum CharsArgument {
    case whitespace
    case object(PyObject)
  }

  private static func parseChars(chars: PyObject?) -> CharsArgument {
    guard let object = chars else {
      return .whitespace
    }

    if object is PyNone {
      return .whitespace
    }

    return .object(object)
  }

  // MARK: - Strip whitespace

  internal static func stripWhitespace(scalars: UnicodeScalars) -> UnicodeScalarsSub {
    return Self.stripWhitespace(collection: scalars)
  }

  internal static func stripWhitespace(data: Data) -> Data {
    return Self.stripWhitespace(collection: data)
  }

  internal static func lstripWhitespace(scalars: UnicodeScalars) -> UnicodeScalarsSub {
    return Self.lstripWhitespace(collection: scalars)
  }

  internal static func lstripWhitespace(data: Data) -> Data {
    return Self.lstripWhitespace(collection: data)
  }

  internal static func rstripWhitespace(scalars: UnicodeScalars) -> UnicodeScalarsSub {
    return Self.rstripWhitespace(collection: scalars)
  }

  internal static func rstripWhitespace(data: Data) -> Data {
    return Self.rstripWhitespace(collection: data)
  }

  private static func stripWhitespace<C: BidirectionalCollection>(
    collection: C
  ) -> C.SubSequence where C.Element: UnicodeScalarConvertible {
    let tmp = Self.lstripWhitespace(collection: collection)
    return Self.rstripWhitespace(collection: tmp)
  }

  private static func lstripWhitespace<C: Collection>(
    collection: C
  ) -> C.SubSequence where C.Element: UnicodeScalarConvertible {
    return collection.drop(while: Self.isWhitespace(scalar:))
  }

  private static func rstripWhitespace<C: BidirectionalCollection>(
    collection: C
  ) -> C.SubSequence where C.Element: UnicodeScalarConvertible {
    return collection.dropLast(while: Self.isWhitespace(scalar:))
  }
}
