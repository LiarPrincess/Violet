# (name, protocol name, operator, function to call)
operations = [
  # PyObject *
  # PyNumber_Add(PyObject *v, PyObject *w)
  # {
  #     PyObject *result = binary_op1(v, w, NB_SLOT(nb_add));
  #     if (result == Py_NotImplemented) {
  #         PySequenceMethods *m = v->ob_type->tp_as_sequence;
  #         Py_DECREF(result);
  #         if (m && m->sq_concat) {
  #             return (*m->sq_concat)(v, w);
  #         }
  #         result = binop_type_error(v, w, "+");
  #     }
  #     return result;
  # }
  ('add', 'add', '+', 'noDone'),
  # define BINARY_FUNC(func, op, op_name) \
  # PyObject * \
  # func(PyObject *v, PyObject *w) { \
  #     return binary_op(v, w, NB_SLOT(op), op_name); \
  # }
  # BINARY_FUNC(PyNumber_Subtract, nb_subtract, "-")
  ('sub', 'sub', '-', 'binary_op'),
  # PyObject *
  # PyNumber_Multiply(PyObject *v, PyObject *w)
  # {
  #     PyObject *result = binary_op1(v, w, NB_SLOT(nb_multiply));
  #     if (result == Py_NotImplemented) {
  #         PySequenceMethods *mv = v->ob_type->tp_as_sequence;
  #         PySequenceMethods *mw = w->ob_type->tp_as_sequence;
  #         Py_DECREF(result);
  #         if  (mv && mv->sq_repeat) {
  #             return sequence_repeat(mv->sq_repeat, v, w);
  #         }
  #         else if (mw && mw->sq_repeat) {
  #             return sequence_repeat(mw->sq_repeat, w, v);
  #         }
  #         result = binop_type_error(v, w, "*");
  #     }
  #     return result;
  # }
  ('mul', 'mul', '*', 'noDone'),

  # PyObject *
  # PyNumber_MatrixMultiply(PyObject *v, PyObject *w) {
  #     return binary_op(v, w, NB_SLOT(nb_matrix_multiply), "@");
  # }
  # ('matrixMul'), # We don't have any type that implements it
  # ('pow', 'pow'),

  # PyObject *
  # PyNumber_TrueDivide(PyObject *v, PyObject *w) {
  #     return binary_op(v, w, NB_SLOT(nb_true_divide), "/");
  # }
  ('div', 'trueDiv', '/', 'binary_op'),
  # PyObject *
  # PyNumber_FloorDivide(PyObject *v, PyObject *w) {
  #     return binary_op(v, w, NB_SLOT(nb_floor_divide), "//");
  # }
  ('divFloor', 'floorDiv', '//', 'binary_op'),
  # PyObject *
  # PyNumber_Remainder(PyObject *v, PyObject *w) {
  #     return binary_op(v, w, NB_SLOT(nb_remainder), "%");
  # }
  ('remainder', 'mod', '%', 'binary_op'),
  # BINARY_FUNC(PyNumber_Divmod, nb_divmod, "divmod()")
  ('divMod', 'divMod', 'divmod()', 'binary_op'),
  # BINARY_FUNC(PyNumber_Lshift, nb_lshift, "<<")
  ('lShift', 'lShift', '<<', 'binary_op'),
  # BINARY_FUNC(PyNumber_Rshift, nb_rshift, ">>")
  ('rShift', 'rShift', '>>', 'binary_op'),
  # BINARY_FUNC(PyNumber_And, nb_and, "&")
  ('and', 'and', '&', 'binary_op'),
  # BINARY_FUNC(PyNumber_Or, nb_or, "|")
  ('or', 'or', '|', 'binary_op'),
  # BINARY_FUNC(PyNumber_Xor, nb_xor, "^")
  ('xor', 'xor', '^', 'binary_op'),
]

if __name__ == '__main__':
  for op, protocol, operator, func in operations:
    op_upper_first = op[0].upper() + op[1:]
    protocol_name = protocol.lower()
    struct_name = op_upper_first + 'Op'

    print(f'''\
// MARK: - {op_upper_first}

private struct {struct_name}: BinaryOp {{

  fileprivate static let op = "{operator}"
  fileprivate static let selector = "__{op}__"
  fileprivate static let reverseSelector = "__r{op}__"

  fileprivate static func callFastOp(left: PyObject,
                                     right: PyObject) -> PyResultOrNot<PyObject> {{
    if let owner = left as? __{protocol_name}__Owner {{
      return owner.{protocol}(right)
    }}
    return .notImplemented
  }}

  fileprivate static func callFastReverse(left: PyObject,
                                          right: PyObject) -> PyResultOrNot<PyObject> {{
    if let owner = right as? __r{protocol_name}__Owner {{
      return owner.r{protocol}(left)
    }}
    return .notImplemented
  }}
}}

public func {op}(left: PyObject, right: PyObject) -> PyResult<PyObject> {{
  return {struct_name}.call(left: left, right: right)
}}
''')
