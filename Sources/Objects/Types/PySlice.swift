import Core

// In CPython:
// Objects -> sliceobject.c
// https://docs.python.org/3.7/c-api/slice.html

// TODO: Slice:
// PyObject_GenericGetAttr,                    /* tp_getattro */
// (traverseproc)slice_traverse,               /* tp_traverse */
// {"indices",    (PyCFunction)slice_indices, METH_O,      slice_indices_doc},
// {"__reduce__", (PyCFunction)slice_reduce,  METH_NOARGS, reduce_doc},
// {"start", T_OBJECT, offsetof(PySliceObject, start), READONLY},
// {"stop",  T_OBJECT, offsetof(PySliceObject, stop),  READONLY},
// {"step",  T_OBJECT, offsetof(PySliceObject, step),  READONLY},

/// The type object for slice objects.
/// This is the same as slice in the Python layer.
internal final class PySlice: PyObject {

  // start, stop, and step are python objects with None indicating no index is present.
  internal var start: Int?
  internal var stop:  Int?
  internal var step:  Int?

  fileprivate init(type:  PySliceType,
                   start: Int?,
                   stop:  Int?,
                   step:  Int?) {
    self.start = start
    self.stop = stop
    self.step = step
    super.init(type: type)
  }
}

/// The type object for slice objects.
/// This is the same as slice in the Python layer.
internal final class PySliceType: PyType,
  ReprTypeClass,
  ComparableTypeClass, HashableTypeClass,
  PyBoolConvertibleTypeClass {

  override internal var name: String { return "slice" }
  override internal var doc: String? { return """
slice(stop)
slice(start, stop[, step])

Create a slice object.
This is used for extended slicing (e.g. a[0:10:2]).
"""
  }

  // MARK: - Ctor

  internal func new(start: Int?, stop: Int?, step: Int? = nil) -> PySlice {
    return PySlice(type: self, start: start, stop: stop, step: step)
  }

  // MARK: - Equatable, hashable

  internal func compare(left:  PyObject,
                        right: PyObject,
                        mode:  CompareMode) throws -> PyBool {
    if left === right {
      switch mode {
      case .equal, .lessEqual, .greaterEqual:
        return self.types.bool.true
      case .notEqual, .less, .greater:
        return self.types.bool.false
      }
    }

    guard let l = self.matchTypeOrNil(left),
          let r = self.matchTypeOrNil(right) else {
        fatalError()
    }

    let lt = self.toTuple(l)
    let rt = self.toTuple(r)
    let result = self.context.richCompareBool(left: lt, right: rt, mode: mode)
    return self.types.bool.new(result)
  }

  private func toTuple(_ slice: PySlice) -> PyTuple {
    let start = slice.start.map { self.types.int.new($0) } ?? self.context.none
    let stop  = slice.stop.map { self.types.int.new($0) } ?? self.context.none
    let step  = slice.step.map { self.types.int.new($0) } ?? self.context.none
    return self.types.tuple.new([start, stop, step])
  }

  internal func hash(value: PyObject) throws -> PyHash {
    throw PyContextError.unhashableType(object: value)
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let noneDescr = try self.types.none.repr(value: self.context.none)

    let slice = try self.matchType(value)
    let start = slice.start.map { String(describing: $0) } ?? noneDescr
    let stop  = slice.stop.map { String(describing: $0) } ?? noneDescr
    let step  = slice.step.map { String(describing: $0) } ?? noneDescr
    return "slice(\(start), \(stop), \(step))"
  }

  // MARK: - Bool

  internal func bool(value: PyObject) throws -> PyBool {
    return self.types.bool.false
  }

  // MARK: - Helpers

  internal struct AdjustedIndices {
    internal var start:  Int
    internal var stop:   Int
    internal var step:   Int
    internal let length: Int
  }

  internal func adjustIndices(value: PySlice, to length: Int) -> AdjustedIndices {
    var start = value.start ?? 0
    var stop = value.stop ?? Int.max
    let step = value.step ?? 1
    let goingDown = step < 0

    if start < 0 {
      start += length
      if start < 0 {
        start = goingDown ? -1 : 0
      }
    } else if start >= length {
      start = goingDown ? length - 1 : length
    }

    if stop < 0 {
      stop += length
      if stop < 0 {
        stop = goingDown ? -1 : 0
      }
    } else if stop >= length {
      stop = goingDown ? length - 1 : length
    }

    var length = length
    if goingDown {
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

  internal func matchTypeOrNil(_ object: PyObject) -> PySlice? {
    if let slice = object as? PySlice {
      return slice
    }

    return nil
  }

  internal func matchType(_ object: PyObject) throws -> PySlice {
    if let slice = object as? PySlice {
      return slice
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
