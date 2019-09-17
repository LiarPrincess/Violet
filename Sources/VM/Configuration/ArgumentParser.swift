import Foundation
import SPMUtility
import Basic // from SPM
import Core

// In CPython:
// Modules -> main.c
//  pymain_wstrlist_append(_PyMain *pymain, int *len, wchar_t ***list, ...)

// swiftlint:disable trailing_closure

internal class ArgumentParser {

  private let parser = SPMUtility.ArgumentParser(
    commandName: Constants.violet,
    usage:    "[-options] [-c command | -m module-name | script | - ]",
    overview: "I will run as fast as I can to wherever my customer desires. " +
              "I am the Auto Memories Doll, Violet Evergarden.",
    seeAlso: nil
  )

  private let binder = ArgumentBinder<Arguments>()

  // swiftlint:disable:next function_body_length
  internal init() {
    self.addFlag(
      option: "--version",
      shortName: "-v",
      usage: "print the Violet version number and exit (also --version)",
      to: { $0.printVersion = $1 }
    )

    self.addFlag(
      option: "-d",
      usage: "debug output messages; also PYTHONDEBUG=x",
      to: { $0.debug = $1 }
    )

    self.addFlag(
      option: "-q",
      usage: "don't print version and copyright messages on interactive startup",
      to: { $0.quiet = $1 }
    )

    self.addFlag(
      option: "-i",
      usage: "inspect interactively after running script; forces a prompt even " +
             "if stdin does not appear to be a terminal; also PYTHONINSPECT=x",
      to: { $0.inspectInteractively = $1 }
    )

    // MARK: Isolate

    self.addFlag(
      option: "-E",
      usage: "ignore PYTHON* environment variables (such as PYTHONPATH)",
      to: { $0.ignoreEnvironment = $1 }
    )

    self.addFlag(
      option: "-I",
      usage: "isolate Violet from the user's environment (implies -E)",
      to: {
        $0.isolated = $1
        $0.ignoreEnvironment = $0.ignoreEnvironment || $1
        $0.noUserSite = $0.noUserSite || $1
      }
    )

    self.addFlag(
      option: "-S",
      usage: "don't imply 'import site' on initialization",
      to: { $0.noSite = $1 }
    )

    self.addFlag(
      option: "-s",
      usage: "don't add user site directory to sys.path; also PYTHONNOUSERSITE",
      to: { $0.noUserSite = $1 }
    )

    // MARK: Byte compare

    self.addFlag(
      option: "-b",
      usage: "issue warnings about str(bytes_instance), str(bytearray_instance)" +
             "and comparing bytes/bytearray with str.",
      to: { opt, _ in
        opt.bytesWarning = (opt.bytesWarning != .error ? .warning : .error)
      }
    )

    self.addFlag(
      option: "-bb",
      usage: "issue error about str(bytes_instance), str(bytearray_instance)" +
             "and comparing bytes/bytearray with str " +
             "(overrides '-b' if it is also set).",
      to: { opt, _ in opt.bytesWarning = .error }
    )

    // MARK: Optimization levels

    self.addFlag(
      option: "-O",
      usage: "remove assert and __debug__-dependent statements; also PYTHONOPTIMIZE=x",
      to: { opt, _ in
        opt.optimization = (opt.optimization != .OO ? .O : .OO)
      }
    )

    self.addFlag(
      option: "-OO",
      usage: "do -O changes and also discard docstrings " +
             "(overrides '-O' if it is also set)",
      to: { opt, _ in opt.optimization = .OO }
    )

    // MARK: Warnings

    self.addFlag(
      option: "-Wdefault",
      usage: "warning control; warn once per call location; also PYTHONWARNINGS=arg",
      to: { opt, _ in opt.warnings.append(.default) }
    )

    self.addFlag(
      option: "-Werror",
      usage: "warning control; convert to exceptions; also PYTHONWARNINGS=arg",
      to: { opt, _ in opt.warnings.append(.error) }
    )

    self.addFlag(
      option: "-Walways",
      usage: "warning control; warn every time; also PYTHONWARNINGS=arg",
      to: { opt, _ in opt.warnings.append(.always) }
    )

    self.addFlag(
      option: "-Wmodule",
      usage: "warning control; warn once per calling module; also PYTHONWARNINGS=arg",
      to: { opt, _ in opt.warnings.append(.module) }
    )

    self.addFlag(
      option: "-Wonce",
      usage: "warning control; warn once per Python process; also PYTHONWARNINGS=arg",
      to: { opt, _ in opt.warnings.append(.once) }
    )

    self.addFlag(
      option: "-Wignore",
      usage: "warning control; never warn; also PYTHONWARNINGS=arg",
      to: { opt, _ in opt.warnings.append(.ignore) }
    )

    // MARK: Command, module, script

    // We need to add '\n' just as in
    // pymain_parse_cmdline_impl(_PyMain *pymain, _PyCoreConfig *config, ...)
    self.addArgument(
      option: "-c",
      kind: String.self,
      usage: "program passed in as string (terminates option list)",
      to: { $0.command = $1 + "\n" }
    )

    self.addArgument(
      option: "-m",
      kind: String.self,
      usage: "run library module as a script (terminates option list)",
      to: { $0.module = $1 }
    )

    self.addArgument(
      positional: "script",
      kind: String.self,
      optional: true,
      usage: "execute the code contained in script (terminates option list)",
      completion: .filename,
      to: { $0.script = $1 }
    )
  }

