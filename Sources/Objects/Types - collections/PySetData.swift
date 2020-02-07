import Core

// TODO: All of the set methods should have tuple as an arg

// swiftlint:disable file_length

// MARK: - Element

internal struct PySetElement: PyHashable {

  internal var hash: PyHash
  internal var object: PyObject

  internal init(hash: PyHash, object: PyObject) {
    self.hash = hash
    self.object = object
  }

  internal func isEqual(to other: PySetElement) -> PyResult<Bool> {
    guard self.hash == other.hash else {
      return .value(false)
    }

    return Py.isEqualBool(left: self.object, right: other.object)
  }
}

extension OrderedDictionary where Value == Void {
  internal mutating func insert(key: Key) -> InsertResult {
    return self.insert(key: key, value: ())
  }
}

// MARK: - PySetType

internal protocol PySetType: PyObject {
  var data: PySetData { get set }
}

// MARK: - PySetData

/// Main logic for Python sets.
/// Used in `PySet` and `PyFrozenSet`.
internal struct PySetData {

  // Small trick: when we use `Void` (which is the same as `()`) as value
  // then it would not take any space in dictionary!
  // For example `struct { Int, Void }` has the same storage as `struct { Int }`.
  // This trick is sponsored by 'go lang': `map[T]struct{}`.
  internal typealias DictType = OrderedDictionary<PySetElement, ()>
  internal typealias Iterator = DictType.Iterator

  internal private(set) var dict: DictType

  internal init() {
    self.dict = DictType()
  }

  internal init(elements: DictType) {
    self.dict = elements
  }

  // MARK: - Equatable

