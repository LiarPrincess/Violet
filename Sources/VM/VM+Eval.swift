import Objects
import Bytecode

extension VM {

  /// PyObject *
  /// PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
  public func eval(code: CodeObject,
                   globals: PyDict,
                   locals: PyDict) -> PyResult<PyObject> {
    return self.eval(
      name: nil,
      qualname: nil,
      code: code,

      args: [],
      kwargs: nil,
      defaults: [],
      kwDefaults: nil,

      globals: globals,
      locals: locals
    )
  }

// swiftlint:disable function_parameter_count

  /// PyObject *
  /// _PyEval_EvalCodeWithName(PyObject *_co, PyObject *globals, PyObject *locals...)
  public func eval(name: String?,
                   qualname: String?,
                   code: CodeObject,

                   args: [PyObject],
                   kwargs: PyDict?,
                   defaults: [PyObject],
                   kwDefaults: PyDict?,

                   globals: PyDict,
                   locals: PyDict) -> PyResult<PyObject> {
// swiftlint:enable function_parameter_count

    // We don't support zombie frames, we always create new one.
    let parent = self.frames.last
    let frame = Frame(code: code,
                      locals: locals,
                      globals: globals,
                      parent: parent)

    var fillFastLocals = FillFastLocals(frame: frame,
                                        args: args,
                                        kwargs: kwargs,
                                        defaults: defaults,
                                        kwDefaults: kwDefaults)

    switch fillFastLocals.run() {
    case .value: break
    case .error(let e): return .error(e)
    }

    // TODO: Everything below following line:
    // Allocate and initialize storage for cell vars, and copy free

    self.frames.push(frame)
    let result = frame.run()
    let poppedFrame = self.frames.popLast()
    assert(poppedFrame === frame)

    return result
  }
}
