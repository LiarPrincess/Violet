import UnicodeData

internal struct UnicodeScalarBuilder: StringBuilderType {

  internal typealias Elements = String.UnicodeScalarView
  internal typealias Element = UnicodeScalar
  internal typealias CaseMapping = UnicodeData.CaseMapping
  internal typealias Result = String

  private var scalars: String.UnicodeScalarView

  // MARK: - StringBuilderType

  internal init(capacity: Int) {
    self.scalars = Elements()
    self.scalars.reserveCapacity(capacity)
  }

  internal init(elements: String.UnicodeScalarView) {
    self.scalars = elements
  }

  internal mutating func append(element: UnicodeScalar) {
    self.scalars.append(element)
  }

  internal mutating func append(element: UnicodeScalar, repeated: Int) {
    let newCount = self.scalars.count + repeated
    self.scalars.reserveCapacity(newCount)

    for _ in 0..<repeated {
      self.scalars.append(element)
    }
  }

  internal mutating func append(contentsOf other: String.UnicodeScalarView) {
    if self.scalars.isEmpty {
      self.scalars = other
    } else {
      self.scalars.append(contentsOf: other)
    }
  }

  internal mutating func append(contentsOf other: String.UnicodeScalarView.SubSequence) {
    self.scalars.append(contentsOf: other)
  }

  internal mutating func append(mapping: UnicodeData.CaseMapping) {
    self.scalars.append(contentsOf: mapping)
  }

  internal func finalize() -> Result {
    return String(self.scalars)
  }
}
