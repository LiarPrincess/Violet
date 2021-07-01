import Foundation

internal struct BytesBuilder2: StringBuilderType2, GetItemSliceBuilderType {

  internal typealias Elements = Data
  internal typealias Element = UInt8
  internal typealias Result = Data

  private var data: Data

  internal init(capacity: Int) {
    self.data = Data(capacity: capacity)
  }

  internal init(elements: Elements) {
    self.data = elements
  }

  internal mutating func append(element: Element) {
    self.data.append(element)
  }

  internal mutating func append(element: Element, repeated: Int) {
    let newCount = self.data.count + repeated
    self.data.reserveCapacity(newCount)

    for _ in 0..<repeated {
      self.data.append(element)
    }
  }

  internal mutating func append(contentsOf other: Elements) {
    if self.data.isEmpty {
      self.data = other
    } else {
      self.data.append(contentsOf: other)
    }
  }

  internal func finalize() -> Result {
    return self.data
  }

  // MARK: - GetItemSliceBuilderType

  internal typealias SourceSubsequence = Data

  internal init(sourceSubsequenceWhenStepIs1: Data) {
    self.data = sourceSubsequenceWhenStepIs1
  }
}
