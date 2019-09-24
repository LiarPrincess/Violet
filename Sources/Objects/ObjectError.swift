public enum ObjectError: Error {

  /// PyErr_SetString(PyExc_ValueError, "negative shift count");
  case negativeShiftCount

  // PyErr_SetString(PyExc_ZeroDivisionError, "float division by zero");
  case intDivisionByZero
  // PyErr_SetString(PyExc_ZeroDivisionError, "float modulo");
  case intModuloZero
  // PyErr_SetString(PyExc_ZeroDivisionError, "float divmod()");
  case intDivModZero

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
  /// PyErr_Format(
  ///   PyExc_TypeError,
  ///   "can only concatenate tuple (not \"%.200s\") to tuple",
  ///   Py_TYPE(bb)->tp_name);
  case tupleInvalidAddendType(addend: PyObject)

  /// PyErr_Format(PyExc_TypeError,
  ///   "unsupported operand type(s) for %.100s: "
  ///   "'%.100s' and '%.100s'",
  ///   op_name,
  ///   v->ob_type->tp_name,
  ///   w->ob_type->tp_name);
  case unsupportedBinaryOperandType(operation: String,
                                    left:  PyObject,
                                    right: PyObject)
  case invalidTypeConversion(object: PyObject, to: PyType)
}
