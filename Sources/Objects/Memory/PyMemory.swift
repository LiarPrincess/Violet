public final class PyMemory {

  private var firstAllocatedObject: PyObject?
  private var lastAllocatedObject: PyObject?

  internal let py: Py

  #if DEBUG
  private var allocatedObjectCount = 0
  private var destroyedObjectCount = 0
  #endif

  internal init(_ py: Py) {
    self.py = py
  }

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

  internal static func allocate(byteCount: Int, alignment: Int) -> RawPtr {
    return RawPtr.allocate(byteCount: byteCount, alignment: alignment)
  }

  public func destroy(object: PyObject) {
    let ptr = object.ptr

    // 1. Remove it from the list.
    let previous = object.memoryInfo.previous
    let next = object.memoryInfo.next

    previous?.memoryInfo.next = next
    next?.memoryInfo.previous = previous

    if let first = self.firstAllocatedObject, first.ptr === ptr {
      self.firstAllocatedObject = next
    }

    if let last = self.lastAllocatedObject, last.ptr === ptr {
      self.lastAllocatedObject = previous
    }

    // 2. Deinitialize & deallocate.
    // A new object may be allocated during 'deinitialize'!
    object.type.deinitialize(self.py, ptr)
    object.ptr.deallocate()

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

    // Remember that objects may be created in the 'deinitialize' functions!
    while let object = memory.lastAllocatedObject {
      memory.destroy(object: object)
    }

    py.deinitialize()
    py.ptr.deallocate()
  }
}