  internal func isEqual(to other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let otherData = other.data

    // Equal count + isSubset -> equal
    guard self.count == otherData.count else {
      return .value(false)
    }

    switch self.isSubset(of: otherData) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  // MARK: - Comparable

  internal func isLess(than other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let otherData = other.data

    guard self.count < otherData.count else {
      return .value(false)
    }

    switch self.isSubset(of: otherData) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal func isLessEqual(than other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let otherData = other.data

    switch self.isSubset(of: otherData) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal func isGreater(than other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let otherData = other.data

    guard self.count > otherData.count else {
      return .value(false)
    }

    switch self.isSuperset(of: otherData) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  internal func isGreaterEqual(than other: PyObject) -> CompareResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let otherData = other.data

    switch self.isSuperset(of: otherData) {
    case let .value(b): return .value(b)
    case let .error(e): return .error(e)
    }
  }

  // MARK: - String

  internal func repr(typeName: String) -> PyResult<String> {
    if self.isEmpty {
      return .value("()")
    }

    var result = "\(typeName)("
    for (index, element) in self.dict.enumerated() {
      if index > 0 {
        result += ", " // so that we don't have ', )'.
      }

      switch Py.repr(element.key.object) {
      case let .value(s): result += s
      case let .error(e): return .error(e)
      }
    }

    result += self.count > 1 ? ")" : ",)"
    return .value(result)
  }

  // MARK: - Length

  internal var isEmpty: Bool {
    return self.dict.isEmpty
  }

  internal var count: Int {
    return self.dict.count
  }

  // MARK: - Contains

  internal func contains(value: PyObject) -> PyResult<Bool> {
    switch self.createElement(from: value) {
    case let .value(element):
      return self.contains(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  internal func contains(element: PySetElement) -> PyResult<Bool> {
    return self.dict.contains(key: element)
  }

  // MARK: - And

  internal func and(other: PyObject) -> BitOpResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let result = self.intersection(with: other)
    return self.toBinOpResult(result)
  }

  internal enum BitOpResult {
    case set(PySetData)
    case notImplemented
    case error(PyBaseException)
  }

  private func toBinOpResult(_ result: PyResult<PySetData>) -> BitOpResult {
    switch result {
    case let .value(data):
      return .set(data)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Or

  internal func or(other: PyObject) -> BitOpResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let result = self.union(with: other)
    return self.toBinOpResult(result)
  }

  // MARK: - Xor

  internal func xor(other: PyObject) -> BitOpResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let result = self.symmetricDifference(with: other)
    return self.toBinOpResult(result)
  }

  // MARK: - Sub

  internal func sub(other: PyObject) -> BitOpResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.sub(other: other.data)
  }

  private func sub(other: PySetData) -> BitOpResult {
    let result = self.difference(with: other)
    return self.toBinOpResult(result)
  }

  internal func rsub(other: PyObject) -> BitOpResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return other.data.sub(other: self)
  }

  // MARK: - Subset

  internal func isSubset(of other: PyObject) -> PyResult<Bool> {
    return self.makeSet(from: other).flatMap(self.isSubset(of:))
  }

  private func isSubset(of other: PySetData) -> PyResult<Bool> {
    guard self.count <= other.count else {
      return .value(false)
    }

    for entry in self.dict {
      switch other.dict.contains(key: entry.key) {
      case .value(true): break // try next
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Superset

  internal func isSuperset(of other: PyObject) -> PyResult<Bool> {
    return self.makeSet(from: other).flatMap(self.isSuperset(of:))
  }

  private func isSuperset(of other: PySetData) -> PyResult<Bool> {
    return other.isSubset(of: self)
  }

  // MARK: - Intersection

  internal func intersection(with other: PyObject) -> PyResult<PySetData> {
    return self.makeSet(from: other).flatMap(self.intersection(with:))
  }

  private func intersection(with other: PySetData) -> PyResult<PySetData> {
    let isSelfSmaller = self.count < other.count
    let smallerSet = isSelfSmaller ? self : other
    let largerSet = isSelfSmaller ? other : self

    var result = PySetData()
    for entry in smallerSet.dict {
      switch largerSet.dict.contains(key: entry.key) {
      case .value(true):
        switch result.insert(element: entry.key) {
        case .ok: break
        case .error(let e): return .error(e)
        }
      case .value(false): break
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Union

  internal func union(with other: PyObject) -> PyResult<PySetData> {
    return self.makeSet(from: other).flatMap(self.union(with:))
  }

  private func union(with other: PySetData) -> PyResult<PySetData> {
    let isSelfSmaller = self.count < other.count
    let smallerSet = isSelfSmaller ? self : other
    let largerSet = isSelfSmaller ? other : self

    var result = largerSet
    for entry in smallerSet.dict {
      switch result.insert(element: entry.key) {
      case .ok: break
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Difference

  internal func difference(with other: PyObject) -> PyResult<PySetData> {
    return self.makeSet(from: other).flatMap(self.difference(with:))
  }

  private func difference(with other: PySetData) -> PyResult<PySetData> {
    var result = PySetData()
    for entry in self.dict {
      switch other.dict.contains(key: entry.key) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(element: entry.key) {
        case .ok: break
        case .error(let e): return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Symmetric difference

  internal func symmetricDifference(with other: PyObject) -> PyResult<PySetData > {
    return self.makeSet(from: other).flatMap(self.symmetricDifference(with:))
  }

  private func symmetricDifference(with other: PySetData) -> PyResult<PySetData > {
    var result = PySetData()

    for entry in self.dict {
      switch other.dict.contains(key: entry.key) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(element: entry.key) {
        case .ok: break
        case .error(let e): return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    for entry in other.dict {
      switch self.dict.contains(key: entry.key) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(element: entry.key) {
        case .ok: break
        case .error(let e): return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Is disjoint

  internal func isDisjoint(with other: PyObject) -> PyResult<Bool> {
    return self.makeSet(from: other).flatMap(self.isDisjoint(with:))
  }

  private func isDisjoint(with other: PySetData) -> PyResult<Bool> {
    let isSelfSmaller = self.count < other.count
    let smallerSet = isSelfSmaller ? self : other
    let largerSet = isSelfSmaller ? other : self

    for entry in smallerSet.dict {
      switch largerSet.dict.contains(key: entry.key) {
      case .value(true): return .value(false)
      case .value(false) : break
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Insert

  internal enum InsertResult {
    case ok
    case error(PyBaseException)
  }

  internal mutating func insert(value: PyObject) -> InsertResult {
    switch self.createElement(from: value) {
    case let .value(element):
      return self.insert(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func insert(element: PySetElement) -> InsertResult {
    switch self.dict.insert(key: element) {
    case .inserted, .updated:
      return .ok
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Update

  internal enum UpdateResult {
    case ok
    case error(PyBaseException)
  }

  internal mutating func update(from other: PyObject) -> UpdateResult {
    if let set = other as? PySetType {
      return self.update(from: set.data)
    }

    if let dict = other as? PyDict {
      return self.update(from: dict.data)
    }

    let result = Py.reduce(iterable: other, initial: 0) { _, object in
      switch self.insert(value: object) {
      case .ok: return .goToNextElement
      case .error(let e): return .error(e)
      }
    }

    switch result {
    case .value: return .ok
    case .error(let e): return .error(e)
    }
  }

  internal mutating func update(from other: PySetData) -> UpdateResult {
    for entry in other.dict {
      switch self.insert(element: entry.key) {
      case .ok: break
      case .error(let e): return .error(e)
      }
    }

    return .ok
  }

  internal mutating func update(from other: PyDictData) -> UpdateResult {
    for entry in other {
      let element = PySetElement(hash: entry.hash, object: entry.key.object)
      switch self.insert(element: element) {
      case .ok: break
      case .error(let e): return .error(e)
      }
    }

    return .ok
  }

  // MARK: - Remove

  internal enum RemoveResult {
    case ok
    case error(PyBaseException)
  }

  internal mutating func remove(value: PyObject) -> RemoveResult {
    switch self.createElement(from: value) {
    case let .value(element):
      return self.remove(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func remove(element: PySetElement) -> RemoveResult {
    switch self.dict.remove(key: element) {
    case .value:
      return .ok
    case .notFound:
      return .error(Py.newKeyError(key: element.object))
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Discard

  internal enum DiscardResult {
    case ok
    case error(PyBaseException)
  }

  internal mutating func discard(value: PyObject) -> DiscardResult {
    switch self.createElement(from: value) {
    case let .value(element):
      return self.discard(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func discard(element: PySetElement) -> DiscardResult {
    switch self.dict.remove(key: element) {
    case .value, .notFound:
      return .ok
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Clear

  internal mutating func clear() {
    self.dict.clear()
  }

  // MARK: - Pop

  internal mutating func pop() -> PyResult<PyObject> {
    guard let lastElement = self.dict.last else {
      return .keyError("pop from an empty set")
    }

    _ = self.remove(element: lastElement.key)
    return .value(lastElement.key.object)
  }

  // MARK: - Helpers

  private func makeSet(from other: PyObject) -> PyResult<PySetData> {
    if let set = other as? PySetType {
      return .value(set.data)
    }

    if let dict = other as? PyDict {
      // Init 'elements' with size, so that we don't have to resize later
      var elements = PySetData.DictType(size: dict.data.count)

      for entry in dict.data {
        let key = PySetElement(hash: entry.hash, object: entry.key.object)
        switch elements.insert(key: key) {
        case .inserted,
             .updated: break
        case .error(let e): return .error(e)
        }
      }

      return .value(PySetData(elements: elements))
    }

    return Py.reduce(iterable: other, into: PySetData()) { acc, element in
      switch acc.insert(value: element) {
      case .ok: return .goToNextElement
      case .error(let e): return .error(e)
      }
    }
  }

  private func createElement(from object: PyObject) -> PyResult<PySetElement> {
    switch Py.hash(object) {
    case let .value(hash):
      return .value(PySetElement(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }
}
