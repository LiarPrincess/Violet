import BigInt
import VioletCore

// swiftlint:disable yoda_condition
// cSpell:ignore rangeobject

// In CPython:
// Objects -> rangeobject.c
// https://docs.python.org/3/library/stdtypes.html#range

// sourcery: pytype = range, isDefault
/// The range type represents an immutable sequence of numbers
/// and is commonly used for looping a specific number of times in for loops.
public struct PyRange: PyObjectMixin {

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

  // MARK: - Properties

  // sourcery: storedProperty
  internal var start: PyInt { self.startPtr.pointee }
  // sourcery: storedProperty
  internal var stop: PyInt { self.stopPtr.pointee }
  // sourcery: storedProperty
  internal var step: PyInt { self.stepPtr.pointee }
  // sourcery: storedProperty
  /// Number of elements in range.
  internal var length: PyInt { self.lengthPtr.pointee }

  private enum StepType {
    /// Step was provided in `init`.
    case explicit
    /// Step was deducted automatically.
    case implicit
  }

  private static let isStepImplicitFlag = PyObject.Flags.custom0

  /// Remember how user created this range (`repr` depends on it).
  private var stepType: StepType {
    get {
      let isImplicit = self.flags.isSet(PyRange.isStepImplicitFlag)
      return isImplicit ? .implicit : .explicit
    }
    nonmutating set {
      switch newValue {
      case .implicit: self.flags.set(PyRange.isStepImplicitFlag, value: true)
      case .explicit: self.flags.set(PyRange.isStepImplicitFlag, value: false)
      }
    }
  }

  private var isGoingUp: Bool {
    return self.start.value <= self.stop.value
  }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  internal func initialize(_ py: Py,
                           type: PyType,
                           start: PyInt,
                           stop: PyInt,
                           step: PyInt?) {
    assert(
      step?.value != 0,
      "PyRange.step cannot be 0. Use 'Py.newRange' to handle this case."
    )

    let unwrappedStep = step?.value ?? 1
    let length = Self.calculateLength(start: start.value,
                                      stop: stop.value,
                                      step: unwrappedStep)

    self.initializeBase(py, type: type)
    self.startPtr.initialize(to: start)
    self.stopPtr.initialize(to: stop)
    self.stepPtr.initialize(to: py.newInt(unwrappedStep))
    self.lengthPtr.initialize(to: py.newInt(length))

    self.stepType = step == nil ? .implicit : .explicit
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

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PyRange(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "start", value: zelf.start, includeInDescription: true)
    result.append(name: "stop", value: zelf.stop, includeInDescription: true)
    result.append(name: "step", value: zelf.step, includeInDescription: true)
    result.append(name: "stepType", value: zelf.stepType)
    return result
  }

  // MARK: - Equatable, comparable

