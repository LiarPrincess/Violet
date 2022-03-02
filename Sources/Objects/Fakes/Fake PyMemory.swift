// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

public struct PyMemory {

  // MARK: - Allocate

  public func allocate(size: Int, alignment: Int) -> RawPtr {
    assert(size >= PyObjectHeader.layout.size)
    return RawPtr.allocate(byteCount: size, alignment: alignment)
  }

  // MARK: - Generic layout

  public struct FieldLayout {
    public let size: Int
    public let alignment: Int

    public init<T>(from type: T.Type) {
      self.size = MemoryLayout<T>.size
      self.alignment = MemoryLayout<T>.alignment
    }
  }

  /// See this:
  /// https://belkadan.com/blog/2020/09/Swift-Runtime-Type-Layout/
  public struct GenericLayout {
    public let size: Int
    public let alignment: Int
    public let offsets: [Int]

    public init(initialOffset: Int, initialAlignment: Int, fields: [FieldLayout]) {
      fatalError()
    }
  }
}
