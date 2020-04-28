import VioletCore

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

  internal func isEqual(to other: PySequenceData) -> CompareResult {
    guard self.count == other.count else {
      return .value(false)
    }

    for (l, r) in zip(self.elements, other.elements) {
      switch Py.isEqualBool(left: l, right: r) {
      case .value(true): break // go to next element
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Comparable

  internal func isLess(than other: PySequenceData) -> CompareResult {
    switch self.getFirstNotEqualElement(with: other) {
    case let .elements(selfElement: l, otherElement: r):
      return Py.isLessBool(left: l, right: r).asCompareResult
    case .allEqualUpToShorterCount:
      return .value(self.count < other.count)
    case let .error(e):
      return .error(e)
    }
  }

  internal func isLessEqual(than other: PySequenceData) -> CompareResult {
    switch self.getFirstNotEqualElement(with: other) {
    case let .elements(selfElement: l, otherElement: r):
      return Py.isLessEqualBool(left: l, right: r).asCompareResult
    case .allEqualUpToShorterCount:
      return .value(self.count <= other.count)
    case let .error(e):
      return .error(e)
    }
  }

  internal func isGreater(than other: PySequenceData) -> CompareResult {
    switch self.getFirstNotEqualElement(with: other) {
    case let .elements(selfElement: l, otherElement: r):
      return Py.isGreaterBool(left: l, right: r).asCompareResult
    case .allEqualUpToShorterCount:
      return .value(self.count > other.count)
    case let .error(e):
      return .error(e)
    }
  }

  internal func isGreaterEqual(than other: PySequenceData) -> CompareResult {
    switch self.getFirstNotEqualElement(with: other) {
    case let .elements(selfElement: l, otherElement: r):
      return Py.isGreaterEqualBool(left: l, right: r).asCompareResult
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
      switch Py.isEqualBool(left: l, right: r) {
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
    var x: PyHash = 0x34_5678
    var mult = Hasher.multiplier

    for e in self.elements {
      switch Py.hash(object: e) {
      case let .value(y):
        x = (x ^ y) &* mult
        mult &+= 82_520 + PyHash(2 * self.elements.count)
      case let .error(e):
        return .error(e)
      }
    }

    return .value(x &+ 97_531)
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
      switch Py.isEqualBool(left: element, right: value) {
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
    switch IndexHelper.intMaybe(index) {
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
    let indices: PySlice.AdjustedIndices
    switch slice.unpack() {
    case let .value(u): indices = u.adjust(toCount: self.count)
    case let .error(e): return .error(e)
    }

    // swiftlint:disable:next empty_count
    if indices.count <= 0 {
      return .value([])
    }

    if indices.step == 0 {
      return .valueError("slice step cannot be zero")
    }

    if indices.step == 1 {
      let result = self.elements.dropFirst(indices.start).prefix(indices.count)
      return .value(Array(result))
    }

    var result = [PyObject]()
    for i in 0..<indices.count {
      let index = indices.start + i * indices.step

      guard 0 <= index && index < self.count else {
        return .value(result)
      }

      result.append(self.elements[index])
    }

    return .value(result)
  }

  // MARK: - Set item

  internal mutating func setItem(at index: PyObject,
                                 to value: PyObject) -> PyResult<PyNone> {
    switch IndexHelper.intMaybe(index) {
    case .value(let indexInt):
      return self.setItem(at: indexInt, to: value)
    case .notIndex:
      break // Try other
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      return self.setItem(at: slice, to: value)
    }

    let msg = "list indices must be integers or slices, not \(index.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  internal mutating func setItem(at index: Int,
                                 to value: PyObject) -> PyResult<PyNone> {
    var index = index

    if index < 0 {
      index += self.elements.count
    }

    guard 0 <= index && index < self.elements.count else {
      let msg = "list assignment index out of range"
      return .error(Py.newIndexError(msg: msg))
    }

    self.elements[index] = value
    return .value(Py.none)
  }

  internal mutating func setItem(at slice: PySlice,
                                 to value: PyObject) -> PyResult<PyNone> {
    var indices: PySlice.AdjustedIndices
    switch slice.unpack() {
    case let .value(u): indices = u.adjust(toCount: self.elements.count)
    case let .error(e): return .error(e)
    }

    if indices.step == 1 {
      return self.setContinuousItems(start: indices.start, stop: indices.stop, to: value)
    }

    // Make sure s[5:2] = [..] inserts at the right place: before 5, not before 2.
    if (indices.step < 0 && indices.start < indices.stop) ||
       (indices.step > 0 && indices.start > indices.stop) {
      indices.stop = indices.start
    }

    let elements: [PyObject]
    switch Py.toArray(iterable: value) {
    case .value(let e): elements = e
    case .error: return .typeError("must assign iterable to extended slice")
    }

    guard elements.count == indices.count else {
      let msg = "attempt to assign sequence of size \(elements.count) " +
                "to extended slice of size \(indices.count)"
      return .valueError(msg)
    }

    // swiftlint:disable:next empty_count
    if indices.count == 0 {
      return .value(Py.none)
    }

    var elementsIndex = 0
    for index in stride(from: indices.start, to: indices.stop, by: indices.step) {
      self.elements[index] = elements[elementsIndex]
      elementsIndex += 1
    }

    return .value(Py.none)
  }

  // static int
  // list_ass_slice(PyListObject *a, Py_ssize_t ilow, Py_ssize_t ihigh, PyObject *v)
  private mutating func setContinuousItems(
    start: Int,
    stop: Int,
    to value: PyObject
  ) -> PyResult<PyNone> {

    let elements: [PyObject]
    switch Py.toArray(iterable: value) {
    case .value(let e): elements = e
    case .error: return .typeError("can only assign an iterable")
    }

    let low = min(max(start, 0), self.elements.count)
    let high = min(max(stop, low), self.elements.count)

    let replacementCount = high - low
    assert(replacementCount >= 0)

    // Fast path: we have list of 7 elements, add 3 more but replace 10.
    // In total that gives us empty list.
    let countChange = elements.count - replacementCount
    if self.elements.count + countChange == 0 {
      return .value(self.clear())
    }

    self.elements.replaceSubrange(low..<high, with: elements)
    return .value(Py.none)
  }

  // MARK: - Del item

  internal mutating func delItem(at index: PyObject) -> PyResult<PyNone> {
    switch IndexHelper.intMaybe(index) {
    case .value(let indexInt):
      return self.delItem(at: indexInt)
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      return self.delItem(at: slice)
    }

    let msg = "list indices must be integers or slices, not \(index.typeName)"
    return .error(Py.newTypeError(msg: msg))
  }

  internal mutating func delItem(at index: Int) -> PyResult<PyNone> {
    var index = index

    if index < 0 {
      index += self.elements.count
    }

    guard 0 <= index && index < self.elements.count else {
      let msg = "list assignment index out of range"
      return .error(Py.newIndexError(msg: msg))
    }

    _ = self.elements.remove(at: index)
    return .value(Py.none)
  }

  internal mutating func delItem(at slice: PySlice) -> PyResult<PyNone> {
    var indices: PySlice.AdjustedIndices
    switch slice.unpack() {
    case let .value(u): indices = u.adjust(toCount: self.elements.count)
    case let .error(e): return .error(e)
    }

    if indices.step == 1 {
      let range = indices.start..<indices.stop
      self.elements.replaceSubrange(range, with: [])
      return .value(Py.none)
    }

    // Make sure s[5:2] = [..] inserts at the right place: before 5, not before 2.
    if (indices.step < 0 && indices.start < indices.stop) ||
       (indices.step > 0 && indices.start > indices.stop) {
      indices.stop = indices.start
    }

    // swiftlint:disable:next empty_count
    if indices.count <= 0 {
      return .value(Py.none)
    }

    // Fix the slice, so we can start from lower indices
    if indices.step < 0 {
      indices.stop = indices.start + 1
      indices.start = indices.stop + indices.step * (indices.count - 1) - 1
      indices.step = -indices.step
    }

    var groupStart = 0
    var result = [PyObject]()
    result.reserveCapacity(self.elements.count - indices.count)

    for index in stride(from: indices.start, to: indices.stop, by: indices.step) {
      let elements = self.elements[groupStart..<index]
      result.append(contentsOf: elements)
      groupStart = index + 1 // +1 to skip 'index'
    }

    // Include final group
    if groupStart < self.elements.count {
      let elements = self.elements[groupStart..<self.elements.count]
      result.append(contentsOf: elements)
    }

    self.elements = result
    return .value(Py.none)
  }

  // MARK: - Count

  internal func count(element: PyObject) -> PyResult<Int> {
    var result = 0

    for e in self.elements {
      switch Py.isEqualBool(left: e, right: element) {
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
                      typeName: String) -> PyResult<BigInt> {
    let subsequence: SubSequence
    switch self.getSubsequence(start: start, end: end) {
    case let .value(s): subsequence = s
    case let .error(e): return .error(e)
    }

    for (index, e) in subsequence.enumerated() {
      switch Py.isEqualBool(left: e, right: element) {
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

  // MARK: - Append

  internal mutating func append(_ element: PyObject) {
    self.elements.append(element)
  }

  // MARK: - Prepend

  internal mutating func prepend(_ element: PyObject) {
    self.elements.insert(element, at: 0)
  }

  // MARK: - Insert

  internal mutating func insert(at index: PyObject,
                                item: PyObject) -> PyResult<PyNone> {
    var parsedIndex: Int
    switch IndexHelper.int(index) {
    case let .value(i): parsedIndex = i
    case let .error(e): return .error(e)
    }

    self.insert(at: parsedIndex, item: item)
    return .value(Py.none)
  }

  internal mutating func insert(at index: Int, item: PyObject) {
    var index = index

    if index < 0 {
      index += self.elements.count
      if index < 0 {
        index = 0
      }
    }

    if index > self.elements.count {
      index = self.elements.count
    }

    self.elements.insert(item, at: index)
  }

  // MARK: - Remove

  internal mutating func remove(typeName: String,
                                value: PyObject) -> PyResult<PyNone> {
    switch self.find(value) {
    case .index(let index):
      self.elements.remove(at: index)
      return .value(Py.none)

    case .notFound:
      return .valueError("\(typeName).remove(x): x not in \(typeName)")

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
      switch Py.isEqualBool(left: element, right: value) {
      case .value(true): return .index(index)
      case .value(false): break // go to next element
      case .error(let e): return .error(e)
      }
    }

    return .notFound
  }

  // MARK: - Extend

  internal mutating func extend(iterable: PyObject) -> PyResult<PyNone> {
    // Fast path: adding tuples, lists
    if let sequence = iterable as? PySequenceType {
      self.elements.append(contentsOf: sequence.data.elements)
      return .value(Py.none)
    }

    // Slow path: iterable
    // Do not modify `self.elements` until we finished iteration.
    switch Py.toArray(iterable: iterable) {
    case let .value(elements):
      self.elements.append(contentsOf: elements)
      return .value(Py.none)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Add

  internal func add(other: PySequenceData) -> [PyObject] {
    return self.elements + other.elements
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

    return self.mul(count: countInt)
  }

  internal func rmul(count: PyObject) -> MulResult {
    guard let countInt = count as? PyInt else {
      return .notImplemented
    }

    return self.mul(count: countInt)
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

  internal mutating func reverse() -> PyResult<PyNone> {
    self.elements.reverse()
    return .value(Py.none)
  }

  // MARK: - Clear

  internal mutating func clear() -> PyNone {
    self.elements.removeAll()
    return Py.none
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
