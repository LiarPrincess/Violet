// swiftlint:disable fatal_error_message

import BigInt

public typealias PyHash = Int

public let Py = PyInstanceFake()

public struct PyInstanceFake {
  public func newDict() -> PyDict {
    fatalError()
  }

  public func newInt(_ value: BigInt) -> PyInt {
    fatalError()
  }

  public func isEqualBool(left: PyObject, right: PyObject) -> PyResult<Bool> {
    return .value(false)
  }
}

public struct IdString {

  internal let value: PyString
  // 'hash' is cached on 'str', but by storing it on 'IdString' we can avoid
  // memory fetch.
  internal let hash: PyHash

//  fileprivate init(value: String) {
//    self.value = Py.newString(value)
//    self.hash = self.value.hash()
//  }
}

