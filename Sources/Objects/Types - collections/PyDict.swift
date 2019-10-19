import Core

// In CPython:
// Objects -> listobject.c
// https://docs.python.org/3.7/c-api/dict.html

// TODO: Dict
// PyObject_GenericGetAttr,                    /* tp_getattro */
// dict_traverse,                              /* tp_traverse */
// (getiterfunc)dict_iter,                     /* tp_iter */
// DICT___CONTAINS___METHODDEF
// {"__getitem__", (PyCFunction)dict_subscript,        METH_O | METH_COEXIST, ...},
// {"__sizeof__",      (PyCFunction)dict_sizeof,       METH_NOARGS, sizeof__doc__},
// DICT_GET_METHODDEF
// DICT_SETDEFAULT_METHODDEF
// {"pop",         (PyCFunction)dict_pop,          METH_VARARGS, pop__doc__},
// {"popitem",         (PyCFunction)dict_popitem,      METH_NOARGS, popitem__doc__},
// {"keys",            (PyCFunction)dictkeys_new,      METH_NOARGS, keys__doc__},
// {"items",           (PyCFunction)dictitems_new,     METH_NOARGS, items__doc__},
// {"values",          (PyCFunction)dictvalues_new,    METH_NOARGS, values__doc__},
// {"update",          (PyCFunction)dict_update,       METH_VARARGS | METH_KEYWORDS, ...},
// DICT_FROMKEYS_METHODDEF
// {"clear",           (PyCFunction)dict_clear,        METH_NOARGS, clear__doc__},
// {"copy",            (PyCFunction)dict_copy,         METH_NOARGS, copy__doc__},
#warning("This is not a correct implementation, it will fail on collision!")

/// This subtype of PyObject represents a Python dictionary object.
internal final class PyDict: PyObject {

  internal var elements: [PyDictKey: PyObject]

  internal init(_ context: PyContext, elements: [PyDictKey: PyObject]) {
    self.elements = elements
    super.init(type: context.types.dict)
  }
}

internal struct PyDictKey: Equatable, Hashable {

  fileprivate let hash: PyHash
  fileprivate let object: PyObject

  internal static func == (lhs: PyDictKey, rhs: PyDictKey) -> Bool {
    return lhs.hash == rhs.hash
  }

  internal func hash(into hasher: inout Swift.Hasher) {
    hasher.combine(self.hash)
  }
}

/// This subtype of PyObject represents a Python dictionary object.
internal final class PyDictType: PyType /* ,
  ReprTypeClass,
  HashableTypeClass, ComparableTypeClass,
  ClearTypeClass, ContainsTypeClass,
  LengthTypeClass, SubscriptTypeClass, SubscriptAssignTypeClass */ {

//  override internal var name: String { return "dict" }
//  override internal var doc: String? { return """
//    dict() -> new empty dictionary
//    dict(mapping) -> new dictionary initialized from a mapping object's
//    (key, value) pairs
//    dict(iterable) -> new dictionary initialized as if via:
//    d = {}
//    for k, v in iterable:
//    d[k] = v
//    dict(**kwargs) -> new dictionary initialized with the name=value pairs
//    in the keyword argument list.  For example:  dict(one=1, two=2)
//    """
//  }

  // MARK: - Ctor
/*
  // MARK: - Equatable, hashable

  internal func hash(value: PyObject) throws -> PyHash {
    throw HashableNotImplemented(value: value)
  }

  internal func compare(left: PyObject,
                        right: PyObject,
                        mode: CompareMode) throws -> Bool {
    let l = try self.matchType(left)
    let r = try self.matchType(right)

    switch mode {
    case .equal:
      let isEqual = try self.isEqual(left: l, right: r)
      return isEqual
    case .notEqual:
      let isEqual = try self.isEqual(left: l, right: r)
      return !isEqual
    case .less,
         .lessEqual,
         .greater,
         .greaterEqual:
      throw ComparableNotImplemented(left: left, right: right)
    }
  }

  private func isEqual(left: PyDict, right: PyDict) throws -> Bool {
    guard left.elements.count == right.elements.count else {
      return false
    }

    for (key, l) in left.elements {
      guard let r = right.elements[key] else {
        return false
      }

      let areEqual = try self.context.richCompareBool(left: l, right: r, mode: .equal)
      if !areEqual {
        return false
      }
    }

    return true
  }

  // MARK: - String

  internal func repr(value: PyObject) throws -> String {
    let v = try self.matchType(value)

    if v.elements.isEmpty {
      return "{}"
    }

    if value.hasReprLock {
      return "{...}"
    }

    return try value.withReprLock {
      var result = "{"
      for (index, element) in v.elements.enumerated() {
        if index > 0 {
          result += ", " // so that we don't have ', )'.
        }

        result += try self.context.reprString(value: element.key.object)
        result += ": "
        result += try self.context.reprString(value: element.value)
      }

      result += "}"
      return result
    }
  }

  // MARK: - Methods

  internal func clear(value: PyObject) throws {
    let v = try self.matchType(value)
    v.elements.removeAll()
  }

  internal func contains(owner: PyObject, element: PyObject) throws -> Bool {
    let v = try self.matchType(owner)

    let hash = try self.context.hash(value: element)
    let key = PyDictKey(hash: hash, object: element)

    return v.elements.contains(key)
  }

  internal func length(value: PyObject) throws -> PyInt {
    let v = try self.matchType(value)
    return self.types.int.new(v.elements.count)
  }

  internal func `subscript`(owner: PyObject, index: PyObject) throws -> PyObject {
    let v = try self.matchType(owner)

    let hash = try self.context.hash(value: index)
    let key = PyDictKey(hash: hash, object: index)

    if let result = v.elements[key] {
      return result
    }

    // _PyErr_SetKeyError(key);
    fatalError()
  }

  internal func subscriptAssign(owner: PyObject, index: PyObject, value: PyObject) throws {
    fatalError()
  }

  // MARK: - Helpers

  internal func matchTypeOrNil(_ object: PyObject) -> PyDict? {
    if let o = object as? PyDict {
      return o
    }

    return nil
  }

  internal func matchType(_ object: PyObject) throws -> PyDict {
    if let o = object as? PyDict {
      return o
    }

    throw PyContextError.invalidTypeConversion(object: object, to: self)
  }
*/
}
