import XCTest
import Core
@testable import Objects

private class TestObject: PyObject, Equatable {

  fileprivate let value: Int

  fileprivate init(value: Int) {
    self.value = value
    super.init()
  }

  fileprivate static func == (lhs: TestObject, rhs: TestObject) -> Bool {
    return lhs.value == rhs.value
  }
}

extension Objects.ArgumentParser {

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

class ArgumentParser: XCTestCase {

  // MARK: - Create

  func test_init_positionalAfterKwarg_fails() {
    guard case let PyResult.error(e) = self.create(fnName: "fn",
                                                   arguments: ["", "kw", ""],
                                                   format: "|OOO:fn") else {
      XCTAssert(false)
      return
    }

    guard case PyErrorEnum.systemError = e else {
      XCTAssert(false)
      return
    }
  }

  func test_init_moreArguments_thanInFormat_fails() {
    guard case let PyResult.error(e) = self.create(fnName: "fn",
                                                   arguments: ["", "kw", "kw2"],
                                                   format: "|OO:fn") else {
      XCTAssert(false)
      return
    }

    guard case PyErrorEnum.systemError = e else {
      XCTAssert(false)
      return
    }
  }

  func test_init_moreArgumentsInFormat_thanNames_fails() {
    guard case let PyResult.error(e) = self.create(fnName: "fn",
                                                   arguments: ["", "kw"],
                                                   format: "|OOO:fn") else {
      XCTAssert(false)
      return
    }

    guard case PyErrorEnum.systemError = e else {
      XCTAssert(false)
      return
    }
  }

  func test_init_multipleMinArgMarker_fails() {
    guard case let PyResult.error(e) = self.create(fnName: "fn",
                                                   arguments: ["", "kw"],
                                                   format: "|O|OO:fn") else {
      XCTAssert(false)
      return
    }

    guard case PyErrorEnum.systemError = e else {
      XCTAssert(false)
      return
    }
  }

  func test_init_multipleMaxPositionalMarker_fails() {
    guard case let PyResult.error(e) = self.create(fnName: "fn",
                                                   arguments: ["", "kw", "kw2"],
                                                   format: "|O$O$O:fn") else {
      XCTAssert(false)
      return
    }

    guard case PyErrorEnum.systemError = e else {
      XCTAssert(false)
      return
    }
  }

  // MARK: - Int.int

  /// int()
  func test_int_new_withoutArgs() {
    guard let parser = self.createOrNil(fnName: "int",
                                        arguments: ["", "base"],
                                        format: "|OO:int") else {
      return
    }

    guard let result = parser.parseOrNil(args: [], kwargs: [:]) else {
      return
    }

    XCTAssertEqual(result.count, 0)
  }

  /// int('5')
  func test_int_new_positional() {
    guard let parser = self.createOrNil(fnName: "int",
                                        arguments: ["", "base"],
                                        format: "|OO:int") else {
      return
    }

    let arg = TestObject(value: 5)
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
    guard let parser = self.createOrNil(fnName: "int",
                                        arguments: ["", "base"],
                                        format: "|OO:int") else {
      return
    }

    let arg0 = TestObject(value: 5)
    let arg1 = TestObject(value: 16)
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
    guard let parser = self.createOrNil(fnName: "int",
                                        arguments: ["", "base"],
                                        format: "|OO:int") else {
      return
    }

    let arg0 = TestObject(value: 5)
    let arg1 = TestObject(value: 16)
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
  func test_int_new_toMuchPositional_fails() {
    guard let parser = self.createOrNil(fnName: "int",
                                        arguments: ["", "base"],
                                        format: "|OO:int") else {
      return
    }

    let arg0 = TestObject(value: 5)
    let arg1 = TestObject(value: 16)
    let arg2 = TestObject(value: 1)
    let args = [arg0, arg1, arg2]

    guard case let PyResult.error(e) = parser.parse(args: args, kwargs: [:]) else {
      XCTAssert(false)
      return
    }

    let msg = "int() takes at most 2 arguments (3 given)"
    guard case PyErrorEnum.typeError(msg) = e else {
      XCTAssert(false)
      return
    }
  }

  /// int('5', elsa=16)
  func test_int_new_invalidKeyword_fails() {
    guard let parser = self.createOrNil(fnName: "int",
                                        arguments: ["", "base"],
                                        format: "|OO:int") else {
      return
    }

    let arg0 = TestObject(value: 5)
    let arg1 = TestObject(value: 16)
    guard case let PyResult.error(e) = parser.parse(args: [arg0], kwargs: ["elsa":arg1]) else {
      XCTAssert(false)
      return
    }

    let msg = "'elsa' is an invalid keyword argument for int()"
    guard case PyErrorEnum.typeError(msg) = e else {
      XCTAssert(false)
      return
    }
  }

  // MARK: - Create helpers

  private func create(fnName: String,
                      arguments: [String],
                      format: String) -> PyResult<Objects.ArgumentParser> {
    return Objects.ArgumentParser.create(fnName: fnName,
                                         arguments: arguments,
                                         format: format)
  }

  private func createOrNil(fnName: String,
                           arguments: [String],
                           format: String,
                           file: StaticString = #file,
                           line: UInt         = #line) -> Objects.ArgumentParser? {
    switch self.create(fnName: fnName, arguments: arguments, format: format) {
    case let .value(r):
      return r
    case let .error(e):
      XCTAssert(false, String(describing: e), file: file, line: line)
      return nil
    }
  }
}
