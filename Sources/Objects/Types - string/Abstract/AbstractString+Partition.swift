// swiftlint:disable:next type_name
internal enum AbstractString_PartitionResult<C: Collection> {
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

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _partition(
    separator: PyObject
  ) -> AbstractString_PartitionResult<Elements> {
    return self._template(separator: separator,
                          findSeparator: self._findImpl(value:),
                          isReverse: false)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _rpartition(
    separator: PyObject
  ) -> AbstractString_PartitionResult<Elements> {
    return self._template(separator: separator,
                          findSeparator: self._rfindImpl(value:),
                          isReverse: true)
  }

  private func _template(
    separator separatorObject: PyObject,
    findSeparator: (Elements) -> AbstractString_FindResult<Elements>,
    isReverse: Bool
  ) -> AbstractString_PartitionResult<Elements> {
    guard let separator = Self._getElements(object: separatorObject) else {
      let t = Self._pythonTypeName
      let st = separatorObject.typeName
      return .error(Py.newTypeError(msg: "sep must be \(t)-like object, not \(st)"))
    }

    if separator.isEmpty {
      return .error(Py.newValueError(msg: "empty separator"))
    }

    let findResult = findSeparator(separator)
    switch findResult {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let endIndex = self.elements.endIndex
      let index2 = self.elements.index(index1,
                                       offsetBy: separator.count,
                                       limitedBy: endIndex) ?? endIndex

      self._wouldBeBetterWithRandomAccessCollection()
      let before = self.elements[self.elements.startIndex..<index1]
      let after = self.elements[index2..<self.elements.endIndex]

      return .separatorFound(before: before, separator: separator, after: after)

    case .notFound:
      return .separatorNotFound
    }
  }
}
