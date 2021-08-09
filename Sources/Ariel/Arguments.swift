import ArgumentParser

// swiftlint:disable let_var_whitespace

struct Arguments: ParsableCommand {

  static var configuration = CommandConfiguration(
    abstract: "Tool to dump module interface " +
      "(all of the 'public' and 'open' declarations).",
    version: "1.0.0"
  )

  // MARK: - Verbose

  @Flag(
    name: .long,
    help: ArgumentHelp(
      "Print additional messages.",
      shouldDisplay: true
    )
  )
  var verbose = false

  // MARK: - Min access level

  @Option(
    name: .customLong("min-access-level"),
    help: ArgumentHelp(
      "Minimum access level needed for the declaration to be visible in the output. " +
        "Note that the declaration may be visible anyway, if one of the nested " +
        "declarations is visible.",
      valueName: "access-level",
      shouldDisplay: true
    )
  )
  var minAccessLevel = AccessModifier.public

  // MARK: - Output path

  @Option(
    name: .customLong("output-path"),
    help: ArgumentHelp(
      "Path at which the generated file will be written (default: standard output). " +
        "If the value represents a path to a file then the output will be written " +
        "to this file. If the value represents a directory then new file will be " +
        "created in this directory (name of the file depends on the input name).",
      valueName: "path",
      shouldDisplay: true
    )
  )
  var outputPath: String?

  // MARK: - Input path

  @Argument(
    help: ArgumentHelp(
      "Path to Swift file or directory that contains such files (recursive).",
      shouldDisplay: true
    )
  )
  var inputPath: String
}
