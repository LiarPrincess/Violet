public enum PyContextError: Error {

  /// PyErr_SetString(PyExc_ValueError, "negative shift count");
  case negativeShiftCount

  /// PyErr_SetString(PyExc_ZeroDivisionError, "float division by zero");
  case intDivisionByZero
  /// PyErr_SetString(PyExc_ZeroDivisionError, "float modulo");
  case intModuloZero
  /// PyErr_SetString(PyExc_ZeroDivisionError, "float divmod()");
  case intDivModZero

  /// PyErr_SetString(PyExc_ZeroDivisionError, "float division by zero");
  case floatDivisionByZero
  /// PyErr_SetString(PyExc_ZeroDivisionError, "float modulo");
  case floatModuloZero
  /// PyErr_SetString(PyExc_ZeroDivisionError, "float divmod()");
  case floatDivModZero

  /// return type_error("bad operand type for unary +: '%.200s'", o);
  case invalidOperandForUnaryPositive(PyObject)
  /// return type_error("bad operand type for unary -: '%.200s'", o);
  case invalidOperandForUnaryNegative(PyObject)
  /// return type_error("bad operand type for unary ~: '%.200s'", o);
  case invalidOperandForUnaryInvert(PyObject)
  /// return type_error("bad operand type for abs(): '%.200s'", o);
  case invalidOperandForAbs(PyObject)

  /// PyErr_SetString(PyExc_IndexError, "tuple index out of range");
  case tupleIndexOutOfRange
  /// PyErr_SetString(PyExc_IndexError, "tuple assignment index out of range");
  case tupleAssignmentIndexOutOfRange
  /// PyErr_Format(
  ///   PyExc_TypeError,
  ///   "can only concatenate tuple (not \"%.200s\") to tuple",
  ///   Py_TYPE(bb)->tp_name);
  case tupleInvalidAddendType(addend: PyObject)

  /// return type_error("can't multiply sequence by non-int of type '%.200s'", n);
  case sequenceRepeatWithNonInt(PyObject)

  /// PyErr_Format(PyExc_TypeError,
  ///   "unsupported operand type(s) for %.100s: "
  ///   "'%.100s' and '%.100s'",
  ///   op_name,
  ///   v->ob_type->tp_name,
  ///   w->ob_type->tp_name);
  case unsupportedBinaryOperandType(operation: String,
                                    left:  PyObject,
                                    right: PyObject)

  // TODO: Remove and use NotImplemented
  case invalidTypeConversion(object: PyObject, to: Any)
}
