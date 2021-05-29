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
  public func isEqual(_ other: PyObject) -> CompareResult {
    guard let otherRange = other as? PyRange else {
      return .notImplemented
    }

    return .value(self.isEqual(otherRange))
  }

  public func isEqual(_ other: PyRange) -> Bool {
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
  public func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  public func isLess(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __le__
  public func isLessEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __gt__
  public func isGreater(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // sourcery: pymethod = __ge__
  public func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  public func hash() -> HashResult {
    var tuple = [self.length, Py.none, Py.none]

    if self.length.value == 0 {
      let data = PySequenceData(elements: tuple)
      return data.hash.asHashResult
    }

    tuple[1] = self.start
    if self.length.value != 1 {
      tuple[2] = self.step
    }

    let data = PySequenceData(elements: tuple)
    return data.hash.asHashResult
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  public func repr() -> PyResult<String> {
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
  public func asBool() -> Bool {
    return self.length.value.isTrue
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  public func getClass() -> PyType {
    return self.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  public func getLength() -> BigInt {
    return self.length.value
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  public func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  public func contains(element: PyObject) -> PyResult<Bool> {
    guard let int = element as? PyInt else {
      return .value(false)
    }

    return .value(self.contains(element: int))
  }

  public func contains(element: PyInt) -> Bool {
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
  /// static PyObject *
  /// range_subscript(rangeobject* self, PyObject* item)
  public func getItem(index: PyObject) -> PyResult<PyObject> {
    switch IndexHelper.bigInt(index) {
    case .value(let int):
      // swiftlint:disable:next array_init
      return self.getItem(index: int).map { $0 }
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = index as? PySlice {
      let result = self.getItem(slice: slice)
      return result.flatMap { PyResult<PyObject>.value($0) }
    }

    let msg = "range indices must be integers or slices, not \(index.typeName)"
    return .typeError(msg)
  }

  public func getItem(index: PyInt) -> PyResult<PyInt> {
    return self.getItem(index: index.value)
  }

  public func getItem(index: Int) -> PyResult<PyInt> {
    return self.getItem(index: BigInt(index))
  }

  public func getItem(index: BigInt) -> PyResult<PyInt> {
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
  public func getItem(slice: PySlice) -> PyResult<PyRange> {
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
  public func getStart() -> PyObject {
    return self.start
  }

  // MARK: - Stop

  // sourcery: pyproperty = stop
  public func getStop() -> PyObject {
    return self.stop
  }

  // MARK: - Step

  // sourcery: pyproperty = step
  public func getStep() -> PyObject {
    return self.step
  }

  // MARK: - Reversed

  // sourcery: pymethod = __reversed__
  public func reversed() -> PyObject {
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

    return PyRangeIterator(start: newStart,
                           step: newStep,
                           length: newLength)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  public func iter() -> PyObject {
    return PyRangeIterator(start: self.start.value,
                           step: self.step.value,
                           length: self.length.value)
  }

  // MARK: - Count

  // sourcery: pymethod = count
  public func count(element: PyObject) -> PyResult<BigInt> {
    if let int = element as? PyInt {
      return .value(self.contains(element: int) ? 1 : 0)
    }

    return .value(0)
  }

  // MARK: - Index

  // sourcery: pymethod = index
  public func index(of element: PyObject) -> PyResult<BigInt> {
    guard let int = element as? PyInt, self.contains(element: int) else {
      switch Py.strValue(object: element) {
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

  // MARK: - Range

  // sourcery: pymethod = __reduce__
  public func reduce(args: [PyObject], kwargs: PyDict?) -> PyTuple {
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
