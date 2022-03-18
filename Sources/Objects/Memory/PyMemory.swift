// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

public final class PyMemory {

  // MARK: - Object

  public func allocate(size: Int, alignment: Int) -> RawPtr {
    assert(size >= PyObject.layout.size)
    return RawPtr.allocate(byteCount: size, alignment: alignment)
  }

  public func destroy(object: PyObject) {
    let ptr = object.ptr

    let deinitialize = object.type.deinitialize
    deinitialize(ptr)

    object.ptr.deallocate()
  }

  // MARK: - Py

  internal static func allocatePy() -> RawPtr {
    let size = Py.layout.size
    let alignment = Py.layout.alignment
    return RawPtr.allocate(byteCount: size, alignment: alignment)
  }

  internal static func destroyPy(_ py: Py) {
    // 1. allObjects.deinitialize
    // 2. allObjects.deallocate()

    py.deinitialize()
    py.ptr.deallocate()
  }

  // MARK: - Generic layout

  /// Input for `GenericLayout.init`.``
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
    public private(set) var size: Int
    public private(set) var alignment: Int
    public private(set) var offsets: [Int]

    public init(initialOffset: Int, initialAlignment: Int, fields: [FieldLayout]) {
      self.size = initialOffset
      self.alignment = initialAlignment

      self.offsets = [Int]()
      offsets.reserveCapacity(fields.count)

      for field in fields {
        self.size += Self.round(self.size, alignment: field.alignment)
        self.offsets.append(self.size)
        self.size += field.size
        self.alignment = Swift.max(self.alignment, field.alignment)
      }

      // Technically we could round up the 'self.size' to 'self.alignment',
      // but by not doing so we can safe some memory (maybe).
      //
      // Example for 'PyObject' on 64-bit:
      // - alignment: 8
      // - last field size: 4 (flags: UInt32, other fields are 8)
      //
      // If we align the 'PyObject' then we will get a hole with size 4 after last
      // field. But what if the next field has size 4? We could have used this hole!
      //
      // In C they would align. This is because of 'taking-pointers-to-nested-structs'
      // and 'other-complicated-things'.
      // In Swift they would not align (afaik) - just like we do. This makes
      // certaing operations illegal, but potentially saves memory.
    }

    private static func round(_ value: Int, alignment: Int) -> Int {
      var result = value
      result += alignment &- 1
      result &-= result % alignment
      return result
    }
  }
}
