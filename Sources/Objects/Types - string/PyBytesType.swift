/// Protocol implemented by both `bytes` and `bytearray`.
internal protocol PyBytesType: PyObject {
  var data: PyBytesData { get }

  /// Is this builtin `bytes/bytearray` type?
  ///
  /// Will return `false` if this is a subclass.
  func checkExact() -> Bool
}
