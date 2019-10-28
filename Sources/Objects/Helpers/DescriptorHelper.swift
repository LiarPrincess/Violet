internal enum DescriptorHelper {

  /// define PyDescr_IsData(d) (Py_TYPE(d)->tp_descr_set != NULL)
  internal static func isData(_ object: PyObject) -> Bool {
    let setter = object.type.lookup(name: "__set__")
    return setter != nil
  }
}
