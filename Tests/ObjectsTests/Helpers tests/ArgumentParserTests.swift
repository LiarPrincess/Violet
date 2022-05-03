import XCTest
import VioletCore
@testable import VioletObjects

class ArgumentParserTests: PyTestCase {

  // MARK: - Init - name

  func test_init_withoutFunctionName_fails() {
    // Format should end with ':FUNCTION_NAME'
    guard let message = self.createError(arguments: ["", "elsa"],
                                         format: "|OO") else {
      return
    }

    XCTAssertEqual(message, "Format does not contain a function name")
  }

  func test_init_withoutFunctionName_withColon_fails() {
    // Nothing after ':'
    guard let message = self.createError(arguments: ["", "elsa"],
                                         format: "|OO:") else {
      return
    }

    XCTAssertEqual(message, "Format does not contain a function name")
  }

  // MARK: - Init - argument count

  func test_init_argumentCount_moreNamesThanInFormat_fails() {
    // 3 arguments, but 2 in format
    guard let message = self.createError(arguments: ["", "elsa", "anna"],
                                         format: "|OO:frozen") else {
      return
    }

    XCTAssertEqual(message, "More keyword list entries (3) than format specifiers (2)")
  }

  func test_init_argumentCount_moreInFormatThanNames_fails() {
    // 2 arguments, but 3 in format
    guard let message = self.createError(arguments: ["", "elsa"],
                                         format: "|OOO:frozen") else {
      return
    }

    XCTAssertEqual(message, "More argument specifiers than keyword list entries")
  }

  // MARK: - Init - argument names

  func test_init_argumentNames_positionalAfterKwarg_fails() {
    // "" after "elsa"
    guard let message = self.createError(arguments: ["", "elsa", ""],
                                         format: "|OOO:frozen") else {
      return
    }

    XCTAssertEqual(message, "Empty keyword parameter name")
  }

  // MARK: - Init - markers

  func test_init_markers_multipleRequiredArg_fails() {
    // multiple '|'
    guard let message = self.createError(arguments: ["", "elsa", "anna"],
                                         format: "|O|OO:frozen") else {
      return
    }

    XCTAssertEqual(message, "Invalid format string (| specified twice)")
  }

  func test_init_markers_multipleMaxPositional_fails() {
    // multiple '$'
    guard let message = self.createError(arguments: ["", "elsa", "anna"],
                                         format: "|O$O$O:frozen") else {
      return
    }

    XCTAssertEqual(message, "Invalid format string ($ specified twice)")
  }

  // MARK: - Bind - too much arguments

  func test_bind_count_tooMany_args() {
    let py = self.createPy()

    let value0 = py.newInt(1).asObject
    let value1 = py.newInt(2).asObject
    let value2 = py.newInt(3).asObject

    guard let error = self.bindError(
      py,
      arguments: ["", "elsa", "anna"], // 1 positional
      format: "O$OO:frozen",
      args: [value0, value1], // 2 positional
      kwargs: ["anna": value2]
    ) else { return }

    self.assertTypeError(
      py,
      error: error,
      message: "frozen() takes at most 1 positional arguments (2 given)"
    )
  }

  func test_bind_count_tooMany_argsKwargs() {
    let py = self.createPy()

    let value0 = py.newInt(1).asObject
    let value1 = py.newInt(2).asObject
    let value2 = py.newInt(3).asObject

    guard let error = self.bindError(
      py,
      arguments: ["", "elsa"], // 2 arguments (1 positional + 1 kwarg)
      format: "OO:frozen",
      args: [value0, value1], // 2 positional
      kwargs: ["elsa": value2] // 1 kwarg -> total 3 arguments
    ) else { return }

    self.assertTypeError(
      py,
      error: error,
      message: "frozen() takes at most 2 arguments (3 given)"
    )
  }

  // MARK: - Bind - required to value

