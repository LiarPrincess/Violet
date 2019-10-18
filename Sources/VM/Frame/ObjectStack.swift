import Objects

/// The main data frame of the stack machine.
internal struct ObjectStack {

  private var elements = [PyObject]()

  internal var top: PyObject {
    get { return self.peek(1) }
    set { self.set(1, to: newValue) }
  }

  internal var second: PyObject {
    get { return self.peek(2) }
    set { self.set(2, to: newValue) }
  }

  internal var third: PyObject {
    get { return self.peek(3) }
    set { self.set(3, to: newValue) }
  }

  internal var fourth: PyObject {
    get { return self.peek(4) }
    set { self.set(4, to: newValue) }
  }

  internal func peek(_ n: Int) -> PyObject {
    return self.elements[self.elements.count - n]
  }

  internal mutating func set(_ n: Int, to value: PyObject) {
    self.elements[self.elements.count - n] = value
  }

  internal var isEmpty: Bool { return self.elements.isEmpty }

  // MARK: - Push

  internal mutating func push(_ value: PyObject) {
    self.elements.push(value)
  }

  // MARK: - Pop

  internal mutating func pop() -> PyObject {
    return self.elements.popLast()!
  }

  /// Pop `count` elements and then reverse, so that first pushed element
  /// is in 1st position.
  internal mutating func popElementsInPushOrder(count: Int) -> [PyObject] {
    var elements = [PyObject]()
    for _ in 0..<count {
      elements.push(self.pop())
    }

    return elements.reversed()
  }
}
