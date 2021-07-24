import BigInt
import VioletCore

// swiftlint:disable yoda_condition
// swiftlint:disable file_length
// cSpell:ignore rangeobject

// In CPython:
// Objects -> rangeobject.c
// https://docs.python.org/3/library/stdtypes.html#range

// sourcery: pytype = range, default
/// The range type represents an immutable sequence of numbers
/// and is commonly used for looping a specific number of times in for loops.
public final class PyRange: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
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
  /// Remember how user created this range (`repr` depends on it).
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

  override public var description: String {
    let start = self.start
    let stop = self.stop
    let step = self.step
    return "PyRange(start: \(start), stop: \(stop), step: \(step))"
  }

  // MARK: - Init

  internal init(start: PyInt, stop: PyInt, step: PyInt?) {
    assert(
      step?.value != 0,
      "PyRange.step cannot be 0. Use 'Py.newRange' to handle this case."
    )

    let unwrappedStep = step?.value ?? 1
    let length = PyRange.calculateLength(start: start.value,
                                         stop: stop.value,
                                         step: unwrappedStep)

    self.start = start
    self.stop = stop
    self.step = Py.newInt(unwrappedStep)
    self.stepType = step == nil ? .implicit : .explicit
    self.length = Py.newInt(length)

    super.init(type: Py.types.range)
  }

  private static func calculateLength(start: BigInt,
                                      stop: BigInt,
                                      step: BigInt) -> BigInt {
    let isGoingUp = step >= 0
    let low = isGoingUp ? start : stop
    let high = isGoingUp ? stop : start

    // len(range(0, 3, -1)) -> 0
    guard low < high else {
      return 0
    }

    let diff = high - low - 1
    return (diff / abs(step)) + 1
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let otherRange = PyCast.asRange(other) else {
      return .notImplemented
    }

    return .value(self.isEqual(otherRange))
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
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    var tuple = [self.length, Py.none, Py.none]

    if self.length.value == 0 {
      return PyTuple.calculateHash(elements: tuple)
    }

    tuple[1] = self.start
    if self.length.value != 1 {
      tuple[2] = self.step
    }

    return PyTuple.calculateHash(elements: tuple)
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
      let step = self.step.repr()
      return "range(\(start), \(stop), \(step))"
    }
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal func asBool() -> Bool {
    return self.length.value.isTrue
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
  internal func contains(object: PyObject) -> PyResult<Bool> {
    guard let int = PyCast.asInt(object) else {
      return .value(false)
    }

    let result = self.contains(int: int)
    return .value(result)
  }

  internal func contains(int: PyInt) -> Bool {
    let value = int.value

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
  /// static PyObject *
  /// range_subscript(rangeobject* self, PyObject* item)
  internal func getItem(index: PyObject) -> PyResult<PyObject> {
    switch IndexHelper.bigInt(index) {
    case .value(let int):
      // swiftlint:disable:next array_init
      return self.getItem(index: int).map { $0 }
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = PyCast.asSlice(index) {
      let result = self.getItem(slice: slice)
      return result.flatMap { PyResult<PyObject>.value($0) }
    }

    let msg = "range indices must be integers or slices, not \(index.typeName)"
    return .typeError(msg)
  }

  internal func getItem(index: PyInt) -> PyResult<PyInt> {
    return self.getItem(index: index.value)
  }

  internal func getItem(index: Int) -> PyResult<PyInt> {
    return self.getItem(index: BigInt(index))
  }

  internal func getItem(index: BigInt) -> PyResult<PyInt> {
    var index = index

    if index < 0 {
      index += self.length.value
    }

    guard 0 <= index && index < self.length.value else {
      return .indexError("range object index out of range")
    }

    let result = self.start.value + self.step.value * index
    return .value(Py.newInt(result))
  }

  /// static PyObject *
  /// compute_slice(rangeobject *r, PyObject *_slice)
  internal func getItem(slice: PySlice) -> PyResult<PyRange> {
    let length = self.length.value

    let indices: PySlice.GetLongIndicesResult
    switch slice.getLongIndices(length: length) {
    case let .value(i): indices = i
    case let .error(e): return .error(e)
    }

    let subStep = self.step.value * indices.step
    let subStart = self.computeItem(at: indices.start)
    let subStop = self.computeItem(at: indices.stop)

    return Py.newRange(start: subStart,
                       stop: subStop,
                       step: subStep)
  }

  /// static PyObject *
  /// compute_item(rangeobject *r, PyObject *i)
  private func computeItem(at index: BigInt) -> BigInt {
    return self.start.value + index * self.step.value
  }

  // MARK: - Start

  // sourcery: pyproperty = start
  internal func getStart() -> PyObject {
    return self.start
  }

  // MARK: - Stop

  // sourcery: pyproperty = stop
  internal func getStop() -> PyObject {
    return self.stop
  }

  // MARK: - Step

  // sourcery: pyproperty = step
  internal func getStep() -> PyObject {
    return self.step
  }

  // MARK: - Reversed

  // sourcery: pymethod = __reversed__
  internal func reversed() -> PyObject {
    // `reversed(range(start, stop, step))` can be expressed as
    // `range(start + (n-1) * step, start-step, -step)`,
    // where n is the number of integers in the range (length).

    let start = self.start.value
    let step = self.step.value
    let length = self.length.value

    // Example: start: 3, stop: 17, step: 2
    // range(3, 17, 2):  3,  5,  7, 9, 11, 13, 15
    // reversed:        15, 13, 11, 9,  7,  5,  3 = range(15, 1, -2)
    let newStop = start - step // 3 - 2 = 1
    let newStart = newStop + length * step // 1 + 7 * 2 = 1 + 14 = 15
    let newStep = -step // -2

    let newLength = PyRange.calculateLength(start: newStart,
                                            stop: newStop,
                                            step: newStep)

    return PyMemory.newRangeIterator(start: newStart,
                                     step: newStep,
                                     length: newLength)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal func iter() -> PyObject {
    return PyMemory.newRangeIterator(start: self.start.value,
                                     step: self.step.value,
                                     length: self.length.value)
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal func count(object: PyObject) -> PyResult<BigInt> {
    if let int = PyCast.asInt(object) {
      let contains = self.contains(int: int)
      return .value(contains ? 1 : 0)
    }

    return .value(0)
  }

  // MARK: - Index

  // sourcery: pymethod = index
  internal func indexOf(object: PyObject) -> PyResult<BigInt> {
    guard let int = PyCast.asInt(object), self.contains(int: int) else {
      switch Py.strString(object: object) {
      case .value(let str):
        return .valueError("\(str) is not in range")
      case .error:
        return .valueError("element is not in range")
      }
    }

    let tmp0 = int.value - self.start.value
    let tmp1 = tmp0 / self.step.value
    return .value(tmp1)
  }

  // MARK: - Range

  // sourcery: pymethod = __reduce__
  internal func reduce(args: [PyObject], kwargs: PyDict?) -> PyTuple {
    let props = Py.newTuple(self.start, self.stop, self.step)
    return Py.newTuple(self.type, props)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PyRange> {
    if let e = ArgumentParser.noKwargsOrError(fnName: "range", kwargs: kwargs) {
      return .error(e)
    }

    // Guarantee that we have 1, 2 or 3 arguments
    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "range",
                                                        args: args,
                                                        min: 1,
                                                        max: 3) {
      return .error(e)
    }

    // Handle 1 argument
    if args.count == 1 {
      return Py.newRange(stop: args[0])
    }

    // Handle 2 or 3 arguments
    let start = args[0]
    let stop = args[1]
    let step = args.count == 3 ? args[2] : nil
    return Py.newRange(start: start, stop: stop, step: step)
  }
}
