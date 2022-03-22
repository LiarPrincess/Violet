/* MARKER
import VioletCore
import VioletBytecode
import VioletObjects

extension VM {

  // MARK: - Eval

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
// ^^^ Well… yep… we will need this one

  /// Run given code object using specified environment.
  ///
  /// Required by `PyDelegate`.
  ///
  /// CPython:
  /// PyObject *
  /// _PyEval_EvalCodeWithName(PyObject *_co, PyObject *globals, PyObject *locals…)
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

    if let e = self.checkRecursionLimit() {
      return .error(e)
    }

    // We don't support zombie frames, we always create new one.
    let parent = self.frames.last
    let frame = Py.newFrame(code: code,
                            locals: locals,
                            globals: globals,
                            parent: parent)

    if let e = self.fillFastLocals(frame: frame,
                                   args: args,
                                   kwargs: kwargs,
                                   defaults: defaults,
                                   kwDefaults: kwDefaults) {
      return .error(e)
    }

    self.fillCells(in: frame, from: code)
    self.fillFree(in: frame, from: code, using: closure)

    // TODO: Everything below following line in CPython:
    /* Handle generator/coroutine/asynchronous generator */

    Debug.frameStart(frame: frame)

    self.frames.push(frame)
    let result = Eval(vm: self, frame: frame).run()
    let poppedFrame = self.frames.popLast()
    assert(poppedFrame === frame)

    Debug.frameEnd(frame: frame)

    return result
  }

  // MARK: - Fill

  /// `Frame.fastLocals` holds function args and local variables.
  private func fillFastLocals(frame: PyFrame,
                              args: [PyObject],
                              kwargs: PyDict?,
                              defaults: [PyObject],
                              kwDefaults: PyDict?) -> PyBaseException? {
    // Filling args and locals is actually quite complicated,
    // so we moved it to separate file.

    var helper = FillFastLocals(frame: frame,
                                args: args,
                                kwargs: kwargs,
                                defaults: defaults,
                                kwDefaults: kwDefaults)

    return helper.run()
  }

  /// Free variables (variables from upper scopes).
  ///
  /// Btw. `Cell` = source for `free` variable.
  ///      `Free` = cell from upper scope.
  private func fillCells(in frame: PyFrame, from code: PyCode) {
    guard code.cellVariableNames.any else {
      return
    }

    for (index, cellName) in code.cellVariableNames.enumerated() {
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
      frame.cellVariables[index] = cell
    }
  }

  /// Free variables (variables from upper scopes).
  ///
  /// Btw. `Cell` = source for `free` variable.
  ///      `Free` = cell from upper scope.
  private func fillFree(in frame: PyFrame,
                        from code: PyCode,
                        using closure: PyTuple?) {
    guard let closure = closure else {
      return
    }

    assert(closure.elements.count == code.freeVariableCount)

    for (index, cellObject) in closure.elements.enumerated() {
      guard let cell = self.py.cast.asCell(cellObject) else {
        let t = cellObject.typeName
        trap("Closure can only contain cells, not '\(t)'.")
      }

      // Free are always after cells
      frame.freeVariables[index] = cell
    }
  }

  // MARK: - Recursion limit

  private func checkRecursionLimit() -> PyBaseException? {
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

    let recursionLimit = Py.sys.getRecursionLimit()
    let depth = self.frames.count
    let depthPlusNewFrame = depth + 1

    if depthPlusNewFrame > recursionLimit.value {
      return Py.newRecursionError()
    }

    return nil
  }
}

*/
