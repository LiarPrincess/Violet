import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html

// swiftlint:disable file_length

// sourcery: pytype = slice, default, hasGC
/// The type object for slice objects.
/// This is the same as slice in the Python layer.
public class PySlice: PyObject {

  internal static let doc: String = """
    slice(stop)
    slice(start, stop[, step])

    Create a slice object.
    This is used for extended slicing (e.g. a[0:10:2]).
    """

  internal var start: PyObject
  internal var stop:  PyObject
  internal var step:  PyObject

  private var asStartStopStepSequence: PySequenceData {
    let elements = [self.start, self.stop, self.step]
    return PySequenceData(elements: elements)
  }

  override public var description: String {
    return "PySlice()"
  }

  // MARK: - Init

  internal init(start: PyObject,
                stop: PyObject,
                step: PyObject) {
    self.start = start
    self.stop = stop
    self.step = step
    super.init(type: Py.types.slice)
  }

  // MARK: - Equatable

  // sourcery: pymethod = __eq__
  internal func isEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    let data = self.asStartStopStepSequence
    return data.isEqual(to: other.asStartStopStepSequence).asCompareResult
  }

  // sourcery: pymethod = __ne__
  internal func isNotEqual(_ other: PyObject) -> CompareResult {
    return self.isEqual(other).not
  }

  // MARK: - Comparable

  // sourcery: pymethod = __lt__
  internal func isLess(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    let data = self.asStartStopStepSequence
    return data.isLess(than: other.asStartStopStepSequence).asCompareResult
  }

  // sourcery: pymethod = __le__
  internal func isLessEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    let data = self.asStartStopStepSequence
    return data.isLessEqual(than: other.asStartStopStepSequence).asCompareResult
  }

  // sourcery: pymethod = __gt__
  internal func isGreater(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    let data = self.asStartStopStepSequence
    return data.isGreater(than: other.asStartStopStepSequence).asCompareResult
  }

  // sourcery: pymethod = __ge__
  internal func isGreaterEqual(_ other: PyObject) -> CompareResult {
    guard let other = other as? PySlice else {
      return .notImplemented
    }

    let data = self.asStartStopStepSequence
    return data.isGreaterEqual(than: other.asStartStopStepSequence).asCompareResult
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
    switch Py.repr(self.start) {
    case let .value(s): start = s
    case let .error(e): return .error(e)
    }

    let stop: String
    switch Py.repr(self.stop) {
    case let .value(s): stop = s
    case let .error(e): return .error(e)
    }

    let step: String
    switch Py.repr(self.step) {
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

  // MARK: - Start

  // sourcery: pymethod = start
  internal func getStart() -> PyObject {
    return self.start
  }

  // MARK: - Stop

  // sourcery: pymethod = stop
  internal func getStop() -> PyObject {
    return self.stop
  }

  // MARK: - Step

  // sourcery: pymethod = step
  internal func getStep() -> PyObject {
    return self.step
  }

  // MARK: - Indices

  internal static let indicesDoc = """
    Return a copy of the string with leading and trailing whitespace remove.

    If chars is given and not None, remove characters in chars instead.
    """

  // sourcery: pymethod = indices, doc = indicesDoc
  /// static PyObject*
  /// slice_indices(PySliceObject* self, PyObject* len)
  internal func indicesInSequence(length: PyObject) -> PyResult<PyObject> {
    let lengthInt: Int
    switch IndexHelper.int(length) {
    case .value(let v): lengthInt = v
    case .error(let e): return .error(e)
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
    var start: Int
    var stop:  Int
    var step:  Int
  }

  /// int _PySlice_GetLongIndices(PySliceObject *self, PyObject *length, ...)
  ///
  /// Compute slice indices given a slice and length.
  /// Return -1 on failure. Used by slice.indices and rangeobject slicing.
  /// Assumes that `len` is a nonnegative instance of PyLong.
  internal func getLongIndices(length: Int) -> PyResult<GetLongIndicesResult> {
    // swiftlint:disable:previous function_body_length

    // Convert step to an integer; raise for zero step.
    var step = 1
    switch self.extractIndex(self.step) {
    case .none: break
    case let .index(value):
      if value == 0 {
        return .valueError("slice step cannot be zero")
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
        return .valueError("slice step cannot be zero")
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

  // MARK: - Python new

  // sourcery: pymethod = __new__
  internal static func pyNew(type: PyType,
                             args: [PyObject],
                             kwargs: PyDictData?) -> PyResult<PyObject> {
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

  // MARK: - Helpers

  internal enum ExtractIndexResult {
    case none
    case index(Int)
    case error(PyBaseException)
  }

  /// _PyEval_SliceIndex
  private func extractIndex(_ value: PyObject) -> ExtractIndexResult {
    if value is PyNone {
      return .index(1)
    }

    switch IndexHelper.tryInt(value) {
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
}