  func test_bind_required_arg() {
    let py = self.createPy()

    let value = py.newInt(1).asObject

    guard let binding = self.bind(
      py,
      arguments: [""], // 1 arg
      format: "O:frozen",
      args: [value], // its value
      kwargs: [:]
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 1)
    XCTAssertEqual(binding.optionalCount, 0)

    let required0 = binding.required(at: 0)
    self.assertIsEqual(py, left: required0, right: value)
  }

  func test_bind_required_kwarg() {
    let py = self.createPy()

    let value = py.newInt(1).asObject

    guard let binding = self.bind(
      py,
      arguments: ["elsa"], // 1 kwarg
      format: "O:frozen",
      args: [],
      kwargs: ["elsa": value] // its value
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 1)
    XCTAssertEqual(binding.optionalCount, 0)

    self.assertIsEqual(py, left: binding.required(at: 0), right: value)
  }

  func test_bind_required_arg_kwarg() {
    let py = self.createPy()

    let value0 = py.newInt(1).asObject
    let value1 = py.newInt(2).asObject

    guard let binding = self.bind(
      py,
      arguments: ["", "elsa"], // 1 positional + 1 kwarg
      format: "OO:frozen",
      args: [value0], // positional value
      kwargs: ["elsa": value1] // kwarg value
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 2)
    XCTAssertEqual(binding.optionalCount, 0)

    let required0 = binding.required(at: 0)
    self.assertIsEqual(py, left: required0, right: value0)

    let required1 = binding.required(at: 1)
    self.assertIsEqual(py, left: required1, right: value1)
  }

  // MARK: - Bind - optional to value

  func test_bind_optional_arg() {
    let py = self.createPy()

    let value = py.newInt(1).asObject

    guard let binding = self.bind(
      py,
      arguments: [""], // 1 optional positional
      format: "|O:frozen", // note '|' - it means that it is optional
      args: [value], // its value
      kwargs: [:]
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 1)

    let optional0 = binding.optional(at: 0)
    self.assertIsEqual(py, left: optional0, right: value)
  }

  func test_bind_optional_kwarg() {
    let py = self.createPy()

    let value = py.newInt(1).asObject

    guard let binding = self.bind(
      py,
      arguments: ["elsa"], // 1 kwarg
      format: "|O:frozen", // note '|' - it means that it is optional
      args: [],
      kwargs: ["elsa": value] // its value
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 1)

    let optional0 = binding.optional(at: 0)
    self.assertIsEqual(py, left: optional0, right: value)
  }

  func test_bind_optional_arg_kwarg() {
    let py = self.createPy()

    let value0 = py.newInt(1).asObject
    let value1 = py.newInt(2).asObject

    guard let binding = self.bind(
      py,
      arguments: ["", "elsa"], // 1 positional + 1 kwarg
      format: "|OO:frozen", // note '|' - it means that it is optional
      args: [value0], // positional value
      kwargs: ["elsa": value1] // kwarg value
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 2)

    let optional0 = binding.optional(at: 0)
    self.assertIsEqual(py, left: optional0, right: value0)

    let optional1 = binding.optional(at: 1)
    self.assertIsEqual(py, left: optional1, right: value1)
  }

  func test_bind_optional_notProvided() {
    let py = self.createPy()

    guard let binding = self.bind(
      py,
      arguments: [""],
      format: "|O:frozen", // note '|' - it means that it is optional
      args: [], // no positional
      kwargs: [:] // no kwarg either
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 1)

    let optional0 = binding.optional(at: 0)
    XCTAssertNil(optional0)
  }

  /// We have 2 kwargs: 'elsa' and 'anna'.
  /// Bind only 'anna' and leave 'elsa' with default value.
  func test_bind_optional_skipKwarg_andBind_nextOne() {
    let py = self.createPy()

    let value = py.newInt(1).asObject

    guard let binding = self.bind(
      py,
      arguments: ["elsa", "anna"], // 2 kwargs
      format: "|OO:frozen", // note '|' - it means that it is optional
      args: [],
      kwargs: ["anna": value] // value for 2nd kwarg
    ) else { return }

    XCTAssertEqual(binding.requiredCount, 0)
    XCTAssertEqual(binding.optionalCount, 2)

    let optional0 = binding.optional(at: 0)
    XCTAssertNil(optional0)

    let optional1 = binding.optional(at: 1)
    self.assertIsEqual(py, left: optional1, right: value)
  }

