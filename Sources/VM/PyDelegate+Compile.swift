import Foundation
import BigInt
import VioletCore
import VioletLexer
import VioletParser
import VioletCompiler
import VioletObjects

extension PyDelegate {

  internal func compile(_ py: Py,
                        source: String,
                        filename: String,
                        mode: Py.ParserMode,
                        optimize: Py.OptimizationLevel) -> PyResultGen<PyCode> {
    let result = self.compileImpl(py,
                                  source: source,
                                  filename: filename,
                                  mode: mode,
                                  optimize: optimize)

    switch result {
    case let .code(c):
      return .value(c)
    case let .lexerWarning(_, e),
      let .lexerError(_, e),
      let .parserWarning(_, e),
      let .parserError(_, e),
      let .compilerWarning(_, e),
      let .compilerError(_, e),
      let .error(e):
      return .error(e)
    }
  }

  // MARK: - Impl

  internal enum CompileImplResult {
    /// Code compiled successfully (Yay!)
    case code(PyCode)

    /// Lexer warning that should be treated as error OR error when printing
    case lexerWarning(LexerWarning, PyBaseException)
    /// Lexing failed
    case lexerError(LexerError, PyBaseException)

    /// Parser warning that should be treated as error OR error when printing
    case parserWarning(ParserWarning, PyBaseException)
    /// Parsing failed
    case parserError(ParserError, PyBaseException)

    /// Compiler warning that should be treated as error OR error when printing
    case compilerWarning(CompilerWarning, PyBaseException)
    /// Compiling failed
    case compilerError(CompilerError, PyBaseException)

    /// Non lexer, parser or compiler error
    case error(PyBaseException)
  }

  private class WarningsHandler: LexerDelegate, ParserDelegate, CompilerDelegate {

    fileprivate private(set) var lexerWarnings = [LexerWarning]()
    fileprivate private(set) var parserWarnings = [ParserWarning]()
    fileprivate private(set) var compilerWarnings = [CompilerWarning]()

    fileprivate func warn(warning: LexerWarning) {
      self.lexerWarnings.append(warning)
    }

    fileprivate func warn(warning: ParserWarning) {
      self.parserWarnings.append(warning)
    }

    fileprivate func warn(warning: CompilerWarning) {
      self.compilerWarnings.append(warning)
    }
  }

  // swiftlint:disable:next function_body_length
  internal func compileImpl(_ py: Py,
                            source: String,
                            filename: String,
                            mode: Py.ParserMode,
                            optimize: Py.OptimizationLevel) -> CompileImplResult {
    do {
      let delegate = WarningsHandler()

      // Parser phase
      let parserMode = self.createParserMode(mode)
      let lexer = Lexer(for: source, delegate: delegate)
      let parser = Parser(mode: parserMode,
                          tokenSource: lexer,
                          delegate: delegate,
                          lexerDelegate: delegate)
      let ast = try parser.parse()

      for warning in delegate.lexerWarnings {
        if let e = self.warn(py, filename: filename, warning: warning) {
          return .lexerWarning(warning, e)
        }
      }

      for warning in delegate.parserWarnings {
        if let e = self.warn(py, filename: filename, warning: warning) {
          return .parserWarning(warning, e)
        }
      }

      // Compiler phase
      let compilerOptions = self.createCompilerOptions(py, optimize: optimize)

      let compiler = Compiler(filename: filename,
                              ast: ast,
                              options: compilerOptions,
                              delegate: delegate)
      let code = try compiler.run()

      for warning in delegate.compilerWarnings {
        if let e = self.warn(py, filename: filename, warning: warning) {
          return .compilerWarning(warning, e)
        }
      }

      let result = py.newCode(code: code)
      return .code(result)
    } catch let e as LexerError {
      let syntaxError = self.newSyntaxError(py, filename: filename, error: e)
      return .lexerError(e, syntaxError.asBaseException)
    } catch let e as ParserError {
      let syntaxError = self.newSyntaxError(py, filename: filename, error: e)
      return .parserError(e, syntaxError.asBaseException)
    } catch let e as CompilerError {
      let syntaxError = self.newSyntaxError(py, filename: filename, error: e)
      return .compilerError(e, syntaxError.asBaseException)
    } catch {
      let message = "Error when compiling '\(filename)': '\(error)'"
      let error = py.newRuntimeError(message: message)
      return .error(error.asBaseException)
    }
  }

