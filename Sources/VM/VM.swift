import Foundation
import Lexer
import Parser
import Compiler
import Bytecode
import Objects

// swiftlint:disable:next type_name
public class VM {

  internal let context: PyContext
  internal let configuration: CoreConfiguration

  internal var arguments: Arguments {
    return self.configuration.arguments
  }

  internal var builtins: Builtins {
    return self.context.builtins
  }

  public init(arguments: Arguments, environment: Environment = Environment()) {
    let contextConf = PyContextConfig()
    self.context = PyContext(config: contextConf)
    self.configuration = CoreConfiguration(arguments: arguments, environment: environment)
  }

  /// static void pymain_run_python(_PyMain *pymain)
  public func run() throws {
    if self.arguments.printHelp {
      print(self.arguments.getUsage())
      return
    }

    if self.arguments.printVersion {
      print("Python \(Constants.pythonVersion)")
      return
    }

    var runRepl = true

    if let command = self.arguments.command {
      runRepl = false
      try self.runCommand(command)
    } else if let module = self.arguments.module {
      runRepl = false
      try self.runModule(module)
    } else if let script = self.arguments.script {
      runRepl = false
      try self.runFilename(script)
    }

    if runRepl || self.configuration.inspectInteractively {
      try self.runRepl()
    }
  }

  private func runCommand(_ command: String) throws {
    let module = self.builtins.newModule(name: "__main__")
    let moduleDict = self.builtins.getDict(module)
    let code = try self.compile(source: command, mode: .fileInput)
    self.run(code: code, globals: moduleDict, locals: moduleDict)
  }

  private func runModule(_ module: String) throws {
    let runpy = self.importModule("runpy")
    let runModule = self.getAttrString(dict: runpy, key: "_run_module_as_main")

    let args = self.newString(module)
    _ = self.call(callable: runModule, args: [args], kwargs: [])
  }

  private func runFilename(_ file: String) throws {
    // We don't support 'PYTHONSTARTUP'
    let fm = FileManager.default

    var isDir: ObjCBool = false
    guard fm.fileExists(atPath: file, isDirectory: &isDir) else {
      self.unimplemented("Can't open file '\(file)': No such file or directory")
    }

    var fileUrl = URL(fileURLWithPath: file, isDirectory: isDir.boolValue)
    if isDir.boolValue {
      fileUrl.appendPathComponent("__main__")
    }

    // TODO: This or RustPython main.rs -> line 410:
    // let sys_path = vm.get_attribute(sys_module, "path")
    // vm.call_method(&sys_path, "insert", vec![vm.new_int(0), vm.new_str(dir)])?;

    let module = self.builtins.newModule(name: "__main__")
    let moduleDict = self.builtins.getDict(module)
    moduleDict.set(key: "__file__", to: self.newString(file))

    let source = try String(contentsOf: fileUrl, encoding: .utf8)
    let code = try self.compile(source: source, mode: .fileInput)

    self.run(code: code, globals: moduleDict, locals: moduleDict)
    moduleDict.del(key: "__file__")
  }

  private func runRepl() throws {
    var input = ""
    var isContinuing = false

    while true {
      let promptObject = self.sysGetObject(key: isContinuing ? "ps2" : "ps1")
      let prompt = self.toStr(promptObject)

      print(prompt, terminator: " ")
      switch readLine() {
      case let .some(line):
        let stopContinuing = line.isEmpty

        if input.isEmpty {
          input = line
        } else {
          input.append(line)
        }
        input.append("\n")

        if isContinuing {
          if stopContinuing {
            isContinuing = false
          } else {
            continue
          }
        }

        switch self.runInteractive(input: input) {
        case .ok:
          input = ""
        case .notFinished:
          isContinuing = true
        case let .error(e):
          throw e
        }

      case .none:
        return
      }
    }
  }

  private enum RunInteractiveResult {
    case ok
    case notFinished
    case error(Error)
  }

  private func runInteractive(input: String) -> RunInteractiveResult {
    do {
      let code = try self.compile(source: input, mode: .interactive)

      let module = self.builtins.newModule(name: "__main__")
      let moduleDict = self.builtins.getDict(module)

      self.run(code: code, globals: moduleDict, locals: moduleDict)
      return .ok
    } catch let error as LexerError {
      switch error.kind {
      case .eof, .unfinishedLongString: return .notFinished
      default: return .error(error)
      }
    } catch let error as ParserError {
      switch error.kind {
      case .unexpectedEOF: return .notFinished
      default: return .error(error)
      }
    } catch {
      return .error(error)
    }
  }

  // MARK: - Compile

  private func compile(source: String, mode: ParserMode) throws -> CodeObject {
    let lexer = Lexer(for: source)
    let parser = Parser(mode: mode, tokenSource: lexer)
    let ast = try parser.parse()

    let optimizationLevel = self.configuration.optimization
    let compilerOptions = CompilerOptions(optimizationLevel: optimizationLevel)
    let compiler = try Compiler(ast: ast, options: compilerOptions)

    return try compiler.run()
  }

  // MARK: - Eval

  /// PyObject *
  /// PyEval_EvalCode(PyObject *co, PyObject *globals, PyObject *locals)
  private func run(code: CodeObject, globals: Attributes, locals: Attributes) {
  }

  // swiftlint:disable:next function_parameter_count
  private func _PyEval_EvalCodeWithName(code: CodeObject,
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

  // MARK: - Unimplemented

  internal func unimplemented(_ message: String = "") -> Never {
    fatalError(message)
  }
}
