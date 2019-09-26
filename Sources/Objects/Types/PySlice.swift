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
  ComparableTypeClass, HashableTypeClass {

  internal let name: String = "slice"
  internal let base: PyType? = nil
  internal let doc:  String? = """
slice(stop)
slice(start, stop[, step])

Create a slice object.
This is used for extended slicing (e.g. a[0:10:2]).
"""

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
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
                        mode:  CompareMode) throws -> PyObject {
    if left === right {
      switch mode {
      case .equal, .lessEqual, .greaterEqual:
        return self.context.true
      case .notEqual, .less, .greater:
        return self.context.false
      }
    }

    guard let l = self.matchTypeOrNil(left),
          let r = self.matchTypeOrNil(right) else {
        return self.context.none
    }

    let tupleType = self.context.types.tuple
    let tl = tupleType.new(l.start, l.stop, l.step)
    let tr = tupleType.new(r.start, r.stop, r.step)
    return self.context.PyObject_RichCompare(left: tl, right: tr, mode: mode)
  }

  internal func hash(value: PyObject, into hasher: inout Hasher) throws -> PyObject {
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
