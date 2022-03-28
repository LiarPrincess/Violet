// swiftlint:disable empty_count

extension PyFrame {

  // MARK: - Allocate

  internal func allocateObjectStack(_ py: Py, code: PyCode) -> BufferPtr<PyObject> {
    // 'PyObject' is trivial, so we don't have to initialize the memory.
    let count = Swift.max(code.predictedObjectStackCount, 128)
    return Self.allocateBuffer(count: count)
  }

  private static func allocateBuffer(count: Int) -> BufferPtr<PyObject> {
    let stride = MemoryLayout<PyObject>.stride
    let alignment = MemoryLayout<PyObject>.alignment
    let rawPtr = PyMemory.allocate(byteCount: count * stride, alignment: alignment)
    return rawPtr.bind(to: PyObject.self, count: count)
  }

  // MARK: - Deallocate

  internal func deallocateObjectStack() {
    Self.deallocateBuffer(ptr: self.objectStackStorage)
  }

  private static func deallocateBuffer(ptr: BufferPtr<PyObject>) {
    let rawPtr = ptr.deinitialize()
    rawPtr.deallocate()
  }

  // MARK: - Stack

  public struct ObjectStackProxy {

    // swiftlint:disable:next nesting
    internal typealias EndPtr = UnsafeMutablePointer<PyObject>

    /// Top of the stack.
    /// Undefined result if used on empty stack.
    public var top: PyObject {
      get { return self.endPointer.advanced(by: -1).pointee }
      nonmutating set { self.endPointer.advanced(by: -1).pointee = newValue }
    }

    /// Object below `self.top`.
    /// Undefined result if `self.count < 2`.
    public var second: PyObject {
      get { return self.endPointer.advanced(by: -2).pointee }
      nonmutating set { self.endPointer.advanced(by: -2).pointee = newValue }
    }

    /// Object below `self.second`.
    /// Undefined result if `self.count < 3`.
    public var third: PyObject {
      get { return self.endPointer.advanced(by: -3).pointee }
      nonmutating set { self.endPointer.advanced(by: -3).pointee = newValue }
    }

    /// Object below `self.third`.
    /// Undefined result if `self.count < 4`.
    public var fourth: PyObject {
      get { return self.endPointer.advanced(by: -4).pointee }
      nonmutating set { self.endPointer.advanced(by: -4).pointee = newValue }
    }

    public var isEmpty: Bool {
      return self.endPointer == self.buffer.baseAddress
    }

    /// CPython `stacklevel`.
    public var count: Int {
      return self.buffer.baseAddress.distance(to: self.endPointer)
    }

    /// Predicted object count next time this `code` executes.
    /// Used to optimize allocation size.
    public var predictedNextRunCount: Int {
      return self.buffer.count
    }

    /// Shortcut to `frame.objectStackStorage`.
    private var buffer: BufferPtr<PyObject> {
      get { self.bufferPtr.pointee }
      nonmutating set { self.bufferPtr.pointee = newValue }
    }

    /// Pointer to the element AFTER the top of the stack.
    private var endPointer: EndPtr {
      get { self.endPointerPtr.pointee }
      nonmutating set { self.endPointerPtr.pointee = newValue }
    }

    /// `self.buffer` is not stored here! It is actually stored in `frame`.
    /// So when we want to resize `self.buffer` we actually have to update
    /// `frame.objectStackStorage`.
    /// This property is a proxy to `frame.objectStackStorage`.
    ///
    /// Don't think about it, just use `self.buffer`.
    private let bufferPtr: Ptr<BufferPtr<PyObject>>
    /// `self.endPointer` is not stored here! It is actually stored in `frame`.
    /// So when we want to update `self.endPointer` we actually have to update
    /// `frame.objectStackEnd`. This property is a proxy to `frame.objectStackEnd`.
    ///
    /// Don't think about it, just use `self.endPointer`.
    private let endPointerPtr: Ptr<EndPtr>

    internal init(frame: PyFrame) {
      self.bufferPtr = frame.objectStackStoragePtr
      self.endPointerPtr = frame.objectStackEndPtr
    }

    // MARK: - Peek/set

    public func peek(_ n: Int) -> PyObject {
      assert(
        0 <= n && n < self.count,
        "Peek out of bounds (n: \(n), count: \(self.count))."
      )

      // '-1' because 'endPointer' is after last object.
      let ptr = self.endPointer.advanced(by: -n - 1)
      return ptr.pointee
    }

    public func set(_ n: Int, object: PyObject) {
      assert(
        0 <= n && n < self.count,
        "Set out of bounds (n: \(n), count: \(self.count))."
      )

      // '-1' because 'endPointer' is after last object.
      let ptr = self.endPointer.advanced(by: -n - 1)
      ptr.pointee = object
    }

    // MARK: - Push

    public func push(_ object: PyObject) {
      self.resizeIfNeeded(pushCount: 1)
      self.endPointer.pointee = object
      self.endPointer = self.endPointer.successor()
    }

    public func push<C: Collection>(
      contentsOf objects: C
    ) where C.Element == PyObject {
      self.resizeIfNeeded(pushCount: objects.count)

      for object in objects {
        self.endPointer.pointee = object
        self.endPointer = self.endPointer.successor()
      }
    }

    private func resizeIfNeeded(pushCount: Int) {
      // Both 'self.count' and 'self.buffer.count' are stored inline inside this
      // 'struct', so this check is trivial.
      let count = self.count
      let bufferCount = self.buffer.count

      if bufferCount >= count + pushCount {
        return
      }

      // We need a new buffer!
      let newCount = self.roundToNextMultipleOf256(count + pushCount)
      let newBuffer = PyFrame.allocateBuffer(count: newCount)
      newBuffer.initialize(from: self.buffer)
      // Elements after 'self.count' are uninitialized
      // (they are trivial, so whatever).

      PyFrame.deallocateBuffer(ptr: self.buffer)

      self.buffer = newBuffer
      self.endPointer = newBuffer.baseAddress.advanced(by: count)
    }

    private func roundToNextMultipleOf256(_ n: Int) -> Int {
      // If we are exactly the multiple of 256 then add another 256.
      let (_, remainder) = n.quotientAndRemainder(dividingBy: 256)
      return n - remainder + 256
    }

    // MARK: - Pop

    public func pop() -> PyObject {
      assert(!self.isEmpty, "Pop from an empty stack.")
      self.endPointer = self.endPointer.predecessor()
      return self.endPointer.pointee
    }

    /// Pop `count` elements and then reverse,
    /// so that first pushed element is at `0` index.
    ///
    /// So, basically it will slice stack `count` elements from the end
    /// and return this slice.
    public func popElementsInPushOrder(count: Int) -> [PyObject] {
      assert(
        self.count >= count,
        "Pop elements out of bounds (pop: \(count), count: \(self.count))."
      )

      // Fast check to avoid allocation.
      if count == 0 {
        return []
      }

      let resultStart = self.count - count
      let resultBuffer = self.buffer[resultStart..<self.count]
      let result = Array(resultBuffer)

      self.endPointer = self.endPointer.advanced(by: -count)
      return result
    }

    /// Pop elements until we reach `untilCount`.
    public func pop(untilCount: Int) {
      assert(
        untilCount <= self.count,
        "Pop until count out of bounds (pop: \(untilCount), count: \(self.count))."
      )

      self.endPointer = self.buffer.baseAddress.advanced(by: untilCount)
    }
  }
}
