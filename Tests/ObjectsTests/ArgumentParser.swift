import XCTest
import Core
@testable import Objects

// swiftlint:disable file_length

class ArgumentParserTests: PyTestCaseOtherwiseItWillTrap {

  // MARK: - Init - name

  func test_init_withoutFunctionName_fails() {
    guard let e = self.createError(
      arguments: ["", "elsa"],
      format: "|OO" // Missing ':function_name'
    ) else { return }

    guard let s = self.asSystemError(e) else { return }
    XCTAssertEqual(s.message, "Format does not contain function name")
  }

  func test_init_withoutFunctionName_withColon_fails() {
    guard let e = self.createError(
      arguments: ["", "elsa"],
      format: "|OO:" // Nothing after ':'
    ) else { return }

    guard let s = self.asSystemError(e) else { return }
    XCTAssertEqual(s.message, "Format does not contain function name")
  }

  // MARK: - Init - argument count

  func test_init_argumentCount_moreNamesThanInFormat_fails() {
    guard let e = self.createError(
      arguments: ["", "elsa", "anna"], // 3
      format: "|OO:frozen" // 2
    ) else { return }

    guard let s = self.asSystemError(e) else { return }
    XCTAssertEqual(s.message, "More keyword list entries (3) than format specifiers (2)")
  }

  func test_init_argumentCount_moreInFormatThanNames_fails() {
    guard let e = self.createError(
      arguments: ["", "elsa"], // 2
      format: "|OOO:frozen" // 3
    ) else { return }

    guard let s = self.asSystemError(e) else { return }
    XCTAssertEqual(s.message, "More argument specifiers than keyword list entries")
  }

  // MARK: - Init - argument names

  func test_init_argumentNames_positionalAfterKwarg_fails() {
    guard let e = self.createError(
      arguments: ["", "elsa", ""], // we have "" after "elsa"
      format: "|OOO:frozen"
    ) else { return }

    guard let s = self.asSystemError(e) else { return }
    XCTAssertEqual(s.message, "Empty keyword parameter name")
  }

  // MARK: - Init - markers

  func test_init_markers_multipleRequiredArg_fails() {
    guard let e = self.createError(
      arguments: ["", "elsa", "anna"],
      format: "|O|OO:frozen" // multiple '|'
    ) else { return }

    guard let s = self.asSystemError(e) else { return }
    XCTAssertEqual(s.message, "Invalid format string (| specified twice)")
  }

  func test_init_markers_multipleMaxPositional_fails() {
    guard let e = self.createError(
      arguments: ["", "elsa", "anna"],
      format: "|O$O$O:frozen"  // multiple '$'
    ) else { return }

    guard let s = self.asSystemError(e) else { return }
    XCTAssertEqual(s.message, "Invalid format string ($ specified twice)")
  }

  // MARK: - Bind - too much arguments

  func test_bind_count_tooMuch_args() {
    let value0 = Py.newInt(1)
    let value1 = Py.newInt(2)
    let value2 = Py.newInt(3)

    guard let e = self.bindError(
      arguments: ["", "elsa", "anna"], // 1 positional
      format: "O$OO:frozen",
      args: [value0, value1], // 2 positionals
      kwargs: ["anna": value2]
    ) else { return }

    guard let t = self.asTypeError(e) else { return }
    XCTAssertEqual(t.message, "frozen() takes at most 1 positional arguments (2 given)")
  }

  func test_bind_count_tooMuch_argsKwargs() {
    let value0 = Py.newInt(1)
    let value1 = Py.newInt(2)
    let value2 = Py.newInt(3)

    guard let e = self.bindError(
      arguments: ["", "elsa"], // 2 arguments (1 positional + 1 kwarg)
      format: "OO:frozen",
      args: [value0, value1], // 2 positional
      kwargs: ["elsa": value2] // 1 kwarg -> total 3 arguments
    ) else { return }

    guard let t = self.asTypeError(e) else { return }
    XCTAssertEqual(t.message, "frozen() takes at most 2 arguments (3 given)")
  }

  // MARK: - Bind - required to value

  func test_bind_required_arg() {
    let value = Py.newInt(1)

    guard let binding = self.bind(
      arguments: [""], // 1 arg
      format: "O:frozen",
      args: [value], // its value
      kwargs: [:]
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 1)
    XCTAssertEqual(binding.optionalCount, 0)

    XCTAssert(binding.required(at: 0) === value)
  }

  func test_bind_required_kwarg() {
    let value = Py.newInt(1)

    guard let binding = self.bind(
      arguments: ["elsa"], // 1 kwarg
      format: "O:frozen",
      args: [],
      kwargs: ["elsa": value] // its value
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 1)
    XCTAssertEqual(binding.optionalCount, 0)

    XCTAssert(binding.required(at: 0) === value)
  }

  func test_bind_required_arg_kwarg() {
    let value0 = Py.newInt(1)
    let value1 = Py.newInt(2)

    guard let binding = self.bind(
      arguments: ["", "elsa"], // 1 positional + 1 kwarg
      format: "OO:frozen",
      args: [value0], // positional value
      kwargs: ["elsa": value1] // kwarg value
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 2)
    XCTAssertEqual(binding.optionalCount, 0)

    XCTAssert(binding.required(at: 0) === value0)
    XCTAssert(binding.required(at: 1) === value1)
  }

  // MARK: - Bind - optional to value

  func test_bind_optional_arg() {
    let value = Py.newInt(1)

    guard let binding = self.bind(
      arguments: [""], // 1 optional positional
      format: "|O:frozen", // note '|' - it means that it is optional
      args: [value], // its value
      kwargs: [:]
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 1)

    XCTAssert(binding.optional(at: 0) === value)
  }

