// swiftlint:disable fatal_error_message

public let Py = PyInstanceFake()

public struct PyInstanceFake {
  public func newDict() -> PyDict {
    fatalError()
  }
}
