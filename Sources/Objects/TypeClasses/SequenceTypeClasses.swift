//  lenfunc sq_length;

internal protocol ConcatenableTypeClass: TypeClass {
  func concat(left: PyObject, right: PyObject) throws -> PyObject
}

internal protocol RepeatableTypeClass: TypeClass {
  func `repeat`(value: PyObject, count: PyInt) throws -> PyObject
}

//  ssizeargfunc sq_item;
//  void *was_sq_slice;
//  ssizeobjargproc sq_ass_item;
//  void *was_sq_ass_slice;
//  objobjproc sq_contains;
//
//  binaryfunc sq_inplace_concat;
//  ssizeargfunc sq_inplace_repeat;
//} PySequenceMethods;
