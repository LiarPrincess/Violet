import Foundation
import VioletCore
import VioletObjects

// In CPython:
// Python -> main.c

// swiftlint:disable file_length

extension VM {

  // MARK: - Run

  public enum RunResult {
    /// Nothing interesting happened. Boring…
    case done
    /// User `raised SystemExit`.
    case systemExit(PyObject)
    /// Something bad happened.
    ///
    /// Stack is already unwinded.
    case error(PyBaseException)
  }

  /// static void
  /// pymain_run_python(_PyMain *pymain)
  ///
  /// This method was not intended to be called multiple times,
  /// but it is not like we can stop you.
  ///
  /// CPython (somewhere around):
  /// static int
  /// pymain_cmdline_impl(_PyMain *pymain, _PyCoreConfig *config, ...)
  ///
  /// And also:
  /// static void
  /// pymain_run_python(_PyMain *pymain)
  public func run() -> RunResult {
    if self.arguments.help {
      return self.writeToStdoutAndFinish(msg: Arguments.helpMessage)
    }

    if self.arguments.version {
      return self.writeToStdoutAndFinish(msg: Py.sys.version)
    }

    // Oh no… we will be running code! Let's prepare for this.
    if let e = self.registerSignalHandlers() {
      return .error(e)
    }

    // For some reason importing stuff seems to be important* in programming…
    // * - intended (sorry!)
    if let e = self.initImportlibIfNeeded() {
      return .error(e)
    }

    var runRepl = Py.sys.flags.inspect
    var result: PyResult<PyObject>

    if let command = self.arguments.command {
      result = self.run(command: command)
    } else if let module = self.arguments.module {
      result = self.run(modulePath: module)
    } else if let script = self.arguments.script {
      result = self.run(scriptPath: script)
    } else {
      runRepl = true
      result = self.prepareForInteractiveWithoutArgs()
    }

    switch result {
    case .value:
      break // Let's ignore the returned value
    case .error(let e):
      return self.handleErrorOrSystemExit(error: e)
    }

    if runRepl {
      let e = self.runRepl()
      return self.handleErrorOrSystemExit(error: e)
    }

    return .done
  }

  private func writeToStdoutAndFinish(msg: String) -> RunResult {
    switch self.writeToStdout(msg: msg) {
    case .ok:
      return .done
    case .streamIsNone:
      // We will just assume that by setting 'sys.stdout = None'
      // (or its equivalent in Swift) user explicitly asked for no messages.
      return .done
    case .error(let e):
      return .error(e)
    }
  }

  /// 'IfNeeded' roughly translates to 'if it was not already initialized'.
  private func initImportlibIfNeeded() -> PyBaseException? {
    // This is probably the first time you see our error handling approach.
    // So… we are using 'enums' instead of Swift 'throw'.
    // There is a long comment about this in 'README' for 'Objects' module.
    //
    // Both 'initImportlibIfNeeded' and 'initImportlibExternalIfNeeded'
    // are idempotent, so we can call them as many times as we want.
    // Unless you do something like 'sys.modules['importlib'] = "let it go"',
    // in such case we will reinitialize the whole thing.

    let importlib: PyModule
    switch Py.initImportlibIfNeeded() {
    case let .value(m): importlib = m
    case let .error(e): return e
    }

    switch Py.initImportlibExternalIfNeeded(importlib: importlib) {
    case .value: break
    case .error(let e): return e
    }

    return nil
  }

