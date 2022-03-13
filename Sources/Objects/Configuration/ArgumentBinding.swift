import ArgumentParser

// swiftlint:disable let_var_whitespace
// cSpell:ignore wstrlist

// In CPython:
// Modules -> main.c
//  pymain_wstrlist_append(_PyMain *pymain, int *len, wchar_t ***list, ...)

// Descriptions taken from:
// https://docs.python.org/3.7/using/cmdline.html

// Swift refuses to accept "a" + "b" for 'ExpressibleByStringInterpolation'.
// And we want to honor our 80 columns per line limit.
// Solution: Manually create 'ArgumentHelp' if we have longer string.
private func concat(_ values: String...) -> ArgumentHelp {
  return ArgumentHelp(stringLiteral: values.joined())
}

internal struct ArgumentBinding: ParsableCommand {

  // MARK: - Configuration

  internal static let configuration = CommandConfiguration(
    commandName: Configure.implementation.name,
    abstract: Configure.implementation.abstract,
    discussion: Configure.implementation.discussion,
    // version: XYZ // Nope! This would add an additional '--version' flag.
    //              // We will handle this on our own.
    helpNames: [] // The same goes for 'help', where we have to add '-help'.
  )

  // MARK: - Flags

  /// `-h -help --help`
  ///
  /// Display available options.
  /// Overrides `ArgumentParser` help.
  @Flag(
    name: [
      NameSpecification.Element.short,
      NameSpecification.Element.long,
      NameSpecification.Element.customLong("help", withSingleDash: true)
    ],
    help: "print this help message and exit (also --help)"
  )
  internal var help = false

  /// `-V --version`
  ///
  /// Print the `Violet` version number and exit.
  /// Example output could be: `Violet 1.0`.
  ///
  /// Please note that `-v` is for `verbose`!
  /// Version uses `-V`!
  @Flag(
    name: [
      NameSpecification.Element.customShort("V"),
      NameSpecification.Element.long
    ],
    help: "print the Python version number and exit (also --version)"
  )
  internal var version = false

  /// `-d`
  ///
  ///  Turn on debugging output.
  @Flag(
    name: NameSpecification.short,
    help: "debug output messages; also PYTHONDEBUG=x"
  )
  internal var debug = false

  /// `-q`
  ///
  ///  Don’t display the copyright and version messages even in interactive mode.
  @Flag(
    name: NameSpecification.short,
    help: "don't print version and copyright messages on interactive startup"
  )
  internal var quiet = false

  /// `-i`
  ///
  /// When a script is passed as first argument or the `-c` option is used,
  /// enter interactive mode after executing the script or the command,
  /// even when `sys.stdin` does not appear to be a terminal.
  @Flag(
    name: NameSpecification.short,
    help: concat(
      "inspect interactively after running script; forces a prompt even ",
      "if stdin does not appear to be a terminal; also PYTHONINSPECT=x"
    )
  )
  internal var inspectInteractively = false

  /// `-E`
  ///
  /// Ignore all `PYTHON*` environment variables,
  /// e.g. `PYTHONPATH` and `PYTHONHOME`, that might be set.
   @Flag(
     name: NameSpecification.customShort("E"),
     help: "ignore PYTHON* environment variables (such as PYTHONPATH)"
   )
  internal var ignoreEnvironment = false

  /// `-I`
  ///
  /// Run Python in isolated mode. This also implies `-E` and `-s`.
  /// In isolated mode `sys.path` contains neither the script’s directory
  /// nor the user’s site-packages directory.
  /// All `PYTHON*` environment variables are ignored, too.
  @Flag(
    name: NameSpecification.customShort("I"),
    help: "isolate Violet from the user's environment (implies -E)"
  )
  internal var isolated = false

  /// `-v`
  @Flag(
    name: NameSpecification.short,
    help: concat(
      "Print a message each time a module is initialized, ",
      "showing the place (filename or built-in module) from which it is loaded. ",
      "When given twice (-vv), print a message for each file that is checked ",
      "for when searching for a module. Also provides information on module ",
      "cleanup at exit. See also PYTHONVERBOSE."
    )
  )
  internal var verbose: Int

