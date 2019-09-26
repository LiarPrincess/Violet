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
  case tupleIndexOutOfRange(tuple: PyObject, index: Int)
  /// PyErr_SetString(PyExc_IndexError, "tuple assignment index out of range");
  case tupleAssignmentIndexOutOfRange
  /// PyErr_Format(
  ///   PyExc_TypeError,
  ///   "can only concatenate tuple (not \"%.200s\") to tuple",
  ///   Py_TYPE(bb)->tp_name);
  case tupleInvalidAddendType(addend: PyObject)
  /// PyErr_Format(
  ///   PyExc_TypeError,
  ///   "tuple indices must be integers or slices, not %.200s",
  ///   Py_TYPE(item)->tp_name);
  case tupleInvalidSubscriptIndex(index: PyObject)

  /// indexerr = PyUnicode_FromString("list index out of range");
  case listIndexOutOfRange(list: PyObject, index: Int)
  /// PyErr_SetString(PyExc_IndexError, "list assignment index out of range");
  case listAssignmentIndexOutOfRange(list: PyObject, index: Int)
  /// PyErr_Format(
  ///   PyExc_TypeError,
  ///   "can only concatenate list (not \"%.200s\") to list",
  ///   bb->ob_type->tp_name);
  case listInvalidAddendType(addend: PyObject)
  /// PyErr_Format(
  ///   PyExc_TypeError,
  ///   "list indices must be integers or slices, not %.200s",
  ///   item->ob_type->tp_name);
  case listInvalidSubscriptIndex(index: PyObject)

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

  /// PyErr_Format(PyExc_TypeError, "unhashable type: '%.200s'", Py_TYPE(v)->tp_name);
  case unhashableType(object: PyObject)

  // TODO: Remove and use NotImplemented
  case invalidTypeConversion(object: PyObject, to: Any)
}
