import Core

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/list.html

// TODO: List
// PyObject_GenericGetAttr,                    /* tp_getattro */
// (traverseproc)list_traverse,                /* tp_traverse */
// list_iter,                                  /* tp_iter */
// {"__getitem__", (PyCFunction)list_subscript, METH_O|METH_COEXIST, ...},
// LIST___REVERSED___METHODDEF
// LIST___SIZEOF___METHODDEF
// LIST_CLEAR_METHODDEF
// LIST_COPY_METHODDEF
// LIST_APPEND_METHODDEF
// LIST_INSERT_METHODDEF
// LIST_EXTEND_METHODDEF
// LIST_POP_METHODDEF
// LIST_REMOVE_METHODDEF
// LIST_INDEX_METHODDEF
// LIST_COUNT_METHODDEF
// LIST_REVERSE_METHODDEF
// LIST_SORT_METHODDEF

// swiftlint:disable yoda_condition

/// This subtype of PyObject represents a Python list object.
internal final class PyList: PyObject {

  internal var elements: [PyObject]

  fileprivate init(type: PyListType, elements: [PyObject]) {
    self.elements = elements
    super.init(type: type)
  }
}

internal final class PyListType: PyType,
ReprTypeClass,
ComparableTypeClass, HashableTypeClass,
LengthTypeClass, ClearTypeClass,
ConcatTypeClass, ConcatInPlaceTypeClass,
RepeatTypeClass, RepeatInPlaceTypeClass,
ItemTypeClass, ItemAssignTypeClass,
SubscriptTypeClass, SubscriptAssignTypeClass,
ContainsTypeClass {

  internal let name: String = "list"
  internal let base: PyType? = nil
  internal let doc:  String? = """
list(iterable=(), /)
--

Built-in mutable sequence.

If no argument is given, the constructor creates a new empty list.
The argument must be an iterable if specified.
"""

  internal lazy var empty = PyList(type: self, elements: [])

  internal unowned let context: PyContext

  internal init(context: PyContext) {
    self.context = context
  }

  // MARK: - Ctor

  internal func new(_ elements: [PyObject]) -> PyList {
    return PyList(type: self, elements: elements)
  }

  internal func new(_ elements: PyObject...) -> PyList {
    return PyList(type: self, elements: elements)
  }

  // MARK: - Equatable, hashable

  internal func compare(left: PyObject,
                        right: PyObject,
                        mode: CompareMode) throws -> PyObject {
    fatalError()
  }

  internal func hash(value: PyObject, into hasher: inout Hasher) throws -> PyObject {
    throw PyContextError.unhashableType(object: value)
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let list = try self.matchType(value)

    if list.elements.isEmpty {
      return "[]"
    }

    if list.hasReprLock {
      return "[...]"
    }

    return try list.withReprLock {
      var result = "["
      for (index, element) in list.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += try self.context.repr(value: element)
      }

      result += list.elements.count > 1 ? "]" : ",]"
      return result
    }
  }

  // MARK: - Length

  internal func length(value: PyObject) throws -> PyInt {
    let list = try self.matchType(value)
    return self.context.types.int.new(list.elements.count)
  }

  // MARK: - Concat

  internal func concat(left: PyObject, right: PyObject) throws -> PyObject {
    let l = try self.matchType(left)

    guard let r = self.matchTypeOrNil(right) else {
      throw PyContextError.listInvalidAddendType(addend: right)
    }

    let result = l.elements + r.elements
    return self.new(result)
  }

  internal func concatInPlace(left: PyObject, right: PyObject) throws {
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    l.elements.append(contentsOf: r.elements)
  }

  // MARK: - Repeat

  internal func `repeat`(value: PyObject, count: PyInt) throws -> PyObject {
    let list = try self.matchType(value)
    let countRaw = try self.context.types.int.extractInt(count)

    let count = max(countRaw, 0)

    if list.elements.isEmpty || count == 1 {
      return self.new(list.elements)
    }

    var i: BigInt = 0
    var result = [PyObject]()
    while i < count {
      result.append(contentsOf: list.elements)
      i += 1
    }

    return self.new(result)
  }

  internal func repeatInPlace(value: PyObject, count: PyInt) throws {
    let list = try self.matchType(value)
    let countRaw = try self.context.types.int.extractInt(count)

    if countRaw == 0 || countRaw == 1 {
      return
    }

    if countRaw < 0 {
      try self.clear(value: list)
      return
    }

    var i: BigInt = 1 // we already have 1!
    while i < countRaw {
      list.elements.append(contentsOf: list.elements)
      i += 1
    }
  }

  // MARK: - Item

  internal func item(owner: PyObject, at index: Int) throws -> PyObject {
    let list = try self.matchType(owner)

    guard 0 <= index && index < list.elements.count else {
      throw PyContextError.listIndexOutOfRange(list: list, index: index)
    }

    return list.elements[index]
  }

  internal func itemAssign(owner: PyObject, at index: Int, to value: PyObject) throws {
    let list = try self.matchType(owner)

    guard 0 <= index && index < list.elements.count else {
      throw PyContextError.listAssignmentIndexOutOfRange(list: list, index: index)
    }

    // TODO: if (v == NULL) return list_ass_slice(a, i, i+1, v);

    list.elements[index] = value
  }

  internal func contains(owner: PyObject, element: PyObject) throws -> Bool {
    let list = try self.matchType(owner)

    for candidate in list.elements {
      let isEqual = self.context.PyObject_RichCompareBool(left: element,
                                                          right: candidate,
                                                          mode: .equal)

      if isEqual {
        return true
      }
    }

    return false
  }

  // MARK: - Subscript

  func subscriptLength(value: PyObject) throws -> PyObject {
    return try self.length(value: value)
  }

  func `subscript`(owner: PyObject, index: PyObject) throws -> PyObject {
    let list = try self.matchType(owner)

    if var i = try self.extractIndex(value: index) {
      if i < 0 { i += list.elements.count }
      return try self.item(owner: list, at: i)
    }

    // TODO: Add slice as in 'list_subscript(PyListObject* self, PyObject* item)'

    throw PyContextError.listInvalidSubscriptIndex(index: index)
  }

  func subscriptAssign(owner: PyObject, index: PyObject, value: PyObject) throws {
    let list = try self.matchType(owner)

    if var i = try self.extractIndex(value: index) {
      if i < 0 { i += list.elements.count }
      try self.itemAssign(owner: list, at: i, to: value)
    }

    // TODO: Add slice as in 'list_ass_subscript(PyListObject* self, PyObject* item, ...)'
    throw PyContextError.listInvalidSubscriptIndex(index: index)
  }

  // MARK: - Clear

  internal func clear(value: PyObject) throws {
    let list = try self.matchType(value)
    list.elements.removeAll()
  }

  // MARK: - Helpers

  private func matchTypeOrNil(_ object: PyObject) -> PyList? {
    if let tuple = object as? PyList {
      return tuple
    }

    return nil
  }

  private func matchType(_ object: PyObject) throws -> PyList {
    if let tuple = object as? PyList {
      return tuple
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
}
