import Foundation
import VioletCore
import VioletObjects

// swiftlint:disable file_length
// cSpell:ignore unwinded

// In CPython:
// Python -> main.c

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

    #if DEBUG
    // Most of the time we don't want to debug importlib
    Debug.isAfterImportlib = true
    #endif

    return nil
  }

  private func handleErrorOrSystemExit(error: PyBaseException) -> RunResult {
    guard PyCast.isSystemExit(error) else {
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

  // MARK: - Helpers - write to stream

  internal enum WriteToStreamResult {
    case ok
    case streamIsNone
    case error(PyBaseException)
  }

  internal func writeToStdout(object: PyObject) -> WriteToStreamResult {
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

  internal func writeToStdout(msg: String) -> WriteToStreamResult {
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

  internal func writeToStderr(error: PyBaseException) -> WriteToStreamResult {
    switch Py.sys.getStderrOrNone() {
    case .value(let file):
      Py.printRecursiveIgnoringErrors(error: error, file: file)
      return .ok
    case .none:
      return .streamIsNone
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Helpers - set argv0

  /// Set given value as `sys.argv[0]`.
  internal func setArgv0(value: String) -> PyBaseException? {
    switch Py.sys.setArgv0(value: value) {
    case .value:
      return nil
    case .error(let e):
      return e
    }
  }

  // MARK: - Helpers - prepend path

  /// Prepend given value to `sys.path`.
  internal func prependPath(value: String) -> PyBaseException? {
    return Py.sys.prependPath(value: value)
  }

  // MARK: - Helpers - add __main__

  /// Type of the `__loader__` to set on `__main__`module.
  internal enum MainLoader {
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
  internal enum Existing__main__ModulePolicy {
    case use
    case replace
  }

  private var __main__ModuleName: PyString {
    return Py.intern(string: "__main__")
  }

  /// static _PyInitError
  /// add_main_module(PyInterpreterState *interp)
  internal func add__main__Module(
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
    let dict = Py.get__dict__(module: module)

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
