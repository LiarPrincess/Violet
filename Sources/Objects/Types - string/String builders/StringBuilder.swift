internal struct StringBuilder: StringBuilderType {

  internal typealias Element = UnicodeScalar
  internal typealias Result = String

  internal private(set) var result = ""

  internal init() {}

  internal mutating func append(_ value: UnicodeScalar) {
    self.result.unicodeScalars.append(value)
  }

  internal mutating func append<C: Sequence>(contentsOf other: C) where C.Element == Element {
    // This may be O(self.count + other.count), but I'm not sure.
    // For now it will stay as it is.
    self.result.unicodeScalars.append(contentsOf: other)
  }
}