  // MARK: - Helpers

  /// Adds an optional true/false argument to the parser.
  private func addFlag(
    option: String,
    shortName: String? = nil,
    usage: String? = nil,
    completion: ShellCompletion? = nil,
    to body: @escaping (inout Arguments, Bool) throws -> Void) {

    // From SPMUtility:
    //   As a special case, Bool options don't consume arguments.
    //   if kind == Bool.self && strategy == .oneByOne {
    //     return [true]
    //   }

    self.addArgument(option: option,
                     shortName: shortName,
                     kind: Bool.self,
                     usage: usage,
                     completion: completion,
                     to: body)
  }

  // swiftlint:disable function_default_parameter_at_end
  /// Adds an option to the parser.
  private func addArgument<T: ArgumentKind>(
    option: String,
    shortName: String? = nil,
    kind: T.Type,
    usage: String? = nil,
    completion: ShellCompletion? = nil,
    to body: @escaping (inout Arguments, T) throws -> Void) {
    // swiftlint:enable function_default_parameter_at_end

    let argument = self.parser.add(option: option,
                                   shortName: shortName,
                                   kind: kind,
                                   usage: usage,
                                   completion: completion)
    self.binder.bind(option: argument, to: body)
  }

  /// Adds an argument to the parser.
  ///
  /// Note: Only one positional argument is allowed if optional setting is enabled.
  private func addArgument<T: ArgumentKind>(
    positional: String,
    kind: T.Type,
    optional: Bool = false,
    usage: String? = nil,
    completion: ShellCompletion? = nil,
    to body: @escaping (inout Arguments, T) throws -> Void) {

    let argument = self.parser.add(positional: positional,
                                   kind: kind,
                                   optional: optional,
                                   usage: usage,
                                   completion: completion)
    self.binder.bind(positional: argument, to: body)
  }

  // MARK: - Parse

  internal func parse(arguments: [String]) throws -> Arguments {
    var result = Arguments()
    result.raw = arguments

    // In SPMUtility '-h -help --help' has exit(0) at the end.
    let hasHelp = arguments.contains { $0 == "-h" || $0 == "-help" || $0 == "--help" }
    if hasHelp {
      result.printHelp = true
      return result
    }

    let argumentsWithoutName = Array(arguments.dropFirst())
    let parseResult = try parser.parse(argumentsWithoutName)
    try binder.fill(parseResult: parseResult, into: &result)
    return result
  }

  // MARK: - Usage

  internal func getUsage() -> String {
    let stream = BufferedOutputByteStream()
    self.parser.printUsage(on: stream)
    return String(describing: stream.bytes)
  }
}
