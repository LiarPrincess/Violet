// swiftlint:disable yoda_condition

internal final class PyTuple: PyObject {

  internal var elements: [PyObject]

  fileprivate init(type: PyTupleType, elements: [PyObject]) {
    self.elements = elements
    super.init(type: type)
  }
}

internal final class PyTupleType: PyType,
ReprConvertibleTypeClass,
ComparableTypeClass, HashableTypeClass {

  internal let name: String = "tuple"
  internal let base: PyType? = nil
  internal let doc:  String? = """
tuple() -> an empty tuple
tuple(sequence) -> tuple initialized from sequence's items

If the argument is a tuple, the return value is the same object.
"""

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

  internal func compare(left: PyObject, right: PyObject, x: Int) throws -> PyObject {
    fatalError()
  }

  internal func hash(value: PyObject, into hasher: inout Hasher) throws -> PyObject {
    fatalError()
  }

  // MARK: - String

  /// static PyObject * tuplerepr(PyTupleObject *v)
  internal func repr(value: PyObject) throws -> String {
    //    let tuple = try self.matchTuple(object)
    //
    //    if tuple.elements.isEmpty {
    //      return "()"
    //    }
    //
    //    // While not mutable, it is still possible to end up with a cycle in a tuple
    //    // through an object that stores itself within a tuple (and thus infinitely
    //    // asks for the repr of itself).
    //    let isRecursive = self.reprEnter(object: tuple)
    //    defer { self.reprLeave(object: tuple) }
    //
    //    if isRecursive {
    //      return "(...)"
    //    }
    //
    //    var result = "("
    //    for (index, element) in tuple.elements.enumerated() {
    //      if index > 0 {
    //        result += ", " // so that we don't have ', )'.
    //      }
    //
    //      // PyObject_Repr(v->ob_item[i]); <-- ?
    //      result += element.repr
    //    }
    //
    //    result += tuple.elements.count > 1 ? ")" : ",)"
    //    return result
    fatalError()
  }

  // MARK: - Methods

  /// Py_ssize_t PyTuple_Size(PyObject *op)
  internal func size(_ object: PyObject) throws -> Int {
    let tuple = try self.matchType(object)
    return tuple.elements.count
  }

  /// PyObject* PyTuple_GetItem(PyObject *op, Py_ssize_t i)
  internal func getItem(_ object: PyObject, at index: Int) throws -> PyObject {
    let tuple = try self.matchType(object)

    guard 0 <= index && index < tuple.elements.count else {
      throw PyContextError.tupleIndexOutOfRange
    }

    return tuple.elements[index]
  }

  /// int PyTuple_SetItem(PyObject *op, Py_ssize_t i, PyObject *newitem)
  internal func setItem(_ object: PyObject, at index: Int, to item: PyObject) throws {
    let tuple = try self.matchType(object)

    guard 0 <= index && index < tuple.elements.count else {
      throw PyContextError.tupleAssignmentIndexOutOfRange
    }

    tuple.elements[index] = item
  }

  /// static int tuplecontains(PyTupleObject *a, PyObject *el)
  internal func contains(_ object: PyObject, element: PyObject) throws -> Bool {
    fatalError()
  }

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

  /// static PyObject * tupleconcat(PyTupleObject *a, PyObject *bb)
  internal func concat(_ object: PyObject, adding other: PyObject) throws -> PyObject {
    let tuple = try self.matchType(object)

    if tuple.elements.isEmpty {
      return other
    }

    guard let otherTuple = self.matchTypeOrNil(other) else {
      throw PyContextError.tupleInvalidAddendType(addend: other)
    }

    if otherTuple.elements.isEmpty {
      return tuple
    }

    let result = tuple.elements + otherTuple.elements
    return self.new(Array(result))
  }

  /// static PyObject * tuplerepeat(PyTupleObject *a, Py_ssize_t n)
  internal func `repeat`(_ object: PyObject, count: Int) throws -> PyTuple {
    let tuple = try self.matchType(object)
    let count = max(count, 0)

    if tuple.elements.isEmpty || count == 1 {
      return tuple
    }

    var result = [PyObject]()
    result.reserveCapacity(tuple.elements.count * count)

    for _ in 0..<count {
      result.append(contentsOf: tuple.elements)
    }

    return self.new(result)
  }

  /// static PyObject* tuple_index_impl(PyTupleObject *self, PyObject *value, ...)
  internal func indexOf(_ object: PyObject,
                        item: PyObject,
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
  internal func countOf(_ object: PyObject, item: PyObject) -> PyObject {
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

  // TODO: static PyObject * tuplerichcompare(PyObject *v, PyObject *w, int op)
  //  static PyObject * tuple_new_impl(PyTypeObject *type, PyObject *iterable)
  //  static PyObject * tuple_subtype_new(PyTypeObject *type, PyObject *iterable)
  //  static PyObject* tuplesubscript(PyTupleObject* self, PyObject* item)
  //  static PyObject * tuple___getnewargs___impl(PyTupleObject *self)

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
