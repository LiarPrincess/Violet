import VioletCore

internal enum AbstractStringPartitionResult<C: Collection> {
  /// Separator was found.
  ///
  /// Return tuple: `(before, separator, after)`
  case separatorFound(before: C.SubSequence, separator: C, after: C.SubSequence)
  /// Separator was not found
  ///
  /// Return tuple:
  /// - `partition` - `(self, empty, empty)`
  /// - `rpartition`- `(empty, empty, self)`
  case separatorNotFound
  case error(PyBaseException)
}

extension AbstractString {

  internal static func abstractPartition(
    _ py: Py,
    zelf: PyObject,
    separator: PyObject
  ) -> AbstractStringPartitionResult<Elements> {
    return Self.template(py,
                         zelf: zelf,
                         separator: separator,
                         fnName: "partition",
                         findSeparator: Self.findHelper(zelf:value:))
  }

  internal static func abstractRPartition(
    _ py: Py,
    zelf: PyObject,
    separator: PyObject
  ) -> AbstractStringPartitionResult<Elements> {
    return Self.template(py,
                         zelf: zelf,
                         separator: separator,
                         fnName: "rpartition",
                         findSeparator: Self.rfindHelper(zelf:value:))
  }

  private static func template(
    _ py: Py,
    zelf _zelf: PyObject,
    separator separatorObject: PyObject,
    fnName: String,
    findSeparator: (Self, Elements) -> AbstractStringFindResult<Elements>
  ) -> AbstractStringPartitionResult<Elements> {
    guard let zelf = Self.downcast(py, _zelf) else {
      let error = py.newInvalidSelfArgumentError(object: _zelf,
                                                 expectedType: Self.pythonTypeName,
                                                 fnName: fnName)

      return .error(error.asBaseException)
    }

    guard let separator = Self.getElements(py, object: separatorObject) else {
      let t = Self.pythonTypeName
      let st = separatorObject.typeName
      let error = py.newTypeError(message: "sep must be \(t)-like object, not \(st)")
      return .error(error.asBaseException)
    }

    if separator.isEmpty {
      let error = py.newValueError(message: "empty separator")
      return .error(error.asBaseException)
    }

    let findResult = findSeparator(zelf, separator)
    switch findResult {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let endIndex = zelf.elements.endIndex
      let index2 = zelf.elements.index(index1,
                                       offsetBy: separator.count,
                                       limitedBy: endIndex) ?? endIndex

      Self.wouldBeBetterWithRandomAccessCollection()
      let before = zelf.elements[zelf.elements.startIndex..<index1]
      let after = zelf.elements[index2..<zelf.elements.endIndex]

      return .separatorFound(before: before, separator: separator, after: after)

    case .notFound:
      return .separatorNotFound
    }
  }
}
