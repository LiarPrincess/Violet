import Foundation

extension StringImplementation {

  // MARK: - Split lines

  private static let splitLinesArguments = ArgumentParser.createOrTrap(
    arguments: ["keepends"],
    format: "|O:splitlines"
  )

  internal static func splitLines(scalars: UnicodeScalars,
                                  args: [PyObject],
                                  kwargs: PyDict?) -> PyResult<[UnicodeScalarsSub]> {
    return Self.splitLines(collection: scalars, args: args, kwargs: kwargs)
  }

  internal static func splitLines(data: Data,
                                  args: [PyObject],
                                  kwargs: PyDict?) -> PyResult<[Data]> {
    return Self.splitLines(collection: data, args: args, kwargs: kwargs)
  }

  private static func splitLines<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    collection: C,
    args: [PyObject],
    kwargs: PyDict?
  ) -> PyResult<[C.SubSequence]> where C.Element: UnicodeScalarConvertible {
    switch splitLinesArguments.bind(args: args, kwargs: kwargs) {
    case let .value(binding):
      assert(binding.requiredCount == 0, "Invalid required argument count.")
      assert(binding.optionalCount == 1, "Invalid optional argument count.")

      let keepEnds = binding.optional(at: 0)
      return Self.splitLines(collection: collection, keepEnds: keepEnds)
    case let .error(e):
      return .error(e)
    }
  }

  private static func splitLines<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    collection: C,
    keepEnds: PyObject?
  ) -> PyResult<[C.SubSequence]> where C.Element: UnicodeScalarConvertible {
    guard let keepEnds = keepEnds else {
      let result = Self.splitLines(collection: collection, keepEnds: false)
      return .value(result)
    }

    // `bool` is also `int`
    if let int = PyCast.asInt(keepEnds) {
      let keepEnds = int.value.isTrue
      let result = Self.splitLines(collection: collection, keepEnds: keepEnds)
      return .value(result)
    }

    return .typeError("keepends must be integer or bool, not \(keepEnds.typeName)")
  }

  private static func splitLines<
    C: CollectionBecauseUnicodeScalarsAreNotRandomAccess
  >(
    collection: C,
    keepEnds: Bool
  ) -> [C.SubSequence] where C.Element: UnicodeScalarConvertible {
    var result = [C.SubSequence]()
    var index = collection.startIndex

    while index != collection.endIndex {
      let groupStart = index

      // Advance 'till line break
      collection.formIndex(after: &index) { !Self.isLineBreak(scalar: collection[$0]) }

      // 'index' is either new line or 'endIndex'
      let lineExcludingNewLine = groupStart..<index

      // Consume CRLF as one line break
      if index != collection.endIndex {
        let after = collection.index(after: index)
        if after != collection.endIndex
            && collection[index].asUnicodeScalar == "\r"
            && collection[after].asUnicodeScalar == "\n" {

          index = after
        }
      }

      // Go to the start of the next group
      if index != collection.endIndex {
        collection.formIndex(after: &index)
      }

      // 'index' is either 1st character of next group or end
      let lineIncludingNewLine = groupStart..<index

      let line = keepEnds ? lineIncludingNewLine : lineExcludingNewLine
      result.append(collection[line])
    }

    return result
  }
}
