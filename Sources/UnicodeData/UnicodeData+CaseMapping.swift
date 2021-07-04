// swiftlint:disable nesting

extension UnicodeData {

  public struct CaseMapping: Sequence {

    private let scalar0: UnicodeScalar
    private let scalar1: UnicodeScalar? // Tag is in spare bits
    private let scalar2: UnicodeScalar?

    internal init(_ scalar0: Int) {
      self.scalar0 = UnicodeScalar(unsafe: scalar0)
      self.scalar1 = nil
      self.scalar2 = nil
    }

    internal init(_ scalar0: UInt32) {
      self.scalar0 = UnicodeScalar(unsafe: scalar0)
      self.scalar1 = nil
      self.scalar2 = nil
    }

    internal init(_ scalar0: UInt32, _ scalar1: UInt32) {
      self.scalar0 = UnicodeScalar(unsafe: scalar0)
      self.scalar1 = UnicodeScalar(unsafe: scalar1)
      self.scalar2 = nil
    }

    internal init(_ scalar0: UInt32, _ scalar1: UInt32, _ scalar2: UInt32) {
      self.scalar0 = UnicodeScalar(unsafe: scalar0)
      self.scalar1 = UnicodeScalar(unsafe: scalar1)
      self.scalar2 = UnicodeScalar(unsafe: scalar2)
    }

    public init(_ scalar0: UnicodeScalar) {
      self.scalar0 = scalar0
      self.scalar1 = nil
      self.scalar2 = nil
    }

    public init(_ scalar0: UnicodeScalar,
                _ scalar1: UnicodeScalar) {
      self.scalar0 = scalar0
      self.scalar1 = scalar1
      self.scalar2 = nil
    }

    public init(_ scalar0: UnicodeScalar,
                _ scalar1: UnicodeScalar,
                _ scalar2: UnicodeScalar) {
      self.scalar0 = scalar0
      self.scalar1 = scalar1
      self.scalar2 = scalar2
    }

    // MARK: - Sequence

    public typealias Element = UnicodeScalar

    public struct Iterator: IteratorProtocol {
      public typealias Element = UnicodeScalar

      private let mapping: CaseMapping
      private var index = UInt8.zero

      fileprivate init(mapping: CaseMapping) {
        self.mapping = mapping
      }

      public mutating func next() -> UnicodeScalar? {
        switch self.index {
        case 0:
          self.index += 1
          return self.mapping.scalar0
        case 1:
          self.index += 1
          return self.mapping.scalar1
        case 2:
          self.index += 1
          return self.mapping.scalar2
        default:
          return nil
        }
      }
    }

    public func makeIterator() -> Iterator {
      return Iterator(mapping: self)
    }
  }
}
