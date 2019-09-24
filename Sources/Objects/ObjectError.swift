public enum ObjectError: Error {
  // PyErr_SetString(PyExc_ZeroDivisionError, "float division by zero");
  case floatDivisionByZero
  // PyErr_SetString(PyExc_ZeroDivisionError, "float modulo");
  case floatModuloZero
  // PyErr_SetString(PyExc_ZeroDivisionError, "float divmod()");
  case floatDivModZero

  /// PyErr_SetString(PyExc_IndexError, "tuple index out of range");
  case tupleIndexOutOfRange
  /// PyErr_SetString(PyExc_IndexError, "tuple assignment index out of range");
  case tupleAssignmentIndexOutOfRange
  /// PyErr_Format(PyExc_TypeError,
  ///              "can only concatenate tuple (not \"%.200s\") to tuple",
  ///              Py_TYPE(bb)->tp_name);
  case tupleInvalidAddendType(addend: PyObject)

  case invalidTypeConversion(object: PyObject, to: PyType)
}
