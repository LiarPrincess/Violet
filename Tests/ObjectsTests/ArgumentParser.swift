import XCTest
import Core
@testable import Objects

private class DummyObject: PyObject {

  fileprivate let value: Int

  fileprivate init(value: Int) {
    self.value = value
    super.init()
  }
}

extension Objects.ArgumentParser {

  // swiftlint:disable:next discouraged_optional_collection
  fileprivate func parseOrNil(args: [PyObject],
                              kwargs: [String:PyObject],
                              file: StaticString = #file,
                              line: UInt         = #line) -> [PyObject]? {
    switch self.parse(args: args, kwargs: kwargs) {
    case let .value(r):
      return r
    case let .error(e):
      XCTAssert(false, String(describing: e), file: file, line: line)
      return nil
    }
  }
}

class ArgumentParser: PyTestCaseOtherwiseItWillTrap {

  // MARK: - Create

  func test_init_withoutName_fails() {
    guard case let .error(e) = self.create(arguments: ["", "kw", ""],
                                           format: "|OOO") else {
      XCTAssert(false)
      return
    }

    XCTAssert(e is PySystemError)
  }

  func test_init_withoutName2_fails() {
    guard case let .error(e) = self.create(arguments: ["", "kw", ""],
                                           format: "|OOO:") else {
      XCTAssert(false)
      return
    }

    XCTAssert(e is PySystemError)
  }

  func test_init_positionalAfterKwarg_fails() {
    guard case let .error(e) = self.create(arguments: ["", "kw", ""],
                                           format: "|OOO:fn") else {
      XCTAssert(false)
      return
    }

    XCTAssert(e is PySystemError)
  }

  func test_init_moreArguments_thanInFormat_fails() {
    guard case let .error(e) = self.create(arguments: ["", "kw", "kw2"],
                                           format: "|OO:fn") else {
      XCTAssert(false)
      return
    }

    XCTAssert(e is PySystemError)
  }

  func test_init_moreArgumentsInFormat_thanNames_fails() {
    guard case let .error(e) = self.create(arguments: ["", "kw"],
                                           format: "|OOO:fn") else {
      XCTAssert(false)
      return
    }

    XCTAssert(e is PySystemError)
  }

  func test_init_multipleMinArgMarker_fails() {
    guard case let .error(e) = self.create(arguments: ["", "kw"],
                                           format: "|O|OO:fn") else {
      XCTAssert(false)
      return
    }

    XCTAssert(e is PySystemError)
  }

  func test_init_multipleMaxPositionalMarker_fails() {
    guard case let .error(e) = self.create(arguments: ["", "kw", "kw2"],
                                           format: "|O$O$O:fn") else {
      XCTAssert(false)
      return
    }

    XCTAssert(e is PySystemError)
  }

  // MARK: - Int.int

  /// int()
  func test_int_new_withoutArgs() {
    guard let parser = self.createIntParser() else {
      return
    }

    guard let result = parser.parseOrNil(args: [], kwargs: [:]) else {
      return
    }

    XCTAssertEqual(result.count, 0)
  }

  /// int('5')
  func test_int_new_positional() {
    guard let parser = self.createIntParser() else {
      return
    }

    let arg = DummyObject(value: 5)
    guard let result = parser.parseOrNil(args: [arg], kwargs: [:]) else {
      return
    }

    guard result.count == 1 else {
      XCTAssert(false)
      return
    }

    XCTAssert(result[0] === arg)
  }

  /// int('5', 16)
  func test_int_new_positional_positional() {
    guard let parser = self.createIntParser() else {
      return
    }

    let arg0 = DummyObject(value: 5)
    let arg1 = DummyObject(value: 16)
    guard let result = parser.parseOrNil(args: [arg0, arg1], kwargs: [:]) else {
      return
    }

    guard result.count == 2 else {
      XCTAssert(false)
      return
    }

    XCTAssert(result[0] === arg0)
    XCTAssert(result[1] === arg1)
  }

  /// int('5', base=16)
  func test_int_new_positional_keyword() {
    guard let parser = self.createIntParser() else {
      return
    }

    let arg0 = DummyObject(value: 5)
    let arg1 = DummyObject(value: 16)
    guard let result = parser.parseOrNil(args: [arg0], kwargs: ["base":arg1]) else {
      return
    }

    guard result.count == 2 else {
      XCTAssert(false)
      return
    }

    XCTAssert(result[0] === arg0)
    XCTAssert(result[1] === arg1)
  }

  /// int('5', 16, 1)
  func test_int_new_tooMuchPositional_fails() {
    guard let parser = self.createIntParser() else {
      return
    }

    let arg0 = DummyObject(value: 5)
    let arg1 = DummyObject(value: 16)
    let arg2 = DummyObject(value: 1)
    let args = [arg0, arg1, arg2]

    guard case let .error(e) = parser.parse(args: args, kwargs: [:]) else {
      XCTAssert(false)
      return
    }

    let msg = "int() takes at most 2 arguments (3 given)"
    XCTAssertTypeError(error: e, msg: msg)
  }

  /// int('5', elsa=16)
  func test_int_new_invalidKeyword_fails() {
    guard let parser = self.createIntParser() else {
      return
    }

    let arg0 = DummyObject(value: 5)
    let arg1 = DummyObject(value: 16)
    guard case let .error(e) = parser.parse(args: [arg0], kwargs: ["elsa":arg1]) else {
      XCTAssert(false)
      return
    }

    let msg = "'elsa' is an invalid keyword argument for int()"
    XCTAssertTypeError(error: e, msg: msg)
  }

  // MARK: - Create helpers

  private func createIntParser(file: StaticString = #file,
                               line: UInt         = #line) -> Objects.ArgumentParser? {
    switch self.create(arguments: ["", "base"], format: "|OO:int") {
    case let .value(r):
      return r
    case let .error(e):
      XCTAssert(false, String(describing: e), file: file, line: line)
      return nil
    }
  }

  private func create(arguments: [String],
                      format: String) -> PyResult<Objects.ArgumentParser> {
    return Objects.ArgumentParser.create(arguments: arguments, format: format)
  }
}
