import Foundation
import BigInt

// cSpell:ignore STRINGLIB

extension StringImplementation {

  // MARK: - Contains

  internal static func contains(scalars: UnicodeScalars,
                                element: PyObject) -> PyResult<Bool> {
    return Self.contains(typeName: Self.scalarsTypeName,
                         collection: scalars,
                         element: element,
                         getCollection: Self.getScalars(object:))
  }

  internal static func contains(scalars: UnicodeScalars,
                                element: UnicodeScalars) -> Bool {
    return Self.contains(collection: scalars, element: element)
  }

  internal static func contains(data: Data,
                                element: PyObject) -> PyResult<Bool> {
    return self.contains(typeName: Self.dataTypeName,
                         collection: data,
                         element: element,
                         getCollection: Self.getData(object:))
  }

  private static func contains<C: CollectionBecauseUnicodeScalarsAreNotRandomAccess>(
    typeName: String,
    collection: C,
    element: PyObject,
    getCollection: ObjectToCollectionFn<C>
  ) -> PyResult<Bool> where C.Element: Equatable {
    switch getCollection(element) {
    case .value(let elementCollection):
      let result = Self.contains(collection: collection, element: elementCollection)
      return .value(result)
    case .notCollection:
      let et = element.typeName
      let msg = "'in <\(typeName)>' requires \(typeName) as left operand, not \(et)"
      return .typeError(msg)
    case .error(let e):
      return .error(e)
    }
  }

  private static func contains<C: CollectionBecauseUnicodeScalarsAreNotRandomAccess>(
    collection: C,
    element: C
  ) -> Bool where C.Element: Equatable {
    // In Python: "\u00E9" in "Cafe\u0301" -> False
    // In Swift:  "Cafe\u{0301}".contains("\u{00E9}") -> True
    // which is 'e with acute (as a single char)' in 'Cafe{accent}'
    let findResult = Self.findRaw(collection: collection, element: element)
    switch findResult {
    case .index: return true
    case .notFound: return false
    }
  }

  // MARK: - Index of

  internal static func indexOf(scalars: UnicodeScalars,
                               element: PyObject,
                               start: PyObject?,
                               end: PyObject?) -> PyResult<BigInt> {
    return Self.indexOfTemplate(typeName: Self.scalarsTypeName,
                                fnName: "index",
                                collection: scalars,
                                element: element,
                                start: start,
                                end: end,
                                getCollection: Self.getScalars(object:),
                                findInSubSequence: Self.findRaw(collection:element:))
  }

  internal static func indexOf(data: Data,
                               element: PyObject,
                               start: PyObject?,
                               end: PyObject?) -> PyResult<BigInt> {
    return Self.indexOfTemplate(typeName: Self.dataTypeName,
                                fnName: "index",
                                collection: data,
                                element: element,
                                start: start,
                                end: end,
                                getCollection: Self.getData(object:),
                                findInSubSequence: Self.findRaw(collection:element:))
  }

  internal static func rindexOf(scalars: UnicodeScalars,
                                element: PyObject,
                                start: PyObject?,
                                end: PyObject?) -> PyResult<BigInt> {
    return Self.indexOfTemplate(typeName: Self.scalarsTypeName,
                                fnName: "rindex",
                                collection: scalars,
                                element: element,
                                start: start,
                                end: end,
                                getCollection: Self.getScalars(object:),
                                findInSubSequence: Self.rfindRaw(collection:element:))
  }

  internal static func rindexOf(data: Data,
                                element: PyObject,
                                start: PyObject?,
                                end: PyObject?) -> PyResult<BigInt> {
    return Self.indexOfTemplate(typeName: Self.dataTypeName,
                                fnName: "rindex",
                                collection: data,
                                element: element,
                                start: start,
                                end: end,
                                getCollection: Self.getData(object:),
                                findInSubSequence: Self.rfindRaw(collection:element:))
  }

