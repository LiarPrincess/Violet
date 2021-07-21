import BigInt
import VioletCore

// swiftlint:disable file_length
// cSpell:ignore sliceobject

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html

// sourcery: pytype = slice, default, hasGC
/// The type object for slice objects.
/// This is the same as slice in the Python layer.
public final class PySlice: PyObject {

  // sourcery: pytypedoc
  internal static let doc = """
    slice(stop)
    slice(start, stop[, step])

    Create a slice object.
    This is used for extended slicing (e.g. a[0:10:2]).
    """

  internal var start: PyObject
  internal var stop: PyObject
  internal var step: PyObject

  override public var description: String {
    let start = "start: \(self.start)"
    let stop = "stop: \(self.stop)"
    let step = "step: \(self.step)"
    return "PySlice(\(start), \(stop), \(step))"
  }

  // MARK: - Init

  internal init(start: PyObject, stop: PyObject, step: PyObject) {
    self.start = start
    self.stop = stop
    self.step = step
    super.init(type: Py.types.slice)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isEqual(to: $1) }
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isLess(than: $1) }
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isLessEqual(than: $1) }
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isGreater(than: $1) }
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    return self.compare(with: other) { $0.isGreaterEqual(than: $1) }
  }

  private func compare(
    with other: PyObject,
    using compareFn: (PySequenceData, PySequenceData) -> CompareResult
  ) -> CompareResult {
    guard let other = PyCast.asSlice(other) else {
      return .notImplemented
    }

    let selfSeq = self.asStartStopStepSequence
    let otherSeq = other.asStartStopStepSequence
    return compareFn(selfSeq, otherSeq)
  }

  /// Create `self.start, self.stop, self.step` sequence.
  private var asStartStopStepSequence: PySequenceData {
    let elements = [self.start, self.stop, self.step]
    return PySequenceData(elements: elements)
  }

  // MARK: - Hashable

  // sourcery: pymethod = __hash__
  internal func hash() -> HashResult {
    return .error(Py.hashNotImplemented(self))
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let start: String
    switch Py.reprString(object: self.start) {
    case let .value(s): start = s
    case let .error(e): return .error(e)
    }

    let stop: String
    switch Py.reprString(object: self.stop) {
    case let .value(s): stop = s
    case let .error(e): return .error(e)
    }

    let step: String
    switch Py.reprString(object: self.step) {
    case let .value(s): step = s
    case let .error(e): return .error(e)
    }

    return .value("slice(\(start), \(stop), \(step))")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(from: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
  }

  // MARK: - Properties

  // sourcery: pyproperty = start
  internal func getStart() -> PyObject {
    return self.start
  }

  // sourcery: pyproperty = stop
  internal func getStop() -> PyObject {
    return self.stop
  }

  // sourcery: pyproperty = step
  internal func getStep() -> PyObject {
    return self.step
  }

  // MARK: - Indices

  // sourcery: pymethod = indices
  /// static PyObject*
  /// slice_indices(PySliceObject* self, PyObject* len)
  internal func indicesInSequence(length: PyObject) -> PyResult<PyObject> {
    let lengthInt: BigInt
    switch IndexHelper.bigInt(length) {
    case let .value(v):
      lengthInt = v
    case let .error(e),
         let .notIndex(e):
      return .error(e)
    }

    if lengthInt < 0 {
      return .valueError("length should not be negative")
    }

    return self.getLongIndices(length: lengthInt).map { indices in
      let start = Py.newInt(indices.start)
      let stop = Py.newInt(indices.stop)
      let step = Py.newInt(indices.step)
      return Py.newTuple(start, stop, step)
    }
  }

  internal struct GetLongIndicesResult {
    var start: BigInt
    var stop: BigInt
    var step: BigInt
  }

  /// int _PySlice_GetLongIndices(PySliceObject *self, PyObject *length, ...)
  ///
  /// Compute slice indices given a slice and length.
  /// Used by slice.indices and range object slicing.
  /// Assumes that `len` is a nonnegative.
  internal func getLongIndices(length: BigInt) -> PyResult<GetLongIndicesResult> {
    // swiftlint:disable:previous function_body_length
    assert(length.isPositiveOrZero)

    // Convert step to an integer; raise for zero step.
    var step: BigInt = 1
    switch self.getLongIndex(self.step) {
    case .none: break
    case .index(let value):
      if value == 0 {
        return .valueError("slice step cannot be zero")
      }
      step = value
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
    switch self.getLongIndex(self.start) {
    case .none: break
    case .index(let value):
      start = value

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
    switch self.getLongIndex(self.stop) {
    case .none: break
    case .index(let value):
      stop = value

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
    case index(BigInt)
    case error(PyBaseException)
  }

  /// CPython: evaluate_slice_index
  private func getLongIndex(_ value: PyObject) -> GetLongIndexResult {
    if PyCast.isNone(value) {
      return .none
    }

    switch IndexHelper.bigInt(value) {
    case .value(let value):
      return .index(value)
    case .notIndex:
      let t = self.typeName
      let msg = "\(t) indices must be integers or None or have an __index__ method"
      return .error(Py.newTypeError(msg: msg))
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
  internal func unpack() -> PyResult<UnpackedIndices> {
    let min = Int.min
    let max = Int.max
    assert(min + 1 <= -max)

    let step: Int
    switch self.unpackIndex(self.step) {
    case .none:
      step = 1

    case .index(let value):
      if value == 0 {
        return .valueError("slice step cannot be zero")
      }
      // Prevent trap on 'step = -step'
      step = Swift.max(value, -max)

    case .error(let e):
      return .error(e)
    }

    let start: Int
    switch self.unpackIndex(self.start) {
    case .none: start = step < 0 ? max : 0
    case .index(let value): start = value
    case .error(let e): return .error(e)
    }

    let stop: Int
    switch self.unpackIndex(self.stop) {
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
  private func unpackIndex(_ value: PyObject) -> UnpackIndexResult {
    if PyCast.isNone(value) {
      return .none
    }

    switch IndexHelper.bigInt(value) {
    case .value(let bigInt):
      if let int = Int(exactly: bigInt) {
        return .index(int)
      }

      let clampedInt = bigInt.isNegative ? Int.min : Int.max
      return .index(clampedInt)

    case .notIndex:
      let t = self.typeName
      let msg = "\(t) indices must be integers or None or have an __index__ method"
      return .error(Py.newTypeError(msg: msg))

    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Python new

  // sourcery: pystaticmethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDict?) -> PyResult<PySlice> {
    if let e = ArgumentParser.noKwargsOrError(fnName: "slice", kwargs: kwargs) {
      return .error(e)
    }

    // Guarantee that we have 1, 2 or 3 arguments
    if let e = ArgumentParser.guaranteeArgsCountOrError(fnName: "slice",
                                                        args: args,
                                                        min: 1,
                                                        max: 3) {
      return .error(e)
    }

    // Handle 1 argument
    if args.count == 1 {
      let result = Py.newSlice(stop: args[0])
      return .value(result)
    }

    // Handle 2 or 3 arguments
    let start = args[0]
    let stop = args[1]
    let step = args.count == 3 ? args[2] : nil

    let result = Py.newSlice(start: start, stop: stop, step: step)
    return .value(result)
  }
}
