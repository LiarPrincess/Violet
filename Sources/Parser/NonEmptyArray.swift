internal struct NonEmptyArray<Element> {

  internal let first: Element
  internal let rest: [Element]

  internal var last: Element {
    if let l = self.rest.last {
      return l
    }
    return self.first
  }

  internal init(first: Element, rest: [Element] = []) {
    self.first = first
    self.rest = rest
  }
}

extension Array {
  internal init(_ nonEmpty: NonEmptyArray<Element>) {
    self.init()
    self.append(nonEmpty.first)
    self.append(contentsOf: nonEmpty.rest)
  }
}
