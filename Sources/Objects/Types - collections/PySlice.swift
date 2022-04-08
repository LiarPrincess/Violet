import BigInt
import VioletCore

// cSpell:ignore sliceobject

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html

// sourcery: pytype = slice, isDefault, hasGC
/// The type object for slice objects.
/// This is the same as slice in the Python layer.
public struct PySlice: PyObjectMixin {

  // sourcery: pytypedoc
  internal static let doc = """
    slice(stop)
    slice(start, stop[, step])

    Create a slice object.
    This is used for extended slicing (e.g. a[0:10:2]).
    """

  // MARK: - Properties

  // sourcery: storedProperty
  internal var start: PyObject { self.startPtr.pointee }
  // sourcery: storedProperty
  internal var stop: PyObject { self.stopPtr.pointee }
  // sourcery: storedProperty
  internal var step: PyObject { self.stepPtr.pointee }

  // MARK: - Swift init

  public let ptr: RawPtr

  public init(ptr: RawPtr) {
    self.ptr = ptr
  }

  // MARK: - Initialize/deinitialize

  internal func initialize(_ py: Py,
                           type: PyType,
                           start: PyObject,
                           stop: PyObject,
                           step: PyObject) {
    self.initializeBase(py, type: type)
    self.startPtr.initialize(to: start)
    self.stopPtr.initialize(to: stop)
    self.stepPtr.initialize(to: step)
  }

  // Nothing to do here.
  internal func beforeDeinitialize(_ py: Py) {}

  // MARK: - Debug

