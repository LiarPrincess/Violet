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
