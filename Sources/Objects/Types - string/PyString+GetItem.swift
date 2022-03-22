// We can't use the 'GetItemHelper' because 'String.UnicodeScalarView' does not
// conform to 'RandomAccessCollection'.

extension PyString {

  internal static func getItem(_ py: Py,
                               zelf: PyString,
                               index indexObject: PyObject) -> PyResult {
    switch IndexHelper.int(py, object: indexObject, onOverflow: .indexError) {
    case .value(let index):
      switch Self.getItem(py, zelf: zelf, index: index) {
      case let .value(element):
        let resultObject = Self.newObject(py, element: element)
        return PyResult(resultObject)
      case let .error(e):
        return .error(e)
      }

    case .notIndex:
      break // Try slice
    case let .overflow(_, lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case .error(let e):
      return .error(e)
    }

    if let slice = py.cast.asSlice(indexObject) {
      switch Self.getSlice(py, zelf: zelf, slice: slice) {
      case let .value(builder):
        let result = builder.finalize()
        let resultObject = Self.newObject(py, result: result)
        return PyResult(resultObject)
      case let .error(e):
        return .error(e)
      }
    }

    let t = Self.pythonTypeName
    let indexType = indexObject.typeName
    let message = "\(t) indices must be integers or slices, not \(indexType)"
    return .typeError(py, message: message)
  }

  // MARK: - Item

  private static func getItem(_ py: Py,
                              zelf: PyString,
                              index indexArg: Int) -> PyResultGen<Element> {
    var offset = indexArg
    if offset < 0 {
      offset += zelf.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= offset && offset < zelf.count else {
      return .indexError(py, message: "\(Self.pythonTypeName) index out of range")
    }

    Self.wouldBeBetterWithRandomAccessCollection()
    let indexOrNil = zelf.elements.index(zelf.elements.startIndex,
                                         offsetBy: offset,
                                         limitedBy: zelf.elements.endIndex)

    guard let index = indexOrNil else {
      return .indexError(py, message: "\(Self.pythonTypeName) index out of range")
    }

    let result = zelf.elements[index]
    return .value(result)
  }

  // MARK: - Slice

  private static func getSlice(_ py: Py,
                               zelf: PyString,
                               slice: PySlice) -> PyResultGen<Builder> {
    switch slice.unpack(py) {
    case let .value(u):
      let indices = u.adjust(toCount: zelf.count)
      return Self.getSlice(py,
                           zelf: zelf,
                           start: indices.start,
                           step: indices.step,
                           count: indices.count)

    case let .error(e):
      return .error(e)
    }
  }

  private static func getSlice(_ py: Py,
                               zelf: PyString,
                               start: Int,
                               step: Int,
                               count: Int) -> PyResultGen<Builder> {
    var builder = Builder(capacity: count)

    // swiftlint:disable:next empty_count
    if count <= 0 {
      return .value(builder)
    }

    if step == 0 {
      return .valueError(py, message: "slice step cannot be zero")
    }

    if step == 1 {
      let result = zelf.elements.dropFirst(start).prefix(count)
      builder.append(contentsOf: result)
      return .value(builder)
    }

    Self.wouldBeBetterWithRandomAccessCollection()
    guard var index = zelf.elements.index(zelf.elements.startIndex,
                                          offsetBy: start,
                                          limitedBy: zelf.elements.endIndex) else {
      return .value(builder)
    }

    let stepLimit = step > 0 ? zelf.elements.endIndex : zelf.elements.startIndex
    for _ in 0..<count {
      builder.append(element: zelf.elements[index])

      guard let newIndex = zelf.elements.index(index,
                                               offsetBy: step,
                                               limitedBy: stepLimit) else {
        return .value(builder)
      }

      index = newIndex
    }

    return .value(builder)
  }
}
