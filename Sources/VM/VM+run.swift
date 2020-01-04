import Lexer
import Parser
import Foundation
import Objects

extension VM {

  // MARK: - Run

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

  // MARK: - Run command

  private func runCommand(_ command: String) throws {
    let module = self.builtins.newModule(name: "__main__")
    let moduleDict = self.builtins.getDict(module)
    let code = try self.compile(filename: "<stdin>", source: command, mode: .fileInput)
    self.run(code: code, globals: moduleDict, locals: moduleDict)
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

  // MARK: - Run filename

  private func runFilename(_ file: String) throws {
    // We don't support 'PYTHONSTARTUP'
    var isDir: ObjCBool = false
    guard self.fm.fileExists(atPath: file, isDirectory: &isDir) else {
      fatalError()
//      self.unimplemented("Can't open file '\(file)': No such file or directory")
    }

    var fileUrl = URL(fileURLWithPath: file, isDirectory: isDir.boolValue)
    if isDir.boolValue {
      fileUrl.appendPathComponent("__main__.py")
    }

    // TODO: This or RustPython main.rs -> line 410:
    // let sys_path = vm.get_attribute(sys_module, "path")
    // vm.call_method(&sys_path, "insert", vec![vm.new_int(0), vm.new_str(dir)])?;

    let module = self.builtins.newModule(name: "__main__")
    let moduleDict = self.builtins.getDict(module)
    moduleDict.set(key: "__file__", to: self.builtins.newString(file))

    let filename = fileUrl.lastPathComponent
    let source = try String(contentsOf: fileUrl, encoding: .utf8)
    let code = try self.compile(filename: filename, source: source, mode: .fileInput)

    self.run(code: code, globals: moduleDict, locals: moduleDict)
    moduleDict.del(key: "__file__")
  }

  // MARK: - Run REPL

  private func runRepl() throws {
    var input = ""
    var isContinuing = false

    while true {
      let prompt = isContinuing ? self.sys.ps2String : self.sys.ps1String
      print(prompt, terminator: "")

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
      let code = try self.compile(filename: "<stdin>", source: input, mode: .interactive)

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
}
