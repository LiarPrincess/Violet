internal protocol TypeClass {
  var context: PyContext { get }
}

// MARK: - Dict owner

internal protocol DictOwnerTypeClass {
  var dict: [String:PyObject] { get set }
}

// MARK: - Comparable

internal typealias EquatableResult = PyResultOrNot<Bool>
internal typealias ComparableResult = PyResultOrNot<Bool>

internal protocol ComparableTypeClass: TypeClass {
  // sourcery: pymethod = __eq__
  func isEqual(_ other: PyObject) -> EquatableResult
  // sourcery: pymethod = __ne__
  func isNotEqual(_ other: PyObject) -> EquatableResult

  // sourcery: pymethod = __lt__
  func isLess(_ other: PyObject) -> ComparableResult
  // sourcery: pymethod = __le__
  func isLessEqual(_ other: PyObject) -> ComparableResult

  // sourcery: pymethod = __gt__
  func isGreater(_ other: PyObject) -> ComparableResult
  // sourcery: pymethod = __ge__
  func isGreaterEqual(_ other: PyObject) -> ComparableResult
}

// DO NOT add default implementations for other methods!
// In Python 'a < b' does not imply 'not(a >= b)'.
extension ComparableTypeClass {
  func isNotEqual(_ other: PyObject) -> EquatableResult {
    switch self.isEqual(other) {
    case let .value(b): return .value(!b)
    case let .error(msg): return .error(msg)
    case .notImplemented: return .notImplemented
    }
  }
}

// MARK: - Hashable

// TODO: Can we remove 'PyResultOrNot'?
internal typealias HashableResult = PyResultOrNot<PyHash>

internal protocol HashableTypeClass: TypeClass {
  // sourcery: pymethod = __hash__
  func hash() -> HashableResult
}

// MARK: - String

internal protocol ReprTypeClass: TypeClass {
  // sourcery: pymethod = __repr__
  func repr() -> String
}

internal protocol StrTypeClass: TypeClass {
  // sourcery: pymethod = __str__
  func str() -> String
}

// MARK: - Attributes

//  getattrfunc tp_getattr;
//  setattrfunc tp_setattr;
//  getattrofunc tp_getattro;
//  setattrofunc tp_setattro;

//  /* More standard operations (here for binary compatibility) */
//

//  ternaryfunc tp_call;
//
//  /* Functions to access object as input/output buffer */
//  PyBufferProcs *tp_as_buffer;
//
//  /* Assigned meaning in release 2.0 */
//  /* call function for all accessible objects */
//  traverseproc tp_traverse;

/// Delete references to contained objects
//internal protocol ClearTypeClass: TypeClass {
//  func clear(value: PyObject) throws
//}

//
//  /* weak reference enabler */
//  Py_ssize_t tp_weaklistoffset;
//
//  /* Iterators */
//  getiterfunc tp_iter;
//  iternextfunc tp_iternext;
//
//  /* Attribute descriptor and subclassing stuff */
//  struct PyMethodDef *tp_methods;
//  struct PyMemberDef *tp_members;
//  struct PyGetSetDef *tp_getset;

//  PyObject *tp_dict;
//  descrgetfunc tp_descr_get;
//  descrsetfunc tp_descr_set;
//  Py_ssize_t tp_dictoffset;
//  initproc tp_init;
//  allocfunc tp_alloc;
//  newfunc tp_new;

//  PyObject *tp_bases;
//  PyObject *tp_mro; /* method resolution order */
//  PyObject *tp_cache;
//  PyObject *tp_subclasses;
//  PyObject *tp_weaklist;
//  destructor tp_del;
//
//  /* Type attribute cache version tag. Added in version 2.6 */
//  unsigned int tp_version_tag;
//
//  destructor tp_finalize;
