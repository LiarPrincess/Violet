import Objects
import Bytecode

extension VM {

  /// PyObject *
  /// PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
  internal func eval(code: CodeObject,
                     globals: Attributes,
                     locals: Attributes) -> PyResult<PyObject> {
    return self.eval(
      name: nil,
      qualname: nil,
      code: code,

      args: [],
      kwArgs: nil,
      defaults: [],
      kwDefaults: nil,

      globals: globals,
      locals: locals,
      parent: nil
    )
  }

// swiftlint:disable function_parameter_count

  /// PyObject *
  /// _PyEval_EvalCodeWithName(PyObject *_co, PyObject *globals, PyObject *locals...)
  internal func eval(name: String?,
                     qualname: String?,
                     code: CodeObject,

                     args: [PyObject],
                     kwArgs: Attributes?,
                     defaults: [PyObject],
                     kwDefaults: Attributes?,

                     globals: Attributes,
                     locals: Attributes,
                     parent: Frame?) -> PyResult<PyObject> {
// swiftlint:enable function_parameter_count

    // We don't support zombie frames, we always create new one.
    let frame = Frame(code: code,
                      locals: locals,
                      globals: globals,
                      parent: parent)

    var fillFastLocals = FillFastLocals(frame: frame,
                                        args: args,
                                        kwArgs: kwArgs,
                                        defaults: defaults,
                                        kwDefaults: kwDefaults)

    switch fillFastLocals.run() {
    case .value: break
    case .error(let e): return .error(e)
    }

    // TODO: Everything below following line:
    // Allocate and initialize storage for cell vars, and copy free
    return frame.run()
  }
}
