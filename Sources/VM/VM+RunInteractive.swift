import Foundation
import FileSystem
import VioletCore
import VioletObjects

// In CPython:
// Python -> main.c

extension VM {

  // MARK: - Interactive without args

  internal func prepareForInteractiveWithoutArgs() -> PyResult {
    // From 'https://docs.python.org/3.7/using/cmdline.html'
    // If no interface option is given:
    // - -i is implied
    // - sys.argv[0] is an empty string ("")
    // - current directory will be added to the start of sys.path.

    let emptyPath = Path(string: "")
    if let e = self.setArgv0(emptyPath) {
      return .error(e)
    }

    let cwd = self.fileSystem.currentWorkingDirectory
    if let e = self.prependPath(cwd) {
      return .error(e)
    }

    if let e = self.addExitAndQuitToBuiltins() {
      return .error(e)
    }

    if let e = self.sayHi() {
      return .error(e)
    }

    return .none(self.py)
  }

  // Normally this would be in 'site.py', but we do not have this module.
  private func addExitAndQuitToBuiltins() -> PyBaseException? {
    let exitFn: PyObject
    switch self.py.sys.getExit() {
    case let .value(f): exitFn = f
    case let .error(e): return e
    }

    let builtins = self.py.builtinsModule
    let builtinsDict = self.py.get__dict__(module: builtins)

    let exit = self.py.newString("exit")
    switch builtinsDict.set(self.py, key: exit, value: exitFn) {
    case .ok: break
    case let .error(e): return e
    }

    let quit = self.py.newString("quit")
    switch builtinsDict.set(self.py, key: quit, value: exitFn) {
    case .ok: break
    case let .error(e): return e
    }

    return nil
  }

  private func sayHi() -> PyBaseException? {
    let hi = """
    Please note that interactive mode is not a priority in Violet development
    and some things may not be working. This includes:
    - arrow keys - we are reading raw <stdin>, so they will be interpreted
      as characters.
    - Xcode autocompletion - if Xcode automatically adds closing brace then
      you still have to type it manually.

    Use 'exit()' or 'quit()' to exit.

    \(Sys.version)

    """

    switch self.writeToStdout(hi) {
    case .ok:
      return nil
    case .streamIsNone:
      // Assuming that user requested no printing.
      return nil
    case .error(let e):
      return e
    }
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
  internal func runRepl() -> PyBaseException {
    while true {
      let code: PyCode
      switch self.readStdinForNextInteractiveInput() {
      case .code(let c):
        code = c
      case .syntaxError(let e):
        switch self.writeToStderr(error: e) {
        case .ok,
             .streamIsNone: continue
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

      let mainDict = self.py.get__dict__(module: main)
      switch self.eval(code: code, globals: mainDict, locals: mainDict) {
      case .value:
        // We are not responsible for printing value, 'printExpr' instruction is
        // (see: PEP-217 for details).
        if let e = self.flushStdout() {
          return e
        }

      case .error(let e):
        if self.py.cast.isSystemExit(e.asObject) {
          return e
        }

        // Line resulted in an error!
        // But that does not mean that we should stop REPL!
        // Just print this error and wait for next input.
        switch self.writeToStderr(error: e) {
        case .ok,
             .streamIsNone: break
        case .error(let e): return e
        }
      }
    }
  }

  // MARK: - Interactive input

  private enum InteractiveInput {
    case code(PyCode)
    case syntaxError(PyBaseException)
    case error(PyBaseException)
  }

// swiftlint:disable function_body_length

  /// static int
  /// PyRun_InteractiveOneObjectEx(FILE *fp, PyObject *filename, ...)
  private func readStdinForNextInteractiveInput() -> InteractiveInput {
// swiftlint:enable function_body_length

    let stdin: PyTextFile
    switch self.py.sys.getStdin() {
    case let .value(f): stdin = f
    case let .error(e): return .error(e)
    }

    let ps1 = self.getInteractivePrompt(type: .ps1)
    let ps2 = self.getInteractivePrompt(type: .ps2)

    var input = ""
    var isFirstLine = true

    while true {
      defer { isFirstLine = false }

      switch self.writeToStdout(isFirstLine ? ps1 : ps2) {
      case .ok,
           .streamIsNone: break
      case .error(let e): return .error(e)
      }

      // This has an interesting interaction with autocompletion in XCode
      // integrated terminal:
      // 1. We type: 'print("abc'
      // 2. XCode auto-completes it to: 'print("abc")'
      // 3. Violet will never get the '")' part and fail to compile
      let line: String
      switch stdin.readLine(self.py) {
      case let .value(s): line = s
      case let .error(e): return .error(e)
      }

      input.append(line)
      if !line.hasSuffix("\n") {
        input.append("\n")
      }

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
          break // We want continue our loop!
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

  // MARK: - Prompt

  private enum PromptType {
    case ps1
    case ps2
  }

  private var defaultInteractivePrompt: String {
    return ""
  }

  /// String that should be printed in interactive mode.
  private func getInteractivePrompt(type: PromptType) -> String {
    let objectResult: PyResult
    switch type {
    case .ps1: objectResult = self.py.sys.getPS1()
    case .ps2: objectResult = self.py.sys.getPS2()
    }

    let object: PyObject
    switch objectResult {
    case .value(let o): object = o
    case .error: return self.defaultInteractivePrompt
    }

    switch self.py.strString(object) {
    case .value(let s): return s
    case .error: return self.defaultInteractivePrompt
    }
  }

  // MARK: - Compile

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
    let optimize = self.py.sys.flags.optimize
    switch self.delegate.compileImpl(self.py,
                                     source: input,
                                     filename: "<stdin>",
                                     mode: .interactive,
                                     optimize: optimize) {
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

    // Warning -> Error
    // Also, no special cases for compiler errors
    case let .lexerWarning(_, e),
         let .parserWarning(_, e),
         let .compilerWarning(_, e),
         let .compilerError(_, e):
      return .syntaxError(e)

    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - Flush

  private func flushStdout() -> PyBaseException? {
    switch self.py.sys.getStdoutOrNone() {
    case .value(let stdout):
      return stdout.flush(self.py)
    case .none:
      // Assuming that user requested no printing
      return nil
    case .error(let e):
      return e
    }
  }
}
