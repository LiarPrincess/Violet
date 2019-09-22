import Bytecode
import Objects

extension Frame {

  // MARK: - Bool

  internal func PyObject_IsTrue(_ number: PyObject) -> Bool {
    return false
  }

  // MARK: - Compare

  internal func cmp_outcome(comparison: ComparisonOpcode,
                            left: PyObject,
                            right: PyObject) -> PyObject {
    return left
  }
}
