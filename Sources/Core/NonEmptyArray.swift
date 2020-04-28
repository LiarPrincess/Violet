/// Array that has at least 1 element.
///
/// Do not add 'ExpressibleByArrayLiteral' - it may break our invariant.
public struct NonEmptyArray<Element>: Sequence,
                                      Collection,
                                      BidirectionalCollection,
                                      CustomStringConvertible {

  public private(set) var elements = [Element]()

  /// The first element of the collection.
  public var first: Element { return self.elements.first! }
  // swiftlint:disable:previous force_unwrapping

  /// The last element of the collection.
  public var last: Element { return self.elements.last! }
  // swiftlint:disable:previous force_unwrapping

  public init(first: Element) {
    self.init(first: first, rest: [])
  }

  public init<S: Sequence>(first: Element, rest: S) where S.Element == Element {
    self.elements.append(first)
    self.elements.append(contentsOf: rest)
  }

  /// Adds a new element at the end of the array.
  public mutating func append(_ newElement: Element) {
    self.elements.append(newElement)
  }

  /// Adds the elements of a sequence to the end of the array.
  public mutating func append<S: Sequence>(contentsOf newElements: S)
    where S.Element == Element {

    self.elements.append(contentsOf: newElements)
  }

  // MARK: - Collection

  public typealias Index = Array<Element>.Index
  public typealias Element = Array<Element>.Element
  public typealias Iterator = Array<Element>.Iterator

  public var startIndex: Index { return self.elements.startIndex }
  public var endIndex: Index { return self.elements.endIndex }

  public subscript(index: Index) -> Iterator.Element {
    return self.elements[index]
  }

  public func index(after i: Index) -> Index {
    return self.elements.index(after: i)
  }

  public func index(before i: Index) -> Index {
    return self.elements.index(before: i)
  }

  public func makeIterator() -> IndexingIterator<[Element]> {
    return self.elements.makeIterator()
  }

  // MARK: - CustomStringConvertible

  public var description: String {
    return String(describing: self.elements)
  }
}

// MARK: - Conditional conformance

extension NonEmptyArray: Equatable where Element: Equatable {}
extension NonEmptyArray: Hashable where Element: Hashable {}

// MARK: - To array

extension Array {
  public init(_ nonEmpty: NonEmptyArray<Element>) {
    self = nonEmpty.elements
  }
}
