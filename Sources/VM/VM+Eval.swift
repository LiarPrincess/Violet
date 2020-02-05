import Objects
import Bytecode

extension VM {

  /// PyObject *
  /// PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
  internal func eval(code: CodeObject, globals: Attributes, locals: Attributes) {
    self.eval(code: code,
              globals: globals,
              locals: locals,

              args: [],
              kwargs: [:],
              defaults: [],

              name: nil,
              qualName: nil,
              parent: nil)
  }

// swiftlint:disable function_parameter_count

  /// PyObject *
  /// _PyEval_EvalCodeWithName(PyObject *_co, PyObject *globals, PyObject *locals...)
  internal func eval(code: CodeObject,
                     globals: Attributes,
                     locals: Attributes,

                     args: [PyObject],
                     kwargs: [String: PyObject],
                     defaults: [PyObject],

                     name: String?,
                     qualName: String?,
                     parent: Frame?) {
// swiftlint:enable function_parameter_count

    // We don't support zombie frames, we always create new one.
//    let totalArgs = args.count + kwargs.count
    let frame = Frame(code: code,
                      locals: locals,
                      globals: globals,
                      parent: parent)

    print("=== Run ===")
    switch frame.run() {
    case let .value(o):
      print("Result:", o)
    case let .error(e):
      let pc = frame.nextInstructionIndex
      let line = code.instructionLines[pc]
      print("Error:", e)
      print("Instruction:", pc)
      print("Line:", line)
    }

//    fastlocals = f->f_localsplus;
//    freevars = f->f_localsplus + co->co_nlocals;

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
}
