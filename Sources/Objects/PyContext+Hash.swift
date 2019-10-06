extension PyContext {

  /// Py_hash_t PyObject_Hash(PyObject *v)
  internal func hash(value: PyObject) throws -> PyHash {
//    if let h = value.type as? HashableTypeClass {
//      do {
//        return try h.hash(value: value)
//      } catch is HashableNotImplemented { }
//    }

    // TODO: This
    /* To keep to the general practice that inheriting
     * solely from object in C code should work without
     * an explicit call to PyType_Ready, we implicitly call
     * PyType_Ready here and then check the tp_hash slot again
     */
//    if (tp->tp_dict == NULL) {
//      if (PyType_Ready(tp) < 0)
//      return -1;
//      if (tp->tp_hash != NULL)
//      return (*tp->tp_hash)(v);
//    }

    // PyErr_Format(PyExc_TypeError, "unhashable type: '%.200s'", Py_TYPE(v)->tp_name);
    fatalError()
  }
}
