import Foundation

extension StringImplementation {

  // MARK: - Starts with

  internal static func startsWith(scalars: UnicodeScalars,
                                  element: PyObject,
                                  start: PyObject?,
                                  end: PyObject?) -> PyResult<Bool> {
    return Self.template(typeName: Self.scalarsTypeName,
                         fnName: "startswith",
                         collection: scalars,
                         element: element,
                         start: start,
                         end: end,
                         getCollection: Self.getScalars(object:),
                         fn: Self.startsWith(subSequence:element:))
  }

  internal static func startsWith(data: Data,
                                  element: PyObject,
                                  start: PyObject?,
                                  end: PyObject?) -> PyResult<Bool> {
    return Self.template(typeName: Self.dataTypeName,
                         fnName: "startswith",
                         collection: data,
                         element: element,
                         start: start,
                         end: end,
                         getCollection: Self.getData(object:),
                         fn: Self.startsWith(subSequence:element:))
  }

  private static func startsWith<C: Collection>(
    subSequence: IndexedSubSequence<C>,
    element: C
  ) -> Bool where C.Element: Equatable {
    let subSequenceIsLonger = Self.isLonger(subSequence: subSequence, than: element)
    if subSequenceIsLonger {
      return false
    }

    // Do not nove this before 'isLonger' check!
    if element.isEmpty {
      return true
    }

    let result = subSequence.value.starts(with: element)
    return result
  }

  private static func isLonger<C: Collection>(
    subSequence: IndexedSubSequence<C>,
    than element: C
  ) -> Bool {
    let start = subSequence.start?.adjustedInt ?? Int.min
    var end = subSequence.end?.adjustedInt ?? Int.max
    // We have to do it this way to prevent overflows
    end -= element.count
    return start > end
  }

  // MARK: - Ends with

  internal static func endsWith(scalars: UnicodeScalars,
                                element: PyObject,
                                start: PyObject?,
                                end: PyObject?) -> PyResult<Bool> {
    return Self.template(typeName: Self.scalarsTypeName,
                         fnName: "endswith",
                         collection: scalars,
                         element: element,
                         start: start,
                         end: end,
                         getCollection: Self.getScalars(object:),
                         fn: Self.endsWith(subSequence:element:))
  }

  internal static func endsWith(data: Data,
                                element: PyObject,
                                start: PyObject?,
                                end: PyObject?) -> PyResult<Bool> {
    return Self.template(typeName: Self.dataTypeName,
                         fnName: "endswith",
                         collection: data,
                         element: element,
                         start: start,
                         end: end,
                         getCollection: Self.getData(object:),
                         fn: Self.endsWith(subSequence:element:))
  }

  private static func endsWith<C: BidirectionalCollection>(
    subSequence: IndexedSubSequence<C>,
    element: C
  ) -> Bool where C.Element: Equatable {
    let subSequenceIsLonger = Self.isLonger(subSequence: subSequence, than: element)
    if subSequenceIsLonger {
      return false
    }

    // Do not nove this before 'isLonger' check!
    if element.isEmpty {
      return true
    }

    let result = subSequence.value.ends(with: element)
    return result
  }

  // MARK: - Template

  // swiftlint:disable:next function_parameter_count
  private static func template<C: BidirectionalCollection>(
    typeName: String,
    fnName: String,
    collection: C,
    element: PyObject,
    start: PyObject?,
    end: PyObject?,
    getCollection: ObjectToCollectionFn<C>,
    fn: (IndexedSubSequence<C>, C) -> Bool
  ) -> PyResult<Bool> where
    C.Element: Equatable,
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess {

    let subSequence: IndexedSubSequence<C>
    switch Self.substring(collection: collection, start: start, end: end) {
    case let .value(s): subSequence = s
    case let .error(e): return .error(e)
    }

    switch getCollection(element) {
    case .value(let elementCollection):
      let result = fn(subSequence, elementCollection)
      return .value(result)
    case .notCollection:
      break // try tuple
    case .error(let e):
      return .error(e)
    }

    if let tuple = PyCast.asTuple(element) {
      for element in tuple.elements {
        switch getCollection(element) {
        case .value(let elementCollection):
          let elementResult = fn(subSequence, elementCollection)
          if elementResult {
            return .value(true)
          }
        case .notCollection:
          let t = element.typeName
          let msg = "tuple for \(fnName) must only contain \(typeName), not \(t)"
          return .typeError(msg)
        case .error(let e):
          return .error(e)
        }
      }

      return .value(false)
    }

    let t = element.typeName
    let msg = "\(fnName) first arg must be \(typeName) or a tuple of \(typeName), not \(t)"
    return .typeError(msg)
  }
}
