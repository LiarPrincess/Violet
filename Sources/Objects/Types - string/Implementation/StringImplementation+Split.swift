import Foundation

extension StringImplementation {
/*
  // MARK: - Split

  private static let splitArguments = ArgumentParser.createOrTrap(
    arguments: ["sep", "maxsplit"],
    format: "|OO:split"
  )

//  internal static func splitLines(scalars: UnicodeScalars,
//                                  args: [PyObject],
//                                  kwargs: PyDict?) -> PyResult<[UnicodeScalarsSub]> {
//    return Self.splitLines(collection: scalars, args: args, kwargs: kwargs)
//  }
//
//  internal static func splitLines(data: Data,
//                                  args: [PyObject],
//                                  kwargs: PyDict?) -> PyResult<[Data]> {
//    return Self.splitLines(collection: data, args: args, kwargs: kwargs)
//  }

  private static func split<C: Collection>(
    collection: C,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<[C.SubSequence]> {
    switch splitArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 2, "Invalid optional argument count.")

      let sep = binding.optional(at: 0)
      let maxCount = binding.optional(at: 1)
      return Self.split(separator: sep, maxCount: maxCount)
    case let .error(e):
      return .error(e)
    }
  }

  private static func split<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    typeName: String,
    collection: C,
    separator separatorObject: PyObject?,
    maxCount: PyObject?,
    getCollection: ObjectToCollectionFn<C>
  ) -> PyResult<[C.SubSequence]> where C.Element: UnicodeScalarConvertible {
    var count: Int
    switch self.parseSplitMaxCount(maxCount) {
    case let .value(c): count = c
    case let .error(e): return .error(e)
    }

    let separator = Self.parseSeparator(typeName: typeName,
                                        separator: separatorObject,
                                        getCollection: getCollection)

    switch separator {
    case .whitespace:
      let result = Self.splitWhitespace(collection: collection, maxCount: count)
      return .value(result)
    case .some(let s):
//      return .value(self.split(separator: s, maxCount: count))
      fatalError()
    case .error(let e):
      return .error(e)
    }
  }

  private static func splitWhitespace<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    collection: C,
    maxCount: Int
  ) -> [C.SubSequence] where C.Element: UnicodeScalarConvertible {
    var result = [C.SubSequence]()
    var index = collection.startIndex

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Consume whitespaces
      collection.formIndex(after: &index) { Self.isWhitespace(scalar: collection[$0]) }

      if index == collection.endIndex {
        return result
      }

      // Consume group
      let groupStart = index
      collection.formIndex(after: &index) { !Self.isWhitespace(scalar: collection[$0]) }

      let s = collection[groupStart..<index]
      result.append(s)
    }

    if index != collection.endIndex && remainingCount == 0 {
      // Only occurs when maxcount was reached
      // Skip any remaining whitespace and copy to end of string
      collection.formIndex(after: &index) { Self.isWhitespace(scalar: collection[$0]) }

      if index != collection.endIndex {
        result.append(collection[index...])
      }
    }

    return result
  }

  private static func split<C: CollectionBecauseUnicodeScalarsAreNotRandomAccess>(
    collection: C,
    separator: C,
    maxCount: Int
  ) -> [C.SubSequence] where C.Element: Equatable {
    if collection.count < separator.count {
      return [collection.asSubSequence]
    }

    var result = [C.SubSequence]()
    var index = collection.startIndex

    var remainingCount = maxCount
    while remainingCount > 0 {
      defer { remainingCount -= 1 }

      // Advance index until the end of the group
      let groupStart = index
      collection.formIndex(after: &index) { !collection[$0...].starts(with: separator) }

      result.append(collection[groupStart..<index])

      if index == collection.endIndex {
        return result
      }

      // Move index after `sep`
      index = collection.index(index, offsetBy: separator.count)
    }

    if index != collection.endIndex && remainingCount == 0 {
      result.append(collection[index...])
    }

    return result
  }
*/
  // MARK: - RSplit

  // MARK: - Parse arguments

  private static func parseSplitMaxCount(_ maxCount: PyObject?) -> PyResult<Int> {
    guard let maxCount = maxCount else {
      return .value(Int.max)
    }

    guard let pyInt = PyCast.asInt(maxCount) else {
      return .typeError("maxsplit must be int, not \(maxCount.typeName)")
    }

    guard let int = Int(exactly: pyInt.value) else {
      return .overflowError("maxsplit is too big")
    }

    return .value(int < 0 ? Int.max : int)
  }

  private enum Separator<C: Collection> {
    case whitespace
    case some(C)
    case error(PyBaseException)
  }

  private static func parseSeparator<C: Collection>(
    typeName: String,
    separator object: PyObject?,
    getCollection: ObjectToCollectionFn<C>
  ) -> Separator<C> {
    guard let object = object else {
      return .whitespace
    }

    if object.isNone {
      return .whitespace
    }

    switch getCollection(object) {
    case .value(let sep):
      if sep.isEmpty {
        return .error(Py.newValueError(msg: "empty separator"))
      }

      return .some(sep)

    case .notCollection:
      let msg = "sep must be \(typeName) or None, not \(object.typeName)"
      return .error(Py.newTypeError(msg: msg))

    case .error(let e):
      return .error(e)
    }
  }
}