  internal static func createDebugInfo(ptr: RawPtr) -> PyObject.DebugMirror {
    let zelf = PySlice(ptr: ptr)
    var result = PyObject.DebugMirror(object: zelf)
    result.append(name: "start", value: zelf.start, includeInDescription: true)
    result.append(name: "stop", value: zelf.stop, includeInDescription: true)
    result.append(name: "step", value: zelf.step, includeInDescription: true)
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

  internal static func isEqual(_ py: Py, zelf: PySlice, other: PyObject) -> CompareResult {
    switch Self.getFirstNonEqualValues(py, zelf: zelf, other: other) {
    case .values: return .value(false)
    case .allValuesEqual: return .value(true)
    case .notImplemented: return .notImplemented
    case .error(let e): return .error(e)
    }
  }

  // sourcery: pymethod = __lt__
  internal static func __lt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py,
                        zelf: zelf,
                        other: other,
                        operation: .__lt__,
                        compareFn: py.isLessBool(left:right:),
                        onEqual: false)
  }

  // sourcery: pymethod = __le__
  internal static func __le__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py,
                        zelf: zelf,
                        other: other,
                        operation: .__le__,
                        compareFn: py.isLessEqualBool(left:right:),
                        onEqual: true)
  }

  // sourcery: pymethod = __gt__
  internal static func __gt__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py,
                        zelf: zelf,
                        other: other,
                        operation: .__gt__,
                        compareFn: py.isGreaterBool(left:right:),
                        onEqual: false)
  }

  // sourcery: pymethod = __ge__
  internal static func __ge__(_ py: Py, zelf: PyObject, other: PyObject) -> CompareResult {
    return Self.compare(py,
                        zelf: zelf,
                        other: other,
                        operation: .__ge__,
                        compareFn: py.isGreaterEqualBool(left:right:),
                        onEqual: true)
  }

  private enum FirstNonEqualValues {
    case values(zelfValue: PyObject, otherValue: PyObject)
    case allValuesEqual
    case notImplemented
    case error(PyBaseException)
  }

  private static func getFirstNonEqualValues(_ py: Py,
                                             zelf: PySlice,
                                             other: PyObject) -> FirstNonEqualValues {
    guard let o = Self.downcast(py, other) else {
      return .notImplemented
    }

    switch py.isEqualBool(left: zelf.start, right: o.start) {
    case .value(true): break
    case .value(false): return .values(zelfValue: zelf.start, otherValue: o.start)
    case .error(let e): return .error(e)
    }

    switch py.isEqualBool(left: zelf.stop, right: o.stop) {
    case .value(true): break
    case .value(false): return .values(zelfValue: zelf.stop, otherValue: o.stop)
    case .error(let e): return .error(e)
    }

    switch py.isEqualBool(left: zelf.step, right: o.step) {
    case .value(true): break
    case .value(false): return .values(zelfValue: zelf.step, otherValue: o.step)
    case .error(let e): return .error(e)
    }

    return .allValuesEqual
  }

  // swiftlint:disable:next function_parameter_count
  private static func compare(_ py: Py,
                              zelf _zelf: PyObject,
                              other: PyObject,
                              operation: CompareResult.Operation,
                              compareFn: (PyObject, PyObject) -> PyResultGen<Bool>,
                              onEqual: Bool) -> CompareResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName, operation)
    }

    switch Self.getFirstNonEqualValues(py, zelf: zelf, other: other) {
    case let .values(zelfValue: s, otherValue: o):
      let result = compareFn(s, o)
      return CompareResult(result)

    case .allValuesEqual:
      return .value(onEqual)
    case .notImplemented:
      return .notImplemented
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal static func __hash__(_ py: Py, zelf _zelf: PyObject) -> HashResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return .invalidSelfArgument(_zelf, Self.pythonTypeName)
    }

    return .unhashable(zelf.asObject)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal static func __repr__(_ py: Py, zelf _zelf: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "__repr__")
    }

    let start: String
    switch py.reprString(zelf.start) {
    case let .value(s): start = s
    case let .error(e): return .error(e)
    }

    let stop: String
    switch py.reprString(zelf.stop) {
    case let .value(s): stop = s
    case let .error(e): return .error(e)
    }

    let step: String
    switch py.reprString(zelf.step) {
    case let .value(s): step = s
    case let .error(e): return .error(e)
    }

    let result = "slice(\(start), \(stop), \(step))"
    return PyResult(py, result)
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

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal static func __class__(_ py: Py, zelf: PyObject) -> PyType {
    return zelf.type
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

  // MARK: - Indices

  // sourcery: pymethod = indices
  /// static PyObject*
  /// slice_indices(PySliceObject* self, PyObject* len)
  internal static func indices(_ py: Py,
                               zelf _zelf: PyObject,
                               length: PyObject) -> PyResult {
    guard let zelf = Self.downcast(py, _zelf) else {
      return Self.invalidZelfArgument(py, _zelf, "indices")
    }

    let lengthInt: BigInt
    switch IndexHelper.pyInt(py, object: length) {
    case let .value(i):
      lengthInt = i.value
    case let .notIndex(lazyError):
      let e = lazyError.create(py)
      return .error(e)
    case let .error(e):
      return .error(e)
    }

    if lengthInt < 0 {
      return .valueError(py, message: "length should not be negative")
    }

    let indices: GetLongIndicesResult
    switch Self.getLongIndices(py, zelf: zelf, length: lengthInt) {
    case let .value(l): indices = l
    case let .error(e): return .error(e)
    }

    let start = py.newInt(indices.start)
    let stop = py.newInt(indices.stop)
    let step = py.newInt(indices.step)
    return PyResult(py, tuple: start.asObject, stop.asObject, step.asObject)
  }

  internal struct GetLongIndicesResult {
    internal var start: BigInt
    internal var stop: BigInt
    internal var step: BigInt
  }

// swiftlint:disable function_body_length

  /// int _PySlice_GetLongIndices(PySliceObject *self, PyObject *length, ...)
  ///
  /// Compute slice indices given a slice and length.
  /// Used by slice.indices and range object slicing.
  /// Assumes that `len` is a nonnegative.
  internal static func getLongIndices(
    _ py: Py,
    zelf: PySlice,
    length: BigInt
  ) -> PyResultGen<GetLongIndicesResult> {
// swiftlint:enable function_body_length

    assert(length.isPositiveOrZero)

    // Convert step to an integer; raise for zero step.
    var step: BigInt = 1
    switch zelf.evaluateIndex(py, zelf: zelf, index: zelf.step) {
    case .none: break
    case .index(let int):
      if int == 0 {
        return .valueError(py, message: "slice step cannot be zero")
      }
      step = int.value
    case .error(let e):
      return .error(e)
    }

    assert(step != 0)

    // Find lower and upper bounds for start and stop.
    let isStepNegative = step.isNegative
    let lower: BigInt = isStepNegative ? -1 : 0
    let upper: BigInt = isStepNegative ? length - 1 : length

    // Compute start.
    var start = isStepNegative ? upper : lower
    switch zelf.evaluateIndex(py, zelf: zelf, index: zelf.start) {
    case .none: break
    case .index(let int):
      start = int.value

      if start < 0 {
        start += length
        start = max(start, lower) // Case when we have high '-1000' index
      } else {
        start = min(start, upper)
      }
    case .error(let e):
      return .error(e)
    }

    // Compute stop.
    var stop = isStepNegative ? lower : upper
    switch zelf.evaluateIndex(py, zelf: zelf, index: zelf.stop) {
    case .none: break
    case .index(let int):
      stop = int.value

      if stop < 0 {
        stop += length
        stop = max(stop, lower) // Case when we have high '-1000' index
      } else {
        stop = min(stop, upper)
      }
    case .error(let e):
      return .error(e)
    }

    return .value(GetLongIndicesResult(start: start, stop: stop, step: step))
  }

  internal enum GetLongIndexResult {
    case none
    case index(PyInt)
    case error(PyBaseException)
  }

  /// CPython: evaluate_slice_index
  private func evaluateIndex(_ py: Py,
                             zelf: PySlice,
                             index: PyObject) -> GetLongIndexResult {
    if py.cast.isNone(index) {
      return .none
    }

    switch IndexHelper.pyInt(py, object: index) {
    case .value(let int):
      return .index(int)
    case .notIndex:
      let t = zelf.typeName
      let message = "\(t) indices must be integers or None or have an __index__ method"
      let error = py.newTypeError(message: message)
      return .error(error.asBaseException)
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Unpack

  /// Ok, so `UnpackedIndices` stores extracted indices,
  /// use `adjust(toCount:)` method to clamp them to desired length.
  internal struct AdjustedIndices {
    internal var start: Int
    internal var stop: Int
    internal var step: Int
    /// Number of entries between `self.start` and `self.stop` using `self.step`.
    internal let count: Int

    internal var isEmpty: Bool {
      // Both 'SwiftLint' and 'SwiftFormat' will fail on the following line

      // swiftformat:disable:next isEmpty
      return self.count == 0 // swiftlint:disable:this empty_count
    }
  }

  /// We store `PyObjects` as slice `start, stop, step` properties,
  /// use `PySlice.unpack` to extract correct indices.
  internal struct UnpackedIndices {
    internal var start: Int
    internal var stop: Int
    internal var step: Int

    /// Ok, so we have correct indices, now clamp them to desired length.
    ///
    /// Py_ssize_t
    /// PySlice_AdjustIndices(Py_ssize_t length,
    ///                       Py_ssize_t *start, Py_ssize_t *stop, Py_ssize_t step)
    internal func adjust(toCount count: Int) -> AdjustedIndices {
      var start = self.start
      var stop = self.stop
      let step = self.step

      assert(step != 0)
      let isGoingDown = step < 0

      if start < 0 {
        start += count
        if start < 0 {
          start = isGoingDown ? -1 : 0
        }
      } else if start >= count {
        start = isGoingDown ? count - 1 : count
      }

      if stop < 0 {
        stop += count
        if stop < 0 {
          stop = isGoingDown ? -1 : 0
        }
      } else if stop >= count {
        stop = isGoingDown ? count - 1 : count
      }

      var length = 0
      if isGoingDown {
        if stop < start {
          // swiftformat:disable:next redundantParens
          length = (start - stop - 1) / (-step) + 1
        }
      } else {
        if start < stop {
          length = (stop - start - 1) / step + 1
        }
      }

      return AdjustedIndices(start: start, stop: stop, step: step, count: length)
    }
  }

  /// We store `PyObjects` as slice properties, use this method to extract
  /// correct indices.
  ///
  /// int
  /// PySlice_Unpack(PyObject *_r,
  ///                Py_ssize_t *start, Py_ssize_t *stop, Py_ssize_t *step)
  internal func unpack(_ py: Py) -> PyResultGen<UnpackedIndices> {
    let min = Int.min
    let max = Int.max
    assert(min + 1 <= -max)

    let step: Int
    switch self.unpackIndex(py, value: self.step) {
    case .none:
      step = 1

    case .index(let value):
      if value == 0 {
        return .valueError(py, message: "slice step cannot be zero")
      }
      // Prevent trap on 'step = -step'
      step = Swift.max(value, -max)

    case .error(let e):
      return .error(e)
    }

    let start: Int
    switch self.unpackIndex(py, value: self.start) {
    case .none: start = step < 0 ? max : 0
    case .index(let value): start = value
    case .error(let e): return .error(e)
    }

    let stop: Int
    switch self.unpackIndex(py, value: self.stop) {
    case .none: stop = step < 0 ? min : max
    case .index(let value): stop = value
    case .error(let e): return .error(e)
    }

    return .value(UnpackedIndices(start: start, stop: stop, step: step))
  }

  private enum UnpackIndexResult {
    case none
    case index(Int)
    case error(PyBaseException)
  }

  /// Extract a slice index from a `PyInt` or an object with the `__index__`.
  ///
  /// Silently reduce values larger than `Int.max` to `Int.max`,
  /// and silently boost values less than `Int.min` to `Int.min`.
  ///
  /// int
  /// _PyEval_SliceIndex(PyObject *v, Py_ssize_t *pi)
  private func unpackIndex(_ py: Py, value: PyObject) -> UnpackIndexResult {
    if py.cast.isNone(value) {
      return .none
    }

    switch IndexHelper.pyInt(py, object: value) {
    case .value(let pyInt):
      let bigInt = pyInt.value

      if let int = Int(exactly: bigInt) {
        return .index(int)
      }

      let clampedInt = bigInt.isNegative ? Int.min : Int.max
      return .index(clampedInt)

    case .notIndex:
      let t = self.typeName
      let msg = "\(t) indices must be integers or None or have an __index__ method"
      let error = py.newTypeError(message: msg)
      return .error(error.asBaseException)

    case .error(let e):
      return .error(e)
    }
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
      let result = py.newSlice(stop: args[0])
      return PyResult(result)
    }

    // Handle 2 or 3 arguments
    let start = args[0]
    let stop = args[1]
    let step = args.count == 3 ? args[2] : nil

    let result = py.newSlice(start: start, stop: stop, step: step)
    return PyResult(result)
  }
}