  // MARK: - Optimization

  /// `-O`
  @Flag(
    name: NameSpecification.customShort("O"),
    help: "remove assert and __debug__-dependent statements; also PYTHONOPTIMIZE=x"
  )
  internal var optimize1 = false // Do not use 'Int'. '-O and -OO' are separate options

  /// `-OO`
  @Flag(
    name: NameSpecification.customLong("OO", withSingleDash: true),
    help: "do -O changes and also discard docstrings (overrides '-O' if it is also set)"
  )
  internal var optimize2 = false // Do not use 'Int'. '-O and -OO' are separate options

  // MARK: - Warnings

  /// Warning control.
  @Flag(
    name: [
      NameSpecification.Element.customLong("Wdefault", withSingleDash: true),
      NameSpecification.Element.customLong("Wd", withSingleDash: true)
    ],
    help: "warning control; warn once per call location; also PYTHONWARNINGS=arg"
  )
  internal var wDefault = false

  /// Warning control.
  @Flag(
    name: [
      NameSpecification.Element.customLong("Werror", withSingleDash: true),
      NameSpecification.Element.customLong("We", withSingleDash: true)
    ],
    help: "warning control; convert to exceptions; also PYTHONWARNINGS=arg"
  )
  internal var wError = false

  /// Warning control.
  @Flag(
    name: [
      NameSpecification.Element.customLong("Walways", withSingleDash: true),
      NameSpecification.Element.customLong("Wa", withSingleDash: true)
    ],
    help: "warning control; warn every time; also PYTHONWARNINGS=arg"
  )
  internal var wAlways = false

  /// Warning control.
  @Flag(
    name: [
      NameSpecification.Element.customLong("Wmodule", withSingleDash: true),
      NameSpecification.Element.customLong("Wm", withSingleDash: true)
    ],
    help: "warning control; warn once per calling module; also PYTHONWARNINGS=arg"
  )
  internal var wModule = false

  /// Warning control.
  @Flag(
    name: [
      NameSpecification.Element.customLong("Wonce", withSingleDash: true),
      NameSpecification.Element.customLong("Wo", withSingleDash: true)
    ],
    help: "warning control; warn once per Python process; also PYTHONWARNINGS=arg"
  )
  internal var wOnce = false

  /// Warning control.
  @Flag(
    name: [
      NameSpecification.Element.customLong("Wignore", withSingleDash: true),
      NameSpecification.Element.customLong("Wi", withSingleDash: true)
    ],
    help: "warning control; never warn; also PYTHONWARNINGS=arg"
  )
  internal var wIgnore = false

  // MARK: - Bytes warning

  /// `-b`
  ///
  /// Issue a warning when comparing `bytes` or `bytearray` with `str`
  /// or bytes with int.
  @Flag(
    name: NameSpecification.customShort("b"),
    help: concat(
      "issue warning about str(bytes_instance), str(bytearray_instance) ",
      "and comparing bytes/bytearray with str."
    )
  )
  internal var bytesWarning: Int

  // MARK: Command, module, script

  /// `-c <command>`
  ///
  /// Execute the Python code in `command`.
  /// `command` can be one or more statements separated by newlines,
  /// with significant leading whitespace as in normal module code.
  ///
  /// We need to add '\n' just as in
  /// pymain_parse_cmdline_impl(_PyMain *pymain, _PyCoreConfig *config, ...)
  @Option(
    name: NameSpecification.short,
    help: "program passed in as string (terminates option list)"
  )
  internal var command: String?

  /// `-m <module-name>`
  ///
  /// Search sys.path for the named module and execute its contents
  /// as the `__main__` module.
   @Option(
     name: NameSpecification.short,
     help: "run library module as a script (terminates option list)"
   )
  internal var module: String?

  /// `<script>`
  ///
  /// Execute the Python code contained in `script`,
  /// which must be a filesystem path (absolute or relative)
  /// referring to either a Python file,
  /// or a directory containing a `__main__.py` file.
  @Argument(
    help: "execute the code contained in script (terminates option list)"
  )
  internal var script: String?

  // MARK: - Init

  internal init() {}
}
