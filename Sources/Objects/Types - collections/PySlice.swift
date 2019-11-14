import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html

// swiftlint:disable file_length

// sourcery: pytype = slice
/// The type object for slice objects.
/// This is the same as slice in the Python layer.
public final class PySlice: PyObject {

  internal static let doc: String = """
    slice(stop)
    slice(start, stop[, step])

    Create a slice object.
    This is used for extended slicing (e.g. a[0:10:2]).
    """

  internal var start: PyObject
  internal var stop:  PyObject
  internal var step:  PyObject

  // MARK: - Init

  internal init(_ context: PyContext, start: PyObject, stop: PyObject, step: PyObject) {
    self.start = start
    self.stop = stop
    self.step = step
    super.init(type: context.builtins.types.slice)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isEqual(context: self.context,
                                  left: self.asArray,
                                  right: other.asArray)
  }

  private var asArray: [PyObject] {
    return [self.start, self.stop, self.step]
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    return NotEqualHelper.fromIsEqual(self.isEqual(other))
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isLess(context: self.context,
                                 left: self.asArray,
                                 right: other.asArray)
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isLessEqual(context: self.context,
                                      left: self.asArray,
                                      right: other.asArray)
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isGreater(context: self.context,
                                    left: self.asArray,
                                    right: other.asArray)
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    return SequenceHelper.isGreaterEqual(context: self.context,
                                         left: self.asArray,
                                         right: other.asArray)
  }

  // MARK: - String

  // sourcery: pymethod = __repr__
  internal func repr() -> PyResult<String> {
    let start: String
    switch self.builtins.repr(self.start) {
    case let .value(s): start = s
    case let .error(e): return .error(e)
    }

    let stop: String
    switch self.builtins.repr(self.stop) {
    case let .value(s): stop = s
    case let .error(e): return .error(e)
    }

    let step: String
    switch self.builtins.repr(self.step) {
    case let .value(s): step = s
    case let .error(e): return .error(e)
    }

    return .value("slice(\(start), \(stop), \(step))")
  }

  // MARK: - Attributes

  // sourcery: pymethod = __getattribute__
  internal func getAttribute(name: PyObject) -> PyResult<PyObject> {
    return AttributeHelper.getAttribute(zelf: self, name: name)
  }

  // MARK: - Class

  // sourcery: pyproperty = __class__
  internal func getClass() -> PyType {
    return self.type
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

    guard let lengthInt = Int(exactly: length) else {
      return .error(.indexError("length out of range"))
    }

    if lengthInt < 0 {
      return .error(.valueError("length should not be negative"))
    }

    switch self.getLongIndices(length: lengthInt) {
    case let .value(v):
      let start = self.builtins.newInt(v.start)
      let stop = self.builtins.newInt(v.stop)
      let step = self.builtins.newInt(v.step)
      return .value(self.builtins.newTuple(start, stop, step))
    case let .error(e):
      return .error(e)
    }
  }

  private struct GetLongIndicesResult {
    var start: Int
    var stop:  Int
    var step:  Int
  }

  /// int _PySlice_GetLongIndices(PySliceObject *self, PyObject *length, ...)
  ///
  /// Compute slice indices given a slice and length.
  /// Return -1 on failure. Used by slice.indices and rangeobject slicing.
  /// Assumes that `len` is a nonnegative instance of PyLong.
  private func getLongIndices(length: Int) -> PyResult<GetLongIndicesResult> {
    // swiftlint:disable:previous function_body_length

    // Convert step to an integer; raise for zero step.
    var step = 1
    switch self.extractIndex(self.step) {
    case .none: break
    case let .index(value):
      if value == 0 {
        return .error(.valueError("slice step cannot be zero"))
      }
      step = value
    case let .error(e):
      return .error(e)
    }

    // Find lower and upper bounds for start and stop.
    let isGoingUp = step > 0
    let lower = isGoingUp ? 0 : -1
    let upper = isGoingUp ? length : length - 1

    // Compute start.
    var start = isGoingUp ? lower : upper
    switch self.extractIndex(self.start) {
    case .none: break
    case let .index(value):
      start = value

      if start < 0 {
        start += length
        start = max(start, lower) // Case when we have high '-1000' index
      } else {
        start = min(start, upper)
      }
    case let .error(e):
      return .error(e)
    }

    // Compute stop.
    var stop = isGoingUp ? upper : lower
    switch self.extractIndex(self.stop) {
    case .none: break
    case let .index(value):
      stop = value

      if stop < 0 {
        stop += length
        stop = max(stop, lower) // Case when we have high '-1000' index
      } else {
        stop = min(stop, upper)
      }
    case let .error(e):
      return .error(e)
    }

    return .value(GetLongIndicesResult(start: start, stop: stop, step: step))
  }

  // MARK: - Unpack

  internal struct UnpackedIndices {
    internal var start: Int
    internal var stop:  Int
    internal var step:  Int
  }

  /// int
  /// PySlice_Unpack(PyObject *_r,
  ///                Py_ssize_t *start, Py_ssize_t *stop, Py_ssize_t *step)
  internal func unpack() -> PyResult<UnpackedIndices> {
    // Prevent trap on "step = -step" (kind of assuming internal int workings)
    let min = Int.min + 1
    let max = Int.max

    var step = 1
    switch self.extractIndex(self.step) {
    case .none: break
    case let .index(value):
      if value == 0 {
        return .error(.valueError("slice step cannot be zero"))
      }
      step = value
    case let .error(e): return .error(e)
    }

    var start = step < 0 ? max : 0
    switch self.extractIndex(self.start) {
    case .none: break
    case let .index(value): start = value
    case let .error(e): return .error(e)
    }

    var stop = step < 0 ? min : max
    switch self.extractIndex(self.stop) {
    case .none: break
    case let .index(value): stop = value
    case let .error(e): return .error(e)
    }

    return .value(UnpackedIndices(start: start, stop: stop, step: step))
  }

  // MARK: - Adjust indices

  internal struct AdjustedIndices {
    internal var start:  Int
    internal var stop:   Int
    internal var step:   Int
    internal let length: Int
  }

  /// Py_ssize_t
  /// PySlice_AdjustIndices(Py_ssize_t length,
  ///                       Py_ssize_t *start, Py_ssize_t *stop, Py_ssize_t step)
  internal func adjust(_ unpack: UnpackedIndices,
                       toLength length: Int) -> AdjustedIndices {
    var start = unpack.start
    var stop = unpack.stop
    let step = unpack.step

    assert(step != 0)
    let isGoingDown = step < 0

    if start < 0 {
      start += length
      if start < 0 {
        start = isGoingDown ? -1 : 0
      }
    } else if start >= length {
      start = isGoingDown ? length - 1 : length
    }

    if stop < 0 {
      stop += length
      if stop < 0 {
        stop = isGoingDown ? -1 : 0
      }
    } else if stop >= length {
      stop = isGoingDown ? length - 1 : length
    }

    var length = 0
    if isGoingDown {
      if stop < start {
        length = (start - stop - 1) / (-step) + 1
      }
    } else {
      if start < stop {
        length = (stop - start - 1) / step + 1
      }
    }

    return AdjustedIndices(start: start, stop: stop, step: step, length: length)
  }

  // MARK: - Helpers

  private func extractIndex(_ value: PyObject) -> SequenceHelper.ExtractIndexResult {
    return SequenceHelper.extractIndex2(value, typeName: "slice")
  }
}
