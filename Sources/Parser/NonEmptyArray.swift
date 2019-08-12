// swiftlint:disable force_unwrapping

/// Array that has at least 1 element.
internal struct NonEmptyArray<Element>: Sequence,
                                        Collection,
                                        BidirectionalCollection,
                                        CustomStringConvertible {

  internal private(set) var elements = [Element]()

  internal var first: Element { return self.elements.first! }
  internal var last:  Element { return self.elements.last! }

  internal init(first: Element, rest: [Element] = []) {
    self.elements.append(first)
    self.elements.append(contentsOf: rest)
  }

  internal mutating func append(_ newElement: Element) {
    self.elements.append(newElement)
  }

  internal mutating func append<S: Sequence>(contentsOf newElements: S)
    where S.Element == Element {

    self.elements.append(contentsOf: newElements)
  }

  // MARK: - Collection

  typealias Index = Array<Element>.Index
  typealias Element = Array<Element>.Element
  typealias Iterator = Array<Element>.Iterator

  internal var startIndex: Index { return self.elements.startIndex }
  internal var endIndex:   Index { return self.elements.endIndex }

  internal subscript(index: Index) -> Iterator.Element {
    return self.elements[index]
  }

  internal func index(after i: Index) -> Index {
    return self.elements.index(after: i)
  }

  internal func index(before i: Index) -> Index {
    return self.elements.index(before: i)
  }

  internal func makeIterator() -> IndexingIterator<[Element]> {
    return self.elements.makeIterator()
  }

  // MARK: - CustomStringConvertible

  internal var description: String {
    return String(describing: self.elements)
  }
}

// MARK: - To array

extension Array {
  internal init(_ nonEmpty: NonEmptyArray<Element>) {
    self = nonEmpty.elements
  }
}
