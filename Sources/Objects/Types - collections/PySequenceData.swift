import Core

// swiftlint:disable file_length
// swiftlint:disable yoda_condition

internal protocol PySequenceType {
  var data: PySequenceData { get }
}

/// Main logic for Python sequences.
/// Used in `PyTuple` and `PyList`.
internal struct PySequenceData {

  internal typealias Elements = [PyObject]
  internal typealias Index = Elements.Index
  internal typealias SubSequence = Elements.SubSequence

  internal private(set) var elements: Elements

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
    case error(PyBaseException)
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

  // MARK: - Hash

  internal var hash: PyResult<PyHash> {
    var x: PyHash = 0x345678
    var mult = Hasher.multiplier

    for e in self.elements {
      switch e.builtins.hash(e) {
      case let .value(y):
        x = (x ^ y) * mult
        mult += 82_520 + PyHash(2 * self.elements.count)
      case let .error(e):
        return .error(e)
      }
    }

    return .value(x + 97_531)
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
    case error(PyBaseException)
  }

  internal func getItem(index: PyObject, typeName: String) -> GetItemResult {
    switch IndexHelper.tryInt(index) {
    case .value(let index):
      switch self.getItem(index: index, typeName: typeName) {
      case let .value(v): return .single(v)
      case let .error(e): return .error(e)
      }
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      switch self.getItem(slice: slice) {
      case let .value(v): return .slice(v)
      case let .error(e): return .error(e)
      }
    }

    let msg = "\(typeName) indices must be integers or slices, not \(index.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  internal func getItem(index: Int, typeName: String) -> PyResult<PyObject> {
    var index = index
    if index < 0 {
      index += self.count
    }

    guard 0 <= index && index < self.count else {
      return .indexError("\(typeName) index out of range")
    }

    return .value(self.elements[index])
  }

  internal func getItem(slice: PySlice) -> PyResult<[PyObject]> {
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

  // MARK: - Set/del item

  internal mutating func setItem(at index: PyObject,
                                 to value: PyObject) -> PyResult<()> {
    // Setting slice is not (yet) implemented

    let parsedIndex: Int
    switch IndexHelper.int(index) {
    case let .value(i): parsedIndex = i
    case let .error(e): return .error(e)
    }

    self.elements[parsedIndex] = value
    return .value()
  }

  internal mutating func delItem(at index: PyObject) -> PyResult<()> {
    let parsedIndex: Int
    switch IndexHelper.int(index) {
    case let .value(i): parsedIndex = i
    case let .error(e): return .error(e)
    }

    _ = self.elements.remove(at: parsedIndex)
    return .value()
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

  internal func index(of element: PyObject,
                      start: PyObject?,
                      end: PyObject?,
                      typeName: String) -> PyResult<Int> {
    let subsequence: SubSequence
    switch self.getSubsequence(start: start, end: end) {
    case let .value(s): subsequence = s
    case let .error(e): return .error(e)
    }

    for (index, e) in subsequence.enumerated() {
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

  // MARK: - Insert

  internal mutating func insert(at index: PyObject,
                                item: PyObject) -> PyResult<()> {
    let parsedIndex: Int
    switch IndexHelper.int(index) {
    case let .value(i): parsedIndex = i
    case let .error(e): return .error(e)
    }

    self.elements.insert(item, at: parsedIndex)
    return .value()
  }

  // MARK: - Remove

  internal mutating func remove(_ value: PyObject) -> PyResult<()> {
    switch self.find(value) {
    case .index(let index):
      self.elements.remove(at: index)
      return .value()

    case .notFound:
      return .valueError("list.remove(x): x not in list")

    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Find

  internal enum FindResult {
    case index(Int)
    case notFound
    case error(PyBaseException)
  }

  internal func find(_ value: PyObject) -> FindResult {
    for (index, element) in self.elements.enumerated() {
      switch element.builtins.isEqualBool(left: element, right: value) {
      case .value(true): return .index(index)
      case .value(false): break // go to next element
      case .error(let e): return .error(e)
      }
    }

    return .notFound
  }

  // MARK: - Extend

  internal mutating func extend(iterable: PyObject) -> PyResult<()> {
    // Fast path: adding tuples, lists
    if let tuple = iterable as? PyTuple {
      self.elements.append(contentsOf: tuple.elements)
      return .value()
    }

    if let list = iterable as? PyList {
      self.elements.append(contentsOf: list.elements)
      return .value()
    }

    // Slow path: iterable
    // Do not modify `self.elements` until we finished iteration.
    let builtins = iterable.builtins
    let d = builtins.reduce(iterable: iterable, into: [PyObject]()) { acc, object in
      acc.append(object)
      return .goToNextElement
    }

    switch d {
    case let .value(elements):
      self.elements.append(contentsOf: elements)
      return .value()
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Add

  internal func add(other: PySequenceData) -> [PyObject] {
    return self.elements + other.elements
  }

  internal mutating func iadd(other: PySequenceData) {
    self.elements += other.elements
  }

  // MARK: - Mul

  internal enum MulResult {
    case value([PyObject])
    case error(PyBaseException)
    case notImplemented
  }

  internal func mul(count: PyObject) -> MulResult {
    guard let countInt = count as? PyInt else {
      return .notImplemented
    }

    return mul(count: countInt)
  }

  internal func rmul(count: PyObject) -> MulResult {
    guard let countInt = count as? PyInt else {
      return .notImplemented
    }

    return mul(count: countInt)
  }

  private func mul(count: PyInt) -> MulResult {
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

  // MARK: - Reverse

  internal mutating func reverse() {
    self.elements.reverse()
  }

  // MARK: - Clear

  internal mutating func clear() {
    self.elements.removeAll()
  }

  // MARK: - Pop

  internal mutating func pop(at index: Int,
                             typeName: String) -> PyResult<PyObject> {
    if self.isEmpty {
      return .indexError("pop from empty \(typeName)")
    }

    var index = index
    if index < 0 {
      index += self.count
    }

    guard 0 <= index && index < self.count else {
      return .indexError("pop index out of range")
    }

    let result = self.elements.remove(at: index)
    return .value(result)
  }

  // MARK: - Index

  private enum ExtractIndexResult {
    case none
    case index(Index)
    case error(PyBaseException)
  }

  private func extractIndex(_ value: PyObject?) -> ExtractIndexResult {
    guard let value = value else {
      return .none
    }

    if value is PyNone {
      return .none
    }

    switch IndexHelper.int(value) {
    case var .value(index):
      if index < 0 {
        index += self.elements.count
        if index < 0 {
          index = 0
        }
      }

      let start = self.elements.startIndex
      let end = self.elements.endIndex
      let result = self.elements.index(start, offsetBy: index, limitedBy: end)
      return .index(result ?? end)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Subsequence

  private func getSubsequence(start: PyObject?,
                              end: PyObject?) -> PyResult<SubSequence> {

    let startIndex: Index
    switch self.extractIndex(start) {
    case .none: startIndex = self.elements.startIndex
    case .index(let index): startIndex = index
    case .error(let e): return .error(e)
    }

    var endIndex: Index
    switch self.extractIndex(end) {
    case .none: endIndex = self.elements.endIndex
    case .index(let index): endIndex = index
    case .error(let e): return .error(e)
    }

    return .value(self.elements[startIndex..<endIndex])
  }
}