  private func handleErrorOrSystemExit(error: PyBaseException) -> RunResult {
    guard error.isSystemExit else {
      return .error(error)
    }

    let code = Py.intern(string: "code")
    switch Py.getattr(object: error, name: code) {
    case let .value(object):
      return .systemExit(object)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Run command

  /// static int
  /// pymain_run_command(wchar_t *command, PyCompilerFlags *cf)
  private func run(command: String) -> PyResult<PyObject> {
    // From: https://docs.python.org/3.7/using/cmdline.html#cmdoption-c
    // Execute the Python code in 'command'.
    // 'command' can be one or more statements separated by newlines
    // - 1st element of sys.argv will be "-c"
    // - current directory will be added to the start of sys.path
    //   (allowing modules in that directory to be imported as top level modules).
    self.unimplemented()
  }

  // MARK: - Run module

  /// static int
  /// pymain_run_module(const wchar_t *modname, int set_argv0)
  private func run(modulePath: String) -> PyResult<PyObject> {
    // From: https://docs.python.org/3.7/using/cmdline.html#cmdoption-m
    // Search sys.path for the named module and execute its contents
    // as the __main__ module.
    // - 1st element of sys.argv will be the full path to the module file
    //   (while the module file is being located, it will be set to "-m")
    // - As with the -c option, the current directory will be added
    //   to the start of sys.path.
    self.unimplemented()
  }

  // MARK: - Run script

  /// int
  /// PyRun_SimpleFileExFlags(FILE *fp, const char *filename, int closeit, ...)
  private func run(scriptPath: String) -> PyResult<PyObject> {
    // From 'https://docs.python.org/3.7/using/cmdline.html':
    // Execute the Python code contained in script, which must be a filesystem path
    // (absolute or relative) referring to either a Python file, a directory
    // containing a __main__.py file, or a zipfile containing a __main__.py file.
    // - 1st element of sys.argv will be the script name as given on the command line
    // - If the script name refers to a Python file,
    //   the directory containing that file is added to the start of sys.path,
    //   and the file is executed as the __main__ module.
    // - If the script name refers to a directory or zipfile,
    //   the script name is added to the start of sys.path and
    //   the __main__.py file in that location is executed as the __main__ module.
    // Btw. we don't support 'PYTHONSTARTUP'!

    let script: ScriptLocation
    switch self.getScriptLocation(path: scriptPath) {
    case let .value(s): script = s
    case let .error(e): return .error(e)
    }

    let code: PyCode
    let compileResult = Py.compile(path: script.__main__, mode: .fileInput)
    switch compileResult.asResult() {
    case let .value(c): code = c
    case let .error(e): return .error(e)
    }

    if let e = self.setArgv0(value: scriptPath) {
      return .error(e)
    }

    if let e = self.prependPath(value: script.directory) {
      return .error(e)
    }

    let main: PyModule
    switch self.add__main__Module(loader: .sourceFileLoader, ifAlreadyExists: .use) {
    case let .value(m): main = m
    case let .error(e): return .error(e)
    }

    // Set '__file__' (and whatever happens we need to do cleanup).
    let mainDict = main.getDict()
    mainDict.set(id: .__file__, to: Py.newString(scriptPath))
    defer { _ = mainDict.del(id: .__file__) }

    return self.eval(code: code, globals: mainDict, locals: mainDict)
  }

  private struct ScriptLocation {
    /// File to execute.
    fileprivate let __main__: String
    /// Directory to add to `sys.path`.
    fileprivate let directory: String
  }

  private func getScriptLocation(path: String) -> PyResult<ScriptLocation> {
    let stat: FileStat

    switch self.fileSystem.stat(path: path) {
    case .value(let s):
      stat = s
    case .enoent:
      return .error(Py.newFileNotFoundError(path: path))
    case .error(let e):
      return .error(e)
    }

    // If it is 'regular file' then return it,
    // otherwise try '__main_._py' inside this dir.

    if stat.isRegularFile {
      let dir = self.fileSystem.dirname(path: path)
      return .value(ScriptLocation(__main__: path, directory: dir.path))
    }

    guard stat.isDirectory else {
      let msg = "'\(path)' is neither file nor directory (mode: \(stat.st_mode))"
      return .error(Py.newOSError(msg: msg))
    }

    let dir = path
    let main = self.fileSystem.join(paths: dir, "__main__.py")

    switch self.fileSystem.stat(path: main) {
    case .value(let s):
      if s.isRegularFile {
        return .value(ScriptLocation(__main__: main, directory: dir))
      }

      let msg = "'\(main)' is not a file (mode: \(s.st_mode))"
      return .error(Py.newOSError(msg: msg))

    case .enoent:
      return .error(Py.newFileNotFoundError(path: main))
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Interactive without args

  private func prepareForInteractiveWithoutArgs() -> PyResult<PyObject> {
    // From 'https://docs.python.org/3.7/using/cmdline.html'
    // If no interface option is given:
    // - -i is implied
    // - sys.argv[0] is an empty string ("")
    // - current directory will be added to the start of sys.path.

    if let e = self.setArgv0(value: "") {
      return .error(e)
    }

    let cwd = self.fileSystem.currentWorkingDirectory
    if let e = self.prependPath(value: cwd) {
      return .error(e)
    }

    let hi = """
    If a client requests it, we shall go anywhere.
    Representing the Auto Memoir Doll service,
    I am Violet Evergarden.

    That said, please note that interactive mode is not a priority in Violet
    development and some things may not be working (most notably arrow keys).

    \(Py.sys.version)

    """

    switch self.writeToStdout(msg: hi) {
    case .ok,
         .streamIsNone: // Assuming that user requested no printing.
      break
    case .error(let e):
      return .error(e)
    }

    return .value(Py.none)
  }

  // MARK: - Run REPL

  /// Run read-eval-print-loop.
  /// We will always return exception, but sometimes this exception
  /// is 'SystemExit' (which is intended way of exiting this loop).
  ///
  /// CPython:
  /// static void
  /// pymain_repl(_PyMain *pymain, PyCompilerFlags *cf)
  /// int
  /// PyRun_InteractiveLoopFlags(FILE *fp, const char *filename_str, ...)
  /// static int
  /// PyRun_InteractiveOneObjectEx(FILE *fp, PyObject *filename, ...)
  private func runRepl() -> PyBaseException {
    while true {
      let code: PyCode
      switch self.readStdinForNextInteractiveInput() {
      case .code(let c):
        code = c
      case .syntaxError(let e):
        switch self.writeToStderr(error: e) {
        case .ok, .streamIsNone: continue
        case .error(let e): return e
        }
      case .keyboardInterrupt:
        // On 'KeyboardInterrupt' we should just print 'KeyboardInterrupt'
        // and wait for next input.
        let type = Py.errorTypes.keyboardInterrupt
        let typeName = type.getNameRaw()

        switch self.writeToStdout(msg: typeName) {
        case .ok, .streamIsNone: continue
        case .error(let e): return e
        }
      case .error(let e):
        return e
      }

      let main: PyModule
      switch self.add__main__Module(loader: .builtinImporter, ifAlreadyExists: .use) {
      case let .value(m): main = m
      case let .error(e): return e
      }

      let mainDict = main.getDict()
      switch self.eval(code: code, globals: mainDict, locals: mainDict) {
      case .value:
        // We are not responsible for printing value, 'printExpr' instruction is
        // (see: PEP-217 for details).
        // TODO: defer { flush_io(); }
        break

      case .error(let e):
        // Line resulted in an error!
        // But that does not mean that we should stop 'repl'!
        // Just print this error and wait for next input.
        switch self.writeToStderr(error: e) {
        case .ok, .streamIsNone: break
        case .error(let e): return e
        }
      }
    }
  }

  private enum InteractiveInput {
    case code(PyCode)
    case syntaxError(PyBaseException)
    case keyboardInterrupt
    case error(PyBaseException)
  }

// TODO: remove this
// swiftlint:disable function_body_length

  /// static int
  /// PyRun_InteractiveOneObjectEx(FILE *fp, PyObject *filename, ...)
  private func readStdinForNextInteractiveInput() -> InteractiveInput {
// swiftlint:enable function_body_length

    let stdin: PyTextFile
    switch Py.sys.getStdin() {
    case let .value(f): stdin = f
    case let .error(e): return .error(e)
    }

    let ps1 = self.getInteractivePrompt(type: .ps1)
    let ps2 = self.getInteractivePrompt(type: .ps2)

    var input = ""
    var isFirstLine = true

    while true {
      defer { isFirstLine = false }

      if hasKeyboardInterrupt {
        hasKeyboardInterrupt = false
        return .keyboardInterrupt
      }

      switch self.writeToStdout(msg: isFirstLine ? ps1 : ps2) {
      case .ok, .streamIsNone: break
      case .error(let e): return .error(e)
      }

      // This has an interesting interaction with autocompletion in XCode
      // integrated terminal:
      // 1. We type: 'print("abc'
      // 2. XCode autocompletes it to: 'print("abc")'
      // 3. We will never get the '")' part and fail to compile
      let line: String
      switch stdin.readLine() {
      case let .value(s): line = s
      case let .error(e): return .error(e)
      }

      assert(!line.hasSuffix("\n"))
      input.append(line)
      input.append("\n")

      // There are 2 major cases when we want to try compile the code:
      // - we are 1st line - this is primary designed for single line statements,
      //   for example: 'elsa = princess + ice'.
      //   It may fail for multiline statements, for example 'class Elsa:'
      //   will result in unexpected EOF.
      // - multiline statement - so basically compile when user enters empty line.
      //   There are some false-positives (for example: empty line inside multiline
      //   string), but otherwise this is it.
      if isFirstLine || line.isEmpty {
        switch self.compileInteractive(input: input) {
        case .code(let c):
          return .code(c)
        case .unfinishedLongString:
          break  // We want continue our loop!
        case .unexpectedEOF(let e):
          // - single line statement -> well… apparently it is multiline
          // - multiline statement   -> we expected correct statement
          if !isFirstLine {
            return .syntaxError(e)
          }
        case .syntaxError(let e):
          return .syntaxError(e)
        case .error(let e):
          return .error(e)
        }
      }
    }
  }

  private enum PromptType {
    case ps1
    case ps2
  }

  private var defaultInteractivePrompt: String {
    return ""
  }

  /// String that should be printed in interactive mode.
  private func getInteractivePrompt(type: PromptType) -> String {
    let objectResult: PyResult<PyObject>
    switch type {
    case .ps1:
      objectResult = Py.sys.getPS1()
    case .ps2:
      objectResult = Py.sys.getPS2()
    }

    let object: PyObject
    switch objectResult {
    case .value(let o):
      object = o
    case .error:
      return self.defaultInteractivePrompt
    }

    if let s = object as? PyString {
      return s.value
    }

    switch Py.strValue(object: object) {
    case .value(let s):
      return s
    case .error:
      return self.defaultInteractivePrompt
    }
  }

  private enum CompileInteractiveResult {
    case code(PyCode)
    case unfinishedLongString(PyBaseException)
    /// Input is not complete,
    /// user should provide the rest of it in the next line.
    case unexpectedEOF(PyBaseException)
    /// Statement is complete, but not correct.
    /// Umbrella case for lexer/parser/compiler error.
    case syntaxError(PyBaseException)
    /// Other (possibly non-trivial) error
    case error(PyBaseException)
  }

  private func compileInteractive(input: String) -> CompileInteractiveResult {
    let compileResult = Py.compile(source: input,
                                   filename: "<stdin>",
                                   mode: .interactive)

    switch compileResult {
    case let .code(code):
      return .code(code)

    case let .lexerError(lexerError, e):
        switch lexerError.kind {
        case .unfinishedLongString:
          return .unfinishedLongString(e)
        case .unexpectedEOF:
          return .unexpectedEOF(e)
        default:
          return .syntaxError(e)
        }

    case let .parserError(parserError, e):
        switch parserError.kind {
        case .unexpectedEOF:
          return .unexpectedEOF(e)
        default:
          return .syntaxError(e)
        }

    case let .lexerWarning(_, e),
         let .parserWarning(_, e),
         let .compilerWarning(_, e),
         let .compilerError(_, e):
      return .syntaxError(e)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Helpers - write to stream

  private enum WriteToStreamResult {
    case ok
    case streamIsNone
    case error(PyBaseException)
  }

  private func writeToStdout(object: PyObject) -> WriteToStreamResult {
    switch Py.sys.getStdoutOrNone() {
    case .value(let file):

      switch Py.print(args: [object], file: file) {
      case .value:
        return .ok
      case .error(let e):
        return .error(e)
      }

    case .none:
      return .streamIsNone

    case .error(let e):
      return .error(e)
    }
  }

  private func writeToStdout(msg: String) -> WriteToStreamResult {
    switch Py.sys.getStdoutOrNone() {
    case .value(let file):
      switch file.write(string: msg) {
      case .value:
        return .ok
      case .error(let e):
        return .error(e)
      }

    case .none:
      return .streamIsNone

    case .error(let e):
      return .error(e)
    }
  }

  private func writeToStderr(error: PyBaseException) -> WriteToStreamResult {
    switch Py.sys.getStderrOrNone() {
    case .value(let file):
      // 'printRecursive' swallows any error
      Py.printRecursive(error: error, file: file)
      return .ok

    case .none:
      return.streamIsNone

    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Helpers - set argv0

  /// Set given value as `sys.argv[0]`.
  private func setArgv0(value: String) -> PyBaseException? {
    switch Py.sys.setArgv0(value: value) {
    case .value:
      return nil
    case .error(let e):
      return e
    }
  }

  // MARK: - Helpers - prepend path

  /// Prepend given value to `sys.path`.
  private func prependPath(value: String) -> PyBaseException? {
    return Py.sys.prependPath(value: value)
  }

  // MARK: - Helpers - add __main__

  /// Type of the `__loader__` to set on `__main__`module.
  private enum MainLoader {
    /// Will use `Importlib.BuiltinImporter` as `__loader__`.
    /// Use this it you have input from `<stdin>` (repl etc.).
    case builtinImporter
    /// Will use `ImportlibExternal.SourceFileLoader` as `__loader__`.
    /// Use this if the code comes from `.py` file.
    case sourceFileLoader
    /// Will use `ImportlibExternal.SourcelessFileLoader` as `__loader__`.
    /// Use this if the code comes from Violet equivalent of `.pyc` file.
    case sourcelessFileLoader

    /// Attribute on `self.module` that contains this loader.
    fileprivate var name: String {
      switch self {
      case .builtinImporter:
        return "BuiltinImporter"
      case .sourceFileLoader:
        return "SourceFileLoader"
      case .sourcelessFileLoader:
        return "SourcelessFileLoader"
      }
    }

    /// Name of the module that contains this loader.
    fileprivate var module: String {
      switch self {
      case .builtinImporter:
        return "importlib"
      case .sourceFileLoader,
           .sourcelessFileLoader:
        return "importlib_external"
      }
    }
  }

  // swiftlint:disable:next type_name
  private enum Existing__main__ModulePolicy {
    case use
    case replace
  }

  private var __main__ModuleName: PyString {
    return Py.intern(string: "__main__")
  }

  /// static _PyInitError
  /// add_main_module(PyInterpreterState *interp)
  private func add__main__Module(
    loader: MainLoader,
    ifAlreadyExists existsPolicy: Existing__main__ModulePolicy
  ) -> PyResult<PyModule> {
    switch self.handleExisting__main__Module(policy: existsPolicy) {
    case .value(let m):
      return .value(m)
    case .notFound:
      break
    case .error(let e):
      return .error(e)
    }

    let name = self.__main__ModuleName
    let module = Py.newModule(name: name)
    let dict = module.getDict()

    if dict.get(id: .__annotations__) == nil {
      dict.set(id: .__annotations__, to: Py.newDict())
    }

    if dict.get(id: .__builtins__) == nil {
      dict.set(id: .__builtins__, to: Py.builtinsModule)
    }

    if dict.get(id: .__loader__) == nil {
      switch self.getLoader(type: loader) {
      case let .value(value):
        dict.set(id: .__loader__, to: value)
      case let .error(e):
        return .error(e)
      }
    }

    if let e = Py.sys.addModule(module: module) {
      return .error(e)
    }

    return .value(module)
  }

  // swiftlint:disable:next type_name
  private enum Existing__main__Module {
    case value(PyModule)
    case notFound
    case error(PyBaseException)
  }

  private func handleExisting__main__Module(
    policy: Existing__main__ModulePolicy
  ) -> Existing__main__Module {
    let name = self.__main__ModuleName

    switch policy {
    case .use:
      switch Py.sys.getModule(name: name) {
      case .module(let m):
        return .value(m)

      case .notModule(let o):
        let msg = "Tried to reuse existing '__main__' module, " +
          "but 'sys.modules' contains \(o.typeName) instead of module"
        let e = Py.newRuntimeError(msg: msg)
        return .error(e)

      case .notFound:
        return .notFound
      case .error(let e):
        return .error(e)
      }

    case .replace:
      return .notFound
    }
  }

  private func getLoader(type: MainLoader) -> PyResult<PyObject> {
    let module: PyObject
    let moduleName = Py.intern(string: type.module)

    switch Py.sys.getModule(name: moduleName) {
    case let .module(m):
      module = m
    case .notModule(let o):
      // This is an interesting case,
      // but we will trust that import knows its stuff.
      module = o
    case let .notFound(e),
         let .error(e):
      return .error(e)
    }

    let attribute = type.name
    return Py.getattr(object: module, name: attribute)
  }
}
