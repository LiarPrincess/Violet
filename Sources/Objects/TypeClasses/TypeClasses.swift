internal protocol TypeClass {
  var name: String { get }
  var base: PyType? { get }
  var doc:  String? { get }
  var context: PyContext { get }
}

// MARK: - Comparable

/// Use to unwind comparable
internal struct ComparableNotImplemented: Error {
  internal let left: PyObject
  internal let right: PyObject
}

internal protocol ComparableTypeClass: TypeClass {
  func compare(left: PyObject,
               right: PyObject,
               mode: CompareMode) throws -> Bool
}

// MARK: - Hashable

/// Use to unwind hashable
internal struct HashableNotImplemented: Error {
  internal let value: PyObject
}

internal protocol HashableTypeClass: TypeClass {
  func hash(value: PyObject) throws -> PyHash
}

// MARK: - String

//  printfunc tp_print;

// TODO: remove this if all types implement
internal protocol ReprTypeClass: TypeClass {
  func repr(value: PyObject) throws -> String
}

internal protocol StrTypeClass: TypeClass {
  func str(value: PyObject) throws -> String
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
internal protocol ClearTypeClass: TypeClass {
  func clear(value: PyObject) throws
}

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
