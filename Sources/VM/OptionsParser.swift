import Foundation
import SPMUtility
import Core

// In CPython:
// Modules -> main.c

// swiftlint:disable trailing_closure

public class OptionsParser {

  private let parser = ArgumentParser(
    commandName: "Violet",
    usage:    "[-options] [-c command | -m module-name | script | - ]",
    overview: "I will run as fast as I can to wherever my customer desires. " +
              "I am the Auto Memories Doll, Violet Evergarden.",
    seeAlso: nil
  )

  private let binder = ArgumentBinder<Options>()

  // swiftlint:disable:next function_body_length
  public init() {
    self.addFlag(
      option: "--version",
      shortName: "-v",
      usage: "print the Python version number and exit (also --version)",
      to: { $0.version = $1 }
    )

    self.addFlag(
      option: "-d",
      usage: "print debugging output",
      to: { $0.debug = $1 }
    )

    self.addFlag(
      option: "-i",
      usage: "inspect interactively after running script; forces a prompt even" +
      "if stdin does not appear to be a terminal",
      to: { $0.enterInteractiveAfterExecuting = $1 }
    )

    self.addArgument(
      option: "-q",
      kind: Bool.self,
      usage: "don't print version and copyright messages on interactive startup",
      to: { $0.quiet = $1 }
    )

    // MARK: Byte compare

    self.addFlag(
      option: "-b",
      usage: "issue warnings about str(bytes_instance), str(bytearray_instance)" +
             "and comparing bytes/bytearray with str.",
      to: { opt, _ in
        opt.byteCompare = (opt.byteCompare != .error ? .warning : .error)
      }
    )

    self.addFlag(
      option: "-bb",
      usage: "issue error about str(bytes_instance), str(bytearray_instance)" +
             "and comparing bytes/bytearray with str (overrides '-b' is also set).",
      to: { opt, _ in opt.byteCompare = .error }
    )

    // MARK: Optimization levels

    self.addFlag(
      option: "-O",
      usage: "remove assert and __debug__-dependent statements",
      to: { opt, _ in
        opt.optimization = (opt.optimization != .OO ? .O : .OO)
      }
    )

    self.addFlag(
      option: "-OO",
      usage: "do -O changes and also discard docstrings (overrides '-O' is also set)",
      to: { opt, _ in opt.optimization = .OO }
    )

    // MARK: Warnings

    self.addArgument(
      option: "-W",
      kind: WarningOptions.self,
      usage: "warning control; arg is ignore:print:error",
      to: { $0.warnings = $1 }
    )

    // MARK: Command, module, script

    self.addArgument(
      option: "-c",
      kind: String.self,
      usage: "program passed in as string (terminates option list)",
      to: { $0.command = $1 }
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
    to body: @escaping (inout Options, Bool) throws -> Void) {

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
    to body: @escaping (inout Options, T) throws -> Void) {
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
    to body: @escaping (inout Options, T) throws -> Void) {

    let argument = self.parser.add(positional: positional,
                                   kind: kind,
                                   optional: optional,
                                   usage: usage,
                                   completion: completion)
    self.binder.bind(positional: argument, to: body)
  }

  // MARK: - Parse

  public func parse(arguments: [String]) throws -> Options {
    var options = Options()

    // In SPMUtility '-h -help --help' exit(0) at the end.
    let hasHelp = arguments.contains { $0 == "-h" || $0 == "-help" || $0 == "--help" }
    if hasHelp {
      options.help = true
      return options
    }

    let result = try parser.parse(arguments)
    try binder.fill(parseResult: result, into: &options)
    return options
  }
}
