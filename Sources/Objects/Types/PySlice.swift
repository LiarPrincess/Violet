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
  internal var start: PyObject
  internal var stop:  PyObject
  internal var step:  PyObject

  fileprivate init(type:  PySliceType,
                   start: PyObject,
                   stop:  PyObject,
                   step:  PyObject) {
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

  internal func new(start: PyObject?, stop: PyObject?, step: PyObject?) -> PySlice {
    return PySlice(
      type:  self,
      start: start ?? self.context.none,
      stop:  stop  ?? self.context.none,
      step:  step  ?? self.context.none
    )
  }

  // MARK: - Equatable, hashable

  internal func compare(left:  PyObject,
                        right: PyObject,
                        mode:  CompareMode) throws -> PyBool {
    if left === right {
      switch mode {
      case .equal, .lessEqual, .greaterEqual:
        return self.context.types.bool.true
      case .notEqual, .less, .greater:
        return self.context.types.bool.false
      }
    }

    guard let l = self.matchTypeOrNil(left),
          let r = self.matchTypeOrNil(right) else {
        fatalError()
    }

    let tupleType = self.context.types.tuple
    let leftTuple = tupleType.new(l.start, l.stop, l.step)
    let rightTuple = tupleType.new(r.start, r.stop, r.step)
    let result = self.context.richCompareBool(left: leftTuple, right: rightTuple, mode: mode)
    return self.context.types.bool.new(result)
  }

  internal func hash(value: PyObject) throws -> PyHash {
    throw PyContextError.unhashableType(object: value)
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let slice = try self.matchType(value)
    let start = try self.context.repr(value:slice.start)
    let stop  = try self.context.repr(value:slice.stop)
    let step  = try self.context.repr(value:slice.step)
    return "slice(\(start), \(stop), \(step))"
  }

  // MARK: - Bool

  internal func bool(value: PyObject) throws -> PyBool {
    return self.context.types.bool.false
  }

  // MARK: - Helpers

  private func matchTypeOrNil(_ object: PyObject) -> PySlice? {
    if let slice = object as? PySlice {
      return slice
    }

    return nil
  }

  private func matchType(_ object: PyObject) throws -> PySlice {
    if let slice = object as? PySlice {
      return slice
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