  // swiftlint:disable:next function_parameter_count
  private static func indexOfTemplate<C: CollectionBecauseUnicodeScalarsAreNotRandomAccess>(
    typeName: String,
    fnName: String,
    collection: C,
    element: PyObject,
    start: PyObject?,
    end: PyObject?,
    getCollection: ObjectToCollectionFn<C>,
    findInSubSequence: (C.SubSequence, C) -> FindResult<C.Index>
  ) -> PyResult<BigInt> where C.Element: Equatable {
    let elementCollection: C
    switch getCollection(element) {
    case .value(let c):
      elementCollection = c
    case .notCollection:
      return .typeError("\(fnName) arg must be \(typeName), not \(element.typeName)")
    case .error(let e):
      return .error(e)
    }

    let subSequence: IndexedSubSequence<C>
    switch self.substring(collection: collection, start: start, end: end) {
    case let .value(s): subSequence = s
    case let .error(e): return .error(e)
    }

    let result = findInSubSequence(subSequence.value, elementCollection)
    switch result {
    case let .index(index: _, position: position):
      // If we found the value, then we have return an index
      // from the start of the string!
      let start = subSequence.start?.adjustedInt ?? 0
      return .value(BigInt(start) + position)
    case .notFound:
      return .valueError("substring not found")
    }
  }

  // MARK: - Count

  internal static func count(scalars: UnicodeScalars,
                             element: PyObject,
                             start: PyObject?,
                             end: PyObject?) -> PyResult<BigInt> {
    return Self.count(typeName: Self.scalarsTypeName,
                      collection: scalars,
                      element: element,
                      start: start,
                      end: end,
                      getCollection: Self.getScalars(object:))
  }

  internal static func count(data: Data,
                             element: PyObject,
                             start: PyObject?,
                             end: PyObject?) -> PyResult<BigInt> {
    return Self.count(typeName: Self.dataTypeName,
                      collection: data,
                      element: element,
                      start: start,
                      end: end,
                      getCollection: Self.getData(object:))
  }

  // swiftlint:disable function_parameter_count
  /// STRINGLIB(count)(const STRINGLIB_CHAR* str, Py_ssize_t str_len,
  ///                  const STRINGLIB_CHAR* sub, Py_ssize_t sub_len,
  ///                  Py_ssize_t maxcount)
  private static func count<C: CollectionBecauseUnicodeScalarsAreNotRandomAccess>(
    // swiftlint:enable function_parameter_count
    typeName: String,
    collection: C,
    element: PyObject,
    start: PyObject?,
    end: PyObject?,
    getCollection: ObjectToCollectionFn<C>
  ) -> PyResult<BigInt> where C.Element: Equatable {
    let elementCollection: C
    switch getCollection(element) {
    case .value(let c):
      elementCollection = c
    case .notCollection:
      return .typeError("count arg must be \(typeName), not \(element.typeName)")
    case .error(let e):
      return .error(e)
    }

    let subSequence: IndexedSubSequence<C>
    switch self.substring(collection: collection, start: start, end: end) {
    case let .value(s): subSequence = s
    case let .error(e): return .error(e)
    }

    let result = Self.count(collection: subSequence.value, element: elementCollection)
    return .value(result)
  }

  private static func count<C: Collection>(
    collection: C.SubSequence,
    element: C
  ) -> BigInt where C.Element: Equatable {
    if collection.isEmpty {
      return 0
    }

    if element.isEmpty {
      return BigInt(collection.count + 1)
    }

    var result = BigInt(0)
    var index = collection.startIndex

    while index != collection.endIndex {
      let substring = collection[index...]
      if substring.starts(with: element) {
        result += 1

        // We know that 'element.count' != 0, because we checked 'element.isEmpty'
        index = collection.index(index, offsetBy: element.count)
      } else {
        collection.formIndex(after: &index)
      }
    }

    return result
  }
}
