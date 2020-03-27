import Lexer
import Parser
import Foundation
import Objects
import Core

extension VM {

  // MARK: - Run

  /// static void
  /// pymain_run_python(_PyMain *pymain)
  ///
  /// This method was not intended to be called multiple times,
  /// but it is not like we can stop you.
  public func run() throws {
    if self.arguments.help {
      print(self.arguments.helpMessage)
      return
    }

    if self.arguments.version {
      print("Python \(Py.sys.version)")
      return
    }

    // Oh no... we will be running code! Let's prepare for this.
    // (For some reason importing stuff seems to be important in programming...)
    let importlib = try self.initImportlibIfNeeded()
    _ = try self.initImportlibExternalIfNeeded(importlib: importlib)

    var runRepl = false

    if let command = self.arguments.command {
      try self.runCommand(command)
    } else if let module = self.arguments.module {
      try self.runModule(module)
    } else if let script = self.arguments.script {
      try self.runScript(script)
    } else {
      runRepl = true
    }

    if runRepl || self.configuration.inspectInteractively {
      try self.runRepl()
    }
  }

  // MARK: - Run command

  private func runCommand(_ command: String) throws {
//    let module = self.builtins.newModule(name: "__main__")
//    let moduleDict = self.builtins.getDict(module)
//    let code = try self.compile(filename: "<stdin>", source: command, mode: .fileInput)
//    self.run(code: code, globals: moduleDict, locals: moduleDict)
  }

  // MARK: - Run module

  private func runModule(_ module: String) throws {
//    let runpy = self.importModule("runpy")

//    switch self.builtins.getAttribute(runpy, name: "_run_module_as_main") {
//    case let .value(runModule):
//      let args = self.builtins.newString(module)
//      switch self.builtins.call(callable: runModule, args: args, kwargs: nil) {
//      case .value: break
//      case .error(let e): fatalError()
//      }
//    case let .error(e):
//      fatalError()
//    }
  }

  // MARK: - Run script

  /// static void
  /// pymain_run_filename(_PyMain *pymain, PyCompilerFlags *cf)
  private func runScript(_ file: String) throws {
    // We don't support 'PYTHONSTARTUP'!

    let url = try self.getScriptURL(file)
    let source = try self.read(url: url, onError: VMError.scriptIsNotReadable)
    let code = try self.compile(filename: url.lastPathComponent,
                                source: source,
                                mode: .fileInput)

    // TODO: This or RustPython main.rs -> line 410:
    // let sys_path = vm.get_attribute(sys_module, "path")
    // vm.call_method(&sys_path, "insert", vec![vm.new_int(0), vm.new_str(dir)])?;

    let main = self.add__main__Module()
    let mainDict = main.getDict()
    mainDict.set(id: .__file__, to: Py.getInterned(file))

    _ = self.eval(code: code, globals: mainDict, locals: mainDict)
    _ = mainDict.del(id: .__file__)
  }

  private func add__main__Module() -> PyModule {
    let name = Py.getInterned("__main__")
    let module = Py.newModule(name: name)

    switch Py.sys.addModule(name: name, module: module) {
    case .value:
      return module
    case .error(let e):
      trap("Unable to add '__main__' module: \(e)")
    }
  }

  private func getScriptURL(_ file: String) throws -> URL {
    var isDir = false
    guard self.fileSystem.exists(path: file, isDirectory: &isDir) else {
      throw VMError.scriptDoesNotExist(path: file)
    }

    let fileUrl = URL(fileURLWithPath: file, isDirectory: isDir)

    // If it is just a file then return this URL,
    // otherwise try '__main_._py' inside this dir.
    guard isDir else {
      return fileUrl
    }

    let mainFileUrl = fileUrl.appendingPathComponent("__main__.py")
    guard self.fileSystem.exists(path: mainFileUrl.path, isDirectory: &isDir),
          !isDir else {
      throw VMError.scriptDirDoesNotContain__main__(dir: file)
    }

    return mainFileUrl
  }

  // MARK: - Run REPL

  private func runRepl() throws {
//    var input = ""
//    var isContinuing = false
//
//    while true {
//      let prompt = isContinuing ? self.sys.ps2String : self.sys.ps1String
//      print(prompt, terminator: "")
//
//      switch readLine() {
//      case let .some(line):
//        let stopContinuing = line.isEmpty
//
//        if input.isEmpty {
//          input = line
//        } else {
//          input.append(line)
//        }
//        input.append("\n")
//
//        if isContinuing {
//          if stopContinuing {
//            isContinuing = false
//          } else {
//            continue
//          }
//        }
//
//        switch self.runInteractive(input: input) {
//        case .ok:
//          input = ""
//        case .notFinished:
//          isContinuing = true
//        case let .error(e):
//          throw e
//        }
//
//      case .none:
//        return
//      }
//    }
  }

//  private enum RunInteractiveResult {
//    case ok
//    case notFinished
//    case error(Error)
//  }
//
//  private func runInteractive(input: String) -> RunInteractiveResult {
//    do {
//      let code = try self.compile(filename: "<stdin>", source: input, mode: .interactive)
//
//      let module = self.builtins.newModule(name: "__main__")
//      let moduleDict = self.builtins.getDict(module)
//
//      self.run(code: code, globals: moduleDict, locals: moduleDict)
//      return .ok
//    } catch let error as LexerError {
//      switch error.kind {
//      case .eof, .unfinishedLongString: return .notFinished
//      default: return .error(error)
//      }
//    } catch let error as ParserError {
//      switch error.kind {
//      case .unexpectedEOF: return .notFinished
//      default: return .error(error)
//      }
//    } catch {
//      return .error(error)
//    }
//  }
}
