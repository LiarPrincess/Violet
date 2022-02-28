public struct PyString {
  public var asObject: PyObject { fatalError() }
}
public struct PyBaseException {}

extension PyType {
  internal struct MemoryLayout {}
  internal struct StaticallyKnownNotOverriddenMethods {}
}