  // sourcery: pymethod = __eq__
  internal static func __eq__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__eq__)
    }

    return Self.isEqual(py, zelf: zelf, other: other)
  }

  // sourcery: pymethod = __ne__
  internal static func __ne__(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, .__ne__)
    }

    let isEqual = Self.isEqual(py, zelf: zelf, other: other)
    return isEqual.not
  }

  internal static func isEqual(_ py: Py, zelf: PyRange, other: PyObject) -> CompareResult {
    guard let other = Self.downcast(py, other) else {
      return .notImplemented
    }

    let length = zelf.length
    guard length == other.length else {
      return .value(false)
    }

    if length == 0 {
      return .value(true)
    }

    guard zelf.start == other.start else {
      return .value(false)
    }

    if length.value == 1 {
      return .value(true)
    }

    let result = zelf.step == other.step
    return .value(result)
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__lt__)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__le__)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__gt__)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py, zelf: zelf, operation: .__ge__)
  }

  private static func compare(_ py: Py,
                              zelf: PyObject,
                              operation: CompareResult.Operation) -> CompareResult {
    guard Self.downcast(py, zelf) != nil else {
      return .invalidSelfArgument(zelf, Self.pythonTypeName, operation)
    }

    return .notImplemented
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    let length = zelf.length
    let none = py.none.asObject
    var tuple = [length.asObject, none, none]

    if length == 0 {
      return PyTuple.calculateHash(py, elements: tuple)
    }

    tuple[1] = zelf.start.asObject
    if length != 1 {
      tuple[2] = zelf.step.asObject
    }

    return PyTuple.calculateHash(py, elements: tuple)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    let start = String(describing: zelf.start.value)
    let stop = String(describing: zelf.stop.value)

    let result: String
    switch zelf.stepType {
    case .implicit:
      result = "range(\(start), \(stop))"
    case .explicit:
      let step = String(describing: zelf.step.value)
      result = "range(\(start), \(stop), \(step))"
    }

    return PyResult(py, result)
  }

  // MARK: - Convertible

  // sourcery: pymethod = __bool__
  internal static func __bool__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__bool__")
    }

    let result = zelf.length.value.isTrue
    return PyResult(py, result)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
  }

  // MARK: - Length

  // sourcery: pymethod = __len__
  internal static func __len__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__len__")
    }

    let result = zelf.length
    return PyResult(result)
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal static func __getattribute__(_ py: Py,
                                        zelf _zelf: PyObject,
                                        name: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getattribute__")
    }

    return AttributeHelper.getAttribute(py, object: zelf.asObject, name: name)
  }

  // MARK: - Contains

  // sourcery: pymethod = __contains__
  internal static func __contains__(_ py: Py,
                                    zelf _zelf: PyObject,
                                    object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__contains__")
    }

    guard let int = py.cast.asInt(object) else {
      return PyResult(py, false)
    }

    let result = Self.contains(zelf: zelf, int: int)
    return PyResult(py, result)
  }

  private static func contains(zelf: PyRange, int: PyInt) -> Bool {
    let value = int.value

    // Check if the value can possibly be in the range.
    if zelf.isGoingUp {
      // positive steps: start <= el < stop
      guard zelf.start <= value && value < zelf.stop else {
        return false
      }
    } else {
      // negative steps: start >= el > stop
      guard zelf.start >= value && value > zelf.stop else {
        return false
      }
    }

    let tmp1 = value - zelf.start.value
    let tmp2 = tmp1 % zelf.step.value
    return tmp2 == 0
  }

  // MARK: - Get item

  // sourcery: pymethod = __getitem__
  /// static PyObject *
  /// range_subscript(rangeobject* self, PyObject* item)
  internal static func __getitem__(_ py: Py,
                                   zelf _zelf: PyObject,
                                   index: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__getitem__")
    }

    switch IndexHelper.pyInt(py, object: index) {
    case .value(let int):
      let result = Self.getItem(py, zelf: zelf, index: int)
      return PyResult(py, result)
    case .notIndex:
      break // Try slice
    case .error(let e):
      return .error(e)
    }

    if let slice = py.cast.asSlice(index) {
      let result = Self.getItem(py, zelf: zelf, slice: slice)
      return PyResult(result)
    }

    let message = "range indices must be integers or slices, not \(index.typeName)"
    return .typeError(py, message: message)
  }

  private static func getItem(_ py: Py,
                              zelf: PyRange,
                              index: PyInt) -> PyResultGen<BigInt> {
    var index = index.value

    if index < 0 {
      index += zelf.length.value
    }

    guard 0 <= index && index < zelf.length else {
      return .indexError(py, message: "range object index out of range")
    }

    let result = zelf.start.value + zelf.step.value * index
    return .value(result)
  }

  /// static PyObject *
  /// compute_slice(rangeobject *r, PyObject *_slice)
  private static func getItem(_ py: Py,
                              zelf: PyRange,
                              slice: PySlice) -> PyResultGen<PyRange> {
    let length = zelf.length.value

    let indices: PySlice.GetLongIndicesResult
    switch PySlice.getLongIndices(py, zelf: slice, length: length) {
    case let .value(i): indices = i
    case let .error(e): return .error(e)
    }

    let subStep = zelf.step.value * indices.step
    let subStart = Self.computeItem(zelf: zelf, index: indices.start)
    let subStop = Self.computeItem(zelf: zelf, index: indices.stop)

    return py.newRange(start: subStart, stop: subStop, step: subStep)
  }

  /// static PyObject *
  /// compute_item(rangeobject *r, PyObject *i)
  private static func computeItem(zelf: PyRange, index: BigInt) -> BigInt {
    return zelf.start.value + index * zelf.step.value
  }

  // MARK: - Start, stop, step

  // sourcery: pyproperty = start
  internal static func start(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "start")
    }

    return PyResult(zelf.start)
  }

  // sourcery: pyproperty = stop
  internal static func stop(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "stop")
    }

    return PyResult(zelf.stop)
  }

  // sourcery: pyproperty = step
  internal static func step(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "step")
    }

    return PyResult(zelf.step)
  }

  // MARK: - Reversed

  // sourcery: pymethod = __reversed__
  internal static func __reversed__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__reversed__")
    }

    // `reversed(range(start, stop, step))` can be expressed as
    // `range(start + (n-1) * step, start-step, -step)`,
    // where n is the number of integers in the range (length).

    let start = zelf.start.value
    let step = zelf.step.value
    let length = zelf.length.value

    // Example: start: 3, stop: 17, step: 2
    // range(3, 17, 2):  3,  5,  7, 9, 11, 13, 15
    // reversed:        15, 13, 11, 9,  7,  5,  3 = range(15, 1, -2)
    let newStop = start - step // 3 - 2 = 1
    let newStart = newStop + length * step // 1 + 7 * 2 = 1 + 14 = 15
    let newStep = -step // -2

    let newLength = PyRange.calculateLength(start: newStart,
                                            stop: newStop,
                                            step: newStep)

    // >>> r = range(1, 2)
    // >>> reversed(r)
    // <range_iterator object at 0x10f2fbd20>
    let result = py.newRangeIterator(start: newStart,
                                     step: newStep,
                                     length: newLength)

    return PyResult(result)
  }

  // MARK: - Iter

  // sourcery: pymethod = __iter__
  internal static func __iter__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__iter__")
    }

    let start = zelf.start.value
    let step = zelf.step.value
    let length = zelf.length.value
    let result = py.newRangeIterator(start: start, step: step, length: length)
    return PyResult(result)
  }

  // MARK: - Count

  // sourcery: pymethod = count
  internal static func count(_ py: Py,
                             zelf _zelf: PyObject,
                             object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "count")
    }

    if let int = py.cast.asInt(object) {
      let contains = Self.contains(zelf: zelf, int: int)
      let result = contains ? 1 : 0
      return PyResult(py, result)
    }

    return PyResult(py, 0)
  }

  // MARK: - Index

  // sourcery: pymethod = index
  internal static func index(_ py: Py,
                             zelf _zelf: PyObject,
                             object: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "index")
    }

    guard let int = py.cast.asInt(object), Self.contains(zelf: zelf, int: int) else {
      switch py.strString(object) {
      case .value(let str):
        return .valueError(py, message: "\(str) is not in range")
      case .error:
        return .valueError(py, message: "element is not in range")
      }
    }

    let tmp0 = int.value - zelf.start.value
    let tmp1 = tmp0 / zelf.step.value
    return PyResult(py, tmp1)
  }

  // MARK: - Reduce

  // sourcery: pymethod = __reduce__
  internal static func __reduce__(_ py: Py,
                                  zelf _zelf: PyObject,
                                  args: [PyObject],
                                  kwargs: PyDict?) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__reduce__")
    }

    let start = zelf.start.asObject
    let stop = zelf.stop.asObject
    let step = zelf.step.asObject
    let props = py.newTuple(elements: start, stop, step)

    let type = zelf.type.asObject
    let result = py.newTuple(elements: type, props.asObject)

    return PyResult(result)
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func __new__(_ py: Py,
                               type: PyType,
                               args: [PyObject],
                               kwargs: PyDict?) -> PyResult {
    if let e = ArgumentParser.noKwargsOrError(py,
                                              fnName: Self.pythonTypeName,
                                              kwargs: kwargs) {
      return .error(e.asBaseException)
    }

    // Guarantee that we have 1, 2 or 3 arguments
    if let e = ArgumentParser.guaranteeArgsCountOrError(py,
                                                        fnName: Self.pythonTypeName,
                                                        args: args,
                                                        min: 1,
                                                        max: 3) {
      return .error(e.asBaseException)
    }

    // Handle 1 argument
    if args.count == 1 {
      let result = py.newRange(stop: args[0])
      return PyResult(result)
    }

    // Handle 2 or 3 arguments
    let start = args[0]
    let stop = args[1]
    let step = args.count == 3 ? args[2] : nil
    let result = py.newRange(start: start, stop: stop, step: step)
    return PyResult(result)
  }
}
