extension AbstractString {

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _partition(separator: PyObject) -> PyResult<PyTuple> {
    return self._template(separator: separator,
                          findSeparator: self._findImpl(value:),
                          isReverse: false)
  }

  /// DO NOT USE! This is a part of `AbstractString` implementation
  internal func _rpartition(separator: PyObject) -> PyResult<PyTuple> {
    return self._template(separator: separator,
                          findSeparator: self._rfindImpl(value:),
                          isReverse: true)
  }

  private func _template(
    separator separatorObject: PyObject,
    findSeparator: (Elements) -> AbstractString_FindResult<Elements>,
    isReverse: Bool
  ) -> PyResult<PyTuple> {
    guard let separator = Self._getElements(object: separatorObject) else {
      let t = Self._pythonTypeName
      let separatorType = separatorObject.typeName
      return .typeError("sep must be \(t)-like object, not \(separatorType)")
    }

    if separator.isEmpty {
      return .valueError("empty separator")
    }

    let findResult = findSeparator(separator)
    switch findResult {
    case let .index(index: index1, position: _):
      // before | index1 | separator | index2 | after
      let separatorCount = separator.count
      let endIndex = self.elements.endIndex
      let index2 = self.elements.index(index1,
                                       offsetBy: separatorCount,
                                       limitedBy: endIndex) ?? endIndex

      self._wouldBeBetterWithRandomAccessCollection()
      let before = self.elements[self.elements.startIndex..<index1]
      let after = self.elements[index2..<self.elements.endIndex]

      let beforeObject = Self._toObject(elements: before)
      let afterObject = Self._toObject(elements: after)
      let result = Py.newTuple(elements: beforeObject, separatorObject, afterObject)
      return .value(result)

    case .notFound:
      let empty = Self._getEmptyObject()
      let result = isReverse ?
        Py.newTuple(elements: empty, empty, self) :
        Py.newTuple(elements: self, empty, empty)

      return .value(result)
    }
  }
}