  private func createParserMode(_ mode: Py.ParserMode) -> Parser.Mode {
    switch mode {
    case .eval: return .eval
    case .fileInput: return .fileInput
    case .interactive: return .interactive
    }
  }

  private func createCompilerOptions(_ py: Py,
                                     optimize: Py.OptimizationLevel) -> Compiler.Options {
    let optimizationLevel: Compiler.OptimizationLevel
    switch optimize {
    case .none: optimizationLevel = .none
    case .O: optimizationLevel = .O
    case .OO: optimizationLevel = .OO
    }

    return Compiler.Options(optimizationLevel: optimizationLevel)
  }

  // MARK: - Errors

  private func newSyntaxError(_ py: Py,
                              filename: String,
                              error: LexerError) -> PySyntaxError {
    let message = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = true

    switch error.kind {
    case .tooManyIndentationLevels,
        .noMatchingDedent:
      let error = py.newIndentationError(message: message,
                                         filename: filename,
                                         lineno: lineno,
                                         offset: offset,
                                         text: text,
                                         printFileAndLine: printFileAndLine)
      return PySyntaxError(ptr: error.ptr)

    default:
      return py.newSyntaxError(message: message,
                               filename: filename,
                               lineno: lineno,
                               offset: offset,
                               text: text,
                               printFileAndLine: printFileAndLine)
    }
  }

  private func newSyntaxError(_ py: Py,
                              filename: String,
                              error: ParserError) -> PySyntaxError {
    let message = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = true

    if case let .unexpectedToken(token, expected: expected) = error.kind {
      let gotUnexpectedIndent = token == .indent || token == .dedent
      let missingIndent = expected.contains { $0 == .indent || $0 == .dedent }

      if gotUnexpectedIndent || missingIndent {
        let error = py.newIndentationError(message: message,
                                           filename: filename,
                                           lineno: lineno,
                                           offset: offset,
                                           text: text,
                                           printFileAndLine: printFileAndLine)

        return PySyntaxError(ptr: error.ptr)
      }
    }

    return py.newSyntaxError(message: message,
                             filename: filename,
                             lineno: lineno,
                             offset: offset,
                             text: text,
                             printFileAndLine: printFileAndLine)
  }

  private func newSyntaxError(_ py: Py,
                              filename: String,
                              error: CompilerError) -> PySyntaxError {
    let message = String(describing: error.kind)
    let lineno = BigInt(error.location.line)
    let offset = BigInt(error.location.column)
    let text = String(describing: error)
    let printFileAndLine = true

    return py.newSyntaxError(message: message,
                             filename: filename,
                             lineno: lineno,
                             offset: offset,
                             text: text,
                             printFileAndLine: printFileAndLine)
  }

  // MARK: - Warnings

  private func warn(_ py: Py,
                    filename: String,
                    warning: LexerWarning) -> PyBaseException? {
    let text = String(describing: warning)
    let line = warning.location.line
    let column = warning.location.column
    return py.warnSyntax(filename: filename, line: line, column: column, text: text)
  }

  private func warn(_ py: Py,
                    filename: String,
                    warning: ParserWarning) -> PyBaseException? {
    let text = String(describing: warning)
    let line = warning.location.line
    let column = warning.location.column
    return py.warnSyntax(filename: filename, line: line, column: column, text: text)
  }

  private func warn(_ py: Py,
                    filename: String,
                    warning: CompilerWarning) -> PyBaseException? {
    let text = String(describing: warning)
    let line = warning.location.line
    let column = warning.location.column
    return py.warnSyntax(filename: filename, line: line, column: column, text: text)
  }
}
