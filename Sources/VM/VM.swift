import Foundation
import Lexer
import Parser
import Compiler
import Bytecode
import Objects

// swiftlint:disable:next type_name
public class VM {

  internal let coreConfiguration: CoreConfiguration

  internal var arguments: Arguments {
    return self.coreConfiguration.arguments
  }

  public init(arguments: Arguments,
              environment: Environment = Environment()) {
    self.coreConfiguration = CoreConfiguration(arguments: arguments,
                                               environment: environment)
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

    if runRepl || self.coreConfiguration.inspectInteractively {
      try self.runRepl()
    }
  }

  private func runCommand(_ command: String) throws {
    let module = self.addModule("__main__")
    let dict = self.getDict(module)

    let code = try self.compile(source: command, mode: .fileInput)
    self.run(code: code, globals: dict, locals: dict)
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

    let module = self.addModule("__main__")
    let dict = self.getDict(module)
    self.setItemString(dict: dict, key: "__file__", value: self.newString(file))

    let source = try String(contentsOf: fileUrl, encoding: .utf8)
    let code = try self.compile(source: source, mode: .fileInput)

    self.run(code: code, globals: dict, locals: dict)
    self.delItemString(dict: dict, key: "__file__")
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
      let module = self.addModule("__main__")
      let dict = self.getDict(module)
      let code = try self.compile(source: input, mode: .interactive)
      self.run(code: code, globals: dict, locals: dict)
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

  // TODO: Use the same optimization enum in VM and in compiler
  private var compilerOptions: CompilerOptions {
    let optimizationLevel: UInt8 = {
      switch self.coreConfiguration.optimization {
      case .none: return 0
      case .O: return 1
      case .OO: return 2
      }
    }()

    return CompilerOptions(optimizationLevel: optimizationLevel)
  }

  private func compile(source: String, mode: ParserMode) throws -> CodeObject {
    let lexer = Lexer(for: source)
    var parser = Parser(mode: mode, tokenSource: lexer)
    let ast = try parser.parse()

    let compiler = try Compiler(ast: ast, options: self.compilerOptions)
    return try compiler.run()
  }

  // MARK: - Eval

  private func run(code: CodeObject, globals: PyObject, locals: PyObject) { }

  // MARK: - Unimplemented

  internal func unimplemented(_ message: String = "") -> Never {
    fatalError(message)
  }
}
