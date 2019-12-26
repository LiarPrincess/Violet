import Core

// In CPython:
// Objects -> rangeobject.c
// https://docs.python.org/3/library/stdtypes.html#range

// swiftlint:disable yoda_condition
// swiftlint:disable file_length

// sourcery: pytype = range, default
/// The range type represents an immutable sequence of numbers
/// and is commonly used for looping a specific number of times in for loops.
public class PyRange: PyObject {

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
    return self.start.value <= self.stop.value
  }

  // MARK: - Init

  internal init(_ context: PyContext, start: PyInt, stop: PyInt, step: PyInt?) {
    let isGoingUp = start.value <= stop.value
    let unwrappedStep = step ?? context.builtins.newInt(isGoingUp ? 1 : -1)

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
    self.stepType = step == nil ? .implicit : .explicit
    self.length = context.builtins.newInt(length)

    super.init(type: context.builtins.types.range)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return (other as? PyRange)
      .map(self.isEqual)
      .map(PyResultOrNot<Bool>.value) ?? .notImplemented
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
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> PyResultOrNot<PyHash> {
    let none = self.builtins.none
    var tuple = [self.length, none, none]

    if self.length.value == 0 {
      let data = PySequenceData(elements: tuple)
      return data.hash.asResultOrNot
    }

    tuple[1] = self.start
    if self.length.value != 1 {
      tuple[2] = self.step
    }

    let data = PySequenceData(elements: tuple)
    return data.hash.asResultOrNot
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let start = self.start.repr()
    let stop = self.stop.repr()

    switch self.stepType {
    case .implicit:
      return .value("range(\(start), \(stop))")
    case .explicit:
      return .value("range(\(start), \(stop), \(self.step.repr()))")
    }
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> Bool {
    return self.length.value > 0
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal func getLength() -> BigInt {
    return self.length.value
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal func contains(_ element: PyObject) -> PyResult<Bool> {
    guard let int = element as? PyInt else {
      return .value(false)
    }

    return .value(self.contains(int))
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
    let tmp2 = tmp1 % self.step.value
    return tmp2 == 0
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  internal func getItem(at index: PyObject) -> PyResult<PyObject> {
    switch IndexHelper.tryInt(index) {
    case .value(let int):
      // swiftlint:disable:next array_init
      return self.getItem(at: BigInt(int)).map { $0 }
    case .notIndex: break // Try slice
    case .error(let e): return .error(e)
    }

    if let slice = index as? PySlice {
      let result = self.getItem(at: slice)
      return result.flatMap { PyResult<PyObject>.value($0) }
    }

    return .typeError(
      "range indices must be integers or slices, not \(index.typeName)"
    )
  }

  internal func getItem(at index: PyInt) -> PyResult<PyInt> {
    return self.getItem(at: index.value)
  }

  internal func getItem(at index: Int) -> PyResult<PyInt> {
    return self.getItem(at: BigInt(index))
  }

  internal func getItem(at index: BigInt) -> PyResult<PyInt> {
    var index = index

    if index < 0 {
      index += self.length.value
    }

    guard 0 <= index && index < self.length.value else {
      return .indexError("range object index out of range")
    }

    let result = self.start.value + self.step.value * index
    return .value(self.builtins.newInt(result))
  }

  internal func getItem(at slice: PySlice) -> PyResult<PyRange> {
    let length: Int
    switch IndexHelper.int(self.length) {
    case let .value(l): length = l
    case let .error(e): return .error(e)
    }

    let indices: PySlice.GetLongIndicesResult
    switch slice.getLongIndices(length: length) {
    case let .value(i):indices = i
    case let .error(e): return .error(e)
    }

    let subStart: PyInt
    switch self.getItem(at: indices.start) {
    case let .value(s): subStart = s
    case let .error(e): return .error(e)
    }

    let subStop: PyInt
    switch self.getItem(at: indices.stop) {
    case let .value(s): subStop = s
    case let .error(e): return .error(e)
    }

    let subStep = self.step.value * BigInt(indices.step)

    return self.builtins.newRange(start: subStart,
                                  stop: subStop,
                                  step: self.builtins.newInt(subStep))
  }

  // MARK: - Start

  // sourcery: pymethod = start
  internal func getStart() -> PyInt {
    return self.start
  }

  // MARK: - Stop

  // sourcery: pymethod = stop
  internal func getStop() -> PyInt {
    return self.stop
  }

  // MARK: - Step

  // sourcery: pymethod = step
  internal func getStep() -> PyInt {
    return self.step
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(_ element: PyObject) -> PyResult<BigInt> {
    if let int = element as? PyInt {
      return .value(self.contains(int) ? 1 : 0)
    }

    return .value(0)
  }

  // MARK: - Index

  // sourcery: pymethod = index
  internal func index(of element: PyObject) -> PyResult<BigInt> {
    guard let int = element as? PyInt, self.contains(int) else {
      switch self.builtins.strValue(element) {
      case .value(let str):
        return .valueError("\(str) is not in range")
      case .error:
        return .valueError("element is not in range")
      }
    }

    let tmp = int.value - self.start.value
    let result = tmp / self.step.value
    return .value(result)
  }
}
