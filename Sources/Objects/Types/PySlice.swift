import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html

// MARK: - Slice
// __getattribute__
// __reduce__
// indices
// start
// step
// stop

// sourcery: pytype = slice
/// The type object for slice objects.
/// This is the same as slice in the Python layer.
internal final class PySlice: PyObject,
  ReprTypeClass,
  ComparableTypeClass, HashableTypeClass {

  internal static let doc: String = """
    slice(stop)
    slice(start, stop[, step])

    Create a slice object.
    This is used for extended slicing (e.g. a[0:10:2]).
    """

  internal var start: PyInt?
  internal var stop:  PyInt?
  internal var step:  PyInt?

  // MARK: - Init

  internal init(_ context: PyContext, start: PyInt?, stop: PyInt?, step: PyInt?) {
    self.start = start
    self.stop = stop
    self.step = step
    super.init(type: context.types.slice)
  }

  // MARK: - Equatable

  internal func isEqual(_ other: PyObject) -> EquatableResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isEqual(context: self.context,
                                  left: self.asObjectArray,
                                  right: other.asObjectArray)
  }

  private var asObjectArray: [PyObject] {
    return [
      self.start ?? self.context.none,
      self.stop  ?? self.context.none,
      self.step  ?? self.context.none
    ]
  }

  // MARK: - Comparable

  internal func isLess(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isLess(context: self.context,
                                 left: self.asObjectArray,
                                 right: other.asObjectArray)
  }

  internal func isLessEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isLessEqual(context: self.context,
                                      left: self.asObjectArray,
                                      right: other.asObjectArray)
  }

  internal func isGreater(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isGreater(context: self.context,
                                    left: self.asObjectArray,
                                    right: other.asObjectArray)
  }

  internal func isGreaterEqual(_ other: PyObject) -> ComparableResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isGreaterEqual(context: self.context,
                                         left: self.asObjectArray,
                                         right: other.asObjectArray)
  }

  // MARK: - Hashable

  internal func hash() -> HashableResult {
    return .notImplemented
  }

  // MARK: - String

  internal func repr() -> String {
    let noneRepr = self.context._none.repr()
    let start = self.start.map(self.context.reprString) ?? noneRepr
    let stop  = self.stop.map(self.context.reprString) ?? noneRepr
    let step  = self.step.map(self.context.reprString) ?? noneRepr
    return "slice(\(start), \(stop), \(step))"
  }

  // MARK: - Indices

  /// S.indices(len) -> (start, stop, stride)
  ///
  /// Assuming a sequence of length len, calculate the start and stop
  /// indices, and the stride length of the extended slice described by S.
  /// Out of bounds indices are clipped in a manner consistent with the
  /// handling of normal slices.
  internal func indicesInSequence(length: PyObject) -> PyResultOrNot<PyObject> {
    guard let length = SequenceHelper.extractIndex(length) else {
      return .notImplemented
    }

    if length < 0 {
      return .error(.valueError("length should not be negative"))
    }

    switch self.getLongIndices(length: length) {
    case let .value(v):
      let start = self.int(v.start)
      let stop = self.int(v.stop)
      let step = self.int(v.step)
      return .value(self.tuple(start, stop, step))
    case let .error(e):
      return .error(e)
    }
  }

  private struct GetLongIndicesResult {
    var start: BigInt = 0
    var stop:  BigInt = 0
    var step:  BigInt = 0
  }

  /// int _PySlice_GetLongIndices(PySliceObject *self, PyObject *length, ...)
  ///
  /// Compute slice indices given a slice and length.
  /// Return -1 on failure. Used by slice.indices and rangeobject slicing.
  /// Assumes that `len` is a nonnegative instance of PyLong.
  private func getLongIndices(length: BigInt) -> PyResult<GetLongIndicesResult> {
    var result = GetLongIndicesResult()

    // Convert step to an integer; raise for zero step.
    result.step = 1
    if let selfStep = self.step {
      if selfStep.value == 0 {
        return .error(.valueError("slice step cannot be zero"))
      }

      result.step = selfStep.value
    }

    // Find lower and upper bounds for start and stop.
    let stepIsNegative = result.step < 0
    let lower: BigInt = stepIsNegative ? -1 : 0
    let upper: BigInt = stepIsNegative ? length + lower : length

    // Compute start.
    result.start = stepIsNegative ? upper : lower
    if let selfStart = self.start {
      result.start = selfStart.value

      if result.start < 0 {
        result.start += length
        result.start = max(result.start, lower)
      } else {
        result.start = min(result.start, upper)
      }
    }

    // Compute stop.
    result.stop = stepIsNegative ? lower : upper
    if let selfStop = self.stop {
      result.stop = selfStop.value

      if result.stop < 0 {
        result.stop += length
        result.stop = max(result.stop, lower)
      } else {
        result.stop = min(result.stop, upper)
      }
    }

    return .value(result)
  }
}
