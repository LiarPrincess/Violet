import Core

// In CPython:
// Objects -> tupleobject.c
// https://docs.python.org/3.7/c-api/tuple.html

// TODO: Tuple
// PyObject_GenericGetAttr,                    /* tp_getattro */
// (traverseproc)tupletraverse,                /* tp_traverse */
// tuple_iter,                                 /* tp_iter */
// TUPLE___GETNEWARGS___METHODDEF
// TUPLE_INDEX_METHODDEF
// TUPLE_COUNT_METHODDEF

// swiftlint:disable yoda_condition
// swiftlint:disable file_length

/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
internal final class PyTuple: PyObject {

  internal var elements: [PyObject]

  fileprivate init(type: PyTupleType, elements: [PyObject]) {
    self.elements = elements
    super.init(type: type)
  }
}

/// This instance of PyTypeObject represents the Python tuple type;
/// it is the same object as tuple in the Python layer.
internal final class PyTupleType: PyType,
  ReprTypeClass,
  ComparableTypeClass, HashableTypeClass,
  LengthTypeClass, ConcatTypeClass, RepeatTypeClass,
  ItemTypeClass, ContainsTypeClass, SubscriptTypeClass {

  override internal var name: String { return "tuple" }
  override internal var doc: String? { return """
tuple() -> an empty tuple
tuple(sequence) -> tuple initialized from sequence's items

If the argument is a tuple, the return value is the same object.
"""
  }

  internal lazy var empty = PyTuple(type: self, elements: [])

  // MARK: - Ctor

  internal func new(_ elements: [PyObject]) -> PyTuple {
    return PyTuple(type: self, elements: elements)
  }

  internal func new(_ elements: PyObject...) -> PyTuple {
    return PyTuple(type: self, elements: elements)
  }

  // MARK: - Equatable, hashable

  internal func compare(left: PyObject,
                        right: PyObject,
                        mode: CompareMode) throws -> Bool {
    guard let l = self.matchTypeOrNil(left),
          let r = self.matchTypeOrNil(right) else {
      throw ComparableNotImplemented(left: left, right: right)
    }

    // try to finc first item that differs
    for (lElem, rElem) in zip(l.elements, r.elements) {
      let areEqual = try self.context.richCompareBool(left: lElem,
                                                      right: rElem,
                                                      mode: .equal)
      if !areEqual {
        switch mode {
        case .equal:
          return false
        case .notEqual:
          return true
        case .less,
             .lessEqual,
             .greater,
             .greaterEqual:
          return try self.context.richCompareBool(left: left, right: right, mode: mode)
        }
      }
    }

    // collections are equal up to to shorter tuple count, compare count
    let lCount = self.types.int.new(l.elements.count)
    let rCount = self.types.int.new(r.elements.count)
    return try self.context.richCompareBool(left: lCount, right: rCount, mode: mode)
  }

  internal func hash(value: PyObject) throws -> PyHash {
    let hasher = self.context.hasher
    let v = try self.matchType(value)

    var x: PyHash = 0x345678
    var mult = hasher._PyHASH_MULTIPLIER
    for element in v.elements {
      let y = try self.context.hash(value: element)
      x = (x ^ y) * mult
      mult += 82_520 + PyHash(2 * v.elements.count)
    }

    x += 97_531
    if x == -1 {
      x = -2
    }
    return x
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let v = try self.matchType(value)

    if v.elements.isEmpty {
      return "()"
    }

    // While not mutable, it is still possible to end up with a cycle in a tuple
    // through an object that stores itself within a tuple (and thus infinitely
    // asks for the repr of itself).
    if v.hasReprLock {
      return "(...)"
    }

    return try v.withReprLock {
      var result = "("
      for (index, element) in v.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += try self.context.reprString(value: element)
      }

      result += v.elements.count > 1 ? ")" : ",)"
      return result
    }
  }

  // MARK: - Length

  internal func length(value: PyObject) throws -> PyInt {
    let v = try self.matchType(value)
    return self.types.int.new(v.elements.count)
  }

  internal func lengthInt(value: PyObject) throws -> Int {
    let v = try self.matchType(value)
    return v.elements.count
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
    let countRaw = try self.types.int.extractInt(count)

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

  internal func contains(owner: PyObject, element: PyObject) throws -> Bool {
    let tuple = try self.matchType(owner)

    for e in tuple.elements {
      let isEqual = try self.context.richCompareBool(left: e,
                                                     right: element,
                                                     mode: .equal)
      if isEqual {
        return true
      }
    }

    return false
  }

  internal func indexOf(owner: PyObject,
                        element: PyObject,
                        start: Int,
                        stop:  Int) throws -> PyInt {
    let tuple = try self.matchType(owner)

    var start = start
    if start < 0 {
      start += tuple.elements.count
      if start < 0 {
        start = 0
      }
    }

    var stop = stop
    if stop < 0 {
      stop += tuple.elements.count
    } else if stop > tuple.elements.count {
      stop = tuple.elements.count
    }

    for i in start..<stop {
      let isEqual = try self.context.richCompareBool(left: tuple.elements[i],
                                                     right: element,
                                                     mode: .equal)
      if isEqual {
        return self.types.int.new(i)
      }
    }

    // PyErr_SetString(PyExc_ValueError, "tuple.index(x): x not in tuple");
    fatalError()
  }

  internal func countOf(owner: PyObject, element: PyObject) throws -> PyObject {
    let tuple = try self.matchType(owner)

    var result = 0
    for e in tuple.elements {
      let isEqual = try self.context.richCompareBool(left: e,
                                                     right: element,
                                                     mode: .equal)
      if isEqual {
        result += 1
      }
    }

    return self.types.int.new(result)
  }

  // MARK: - Subscript

  internal func `subscript`(owner: PyObject, index: PyObject) throws -> PyObject {
    let tuple = try self.matchType(owner)

    if var i = try self.extractIndex(value: index) {
      if i < 0 { i += tuple.elements.count }
      return try self.item(owner: tuple, at: i)
    }

    if let slice = index as? PySlice {
      let count = tuple.elements.count
      let adjusted = self.types.slice.adjustIndices(value: slice, to: count)

      if adjusted.length <= 0 {
        return self.empty
      }

      if adjusted.start == 0 && adjusted.step == 1 && adjusted.length == count {
        return tuple
      }

      var elements = [PyObject]()
      for i in 0..<adjusted.length {
        let index = adjusted.start + i * adjusted.step
        elements.append(tuple.elements[index])
      }
      return self.new(elements)
    }

    throw PyContextError.tupleInvalidSubscriptIndex(index: index)
  }

  // MARK: - Slice

  internal func slice(_ object: PyObject, low: Int, high: Int) throws -> PyObject {
    let tuple = try self.matchType(object)

    var low = max(low, 0)
    var high = min(high, tuple.elements.count)

    if low > high {
      (low, high) = (high, low)
    }

    if low == 0 && high == tuple.elements.count {
      return self.new(tuple.elements)
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
