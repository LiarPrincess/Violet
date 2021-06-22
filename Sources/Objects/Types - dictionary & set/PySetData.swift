import VioletCore

// TODO: All of the set methods should allow tuple as an arg

// swiftlint:disable file_length

// MARK: - PySetType

internal protocol PySetType: PyObject {
  var data: PySetData { get set }

  /// Is this builtin `set/frozenset` type?
  ///
  /// Will return `false` if this is a subclass.
  func checkExact() -> Bool
}

// MARK: - PySetData

/// Main logic for Python sets.
/// Used in `PySet` and `PyFrozenSet`.
internal struct PySetData {

  internal typealias OrderedSet = PySet.OrderedSet
  internal typealias Element = PySet.Element

  internal private(set) var elements: OrderedSet

  internal init() {
    self.elements = OrderedSet()
  }

  internal init(count: Int) {
    self.elements = OrderedSet(count: count)
  }

  internal init(elements: OrderedSet) {
    self.elements = elements
  }

  // MARK: - Factory

  internal static func from(iterable: PyObject) -> PyResult<PySetData> {
    // Fast path for sets (since they already have hashed elements)
    if let set = iterable as? PySetType, set.checkExact() {
      return .value(set.data)
    }

    // Fast path for dictionaries (same reason as above)
    if let dict = PyCast.asExactlyDict(iterable) {
      // Init with 'count', so that we don't have to resize later
      var result = PySetData(count: dict.elements.count)

      for entry in dict.elements {
        let key = entry.key
        let element = Element(hash: key.hash, object: key.object)

        switch result.insert(element: element) {
        case .ok:
          break // go to next element
        case .error(let e):
          return .error(e)
        }
      }

      return .value(result)
    }

    var result = PySetData()
    let reduceError = Py.reduce(iterable: iterable, into: &result) { acc, object in
      switch acc.insert(object: object) {
      case .ok:
        return .goToNextElement
      case .error(let e):
        return .error(e)
      }
    }

    if let e = reduceError {
      return .error(e)
    }

    return .value(result)
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

  internal func joinElementsForRepr() -> PyResult<String> {
    var result = ""

    for (index, element) in self.elements.enumerated() {
      if index > 0 {
        result.append(", ")
      }

      switch Py.repr(object: element.object) {
      case let .value(s): result.append(s)
      case let .error(e): return .error(e)
      }
    }

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

  internal func contains(object: PyObject) -> PyResult<Bool> {
    switch self.createElement(from: object) {
    case let .value(element):
      return self.contains(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  internal func contains(element: Element) -> PyResult<Bool> {
    return self.elements.contains(element: element)
  }

  // MARK: - And

  internal enum BitOperationResult {
    case set(PySetData)
    case notImplemented
    case error(PyBaseException)

    fileprivate init(_ result: PyResult<PySetData>) {
      switch result {
      case let .value(data):
        self = .set(data)
      case let .error(e):
        self = .error(e)
      }
    }
  }

  internal func and(other: PyObject) -> BitOperationResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let result = self.intersection(with: other)
    return BitOperationResult(result)
  }

  // MARK: - Or

  internal func or(other: PyObject) -> BitOperationResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let result = self.union(with: other)
    return BitOperationResult(result)
  }

  // MARK: - Xor

  internal func xor(other: PyObject) -> BitOperationResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    let result = self.symmetricDifference(with: other)
    return BitOperationResult(result)
  }

  // MARK: - Sub

  internal func sub(other: PyObject) -> BitOperationResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return self.sub(other: other.data)
  }

  private func sub(other: PySetData) -> BitOperationResult {
    let result = self.difference(with: other)
    return BitOperationResult(result)
  }

  internal func rsub(other: PyObject) -> BitOperationResult {
    guard let other = other as? PySetType else {
      return .notImplemented
    }

    return other.data.sub(other: self)
  }

  // MARK: - Subset

  internal func isSubset(of other: PyObject) -> PyResult<Bool> {
    let set = PySetData.from(iterable: other)
    return set.flatMap(self.isSubset(of:))
  }

  private func isSubset(of other: PySetData) -> PyResult<Bool> {
    guard self.count <= other.count else {
      return .value(false)
    }

    for element in self.elements {
      switch other.contains(element: element) {
      case .value(true): break // try next
      case .value(false): return .value(false)
      case .error(let e): return .error(e)
      }
    }

    return .value(true)
  }

  // MARK: - Superset

  internal func isSuperset(of other: PyObject) -> PyResult<Bool> {
    let set = PySetData.from(iterable: other)
    return set.flatMap(self.isSuperset(of:))
  }

  private func isSuperset(of other: PySetData) -> PyResult<Bool> {
    return other.isSubset(of: self)
  }

  // MARK: - Intersection

  internal func intersection(with other: PyObject) -> PyResult<PySetData> {
    let set = PySetData.from(iterable: other)
    return set.flatMap(self.intersection(with:))
  }

  private func intersection(with other: PySetData) -> PyResult<PySetData> {
    let isSelfSmaller = self.count < other.count
    let smaller = isSelfSmaller ? self : other
    let bigger = isSelfSmaller ? other : self

    var result = PySetData()
    for element in smaller.elements {
      switch bigger.contains(element: element) {
      case .value(true):
        switch result.insert(element: element) {
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
    let set = PySetData.from(iterable: other)
    return set.flatMap(self.union(with:))
  }

  private func union(with other: PySetData) -> PyResult<PySetData> {
    let isSelfSmaller = self.count < other.count
    let smaller = isSelfSmaller ? self : other
    let bigger = isSelfSmaller ? other : self

    var result = bigger
    for element in smaller.elements {
      switch result.insert(element: element) {
      case .ok: break
      case .error(let e): return .error(e)
      }
    }

    return .value(result)
  }

  // MARK: - Difference

  internal func difference(with other: PyObject) -> PyResult<PySetData> {
    let set = PySetData.from(iterable: other)
    return set.flatMap(self.difference(with:))
  }

  private func difference(with other: PySetData) -> PyResult<PySetData> {
    var result = PySetData()

    for element in self.elements {
      switch other.contains(element: element) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(element: element) {
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

  internal func symmetricDifference(with other: PyObject) -> PyResult<PySetData> {
    let set = PySetData.from(iterable: other)
    return set.flatMap(self.symmetricDifference(with:))
  }

  private func symmetricDifference(with other: PySetData) -> PyResult<PySetData> {
    var result = PySetData()

    for element in self.elements {
      switch other.contains(element: element) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(element: element) {
        case .ok: break
        case .error(let e): return .error(e)
        }
      case .error(let e):
        return .error(e)
      }
    }

    for element in other.elements {
      switch self.contains(element: element) {
      case .value(true):
        break
      case .value(false):
        switch result.insert(element: element) {
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
    let set = PySetData.from(iterable: other)
    return set.flatMap(self.isDisjoint(with:))
  }

  private func isDisjoint(with other: PySetData) -> PyResult<Bool> {
    let isSelfSmaller = self.count < other.count
    let smaller = isSelfSmaller ? self : other
    let bigger = isSelfSmaller ? other : self

    for element in smaller.elements {
      switch bigger.contains(element: element) {
      case .value(true): return .value(false)
      case .value(false): break
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

  internal mutating func insert(object: PyObject) -> InsertResult {
    switch self.createElement(from: object) {
    case let .value(element):
      return self.insert(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func insert(element: Element) -> InsertResult {
    switch self.elements.insert(element: element) {
    case .inserted,
         .updated:
      return .ok
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Add

  /// Implementation of Python method `add`.
  /// Basically, the same as `self.insert(object)`, but will convert result to `None`.
  ///
  /// Most of the time you want to use `self.insert(object)`.
  internal mutating func add(object: PyObject) -> PyResult<PyNone> {
    let result = self.insert(object: object)
    switch result {
    case .ok:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Update

  internal mutating func update(from other: PyObject) -> PyResult<PyNone> {
    if let set = other as? PySetType {
      return self.update(fromSet: set.data)
    }

    // Fast path if 'other' is 'dict' (but not dict subclass!)
    if let dict = PyCast.asExactlyDict(other) {
      return self.update(fromDict: dict)
    }

    let result = Py.reduce(iterable: other, initial: ()) { _, object in
      switch self.insert(object: object) {
      case .ok: return .goToNextElement
      case .error(let e): return .error(e)
      }
    }

    switch result {
    case .value: return .value(Py.none)
    case .error(let e): return .error(e)
    }
  }

  internal mutating func update(fromSet other: PySetData) -> PyResult<PyNone> {
    for element in other.elements {
      switch self.insert(element: element) {
      case .ok: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }

  internal mutating func update(fromDict other: PyDict) -> PyResult<PyNone> {
    for entry in other.elements {
      let key = entry.key
      let element = Element(hash: key.hash, object: key.object)

      switch self.insert(element: element) {
      case .ok: break
      case .error(let e): return .error(e)
      }
    }

    return .value(Py.none)
  }

  // MARK: - Remove

  internal mutating func remove(object: PyObject) -> PyResult<PyNone> {
    switch self.createElement(from: object) {
    case let .value(element):
      return self.remove(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func remove(element: Element) -> PyResult<PyNone> {
    switch self.elements.remove(element: element) {
    case .ok:
      return .value(Py.none)
    case .notFound:
      return .error(Py.newKeyError(key: element.object))
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Discard

  internal mutating func discard(object: PyObject) -> PyResult<PyNone> {
    switch self.createElement(from: object) {
    case let .value(element):
      return self.discard(element: element)
    case let .error(e):
      return .error(e)
    }
  }

  internal mutating func discard(element: Element) -> PyResult<PyNone> {
    switch self.elements.remove(element: element) {
    case .ok, .notFound:
      return .value(Py.none)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Clear

  internal mutating func clear() -> PyNone {
    self.elements.clear()
    return Py.none
  }

  // MARK: - Pop

  internal mutating func pop() -> PyResult<PyObject> {
    guard let lastElement = self.elements.last else {
      return .keyError("pop from an empty set")
    }

    _ = self.remove(element: lastElement)
    return .value(lastElement.object)
  }

  // MARK: - Helpers

  private func createElement(from object: PyObject) -> PyResult<Element> {
    switch Py.hash(object: object) {
    case let .value(hash):
      return .value(Element(hash: hash, object: object))
    case let .error(e):
      return .error(e)
    }
  }
}
