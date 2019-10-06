internal protocol TypeClass {
  var context: PyContext { get }
}

// MARK: - Equatable

internal enum EquatableResult {
  case value(Bool)
  case notImplemented
}

internal protocol EquatableTypeClass: TypeClass {
  func isEqual(_ other: PyObject) -> EquatableResult
  func isNotEqual(_ other: PyObject) -> EquatableResult
}

extension EquatableTypeClass {
  func isNotEqual(_ other: PyObject) -> EquatableResult {
    switch self.isEqual(other) {
    case let .value(b): return .value(!b)
    case .notImplemented: return .notImplemented
    }
  }
}

// MARK: - Comparable

internal enum ComparableResult {
  case value(Bool)
  case notImplemented
}

internal protocol ComparableTypeClass: EquatableTypeClass {
  func isLess(_ other: PyObject) throws -> ComparableResult
  func isLessEqual(_ other: PyObject) throws -> ComparableResult
  func isGreater(_ other: PyObject) throws -> ComparableResult
  func isGreaterEqual(_ other: PyObject) throws -> ComparableResult
}

// MARK: - Hashable

/// Use to unwind hashable

internal protocol HashableTypeClass: TypeClass {
  var hash: PyHash { get }
}

// MARK: - String

internal protocol ReprTypeClass: TypeClass {
  var repr: String { get }
}

internal protocol StrTypeClass: TypeClass {
  var str: String { get }
}

// MARK: - Attributes

//  getattrfunc tp_getattr;
//  setattrfunc tp_setattr;
//  getattrofunc tp_getattro;
//  setattrofunc tp_setattro;

// MARK: - Other

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
