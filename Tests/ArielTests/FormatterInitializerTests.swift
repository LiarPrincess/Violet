import XCTest
@testable import LibAriel

class FormatterInitializerTests: XCTestCase {

  func test_simple() {
    guard let declaration = Parser.initializer(source: "init() {}") else {
      return
    }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, "init()")
  }

  func test_full() {
    guard let declaration = Parser.initializer(source: """
@available(macOS 10.15, *)
private init?<T>(arg: T) throws where T: Ice
""") else { return }

    let formatter = Formatter(newLineAfterAttribute: true,
                              maxInitializerLength: nil)

    let result = formatter.format(declaration)
    XCTAssertEqual(result, """
@available
private init?<T>(arg: T) throws where T: Ice
""")
  }
}
