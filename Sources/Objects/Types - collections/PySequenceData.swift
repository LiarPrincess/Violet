import Core

// swiftlint:disable file_length
// swiftlint:disable yoda_condition

/// Main logic for Python sequences.
/// Used in `PyTuple` and `PyList`.
internal struct PySequenceData {

  internal private(set) var elements: [PyObject]

  internal init() {
    self.elements = []
  }

  internal init(elements: [PyObject]) {
    self.elements = elements
  }

  // MARK: - Equatable

  internal func isEqual(to other: PySequenceData) -> PyResult<Bool> {
    guard self.count == other.count else {
      return .value(false)
    }

    for (l, r) in zip(self.elements, other.elements) {
      switch l.builtins.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Comparable

  internal func isLess(than other: PySequenceData) -> PyResult<Bool> {
    switch self.getFirstNotEqualElement(with: other) {
    case let .elements(selfElement: l, otherElement: r):
      return l.builtins.isLessBool(left: l, right: r)
    case .allEqualUpToShorterCount:
      return .value(self.count < other.count)
    case let .error(e):
      return .error(e)
    }
  }

  internal func isLessEqual(than other: PySequenceData) -> PyResult<Bool> {
    switch self.getFirstNotEqualElement(with: other) {
    case let .elements(selfElement: l, otherElement: r):
      return l.builtins.isLessEqualBool(left: l, right: r)
    case .allEqualUpToShorterCount:
      return .value(self.count <= other.count)
    case let .error(e):
      return .error(e)
    }
  }

  internal func isGreater(than other: PySequenceData) -> PyResult<Bool> {
    switch self.getFirstNotEqualElement(with: other) {
    case let .elements(selfElement: l, otherElement: r):
      return l.builtins.isGreaterBool(left: l, right: r)
    case .allEqualUpToShorterCount:
      return .value(self.count > other.count)
    case let .error(e):
      return .error(e)
    }
  }

  internal func isGreaterEqual(than other: PySequenceData) -> PyResult<Bool> {
    switch self.getFirstNotEqualElement(with: other) {
    case let .elements(selfElement: l, otherElement: r):
      return l.builtins.isGreaterEqualBool(left: l, right: r)
    case .allEqualUpToShorterCount:
      return .value(self.count >= other.count)
    case let .error(e):
      return .error(e)
    }
  }

  private enum FistNotEqualElements {
    case elements(selfElement: PyObject, otherElement: PyObject)
    case allEqualUpToShorterCount
    case error(PyErrorEnum)
  }

  private func getFirstNotEqualElement(with other: PySequenceData) -> FistNotEqualElements {
    for (l, r) in zip(self.elements, other.elements) {
      switch l.builtins.isEqualBool(left: l, right: r) {
      case .value(true):
        break // go to next element
      case .value(false):
        return .elements(selfElement: l, otherElement: r)
      case .error(let e):
        return .error(e)
      }
    }

    return .allEqualUpToShorterCount
  }

  // MARK: - String

  internal func repr(openBrace: String,
                     closeBrace: String) -> PyResult<String> {

    if self.isEmpty {
      return .value(openBrace + closeBrace) // '[]'
    }

    var result = openBrace // start with '['
    for (index, element) in self.elements.enumerated() {
      if index > 0 {
        result += ", " // so that we don't have ', )'.
      }

      switch element.builtins.repr(element) {
      case let .value(s): result += s
      case let .error(e): return .error(e)
      }
    }

    if self.count > 1 {
      result += ","
    }

    result += closeBrace
    return .value(result)
  }

  // MARK: - Length

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var count: Int {
  return self.elements.count
  }

  // MARK: - Contains

  internal func contains(value: PyObject) -> PyResult<Bool> {
    for element in self.elements {
      switch element.builtins.isEqualBool(left: element, right: value) {
      case .value(true):
        return .value(true)
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    return .value(false)
  }

  // MARK: - Get item

  internal enum GetItemResult {
    case single(PyObject)
    case slice([PyObject])
    case error(PyErrorEnum)
  }

  internal func getItem(index: PyObject, typeName: String) -> GetItemResult {
    switch SequenceHelper.tryGetIndex(index) {
    case .value(let index):
      switch self.getSingleItem(index: index, typeName: typeName) {
      case let .value(v): return .single(v)
      case let .error(e): return .error(e)
      }
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      switch self.getSliceItem(slice: slice) {
      case let .value(v): return .slice(v)
      case let .error(e): return .error(e)
      }
    }

    let msg = "\(typeName) indices must be integers or slices, not \(index.typeName)"
    return .error(.typeError(msg))
  }

  private func getSingleItem(index: Int, typeName: String) -> PyResult<PyObject> {
    var index = index
    if index < 0 {
      index += self.count
    }

    guard 0 <= index && index < self.count else {
      return .indexError("\(typeName) index out of range")
    }

    return .value(self.elements[index])
  }

  private func getSliceItem(slice: PySlice) -> PyResult<[PyObject]> {
    let unpack: PySlice.UnpackedIndices
    switch slice.unpack() {
    case let .value(v): unpack = v
    case let .error(e): return .error(e)
    }

    let adjusted = slice.adjust(unpack, toLength: self.count)
    if adjusted.length <= 0 {
      return .value([])
    }

    if adjusted.step == 0 {
      return .valueError("slice step cannot be zero")
    }

    if adjusted.step == 1 {
      let result = self.elements.dropFirst(adjusted.start).prefix(adjusted.length)
      return .value(Array(result))
    }

    var result = [PyObject]()
    for i in 0..<adjusted.length {
      let index = adjusted.start + i * adjusted.step

      guard 0 <= index && index < self.count else {
        return .value(result)
      }

      result.append(self.elements[index])
    }

    return .value(result)
  }

  // MARK: - Count

  internal func count(element: PyObject) -> PyResult<Int> {
    var result = 0

    for e in self.elements {
      switch e.builtins.isEqualBool(left: e, right: element) {
      case .value(true): result += 1
      case .value(false): break // go to next element
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Get index

  internal func index(of element: PyObject, typeName: String) -> PyResult<Int> {
    for (index, e) in self.elements.enumerated() {
      switch e.builtins.isEqualBool(left: e, right: element) {
      case .value(true):
        return .value(index)
      case .value(false):
        break // go to next element
      case .error(let e):
        return .error(e)
      }
    }

    return .valueError("\(typeName).index(x): x not in \(typeName)")
  }

  // MARK: - Append

  internal mutating func append(_ element: PyObject) {
    self.elements.append(element)
  }

  // MARK: - Add

  internal func add(other: PySequenceData) -> [PyObject] {
    return self.elements + other.elements
  }

  // MARK: - Mul

  internal func mul(count: PyObject) -> PyResultOrNot<[PyObject]> {
    guard let countInt = count as? PyInt else {
      return .notImplemented
    }

    return mul(count: countInt)
  }

  private func mul(count: PyInt) -> PyResultOrNot<[PyObject]> {
    let count = max(count.value, 0)

    // swiftlint:disable:next empty_count
    if count == 0 {
      return .value([])
    }

    if count == 1 {
      return .value(self.elements) // avoid copy
    }

    var i: BigInt = 0
    var result = [PyObject]()
    while i < count {
      result.append(contentsOf: self.elements)
      i += 1
    }

    return .value(result)
  }

  internal func rmul(count: PyObject) -> PyResultOrNot<[PyObject]> {
    guard let countInt = count as? PyInt else {
      return .notImplemented
    }

    return mul(count: countInt)
  }

  // MARK: - Clear

  internal mutating func clear() {
    self.elements.removeAll()
  }

  // MARK: - Pop

  internal mutating func pop(at index: BigInt,
                             typeName: String) -> PyResult<PyObject> {
    if self.isEmpty {
      return .indexError("pop from empty \(typeName)")
    }

    var index = index
    if index < 0 {
      index += BigInt(self.count)
    }

    guard let indexInt = Int(exactly: index) else {
      return .indexError("pop index out of range")
    }

    guard 0 <= indexInt && indexInt < self.count else {
      return .indexError("pop index out of range")
    }

    let result = self.elements.remove(at: indexInt)
    return .value(result)
  }
}
