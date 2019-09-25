import Compiler

internal class Scope { }

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

  public func run() {
    if self.arguments.printHelp {
      print(self.arguments.getUsage())
      return
    }

    if self.arguments.printVersion {
      print("Python \(Constants.pythonVersion)")
      return
    }

//    if let command = self.arguments.command {
//// pymain->status = pymain_run_command(pymain->command, &cf);
//    } else if let module = self.arguments.module {
//// pymain->status = (pymain_run_module(pymain->module, 1) != 0);
//    } else if let script = self.arguments.script {
//// pymain_run_filename(pymain, &cf);
//    } else {
//    }

// pymain_repl(pymain, &cf);
  }

  private func runString(file: String, code: String) {
//    let code_obj = vm
//      .compile(source, compile::Mode::Exec, source_path.clone())
//      .map_err(|err| vm.new_syntax_error(&err))?;
//    // trace!("Code object: {:?}", code_obj.borrow());
//    scope
//      .globals
//      .set_item("__file__", vm.new_str(source_path), vm)?;
//    vm.run_code_obj(code_obj, scope)
  }

  private func runCommand(_ command: String) {
  }

  private func runModule(_ module: String) {
  }

  private func runScript(_ code: String) {
  }
}
