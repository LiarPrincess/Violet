/* MARKER
// We can't use the 'GetItemHelper' because 'String.UnicodeScalarView' does not
// conform to 'RandomAccessCollection'.

extension PyString {

  /// DO NOT USE! This is a helper method!
  internal func _getItem(index indexObject: PyObject) -> PyResult<PyObject> {
    switch IndexHelper.int(indexObject, onOverflow: .indexError) {
    case .value(let index):
      switch self._getItem(index: index) {
      case let .value(element):
        let resultObject = Self._toObject(element: element)
        return .value(resultObject)
      case let .error(e):
        return .error(e)
      }
    case .notIndex:
      break // Try slice
    case let .overflow(_, lazyError):
      let e = lazyError.create()
      return .error(e)
    case .error(let e):
      return .error(e)
    }

    if let slice = PyCast.asSlice(indexObject) {
      switch self._getSlice(slice: slice) {
      case let .value(builder):
        let result = builder.finalize()
        let resultObject = Self._toObject(result: result)
        return .value(resultObject)
      case let .error(e):
        return .error(e)
      }
    }

    let t = Self._pythonTypeName
    let indexType = indexObject.typeName
    return .typeError("\(t) indices must be integers or slices, not \(indexType)")
  }

  // MARK: - Item

  private func _getItem(index indexInt: Int) -> PyResult<Element> {
    var offset = indexInt
    if offset < 0 {
      offset += self.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= offset && offset < self.count else {
      return .indexError("\(Self._pythonTypeName) index out of range")
    }

    self._wouldBeBetterWithRandomAccessCollection()
    let indexOrNil = self.elements.index(self.elements.startIndex,
                                         offsetBy: offset,
                                         limitedBy: self.elements.endIndex)

    guard let index = indexOrNil else {
      return .indexError("\(Self._pythonTypeName) index out of range")
    }

    let result = self.elements[index]
    return .value(result)
  }

  // MARK: - Slice

   private func _getSlice(slice: PySlice) -> PyResult<Builder> {
    switch slice.unpack() {
    case let .value(u):
      let indices = u.adjust(toCount: self.count)
      return self._getSlice(start: indices.start,
                            step: indices.step,
                            count: indices.count)

    case let .error(e):
      return .error(e)
    }
  }

  private func _getSlice(start: Int,
                         step: Int,
                         count: Int) -> PyResult<Builder> {
    var builder = Builder(capacity: count)

    // swiftlint:disable:next empty_count
    if count <= 0 {
      return .value(builder)
    }

    if step == 0 {
      return .valueError("slice step cannot be zero")
    }

    if step == 1 {
      let result = self.elements.dropFirst(start).prefix(count)
      builder.append(contentsOf: result)
      return .value(builder)
    }

    self._wouldBeBetterWithRandomAccessCollection()
    guard var index = self.elements.index(self.elements.startIndex,
                                          offsetBy: start,
                                          limitedBy: self.elements.endIndex) else {
      return .value(builder)
    }

    let stepLimit = step > 0 ? self.elements.endIndex : self.elements.startIndex
    for _ in 0..<count {
      builder.append(element: self.elements[index])

      guard let newIndex = self.elements.index(index,
                                               offsetBy: step,
                                               limitedBy: stepLimit) else {
        return .value(builder)
      }

      index = newIndex
    }

    return .value(builder)
  }
}

*/