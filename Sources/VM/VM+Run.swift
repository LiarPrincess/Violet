import Foundation
import FileSystem
import VioletCore
import VioletObjects

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
    let arguments = self.py.config.arguments

    if arguments.help {
      // (Help!) I need somebody
      // (Help!) Not just anybody
      let helpMessage = Arguments.helpMessage()
      return self.writeToStdoutAndFinish(helpMessage)
    }

    if arguments.version {
      return self.writeToStdoutAndFinish(Sys.version)
    }

    // Oh no… we will be running code! Let's prepare for this.
    if let e = self.registerSignalHandlers() {
      return .error(e.asBaseException)
    }

    // For some reason importing stuff seems to be important* in programming…
    // * - intended (sorry!)
    if let e = self.initImportlibIfNeeded() {
      return .error(e)
    }

    var runRepl = self.py.sys.flags.inspect
    var result: PyResult

    if let command = arguments.command {
      result = self.run(command: command)
    } else if let module = arguments.module {
      result = self.run(modulePath: module)
    } else if let script = arguments.script {
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

  private func writeToStdoutAndFinish(_ string: String) -> RunResult {
    switch self.writeToStdout(string) {
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
    // There is a long comment about this in documentation for 'Objects' module.
    //
    // Btw. both 'initImportlibIfNeeded' and 'initImportlibExternalIfNeeded'
    // are idempotent, so we can call them as many times as we want.
    // Unless you do something like 'sys.modules['importlib'] = "let it go"',
    // in such case we will reinitialize the whole thing.

    let importlib: PyModule
    switch self.py.initImportlibIfNeeded() {
    case let .value(m): importlib = m
    case let .error(e): return e
    }

    switch self.py.initImportlibExternalIfNeeded(importlib: importlib) {
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
    let errorObject = error.asObject

    guard self.py.cast.isSystemExit(errorObject) else {
      return .error(error)
    }

    let code = self.py.intern(string: "code")
    switch self.py.getAttribute(object: errorObject, name: code) {
    case let .value(object):
      return .systemExit(object)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Helpers - eval

  internal func eval(code: PyCode, globals: PyDict, locals: PyDict) -> PyResult {
    return self.delegate.eval(self.py, code: code, globals: globals, locals: locals)
  }

  // MARK: - Helpers - Stream write

  internal enum WriteToStreamResult {
    case ok
    case streamIsNone
    case error(PyBaseException)

    fileprivate init(_ error: PyBaseException?) {
      switch error {
      case .some(let e): self = .error(e)
      case .none: self = .ok
      }
    }
  }

  internal func writeToStdout(_ object: PyObject) -> WriteToStreamResult {
    switch self.py.sys.getStdoutOrNone() {
    case .value(let file):
      let result = file.write(self.py, object: object)
      return WriteToStreamResult(result)
    case .none:
      return .streamIsNone
    case .error(let e):
      return .error(e)
    }
  }

  internal func writeToStdout(_ string: String) -> WriteToStreamResult {
    switch self.py.sys.getStdoutOrNone() {
    case .value(let file):
      let result = file.write(self.py, string: string)
      return WriteToStreamResult(result)
    case .none:
      return .streamIsNone
    case .error(let e):
      return .error(e)
    }
  }

  internal func writeToStderr(error: PyBaseException) -> WriteToStreamResult {
    switch self.py.sys.getStderrOrNone() {
    case .value(let file):
      self.py.printRecursiveIgnoringErrors(file: file, error: error)
      return .ok
    case .none:
      return .streamIsNone
    case .error(let e):
      return .error(e)
    }
  }

  // MARK: - Helpers - Set argv0

  /// Set given value as `sys.argv[0]`.
  internal func setArgv0(_ value: Path) -> PyBaseException? {
    return self.py.sys.setArgv0(value)
  }

  // MARK: - Helpers - Prepend path

  /// Prepend given value to `sys.path`.
  internal func prependPath(_ value: Path) -> PyBaseException? {
    return self.py.sys.prependPath(value)
  }

  // MARK: - Helpers - Add __main__

  /// Type of the `__loader__` to set on `__main__`module.
  internal struct MainLoader {

    /// Will use `Importlib.BuiltinImporter` as `__loader__`.
    /// Use this it you have input from `<stdin>` (repl etc.).
    internal static let builtinImporter = MainLoader(name: "BuiltinImporter",
                                                     module: "importlib")
    /// Will use `ImportlibExternal.SourceFileLoader` as `__loader__`.
    /// Use this if the code comes from `.py` file.
    internal static let sourceFileLoader = MainLoader(name: "SourceFileLoader",
                                                      module: "importlib_external")
    /// Will use `ImportlibExternal.SourcelessFileLoader` as `__loader__`.
    /// Use this if the code comes from Violet equivalent of `.pyc` file.
    internal static let sourcelessFileLoader = MainLoader(name: "SourcelessFileLoader",
                                                          module: "importlib_external")

    /// Attribute on `self.module` that contains this loader.
    fileprivate let name: String
    /// Name of the module that contains this loader.
    fileprivate let module: String

    // We don't want 'init' to be visible outside of this type.
    private init(name: String, module: String) {
      self.name = name
      self.module = module
    }
  }

  // swiftlint:disable:next type_name
  internal enum Existing__main__ModulePolicy {
    case use
    case replace
  }

  private var __main__ModuleName: String {
    return "__main__"
  }

  /// static _PyInitError
  /// add_main_module(PyInterpreterState *interp)
  internal func add__main__Module(
    loader: MainLoader,
    ifAlreadyExists existsPolicy: Existing__main__ModulePolicy
  ) -> PyResultGen<PyModule> {
    switch self.handleExisting__main__Module(policy: existsPolicy) {
    case .value(let m):
      return .value(m)
    case .notFound:
      break
    case .error(let e):
      return .error(e)
    }

    let name = self.__main__ModuleName
    let module = self.py.newModule(name: name, doc: nil, dict: nil)
    let dict = self.py.get__dict__(module: module)

    if dict.get(self.py, id: .__annotations__) == nil {
      let annotations = self.py.newDict()
      dict.set(self.py, id: .__annotations__, value: annotations.asObject)
    }

    if dict.get(self.py, id: .__builtins__) == nil {
      let builtins = self.py.builtinsModule
      dict.set(self.py, id: .__builtins__, value: builtins.asObject)
    }

    if dict.get(self.py, id: .__loader__) == nil {
      switch self.getLoader(type: loader) {
      case let .value(value):
        dict.set(self.py, id: .__loader__, value: value)
      case let .error(e):
        return .error(e)
      }
    }

    if let e = self.py.sys.addModule(module: module) {
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
    let name = self.py.intern(string: self.__main__ModuleName)

    switch policy {
    case .use:
      switch self.py.sys.getModule(name: name) {
      case .module(let m):
        return .value(m)

      case .notModule(let o):
        let message = "Tried to reuse existing '__main__' module, " +
          "but 'sys.modules' contains \(o.typeName) instead of module"
        let error = self.py.newRuntimeError(message: message)
        return .error(error.asBaseException)

      case .notFound:
        return .notFound
      case .error(let e):
        return .error(e)
      }

    case .replace:
      return .notFound
    }
  }

  private func getLoader(type: MainLoader) -> PyResult {
    let module: PyObject
    let moduleName = self.py.intern(string: type.module)

    switch self.py.sys.getModule(name: moduleName) {
    case let .module(m):
      module = m.asObject
    case .notModule(let o):
      // This is an interesting case,
      // but we will trust that import knows its stuff.
      module = o
    case let .notFound(e),
         let .error(e):
      return .error(e)
    }

    let attribute = type.name
    return self.py.getAttribute(object: module, name: attribute)
  }
}
