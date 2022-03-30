import Foundation
import VioletCore
import VioletObjects

extension PyFrame {
  internal static func === (lhs: PyFrame?, rhs: PyFrame) -> Bool {
    guard let lhs = lhs else {
      return false
    }

    return lhs.ptr === rhs.ptr
  }
}

internal class PyDelegate: PyDelegateType {

  internal var hasKeyboardInterrupt = false

  // MARK: - Frames

  /// Stack of currently executed frames.
  ///
  /// Current frame is last.
  private var frames = [PyFrame]()

  internal func getCurrentlyExecutedFrame(_ py: Py) -> PyFrame? {
    return self.frames.last
  }

  // MARK: - Currently handled exception

  internal var currentlyHandledException: PyBaseException?

  internal func getCurrentlyHandledException(_ py: Py) -> PyBaseException? {
    return self.currentlyHandledException
  }

  // MARK: - Eval

  /// Run given code object using specified environment.
  ///
  /// CPython:
  /// PyObject *
  /// PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
  internal func eval(_ py: Py,
                     code: PyCode,
                     globals: PyDict,
                     locals: PyDict) -> PyResult {
    return self.eval(py,
                     name: nil,
                     qualname: nil,
                     code: code,
                     args: [],
                     kwargs: nil,
                     defaults: [],
                     kwDefaults: nil,
                     globals: globals,
                     locals: locals,
                     closure: nil)
  }

  // swiftlint:disable function_parameter_count

  /// Run given code object using specified environment.
  ///
  /// CPython:
  /// PyObject *
  /// _PyEval_EvalCodeWithName(PyObject *_co, PyObject *globals, PyObject *locals…)
  internal func eval(_ py: Py,
                     name: PyString?,
                     qualname: PyString?,
                     code: PyCode,
                     args: [PyObject],
                     kwargs: PyDict?,
                     defaults: [PyObject],
                     kwDefaults: PyDict?,
                     globals: PyDict,
                     locals: PyDict,
                     closure: PyTuple?) -> PyResult {
    if let e = self.checkRecursionLimit(py) {
      return .error(e)
    }

    // We don't support zombie frames, we always create new one.
    let frame: PyFrame
    let parent = self.frames.last
    switch py.newFrame(parent: parent,
                       code: code,
                       args: args,
                       kwargs: kwargs,
                       defaults: defaults,
                       kwDefaults: kwDefaults,
                       locals: locals,
                       globals: globals,
                       closure: closure) {
    case let .value(f): frame = f
    case let .error(e): return .error(e)
    }

    // TODO: Everything below following line in CPython:
    /* Handle generator/coroutine/asynchronous generator */

    Debug.frameStart(py, frame)

    self.frames.push(frame)
    let result = Eval(py, delegate: self, frame: frame).run()
    let popFrame = self.frames.popLast()
    assert(popFrame === frame)

    Debug.frameEnd(py, frame, result: result)

    return result
  }

  private func checkRecursionLimit(_ py: Py) -> PyBaseException? {
    // 'sys.recursionLimit' is not only for recursion!
    // It also applies to non-recursive calls.
    // In this sense it is more like 'max call stack depth'.
    //
    // Try to run program generated by following code:
    //
    // fn_count = 1000
    //
    // for i in range(0, fn_count + 1):
    //   body = 'pass' if i == 0 else f'f{i-1}()'
    //   print(f'def f{i}(): {body}')
    //
    // print(f'f{fn_count}()')

    let recursionLimit = py.sys.recursionLimit
    let depth = self.frames.count
    let depthPlusNewFrame = depth + 1

    if depthPlusNewFrame > recursionLimit.value {
      let error = py.newRecursionError()
      return error.asBaseException
    }

    return nil
  }
}