// MARK: - Get item

internal enum StringGetItemResult<Item, Slice> {
  case item(Item)
  case slice(Slice)
  case error(PyBaseException)
}

extension PyStringImpl {

  internal func getItem(index: PyObject) -> StringGetItemResult<Element, Builder.Result> {
    switch IndexHelper.int(index, onOverflow: .indexError) {
    case .value(let index):
      switch self.getItem(index: index) {
      case let .value(r): return .item(r)
      case let .error(e): return .error(e)
      }
    case .notIndex:
      break // Try slice
    case .error(let e),
         .overflow(_, let e):
      return .error(e)
    }

    if let slice = PyCast.asSlice(index) {
      switch self.getSlice(slice: slice) {
      case let .value(r): return .slice(r)
      case let .error(e): return .error(e)
      }
    }

    let t = index.typeName
    let msg = "\(Self.typeName) indices must be integers or slices, not \(t)"
    return .error(Py.newTypeError(msg: msg))
  }

  internal func getItem(index: Int) -> PyResult<Element> {
    var offset = index
    if offset < 0 {
      offset += self.count
    }

    // swiftlint:disable:next yoda_condition
    guard 0 <= offset && offset < self.count else {
      return .indexError("\(Self.typeName) index out of range")
    }

    let indexOrNil = self.index(self.startIndex,
                                offsetBy: offset,
                                limitedBy: self.endIndex)

    guard let index = indexOrNil else {
      return .indexError("\(Self.typeName) index out of range")
    }

    return .value(self[index])
  }

  private func getSlice(slice: PySlice) -> PyResult<Builder.Result> {
    switch slice.unpack() {
    case let .value(u):
      let indices = u.adjust(toCount: self.count)
      return self.getSlice(start: indices.start,
                           step: indices.step,
                           count: indices.count)

    case let .error(e):
      return .error(e)
    }
  }

  internal func getSlice(start: Int,
                         step: Int,
                         count: Int) -> PyResult<Builder.Result> {
    var builder = Builder()

    // swiftlint:disable:next empty_count
    if count <= 0 {
      return .value(builder.result)
    }

    if step == 0 {
      return .valueError("slice step cannot be zero")
    }

    if step == 1 {
      let result = self.scalars.dropFirst(start).prefix(count)
      builder.append(contentsOf: result)
      return .value(builder.result)
    }

    guard var index = self.index(self.startIndex,
                                 offsetBy: start,
                                 limitedBy: self.endIndex) else {
      return .value(builder.result)
    }

    for _ in 0..<count {
      builder.append(self[index])

      let limit = step > 0 ? self.endIndex : self.startIndex
      guard let newIndex = self.index(index,
                                      offsetBy: step,
                                      limitedBy: limit) else {
        return .value(builder.result)
      }

      index = newIndex
    }

    return .value(builder.result)
  }
}
