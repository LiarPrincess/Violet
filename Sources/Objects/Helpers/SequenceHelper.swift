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
      switch context.builtins.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Comparable

  internal static func isLess(context: PyContext,
                              left: [PyObject],
                              right: [PyObject]) -> PyResultOrNot<Bool> {
    for (l, r) in zip(left, right) {
      // Find 1st not equal element
      switch context.builtins.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false):
        let result = context.builtins.isLessBool(left: l, right: r)
        return SequenceHelper.toCompareResult(result)
      case .error(let e): return .error(e)
      }
    }

    return .value(left.count < right.count)
  }

  internal static func isLessEqual(context: PyContext,
                                   left: [PyObject],
                                   right: [PyObject]) -> PyResultOrNot<Bool> {
    for (l, r) in zip(left, right) {
      // Find 1st not equal element
      switch context.builtins.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false):
        let result = context.builtins.isLessEqualBool(left: l, right: r)
        return SequenceHelper.toCompareResult(result)
      case .error(let e): return .error(e)
      }
    }

    return .value(left.count <= right.count)
  }

  internal static func isGreater(context: PyContext,
                                 left: [PyObject],
                                 right: [PyObject]) -> PyResultOrNot<Bool> {
    for (l, r) in zip(left, right) {
      // Find 1st not equal element
      switch context.builtins.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false):
        let result = context.builtins.isGreaterBool(left: l, right: r)
        return SequenceHelper.toCompareResult(result)
      case .error(let e): return .error(e)
      }
    }

    return .value(left.count > right.count)
  }

  internal static func isGreaterEqual(context: PyContext,
                                      left: [PyObject],
                                      right: [PyObject]) -> PyResultOrNot<Bool> {
    for (l, r) in zip(left, right) {
      // Find 1st not equal element
      switch context.builtins.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false):
        let result = context.builtins.isGreaterEqualBool(left: l, right: r)
        return SequenceHelper.toCompareResult(result)
      case .error(let e): return .error(e)
      }
    }

    return .value(left.count >= right.count)
  }

  private static func toCompareResult(_ value: PyResult<Bool>) -> PyResultOrNot<Bool> {
    switch value {
    case let .value(b):
      return .value(b)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Contains

  internal static func contains(context: PyContext,
                                elements: [PyObject],
                                element: PyObject) -> Bool {
    for e in elements {
      switch context.builtins.isEqualBool(left: e, right: element) {
      case .value(true): return true
      case .value(false), .error: break // go to next element
      }
    }

    return false
  }

  // MARK: - Extract index

  internal enum GetIndexResult<T> {
    case value(T)
    case notIndex
    case error(PyErrorEnum)
  }

  /// Py_ssize_t PyNumber_AsSsize_t(PyObject *item, PyObject *err)
  /// _PyEval_SliceIndexNotNone
  internal static func tryGetIndex(_ value: PyObject) -> GetIndexResult<Int> {
    let bigInt: BigInt
    switch getIndexBigInt(value) {
    case .value(let v): bigInt = v
    case .notIndex: return .notIndex
    case .error(let e): return .error(e)
    }

    if let int = Int(exactly: bigInt) {
      return .value(int)
    }

    return .error(
      .indexError("cannot fit '\(value.typeName)' into an index-sized integer")
    )
  }

  /// Basically `SequenceHelper.tryGetIndex`, but it will return type error
  /// if the value cannot be converted to index.
  internal static func getIndex(_ value: PyObject) -> PyResult<Int> {
    switch SequenceHelper.tryGetIndex(value) {
    case .value(let v):
      return .value(v)
    case .notIndex:
      let msg = "'\(value.typeName)' object cannot be interpreted as an integer"
      return .error(.typeError(msg))
    case .error(let e):
      return .error(e)
    }
  }

  /// Return a Python int from the object item.
  /// Raise TypeError if the result is not an int
  /// or if the object cannot be interpreted as an index.
  ///
  /// PyObject * PyNumber_Index(PyObject *item)
  private static func getIndexBigInt(_ value: PyObject) -> GetIndexResult<BigInt> {
    if let int = value as? PyInt {
      return .value(int.value)
    }

    if let indexOwner = value as? __index__Owner {
      return .value(indexOwner.asIndex())
    }

    switch value.builtins.callMethod(on: value, selector: "__index__") {
    case .value(let object):
      guard let int = object as? PyInt else {
        let msg = "__index__ returned non-int (type \(object.typeName)"
        return .error(.typeError(msg))
      }
      return .value(int.value)

    case .noSuchMethod,
         .notImplemented:
      return .notIndex
    case .methodIsNotCallable(let e),
         .error(let e):
      return .error(e)
    }
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

    switch SequenceHelper.tryGetIndex(index) {
    case .value(let index):
      switch getSingleItem(elements: elements, index: index, typeName: typeName) {
      case let .value(v): return .single(v)
      case let .error(e): return .error(e)
      }
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      switch getSliceItem(context: context, elements: elements, slice: slice) {
      case let .value(v): return .slice(v)
      case let .error(e): return .error(e)
      }
    }

    return .error(
      .typeError(
        "\(typeName) indices must be integers or slices, not \(index.typeName)"
      )
    )
  }

  internal static func getSingleItem<C: Collection>(
    elements: C,
    index: Int,
    typeName: String) -> PyResult<C.Element> {

    var index = index
    if index < 0 {
      index += elements.count
    }

    let start = elements.startIndex
    let end = elements.endIndex

    guard let i = elements.index(start, offsetBy: index, limitedBy: end) else {
      return .indexError("\(typeName) index out of range")
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
      return .valueError("slice step cannot be zero")
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
      switch context.builtins.isEqualBool(left: e, right: element) {
      case .value(true): result += 1
      case .value(false): break // go to next element
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Get index

  internal static func index(context: PyContext,
                             elements: [PyObject],
                             element: PyObject,
                             typeName: String) -> PyResult<BigInt> {
    for (index, e) in elements.enumerated() {
      switch context.builtins.isEqualBool(left: e, right: element) {
      case .value(true):
        return .value(BigInt(index))
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    return .valueError("\(typeName).index(x): x not in \(typeName)")
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
