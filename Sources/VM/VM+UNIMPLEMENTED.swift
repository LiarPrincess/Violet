import Objects
import Bytecode

extension VM {

  // MARK: - Import

  /// PyImport_ImportModule
  internal func importModule(_ name: String) -> PyModule {
    return self.context.builtinsModule
  }

  // MARK: - Eval

  /// PyObject *
  /// PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
  internal func run(code: CodeObject, globals: Attributes, locals: Attributes) {
  }

  // swiftlint:disable:next function_parameter_count
  internal func _PyEval_EvalCodeWithName(code: CodeObject,
                                         globals: [String: PyObject],
                                         locals: [String: PyObject],
                                         args: [PyObject],
                                         kwargs: [String: PyObject],
                                         defaults: [PyObject],
                                         name: String,
                                         qualName: String,
                                         parent: Frame?) {
    //    let totalArgs = args.count + kwargs.count
    //    let f = self._PyFrame_New_NoTrack(code: code,
    //                                      globals: globals,
    //                                      locals: locals,
    //                                      parent: parent)

    // Create a dictionary for keyword parameters (**kwags)
    // kwdict = PyDict_New();
    // i = total_args; // + 1 if 'co->co_flags & CO_VARARGS'
    // SETLOCAL(i, kwdict);

    // Copy positional arguments into local variables
    // n = min(co->co_argcount, argcount) <-- this is for *args
    // for i = 0 to n: SETLOCAL(i, args[i]);

    // Pack other positional arguments into the *args argument
    // u = tuple()
    // for i = n to argcount: u[i - n] = args[i]

    // Handle keyword arguments passed as two strided arrays
    // for k, v in kwargs:
    // do we have such code.kwarg? -> assign kwarg
    // else kwdict[k] = v

    // Check the number of positional arguments
    // if (argcount > co->co_argcount && !(co->co_flags & CO_VARARGS)):
    //   too_many_positional(co, argcount, defcount, fastlocals);

    // Add missing positional arguments (copy default values from defs)
    // if (argcount < co->co_argcount) ...

    // Add missing keyword arguments (copy default values from kwdefs)
    // if (co->co_kwonlyargcount > 0):

    // Allocate and initialize storage for cell vars, and copy free vars into frame.
    // Copy closure variables to free variables

    // retval = PyEval_EvalFrameEx(f,0);
  }

  private func _PyFrame_New_NoTrack(code: CodeObject,
                                    globals: [String: PyObject],
                                    locals: [String: PyObject],
                                    parent: Frame?) {
    // let back = parent
    //    if let parent = parent {
    //      builtins = back->f_builtins;
    //    } else {
    //      builtins = _PyDict_GetItemId(globals, &PyId___builtins__);
    //      if (PyModule_Check(builtins)) {
    //          builtins = PyModule_GetDict(builtins);
    //      }
    //    }

    //    let nCells = code.cellVars.count
    //    let nFrees = code.freeVars.count
    //    let extras = /* code->co_nlocals */ nCells + nFrees

    //    let f = Frame()
    //    f->f_code = code;
    //    f->f_valuestack = f->f_localsplus + extras;
    //    for (i=0; i<extras; i++)
    //        f->f_localsplus[i] = NULL;
    //    f->f_locals = NULL; // will be set by PyFrame_FastToLocals()
    //    f->f_trace = NULL;

    //    f->f_stacktop = f->f_valuestack;
    //    f->f_builtins = builtins;
    //    Py_XINCREF(back);
    //    f->f_back = back;
    //    Py_INCREF(code);
    //    Py_INCREF(globals);
    //    f->f_globals = globals;
  }
}
