import BigInt
import VioletCore

// swiftlint:disable file_length
// swiftlint:disable yoda_condition

internal protocol PySequenceType {
  var data: PySequenceData { get }

  /// Is this builtin `list/tuple` type?
  ///
  /// Will return `false` if this is a subclass.
  func checkExact() -> Bool
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

  // MARK: - Repr

  internal func repr(openBracket: String,
                     closeBracket: String,
                     appendCommaIfSingleElement: Bool) -> PyResult<String> {
    if self.isEmpty {
      return .value(openBracket + closeBracket)
    }

    var result = openBracket
    for (index, element) in self.elements.enumerated() {
      if index > 0 {
        result += ", " // so that we don't have ', )'.
      }

      switch Py.repr(object: element) {
      case let .value(s): result += s
      case let .error(e): return .error(e)
      }
    }

    if appendCommaIfSingleElement && self.count == 1 {
      result += ","
    }

    result += closeBracket
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

  private enum GetItemImpl: GetItemHelper {
    // swiftlint:disable:next nesting
    fileprivate typealias Collection = [PyObject]
  }

  internal func getItem(index: PyObject) -> GetItemResult<PyObject> {
    return GetItemImpl.getItem(collection: self.elements, index: index)
  }

  internal func getItem(index: Int) -> PyResult<PyObject> {
    return GetItemImpl.getItem(collection: self.elements, index: index)
  }

  internal func getItem(slice: PySlice) -> PyResult<[PyObject]> {
    return GetItemImpl.getItem(collection: self.elements, slice: slice)
  }

  // MARK: - Set item

  private enum SetItemImpl: SetItemHelper {

    // swiftlint:disable:next nesting
    fileprivate typealias Collection = [PyObject]

    fileprivate static func getElement(object: PyObject) -> PyResult<PyObject> {
      return .value(object)
    }

    fileprivate static func getElements(object: PyObject) -> PyResult<[PyObject]> {
      switch Py.toArray(iterable: object) {
      case let .value(elements):
        return .value(elements)
      case .error:
        return .typeError("can only assign an iterable")
      }
    }
  }

  internal mutating func setItem(index: PyObject,
                                 value: PyObject) -> PyResult<PyNone> {
    return SetItemImpl.setItem(collection: &self.elements,
                               index: index,
                               value: value)
  }

  internal mutating func setItem(index: Int,
                                 value: PyObject) -> PyResult<PyNone> {
    return SetItemImpl.setItem(collection: &self.elements,
                               index: index,
                               value: value)
  }

  internal mutating func setItem(slice: PySlice,
                                 value: PyObject) -> PyResult<PyNone> {
    return SetItemImpl.setItem(collection: &self.elements,
                               slice: slice,
                               value: value)
  }

  // MARK: - Del item

  private enum DelItemImpl: DelItemHelper {
    // swiftlint:disable:next nesting
    fileprivate typealias Collection = [PyObject]
  }

  internal mutating func delItem(index: PyObject) -> PyResult<PyNone> {
    return DelItemImpl.delItem(collection: &self.elements, index: index)
  }

  internal mutating func delItem(index: Int) -> PyResult<PyNone> {
    return DelItemImpl.delItem(collection: &self.elements, index: index)
  }

  internal mutating func delItem(slice: PySlice) -> PyResult<PyNone> {
    return DelItemImpl.delItem(collection: &self.elements, slice: slice)
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

  internal mutating func insert(index: PyObject,
                                item: PyObject) -> PyResult<PyNone> {
    var parsedIndex: Int
    switch IndexHelper.intOrError(index) {
    case let .value(i): parsedIndex = i
    case let .error(e): return .error(e)
    }

    self.insert(index: parsedIndex, item: item)
    return .value(Py.none)
  }

  internal mutating func insert(index: Int, item: PyObject) {
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

  internal mutating func pop(index: PyObject?,
                             typeName: String) -> PyResult<PyObject> {
    let intIndex = self.parsePopIndex(from: index)
    return intIndex.flatMap { self.pop(index: $0, typeName: typeName) }
  }

  private func parsePopIndex(from index: PyObject?) -> PyResult<Int> {
    guard let index = index else {
      return .value(-1)
    }

    return IndexHelper.intOrError(index)
  }

  internal mutating func pop(index: Int,
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

    switch IndexHelper.intOrError(value) {
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
