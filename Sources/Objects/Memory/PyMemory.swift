// swiftlint:disable fatal_error_message
// swiftlint:disable unavailable_function

public final class PyMemory {

  private var firstAllocatedObject: PyObject?
  private var lastAllocatedObject: PyObject?

  #if DEBUG
  private var allocatedObjectCount = 0
  private var destroyedObjectCount = 0
  #endif

  // MARK: - Object

  /// Things that `PyMemory` stores in every object.
  internal struct ObjectHeader {
    /// Object allocated before this object (doubly linked list).
    internal var previous: PyObject?
    /// Object allocated after this object (doubly linked list).
    internal var next: PyObject?
  }

  /// Allocates and starts tracking an python object.
  public func allocateObject(size: Int, alignment: Int) -> RawPtr {
    assert(size >= PyObject.layout.size)
    let ptr = Self.allocate(byteCount: size, alignment: alignment)
    let object = PyObject(ptr: ptr)

    if self.firstAllocatedObject == nil {
      self.firstAllocatedObject = object
    }

    let lastAllocatedObject = self.lastAllocatedObject
    self.lastAllocatedObject = object

    let memoryInfo = ObjectHeader(previous: lastAllocatedObject, next: nil)
    object.memoryInfoPtr.initialize(to: memoryInfo)

#if DEBUG
    self.allocatedObjectCount += 1
#endif

    return ptr
  }

  private static func allocate(byteCount: Int, alignment: Int) -> RawPtr {
    return RawPtr.allocate(byteCount: byteCount, alignment: alignment)
  }

  public func destroy(object: PyObject) {
    let ptr = object.ptr
    let previous = object.memoryInfo.previous
    let next = object.memoryInfo.next

    object.type.deinitialize(ptr)
    object.ptr.deallocate()

    previous?.memoryInfo.next = next
    next?.memoryInfo.previous = previous

    if let first = self.firstAllocatedObject, first.ptr === ptr {
      self.firstAllocatedObject = next
    }

    if let last = self.lastAllocatedObject, last.ptr === ptr {
      self.lastAllocatedObject = previous
    }

#if DEBUG
    self.destroyedObjectCount += 1
#endif
  }

  // MARK: - Py

  internal static func allocatePy() -> RawPtr {
    let size = Py.layout.size
    let alignment = Py.layout.alignment
    return Self.allocate(byteCount: size, alignment: alignment)
  }

  internal static func destroyPy(_ py: Py) {
    let memory = py.memory

    var object = memory.lastAllocatedObject
    while let o = object {
      let previous = o.memoryInfo.previous
      memory.destroy(object: o)
      object = previous
    }

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
        Self.round(&self.size, alignment: field.alignment)
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
      // certain operations illegal, but potentially saves memory.
    }

    private static func round(_ value: inout Int, alignment: Int) {
      value += alignment &- 1
      value &-= value % alignment
    }
  }
}
