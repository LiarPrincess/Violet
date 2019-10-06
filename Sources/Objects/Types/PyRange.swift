import Core

// In CPython:
// Objects -> rangeobject.c
// https://docs.python.org/3/library/stdtypes.html#range

// TODO: PyRange
// def __iter__(self) -> Iterator[int]: ...
// def __reversed__(self) -> Iterator[int]: ...

// swiftlint:disable yoda_condition
// swiftlint:disable file_length

/// The range type represents an immutable sequence of numbers
/// and is commonly used for looping a specific number of times in for loops.
internal final class PyRange: PyObject,
  ReprTypeClass, EquatableTypeClass, HashableTypeClass,
  BoolConvertibleTypeClass,
  LengthTypeClass, ContainsTypeClass, GetItemTypeClass, CountTypeClass, IndexOfTypeClass {

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

  /// Result of calling `new`.
  internal typealias NewResult = Either<PyRange, PyErrorEnum>

  internal static func new(_ context: PyContext, stop: PyInt) -> NewResult {
    let zero = context.types.int.new(0)
    return new(context, start: zero, stop: stop, step: nil)
  }

  internal static func new(_ context: PyContext,
                           start: PyInt,
                           stop:  PyInt,
                           step: PyInt?) -> NewResult {
    if let s = step, s.value == 0 {
      return .error(.valueError("range() arg 3 must not be zero"))
    }

    let isGoingUp = start.value < stop.value

    let unwrappedStep: PyInt = {
      if let s = step {
        return s
      }
      return context.types.int.new(isGoingUp ? 1 : -1)
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

    return .value(
      PyRange(
        context,
        start: start,
        stop: stop,
        step: unwrappedStep,
        stepType: step == nil ? .implicit: .explicit,
        length: context.types.int.new(length)
      )
    )
  }

  private init(_ context: PyContext,
               start: PyInt,
               stop: PyInt,
               step: PyInt,
               stepType: StepType,
               length: PyInt) {
    self.start = start
    self.stop = stop
    self.step = step
    self.stepType = stepType
    self.length = length
    super.init(type: context.types.range)
  }

  // MARK: - Equatable

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

  // MARK: - Hashable

  internal var hash: PyHash {
    let none = self.context.none
    let lengthInt = self.pyInt(self.length.value)
    let tuple = self.types.tuple.new([lengthInt, none, none])

    if self.length.value == 0 {
      return self.context.hash(value: tuple)
    }

    tuple.elements[1] = self.start
    if self.length.value != 1 {
      tuple.elements[2] = self.step
    }

    return self.context.hash(value: tuple)
  }

  // MARK: - String

  internal var repr: String {
    let start = self.start.repr
    let stop = self.stop.repr

    switch self.stepType {
    case .implicit:
      return "range(\(start), \(stop))"
    case .explicit:
      return "range(\(start), \(stop), \(self.step.repr))"
    }
  }

  // MARK: - Convertible

  internal var asBool: PyBool {
    return self.types.bool.new(self.length.value)
  }

  // MARK: - Contains

  internal func contains(_ element: PyObject) -> Bool {
    guard let int = self.extractInt(element) else {
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

  internal func getItem(at index: PyObject) -> GetItemResult<PyObject> {
    if let index = self.extractIndex(value: index) {
      let result = self.getItem(at: index)
      return result.flatMap { GetItemResult<PyObject>.value($0) }
    }

    if let slice = index as? PySlice {
      let result = self.getItem(at: slice)
      return result.flatMap { GetItemResult<PyObject>.value($0) }
    }

    return .error(
      .typeError("range indices must be integers or slices, not \(index.type.name)")
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
    return .value(self.pyInt(result))
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
    let step = self.pyInt(sliceStep * self.step.value)

    let result = PyRange.new(self.context, start: start, stop: stop, step: step)
    return result.flatMap { .value($0) }
  }

  // MARK: - Count

  internal func count(_ element: PyObject) -> BigInt {
    if let int = element as? PyInt {
      return self.contains(int) ? 1 : 0
    }

    return 0
  }

  // MARK: - Index

  internal typealias IndexResult = Either<BigInt, PyErrorEnum>

  internal func index(of element: PyObject) -> IndexResult {
    guard let int = element as? PyInt, self.contains(int) else {
      let str = self.context.strString(value: element)
      return .error(.valueError("\(str) is not in range"))
    }

    let tmp = int.value - self.start.value
    let result = tmp / self.step.value
    return .value(result)
  }
}

internal final class PyRangeType: PyType {
//  override internal var name: String { return "range" }
//  override internal var doc: String? { return """
//    range(stop) -> range object
//    range(start, stop[, step]) -> range object
//
//    Return an object that produces a sequence of integers from start (inclusive)
//    to stop (exclusive) by step.  range(i, j) produces i, i+1, i+2, ..., j-1.
//    start defaults to 0, and stop is omitted!  range(4) produces 0, 1, 2, 3.
//    These are exactly the valid indices for a list of 4 elements.
//    When step is given, it specifies the increment (or decrement).
//    """
//  }
}
