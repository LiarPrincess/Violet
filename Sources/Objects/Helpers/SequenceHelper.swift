import Core

// swiftlint:disable file_length

internal enum SequenceHelper {

  // MARK: - Equatable

  internal static func isEqual(context: PyContext,
                               left: [PyObject],
                               right: [PyObject]) -> PyResultOrNot<Bool> {
    guard left.count == right.count else {
      return .value(false)
    }

    for (l, r) in zip(left, right) {
      switch context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return .value(false)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(true)
  }

  // MARK: - Comparable

  internal static func isLess(context: PyContext,
                              left: [PyObject],
                              right: [PyObject]) -> PyResultOrNot<Bool> {
    for (l, r) in zip(left, right) {
      switch context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return context.isLess(left: l, right: r)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(left.count < right.count)
  }

  internal static func isLessEqual(context: PyContext,
                                   left: [PyObject],
                                   right: [PyObject]) -> PyResultOrNot<Bool> {
    for (l, r) in zip(left, right) {
      switch context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return context.isLessEqual(left: l, right: r)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(left.count <= right.count)
  }

  internal static func isGreater(context: PyContext,
                                 left: [PyObject],
                                 right: [PyObject]) -> PyResultOrNot<Bool> {
    for (l, r) in zip(left, right) {
      switch context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return context.isGreater(left: l, right: r)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(left.count > right.count)
  }

  internal static func isGreaterEqual(context: PyContext,
                                      left: [PyObject],
                                      right: [PyObject]) -> PyResultOrNot<Bool> {
    for (l, r) in zip(left, right) {
      switch context.isEqual(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return context.isGreaterEqual(left: l, right: r)
      case .error(let msg): return .error(msg)
      case .notImplemented: return .notImplemented
      }
    }

    return .value(left.count >= right.count)
  }

  // MARK: - Contains

  internal static func contains(context: PyContext,
                                elements: [PyObject],
                                element: PyObject) -> Bool {
    for e in elements {
      switch context.isEqual(left: e, right: element) {
      case .value(true):
        return true
      case .value(false),
           .error,
           .notImplemented:
        break // go to next element
      }
    }

    return false
  }

  // MARK: - Extract index

  internal enum ExtractIndexResult {
    case none
    case int(Int)
    case notIndex
  }

  internal static func extractIndex2(_ value: PyObject) -> ExtractIndexResult {
    fatalError()
  }

  /// PyLong_FromSsize_t
  /// _PyEval_SliceIndex
  /// _PyEval_SliceIndexNotNone
  internal static func extractIndex(_ value: PyObject) -> BigInt? {
//    guard let indexType = value.type as? IndexConvertibleTypeClass else {
//      return nil
//    }

//    return indexType.asIndex()
    fatalError()
  }

  // MARK: - Get item

  internal enum GetItemResult<E> {
    case single(E)
    case slice([E])
    case error(PyErrorEnum)
  }

  internal static func getItem<C: Collection>(
    context: PyContext,
    elements: C,
    index: PyObject,
    typeName: String) -> GetItemResult<C.Element> {

    if let index = extractIndex(index) {
      let item = getSingleItem(context: context,
                               elements: elements,
                               index: index,
                               typeName: typeName)
      switch item {
      case let .value(v): return .single(v)
      case let .error(e): return .error(e)
      }
    }

    if let slice = index as? PySlice {
      switch getSliceItem(context: context, elements: elements, slice: slice) {
      case let .value(v): return .slice(v)
      case let .error(e): return .error(e)
      }
    }

    return .error(
      .typeError("\(typeName) indices must be integers or slices, not \(index.typeName)")
    )
  }

  internal static func getSingleItem<C: Collection>(
    context: PyContext,
    elements: C,
    index: BigInt,
    typeName: String) -> PyResult<C.Element> {

    var index = index
    if index < 0 {
      index += BigInt(elements.count)
    }

    let start = elements.startIndex
    let end = elements.endIndex

    guard let int = Int(exactly: index),
          let i = elements.index(start, offsetBy: int, limitedBy: end) else {
      return .error(.indexError("\(typeName) index out of range"))
    }

    return .value(elements[i])
  }

  internal static func getSliceItem<C: Collection>(
    context: PyContext,
    elements: C,
    slice: PySlice) -> PyResult<[C.Element]> {

    let unpack: PySlice.UnpackedIndices
    switch slice.unpack() {
    case let .value(v): unpack = v
    case let .error(e): return .error(e)
    }

    let adjusted = slice.adjust(unpack, toLength: elements.count)
    if adjusted.length <= 0 {
      return .value([])
    }

    if adjusted.step == 0 {
      return .error(.valueError("slice step cannot be zero"))
    }

    if adjusted.step == 1 {
      let result = elements.dropFirst(adjusted.start).prefix(adjusted.length)
      return .value(Array(result))
    }

    guard var index = elements.index(elements.startIndex,
                                     offsetBy: adjusted.start,
                                     limitedBy: elements.endIndex) else {
      return .value([])
    }

    var result = [C.Element]()
    for _ in 0..<adjusted.length {
      result.append(elements[index])

      let limit = adjusted.step > 0 ? elements.endIndex : elements.startIndex
      guard let newIndex = elements.index(index,
                                          offsetBy: adjusted.step,
                                          limitedBy: limit) else {
        return .value(result)
      }

      index = newIndex
    }

    return .value(result)
  }

  // MARK: - Count

  internal static func count(context: PyContext,
                             elements: [PyObject],
                             element: PyObject) -> PyResult<BigInt> {
    var result: BigInt = 0

    for e in elements {
      switch context.isEqual(left: e, right: element) {
      case .value(true):
        result += 1
      case .value(false),
           .error,
           .notImplemented:
        break // go to next element
      }
    }

    return .value(result)
  }

  // MARK: - Get index

  internal static func getIndex(context: PyContext,
                                elements: [PyObject],
                                element: PyObject,
                                typeName: String) -> PyResult<BigInt> {
    for (index, e) in elements.enumerated() {
      switch context.isEqual(left: e, right: element) {
      case .value(true):
        return .value(BigInt(index))
      case .value(false),
           .error,
           .notImplemented:
        break // go to next element
      }
    }

    return .error(.valueError("\(typeName).index(x): x not in \(typeName)"))
  }

  // MARK: - Mul

  internal static func mul(elements: [PyObject],
                           count: PyObject) -> PyResultOrNot<[PyObject]> {
    guard let countInt = count as? PyInt else {
      return .notImplemented
    }

    return mul(elements: elements, count: countInt)
  }

  internal static func mul(elements: [PyObject],
                           count: PyInt) -> PyResultOrNot<[PyObject]> {
    let count = max(count.value, 0)

    // swiftlint:disable:next empty_count
    if count == 0 {
      return .value([])
    }

    if count == 1 {
      return .value(elements) // avoid copy
    }

    var i: BigInt = 0
    var result = [PyObject]()
    while i < count {
      result.append(contentsOf: elements)
      i += 1
    }

    return .value(result)
  }

  internal static func rmul(elements: [PyObject],
                            count: PyObject) -> PyResultOrNot<[PyObject]> {
    guard let countInt = count as? PyInt else {
      return .notImplemented
    }

    return mul(elements: elements, count: countInt)
  }
}
