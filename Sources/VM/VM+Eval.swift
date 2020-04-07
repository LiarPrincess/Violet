import Core
import Objects
import Bytecode

extension VM {

  /// Run given code object using specified environment.
  ///
  /// CPython:
  /// PyObject *
  /// PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
  public func eval(code: PyCode,
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
      locals: locals,
      closure: nil
    )
  }

// swiftlint:disable function_parameter_count

  /// Run given code object using specified environment.
  ///
  /// Required by `PyDelegate`.
  ///
  /// CPython:
  /// PyObject *
  /// _PyEval_EvalCodeWithName(PyObject *_co, PyObject *globals, PyObject *locals...)
  public func eval(name: PyString?,
                   qualname: PyString?,
                   code: PyCode,

                   args: [PyObject],
                   kwargs: PyDict?,
                   defaults: [PyObject],
                   kwDefaults: PyDict?,

                   globals: PyDict,
                   locals: PyDict,
                   closure: PyTuple?) -> PyResult<PyObject> {
// swiftlint:enable function_parameter_count

    // We don't support zombie frames, we always create new one.
    let parent = self.frames.last
    let frame = Py.newFrame(code: code,
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

    self.fillCells(in: frame, from: code)
    self.fillFree(in: frame, from: code, using: closure)

    // TODO: Everything below following line:
    /* Handle generator/coroutine/asynchronous generator */

    Debug.frameStart(frame: frame)

    self.frames.push(frame)
    let result = Eval(vm: self, frame: frame).run()
    let poppedFrame = self.frames.popLast()
    assert(poppedFrame === frame)

    Debug.frameEnd(frame: frame)

    return result
  }

  private func fillCells(in frame: PyFrame, from code: PyCode) {
    guard code.cellVariableNames.any else {
      return
    }

    for (i, cellName) in code.cellVariableNames.enumerated() {
      let cell: PyCell

      // Possibly account for the cell variable being an argument.
      if let arg = code.variableNames.firstIndex(of: cellName) {
        let local = frame.fastLocals[arg]
        cell = Py.newCell(content: local)
        frame.fastLocals[arg] = nil
      } else {
        cell = Py.newCell(content: nil)
      }

      // CPython stores everything in a single memory block
      // that's why they have to add 'co->co_nlocals'.
      frame.cellsAndFreeVariables[i] = cell
    }
  }

  private func fillFree(in frame: PyFrame,
                        from code: PyCode,
                        using closure: PyTuple?) {
    guard let closure = closure else {
      return
    }

    assert(closure.elements.count == code.freeVariableCount)

    let cellCount = code.cellVariableCount
    for (index, cellObject) in closure.elements.enumerated() {
      guard let cell = cellObject as? PyCell else {
        let t = cellObject.typeName
        trap("Closure can only contain cells, not '\(t)'.")
      }

      // Free are laways after cells
      let cellOrFreeIndex = cellCount + index
      frame.cellsAndFreeVariables[cellOrFreeIndex] = cell
    }
  }
}
