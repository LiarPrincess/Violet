import Objects
import Bytecode

extension Frame {

  /// Performs a `Boolean` operation.
  internal func compareOp(comparison: ComparisonOpcode) -> InstructionResult {
    let right = self.stack.pop()
    let left = self.stack.top

    switch self.compare(left: left, right: right, comparison: comparison) {
    case let .value(result):
      self.stack.top = result
      return .ok
    case let .error(e):
      return .builtinError(e)
    }
  }

  private func compare(left: PyObject,
                       right: PyObject,
                       comparison: ComparisonOpcode) -> PyResult<PyObject> {
    switch comparison {
    case .equal:
      return self.builtins.isEqual(left: left, right: right)
    case .notEqual:
      return self.builtins.isNotEqual(left: left, right: right)
    case .less:
      return self.builtins.isLess(left: left, right: right)
    case .lessEqual:
      return self.builtins.isLessEqual(left: left, right: right)
    case .greater:
      return self.builtins.isGreater(left: left, right: right)
    case .greaterEqual:
      return self.builtins.isGreaterEqual(left: left, right: right)
    case .is:
      let result = self.builtins.is(left: left, right: right)
      return .value(self.builtins.newBool(result))
    case .isNot:
      let result = self.builtins.is(left: left, right: right)
      return .value(self.builtins.newBool(!result))
    case .in:
      let result = self.builtins.contains(iterable: left, element: right)
      return result.map(self.builtins.newBool)
    case .notIn:
      let result = self.builtins.contains(iterable: left, element: right)
      return result.map { !$0 }.map(self.builtins.newBool)
    case .exceptionMatch:
      // ceval.c -> case PyCmp_EXC_MATCH:
      fatalError()
    }
  }
}
