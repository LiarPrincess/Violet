internal struct UnicodeScalarBuilder: StringBuilderType2 {

  internal typealias Elements = String.UnicodeScalarView
  internal typealias Element = UnicodeScalar
  internal typealias Result = String

  private var scalars: String.UnicodeScalarView

  internal init(capacity: Int) {
    self.scalars = Elements()
    self.scalars.reserveCapacity(capacity)
  }

  internal init(elements: Elements) {
    self.scalars = elements
  }

  internal mutating func append(element: Element) {
    self.scalars.append(element)
  }

  internal mutating func append(element: Element, repeated: Int) {
    let newCount = self.scalars.count + repeated
    self.scalars.reserveCapacity(newCount)

    for _ in 0..<repeated {
      self.scalars.append(element)
    }
  }

  internal mutating func append(contentsOf other: Elements) {
    // This may be O(self.count + other.count), but I'm not sure.
    // For now it will stay as it is.
    if self.scalars.isEmpty {
      self.scalars = other
    } else {
      self.scalars.append(contentsOf: other)
    }
  }

  internal mutating func append(contentsOf other: Elements.SubSequence) {
    // This may be O(self.count + other.count), but I'm not sure.
    // For now it will stay as it is.
    self.scalars.append(contentsOf: other)
  }

  internal func finalize() -> Result {
    return String(self.scalars)
  }
}