  // MARK: - Bind - errors

  func test_bind_missingRequiredArg_fails() {
    let py = self.createPy()

    let value0 = py.newInt(1).asObject

    guard let error = self.bindError(
      py,
      arguments: ["", "", "elsa"],
      format: "OO|O:frozen", // 2 required args
      args: [value0], // 1 provided
      kwargs: [:]
    ) else { return }

    self.assertTypeError(
      py,
      error: error,
      message: "frozen() takes at least 2 positional arguments (1 given)"
    )
  }

  func test_bind_extraneousKwarg_fails() {
    let py = self.createPy()

    let value = py.newInt(1).asObject

    guard let error = self.bindError(
      py,
      arguments: ["", "elsa"],
      format: "|OO:frozen",
      args: [],
      kwargs: ["anna": value] // totally unrelated kwarg
    ) else { return }

    self.assertTypeError(
      py,
      error: error,
      message: "'anna' is an invalid keyword argument for frozen()"
    )
  }

  func test_bind_argumentGivenBy_argsAndKwargs_fails() {
    let py = self.createPy()

    let value0 = py.newInt(1).asObject
    let value1 = py.newInt(2).asObject
    let value2 = py.newInt(3).asObject

    guard let error = self.bindError(
      py,
      arguments: ["", "elsa", "dummy"],
      format: "|OOO:frozen",
      args: [value0, value1], // 2 positional, 2nd one will bind 'elsa'
      kwargs: ["elsa": value2] // elsa kwarg
    ) else { return }

    self.assertTypeError(
      py,
      error: error,
      message: "argument for frozen() given by name ('elsa') and position (2)"
    )
  }

  // MARK: - Create helpers

  private func create(arguments: [String],
                      format: String,
                      file: StaticString = #file,
                      line: UInt = #line) -> ArgumentParser? {
    switch ArgumentParser.create(arguments: arguments, format: format) {
    case let .value(r):
      return r
    case let .error(message):
      XCTFail(message, file: file, line: line)
      return nil
    }
  }

  private func createError(arguments: [String],
                           format: String,
                           file: StaticString = #file,
                           line: UInt = #line) -> String? {
    switch ArgumentParser.create(arguments: arguments, format: format) {
    case .value:
      XCTFail("Parser was created", file: file, line: line)
      return nil
    case .error(let message):
      return message
    }
  }

  private func bind(_ py: Py,
                    arguments: [String],
                    format: String,
                    args: [PyObject],
                    kwargs: [String: PyObject],
                    file: StaticString = #file,
                    line: UInt = #line) -> ArgumentParser.Binding? {
    guard let parser = self.create(arguments: arguments,
                                   format: format,
                                   file: file,
                                   line: line) else {
      return nil
    }

    switch parser.bind(py, args: args, kwargs: kwargs) {
    case let .value(r):
      return r
    case let .error(e):
      let reason = self.toString(py, error: e)
      XCTFail("Binding failed: \(reason)", file: file, line: line)
      return nil
    }
  }

  private func bindError(_ py: Py,
                         arguments: [String],
                         format: String,
                         args: [PyObject],
                         kwargs: [String: PyObject],
                         file: StaticString = #file,
                         line: UInt = #line) -> PyBaseException? {
    guard let parser = self.create(arguments: arguments,
                                   format: format,
                                   file: file,
                                   line: line) else {
      return nil
    }

    switch parser.bind(py, args: args, kwargs: kwargs) {
    case .value:
      XCTFail("Binding succeeded.", file: file, line: line)
      return nil
    case .error(let e):
      return e
    }
  }
}
