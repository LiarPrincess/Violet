import VioletCore

/// A generic collection to store unique values in exactly the same order
/// as they were inserted.
public struct OrderedSet {

  // Small trick: when we use `Void` (which is the same as `()`) as value
  // then it does not take any space in a dictionary!
  // For example `struct { Int, Void }` has the same storage as `struct { Int }`.
  // (Though you will still pay the cost for generics.)
  //
  // This trick is sponsored by 'go lang': `map[T]struct{}`.
  public typealias Dict = OrderedDictionary<Void>
  public typealias Element = Dict.Key

  internal private(set) var dict: Dict

  public var count: Int { self.dict.count }
  public var capacity: Int { self.dict.capacity }
  public var isEmpty: Bool { self.dict.isEmpty }
  public var any: Bool { self.dict.any }
  public var last: Element? { self.dict.last?.key }

  // MARK: - Init

  public init() {
    self.dict = Dict()
  }

  public init(count: Int) {
    self.dict = Dict(count: count)
  }

  public init(copy: OrderedSet) {
    self.dict = copy.dict
  }

  // MARK: - Contains

  public func contains(_ py: Py, element: Element) -> PyResultGen<Bool> {
    return self.dict.contains(py, key: element)
  }

  // MARK: - Insert

  public typealias InsertResult = Dict.InsertResult

  public mutating func insert(_ py: Py, element: Element) -> InsertResult {
    return self.dict.insert(py, key: element, value: ())
  }

  // MARK: - Remove

  public enum RemoveResult {
    case ok
    case notFound
    case error(PyBaseException)
  }

  public mutating func remove(_ py: Py, element: Element) -> RemoveResult {
    let result = self.dict.remove(py, key: element)
    switch result {
    case .value:
      return .ok
    case .notFound:
      return .notFound
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Copy

  public func copy() -> OrderedSet {
    return OrderedSet(copy: self)
  }

  // MARK: - Clear

  public mutating func clear() {
    self = OrderedSet()
  }
}

// MARK: - CustomStringConvertible

extension OrderedSet: CustomStringConvertible {
  public var description: String {
    if self.isEmpty {
      return "OrderedSet()"
    }

    var result = "OrderedSet("

    for (index, element) in self.enumerated() {
      if index > 0 {
        result += ", " // so that we don't have ', )'.
      }

      result += String(describing: element)
    }

    result += ")"
    return result
  }
}

// MARK: - Sequence

extension OrderedSet: Sequence {

  public struct Iterator: IteratorProtocol {

    private var inner: Dict.Iterator

    public init(_ set: OrderedSet) {
      self.inner = set.dict.makeIterator()
    }

    public mutating func next() -> Element? {
      let dictElement = self.inner.next()
      return dictElement?.key
    }
  }

  public func makeIterator() -> Iterator {
    return Iterator(self)
  }
}
