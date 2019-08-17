// swiftlint:disable force_unwrapping

// Do not add:
// - RandomAccessCollection - it may throw. We don’t like throwing (and runtime checks).
// - ExpressibleByArrayLiteral - it may break our invariant. We dont't like that.

/// Array that has at least 1 element.
public struct NonEmptyArray<Element>: Sequence,
                                        Collection,
                                        BidirectionalCollection,
                                        CustomStringConvertible {

  public private(set) var elements = [Element]()

  public var first: Element { return self.elements.first! }
  public var last:  Element { return self.elements.last! }

  public init(first: Element, rest: [Element] = []) {
    self.elements.append(first)
    self.elements.append(contentsOf: rest)
  }

  public init(_ first: Element, _ rest: Element...) {
    self.init(first: first, rest: rest)
  }

  public mutating func append(_ newElement: Element) {
    self.elements.append(newElement)
  }

  public mutating func append<S: Sequence>(contentsOf newElements: S)
    where S.Element == Element {

    self.elements.append(contentsOf: newElements)
  }

  // MARK: - Collection

  public typealias Index = Array<Element>.Index
  public typealias Element = Array<Element>.Element
  public typealias Iterator = Array<Element>.Iterator

  public var startIndex: Index { return self.elements.startIndex }
  public var endIndex:   Index { return self.elements.endIndex }

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

// MARK: - To array

extension Array {
  public init(_ nonEmpty: NonEmptyArray<Element>) {
    self = nonEmpty.elements
  }
}
