import Core

// swiftlint:disable yoda_condition

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
      let isEqual = context.isEqual(left: e, right: element)
      switch isEqual {
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

  /// PyLong_FromSsize_t
  internal static func extractIndex(_ value: PyObject) -> BigInt? {
//    guard let indexType = value.type as? IndexConvertibleTypeClass else {
//      return nil
//    }

//    return indexType.asIndex()
    fatalError()
  }

  // MARK: - Get item

  internal static func getItem(context: PyContext,
                               elements: [PyObject],
                               index: PyObject,
                               canIndexFromEnd: Bool,
                               typeName: String) -> PyResult<PyObject> {
    if let index = extractIndex(index) {
      return getItem(context: context,
                     elements: elements,
                     index: index,
                     canIndexFromEnd: canIndexFromEnd,
                     typeName: typeName)
    }

    if let slice = index as? PySlice {
      return SequenceHelper
        .getItem(context: context, elements: elements, slice: slice)
        .map(context._tuple)
        .flatMap { PyResult<PyObject>.value($0) }
    }

    return .error(
      .typeError("\(typeName) indices must be integers or slices, not \(index.typeName)")
    )
  }

  /// Use `canIndexFromEnd` for `tuple[-1]`.
  internal static func getItem(context: PyContext,
                               elements: [PyObject],
                               index: PyInt,
                               canIndexFromEnd: Bool,
                               typeName: String) -> PyResult<PyObject> {
    return getItem(context: context,
                   elements: elements,
                   index: index.value,
                   canIndexFromEnd: canIndexFromEnd,
                   typeName: typeName)
  }

  /// Use `canIndexFromEnd` for `tuple[-1]`.
  internal static func getItem(context: PyContext,
                               elements: [PyObject],
                               index: BigInt,
                               canIndexFromEnd: Bool,
                               typeName: String) -> PyResult<PyObject> {
    var index = index
    if index < 0, canIndexFromEnd {
      index += BigInt(elements.count)
    }

    guard let indexInt = Int(exactly: index) else {
      return .error(.indexError("\(typeName) index out of range"))
    }

    guard 0 <= indexInt && indexInt < elements.count else {
      return .error(.indexError("\(typeName) index out of range"))
    }

    return .value(elements[indexInt])
  }

  internal static func getItem(context: PyContext,
                               elements: [PyObject],
                               slice: PySlice) -> PyResult<[PyObject]> {
    let count = elements.count
    let adjusted = GeneralHelpers.adjustIndices(value: slice, to: count)

    if adjusted.length <= 0 {
      return .value([])
    }

    // Small otimization, so we don't allocate new object
    if adjusted.start == 0 && adjusted.step == 1 && adjusted.length == count {
      return .value(elements)
    }

    // TODO: RustPython does it differently (objsequence -> fn get_slice_items)
    var elements = [PyObject]()
    for i in 0..<adjusted.length {
      let index = adjusted.start + i * adjusted.step
      elements.append(elements[index])
    }

    return .value(elements)
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
