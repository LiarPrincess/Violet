import Core

// In CPython:
// Objects -> rangeobject.c
// https://docs.python.org/3/library/stdtypes.html#range

// swiftlint:disable yoda_condition

// sourcery: pytype = range
/// The range type represents an immutable sequence of numbers
/// and is commonly used for looping a specific number of times in for loops.
internal final class PyRange: PyObject, GenericNotEqual {

  internal static let doc: String = """
    range(stop) -> range object
    range(start, stop[, step]) -> range object

    Return an object that produces a sequence of integers from start (inclusive)
    to stop (exclusive) by step.  range(i, j) produces i, i+1, i+2, ..., j-1.
    start defaults to 0, and stop is omitted!  range(4) produces 0, 1, 2, 3.
    These are exactly the valid indices for a list of 4 elements.
    When step is given, it specifies the increment (or decrement).
    """

  internal let start: PyInt
  internal let stop: PyInt
  internal let step: PyInt
  /// Number of elements in range.
  internal let length: PyInt
  private let stepType: StepType

  private enum StepType {
    /// Step was provided in ctor
    case explicit
    /// Step was deducted automatically
    case implicit
  }

  private var isGoingUp: Bool {
    return self.start.value < self.stop.value
  }

  // MARK: - Init

  internal init(_ context: PyContext, start: PyInt, stop: PyInt, step: PyInt?) {
    let isGoingUp = start.value < stop.value

    let unwrappedStep: PyInt = {
      if let s = step {
        return s
      }
      return context._int(isGoingUp ? 1 : -1)
    }()

    let length: BigInt = {
      let low  = isGoingUp ? start : stop
      let high = isGoingUp ? stop : start

      // len(range(0, 3, -1)) -> 0
      guard low.value < high.value else {
        return 0
      }

      let diff = (high.value - low.value) - 1
      return (diff / abs(unwrappedStep.value)) + 1
    }()

    self.start = start
    self.stop = stop
    self.step = unwrappedStep
    self.stepType = step == nil ? .implicit: .explicit
    self.length = context._int(length)

    super.init(type: context.types.range)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> EquatableResult {
    return (other as? PyRange)
      .map(self.isEqual)
      .map(EquatableResult.value) ?? .notImplemented
  }

  internal func isEqual(_ other: PyRange) -> Bool {
    guard self.length.value == other.length.value else {
      return false
    }

    if self.length.value == 0 {
      return true
    }

    guard self.start.isEqual(other.start) else {
      return false
    }

    if self.length.value == 1 {
      return true
    }

    return self.step.isEqual(other.step)
  }

  // sourcery: pymethod = __ne__
  func isNotEqual(_ other: PyObject) -> EquatableResult {
    return self.genericIsNotEqual(other)
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashableResult {
    let none = self.context.none
    var tuple = [self.length, none, none]

    if self.length.value == 0 {
      let result = self.context.hash(value: self.tuple(type))
      return .value(result)
    }

    tuple[1] = self.start
    if self.length.value != 1 {
      tuple[2] = self.step
    }

    let result = self.context.hash(value: self.tuple(type))
    return .value(result)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> String {
    let start = self.start.repr()
    let stop = self.stop.repr()

    switch self.stepType {
    case .implicit:
      return "range(\(start), \(stop))"
    case .explicit:
      return "range(\(start), \(stop), \(self.step.repr()))"
    }
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> PyResult<Bool> {
    return .value(self.length.value > 0)
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return self.length.value
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> Bool {
    guard let int = element as? PyInt else {
      return false
    }

    return self.contains(int)
  }

  private func contains(_ element: PyInt) -> Bool {
    let value = element.value

    // Check if the value can possibly be in the range.
    if self.isGoingUp {
      // positive steps: start <= el < stop
      guard self.start.value <= value && value < self.stop.value else {
        return false
      }
    } else {
      // negative steps: start >= el > stop
      guard self.start.value >= value && value > self.stop.value else {
        return false
      }
    }

    let tmp1 = value - self.start.value
    let tmp2 = tmp1 & self.step.value
    return tmp2 == 0
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> GetItemResult<PyObject> {
    if let index = SequenceHelper.extractIndex(index) {
      let result = self.getItem(at: index)
      return result.flatMap { GetItemResult<PyObject>.value($0) }
    }

    if let slice = index as? PySlice {
      let result = self.getItem(at: slice)
      return result.flatMap { GetItemResult<PyObject>.value($0) }
    }

    return .error(
      .typeError("range indices must be integers or slices, not \(index.typeName)")
    )
  }

  internal func getItem(at index: PyInt) -> GetItemResult<PyInt> {
    return self.getItem(at: index.value)
  }

  internal func getItem(at index: BigInt) -> GetItemResult<PyInt> {
    var index = index

    if index < 0 {
      index += self.length.value
    }

    guard 0 <= index && index < self.length.value else {
      return .error(.indexError("range object index out of range"))
    }

    let result = self.start.value + self.step.value * index
    return .value(self.int(result))
  }

  internal func getItem(at slice: PySlice) -> GetItemResult<PyRange> {
    var start = self.start
    if let sliceStart = slice.start {
      switch self.getItem(at: sliceStart) {
      case let .value(v): start = v
      case let .error(e): return .error(e)
      }
    }

    var stop = self.stop
    if let sliceStop = slice.stop {
      switch self.getItem(at: sliceStop) {
      case let .value(v): stop = v
      case let .error(e): return .error(e)
      }
    }

    let sliceStep = slice.step?.value ?? 1
    let step = self.int(sliceStep * self.step.value)

    let result = self.range(start: start, stop: stop, step: step)
    return result.flatMap { .value($0) }
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(_ element: PyObject) -> CountResult {
    if let int = element as? PyInt {
      return .value(self.contains(int) ? 1 : 0)
    }

    return .value(0)
  }

  // MARK: - Index

  // sourcery: pymethod = index
  internal func getIndex(of element: PyObject) -> PyResult<BigInt> {
    guard let int = element as? PyInt, self.contains(int) else {
      let str = self.context._str(value: element)
      return .error(.valueError("\(str) is not in range"))
    }

    let tmp = int.value - self.start.value
    let result = tmp / self.step.value
    return .value(result)
  }
}