  func test_bind_optional_kwarg() {
    let value = Py.newInt(1)

    guard let binding = self.bind(
      arguments: ["elsa"], // 1 kwarg
      format: "|O:frozen", // note '|' - it means that it is optional
      args: [],
      kwargs: ["elsa": value] // its value
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 1)

    XCTAssert(binding.optional(at: 0) === value)
  }

  func test_bind_optional_arg_kwarg() {
    let value0 = Py.newInt(1)
    let value1 = Py.newInt(2)

    guard let binding = self.bind(
      arguments: ["", "elsa"], // 1 positional + 1 kwarg
      format: "|OO:frozen", // note '|' - it means that it is optional
      args: [value0], // positional value
      kwargs: ["elsa": value1] // kwarg value
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 2)

    XCTAssert(binding.optional(at: 0) === value0)
    XCTAssert(binding.optional(at: 1) === value1)
  }

  func test_bind_optional_notProvided() {
    guard let binding = self.bind(
      arguments: [""],
      format: "|O:frozen", // note '|' - it means that it is optional
      args: [], // no positional
      kwargs: [:] // no kwarg either
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 1)

    XCTAssert(binding.optional(at: 0) == nil)
  }

  /// We have 2 kwargs: 'elsa' and 'anna'.
  /// Bind only 'anna' and leave 'elsa' with default value.
  func test_bind_optional_skipKwarg_andBind_nextOne() {
    let value = Py.newInt(1)

    guard let binding = self.bind(
      arguments: ["elsa", "anna"], // 2 kwargs
      format: "|OO:frozen", // note '|' - it means that it is optional
      args: [],
      kwargs: ["anna": value] // value for 2nd kwarg
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 2)

    XCTAssert(binding.optional(at: 0) == nil)
    XCTAssert(binding.optional(at: 1) === value)
  }

  // MARK: - Bind - errors

  func test_bind_missingRequiredArg_fails() {
    let value0 = Py.newInt(1)

    guard let e = self.bindError(
      arguments: ["", "", "elsa"],
      format: "OO|O:frozen", // 2 required args
      args: [value0], // 1 provided
      kwargs: [:]
    ) else { return }

    guard let t = self.asTypeError(e) else { return }
    XCTAssertEqual(t.message, "frozen() takes at least 2 positional arguments (1 given)")
  }

  func test_bind_extraneousKwarg_fails() {
    let value = Py.newInt(1)

    guard let e = self.bindError(
      arguments: ["", "elsa"],
      format: "|OO:frozen",
      args: [],
      kwargs: ["anna": value] // totally unrelated kwarg
    ) else { return }

    guard let t = self.asTypeError(e) else { return }
    XCTAssertEqual(t.message, "'anna' is an invalid keyword argument for frozen()")
  }

  func test_bind_argumentGivenBy_argsAndKwargs_fails() {
    let value0 = Py.newInt(1)
    let value1 = Py.newInt(2)
    let value2 = Py.newInt(3)

    guard let e = self.bindError(
      arguments: ["", "elsa", "dummy"],
      format: "|OOO:frozen",
      args: [value0, value1], // 2 positional, 2nd one will bind 'elsa'
      kwargs: ["elsa": value2] // elsa kwarg
    ) else { return }

    guard let t = self.asTypeError(e) else { return }
    XCTAssertEqual(t.message, "argument for frozen() given by name ('elsa') and position (2)")
  }

  // MARK: - Create helpers

  private func createParser(arguments: [String],
                            format: String,
                            file: StaticString = #file,
                            line: UInt         = #line) -> ArgumentParser? {
    switch ArgumentParser.create(arguments: arguments, format: format) {
    case let .value(r):
      return r
    case let .error(e):
      XCTAssert(false, String(describing: e), file: file, line: line)
      return nil
    }
  }

  private func createError(arguments: [String],
                           format: String,
                           file: StaticString = #file,
                           line: UInt         = #line) -> PyBaseException? {
    switch ArgumentParser.create(arguments: arguments, format: format) {
    case let .value(r):
      XCTAssert(false, String(describing: r), file: file, line: line)
      return nil
    case let .error(e):
      return e
    }
  }

  private func asSystemError(_ e: PyBaseException?,
                             file: StaticString = #file,
                             line: UInt         = #line) -> PySystemError? {
    if let s = e as? PySystemError {
      return s
    }

    XCTAssert(false, String(describing: e), file: file, line: line)
    return nil
  }

  private func asTypeError(_ e: PyBaseException?,
                           file: StaticString = #file,
                           line: UInt         = #line) -> PyTypeError? {
    if let s = e as? PyTypeError {
      return s
    }

    XCTAssert(false, String(describing: e), file: file, line: line)
    return nil
  }

  private func bind(arguments: [String],
                    format: String,
                    args: [PyObject],
                    kwargs: [String:PyObject],
                    file: StaticString = #file,
                    line: UInt         = #line) -> ArgumentParser.Binding? {
    guard let parser = self.createParser(arguments: arguments,
                                         format: format,
                                         file: file,
                                         line: line) else {
      return nil
    }

     switch parser.bind(args: args, kwargs: kwargs) {
     case let .value(r):
       return r
     case let .error(e):
       XCTAssert(false, String(describing: e), file: file, line: line)
       return nil
     }
   }

  private func bindError(arguments: [String],
                         format: String,
                         args: [PyObject],
                         kwargs: [String:PyObject],
                         file: StaticString = #file,
                         line: UInt         = #line) -> PyBaseException? {
    guard let parser = self.createParser(arguments: arguments,
                                         format: format,
                                         file: file,
                                         line: line) else {
      return nil
    }

     switch parser.bind(args: args, kwargs: kwargs) {
     case let .value(r):
      XCTAssert(false, String(describing: r), file: file, line: line)
       return nil
     case let .error(e):
       return e
     }
   }
}
