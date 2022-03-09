import Foundation

internal struct BytesBuilder: StringBuilderType, GetItemSliceBuilderType {

  internal typealias Elements = Data
  internal typealias CaseMapping = UInt8
  internal typealias Result = Data

  private var data: Data

  // MARK: - StringBuilderType

  internal init(capacity: Int) {
    self.data = Data(capacity: capacity)
  }

  internal init(elements: Data) {
    self.data = elements
  }

  internal mutating func append(element: UInt8) {
    self.data.append(element)
  }

  internal mutating func append(element: UInt8, repeated: Int) {
    let newCount = self.data.count + repeated
    self.data.reserveCapacity(newCount)

    for _ in 0..<repeated {
      self.data.append(element)
    }
  }

  internal mutating func append(contentsOf other: Data) {
    if self.data.isEmpty {
      self.data = other
    } else {
      self.data.append(contentsOf: other)
    }
  }

  internal mutating func append(mapping: UInt8) {
    self.data.append(mapping)
  }

  internal func finalize() -> Result {
    return self.data
  }

  // MARK: - GetItemSliceBuilderType

  // This is for 'GetItemSliceBuilderType'
  internal typealias Source = Data

  internal static func whenStepIs1(subsequence: Data) -> Data {
    return subsequence
  }
}
