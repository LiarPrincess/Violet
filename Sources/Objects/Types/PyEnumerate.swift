import Core

// TODO: Enumerate
// PyObject_GenericGetAttr,        /* tp_getattro */
// PyObject_SelfIter,              /* tp_iter */
// {"__reduce__", (PyCFunction)enum_reduce, METH_NOARGS, reduce_doc},

/// Return an enumerate object. iterable must be a sequence, an iterator,
/// or some other object which supports iteration.
internal final class PyEnumerate: PyObject {

  /// Secondary iterator of enumeration
  internal let iterable: PyObject
  /// Current index of enumeration
  internal var index: Index
  /// Result tuple
  internal var item: PyObject

  internal enum Index {
    /// Before first call to next
    case notStarted(startingIndex: Int)
    /// After first call to next
    case started(Int)
  }

  fileprivate init(type: PyEnumerateType,
                   iterable: PyObject,
                   startIndex: Int,
                   none: PyNone) {
    self.iterable = iterable
    self.index = .notStarted(startingIndex: startIndex)
    self.item = none
    super.init(type: type)
  }
}

/// Return an enumerate object. iterable must be a sequence, an iterator,
/// or some other object which supports iteration.
internal final class PyEnumerateType: PyType /* ,
  IterableTypeClass */ {

  override internal var name: String { return "enumerate" }
  override internal var doc: String? { return """
    enumerate(iterable, start=0)
    --

    Return an enumerate object.

    iterable
    an object supporting iteration

    The enumerate object yields pairs containing a count (from start, which
    defaults to zero) and a value yielded by the iterable argument.

    enumerate is useful for obtaining an indexed list:
    (0, seq[0]), (1, seq[1]), (2, seq[2]), ...
    """
  }

  // MARK: - Ctor

  internal func new(iterable: PyObject, start: PyObject?) throws -> PyEnumerate {
//    var index = -1
//
//    if let s = start, let i = self.extractIndex(value: s) {
//      index = i
//    }
//
//    let none = self.types.none.value
//    let iterable = self.context.PyObject_GetIter(value: iterable)
//    return PyEnumerate(type: self,
//                       iterable: iterable,
//                       startIndex: index,
//                       none: none)
    fatalError()
  }

  // MARK: - Methods
/*
  internal func next(value: PyObject) throws -> PyObject {
    let v = try self.matchType(value)

    guard let iterableType = v.iterable.type as? IterableTypeClass else {
      fatalError()
    }

    v.item = try iterableType.next(value: v.iterable)

    let index = self.advanceIndex(v)
    let pyIndex = self.types.int.new(index)

    return self.types.tuple.new([pyIndex, v.item])
  }

  private func advanceIndex(_ value: PyEnumerate) -> Int {
    switch value.index {
    case let .notStarted(startingIndex: index):
      value.index = .started(index)
      return index
    case let .started(index):
      let nextIndex = index + 1
      value.index = .started(nextIndex)
      return nextIndex
    }
  }

  // MARK: - GC

  internal func gcTraverse(value: PyObject, visitor: CGVisitor) throws {
    let v = try self.matchType(value)
    visitor.visit(v.iterable)
    visitor.visit(v.item)
  }

  // MARK: - Helpers

  internal func matchTypeOrNil(_ object: PyObject) -> PyEnumerate? {
    if let o = object as? PyEnumerate {
      return o
    }

    return nil
  }

  internal func matchType(_ object: PyObject) throws -> PyEnumerate {
    if let o = object as? PyEnumerate {
      return o
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
*/
}
