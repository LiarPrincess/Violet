import Core

// TODO: Check docs in other
// In CPython:
// Objects -> tupleobject.c

// swiftlint:disable yoda_condition

internal final class PyTuple: PyObject {

  internal var elements: [PyObject]

  fileprivate init(type: PyTupleType, elements: [PyObject]) {
    self.elements = elements
    super.init(type: type)
  }
}

internal final class PyTupleType: PyType,
ReprTypeClass,
ComparableTypeClass, HashableTypeClass,
LengthTypeClass, ConcatTypeClass, RepeatTypeClass,
ItemTypeClass, ContainsTypeClass {

  internal let name: String = "tuple"
  internal let base: PyType? = nil
  internal let doc:  String? = """
tuple() -> an empty tuple
tuple(sequence) -> tuple initialized from sequence's items

If the argument is a tuple, the return value is the same object.
"""

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }

  // MARK: - Ctor

  /// PyObject* PyTuple_New(Py_ssize_t size)
  internal func new() -> PyTuple {
    return PyTuple(type: self, elements: [])
  }

  /// PyObject * PyTuple_Pack(Py_ssize_t n, ...)
  internal func new(_ elements: [PyObject]) -> PyTuple {
    return PyTuple(type: self, elements: elements)
  }

  /// PyObject * PyTuple_Pack(Py_ssize_t n, ...)
  internal func new(_ elements: PyObject...) -> PyTuple {
    return PyTuple(type: self, elements: elements)
  }

  // MARK: - Equatable, hashable

  /// static PyObject * tuplerichcompare(PyObject *v, PyObject *w, int op)
  func compare(left: PyObject, right: PyObject, mode: CompareMode) throws -> PyObject {
//    guard let l = self.matchTypeOrNil(left),
//          let r = self.matchTypeOrNil(right) else {
//        return self.context.notImplemented
//    }
    fatalError()
  }

  internal func hash(value: PyObject, into hasher: inout Hasher) throws -> PyObject {
    fatalError()
  }

  // MARK: - String

  /// static PyObject * tuplerepr(PyTupleObject *v)
  internal func repr(value: PyObject) throws -> String {
    let tuple = try self.matchType(value)

    if tuple.elements.isEmpty {
      return "()"
    }

    // While not mutable, it is still possible to end up with a cycle in a tuple
    // through an object that stores itself within a tuple (and thus infinitely
    // asks for the repr of itself).
    if tuple.hasReprLock {
      return "(...)"
    }

    return try tuple.withReprLock {
      var result = "("
      for (index, element) in tuple.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += try self.context.repr(value: element)
      }

      result += tuple.elements.count > 1 ? ")" : ",)"
      return result
    }
  }

  // MARK: - Length

  /// Py_ssize_t PyTuple_Size(PyObject *op)
  internal func length(value: PyObject) throws -> PyInt {
    let tuple = try self.matchType(value)
    return self.context.types.int.new(tuple.elements.count)
  }

  // MARK: - Concat

  internal func concat(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.matchType(left)

    guard let r = self.matchTypeOrNil(right) else {
      throw PyContextError.tupleInvalidAddendType(addend: right)
    }

    let result = l.elements + r.elements
    return self.new(Array(result))
  }

  // MARK: - Repeat

  internal func `repeat`(value: PyObject, count: PyInt) throws -> PyObject {
    let tuple = try self.matchType(value)
    let countRaw = try self.context.types.int.extractInt(count)

    let count = max(countRaw, 0)

    if tuple.elements.isEmpty || count == 1 {
      return self.new(tuple.elements)
    }

    var i: BigInt = 0
    var result = [PyObject]()
    while i < count {
      result.append(contentsOf: tuple.elements)
      i += 1
    }

    return self.new(result)
  }

  // MARK: - Item

  internal func item(owner: PyObject, at index: Int) throws -> PyObject {
    let tuple = try self.matchType(owner)

    guard 0 <= index && index < tuple.elements.count else {
      throw PyContextError.tupleIndexOutOfRange(tuple: tuple, index: index)
    }

    return tuple.elements[index]
  }

  /// static int tuplecontains(PyTupleObject *a, PyObject *el)
  internal func contains(owner: PyObject, element: PyObject) throws -> Bool {
    fatalError()
  }

  /// static PyObject* tuple_index_impl(PyTupleObject *self, PyObject *value, ...)
  internal func indexOf(owner: PyObject,
                        item:  PyObject,
                        start: Int,
                        stop:  Int) throws -> PyObject {
//    let tuple = try self.matchTuple(object)
//
//    var start = start
//    if start < 0 {
//      start += tuple.elements.count
//      if start < 0 {
//        start = 0
//      }
//    }
//
//    var stop = stop
//    if stop < 0 {
//      stop += tuple.elements.count
//    } else if stop > tuple.elements.count {
//      stop = tuple.elements.count
//    }

//    for i in start..<stop {
      //      int cmp = PyObject_RichCompareBool(self->ob_item[i], value, Py_EQ);
      //      if (cmp > 0)
      //        return PyLong_FromSsize_t(i);
      //      else if (cmp < 0)
      //        return NULL;
//    }

    // PyErr_SetString(PyExc_ValueError, "tuple.index(x): x not in tuple");
    fatalError()
  }

  /// Return number of occurrences of value.
  ///
  /// static PyObject * tuple_count(PyTupleObject *self, PyObject *value)
  internal func countOf(owner: PyObject, item: PyObject) -> PyObject {
//    let tuple = try self.matchTuple(object)

//    var result = 0
//    for element in tuple.elements {
//      int cmp = PyObject_RichCompareBool(self->ob_item[i], value, Py_EQ);
//      if (cmp > 0)
//      count++;
//      else if (cmp < 0)
//      return NULL;
//    }

    fatalError()
  }

  // MARK: - Slice

  /// PyObject * PyTuple_GetSlice(PyObject *op, Py_ssize_t i, Py_ssize_t j)
  internal func slice(_ object: PyObject, low: Int, high: Int) throws -> PyObject {
    let tuple = try self.matchType(object)

    var low = max(low, 0)
    var high = min(high, tuple.elements.count)

    if low > high {
      (low, high) = (high, low)
    }

    if low == 0 && high == tuple.elements.count {
      return tuple
    }

    let result = tuple.elements[low..<high]
    return self.new(Array(result))
  }

  // MARK: - Helpers

  private func matchTypeOrNil(_ object: PyObject) -> PyTuple? {
    if let tuple = object as? PyTuple {
      return tuple
    }

    return nil
  }

  private func matchType(_ object: PyObject) throws -> PyTuple {
    if let tuple = object as? PyTuple {
      return tuple
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
