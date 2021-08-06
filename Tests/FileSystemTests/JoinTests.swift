import XCTest
@testable import FileSystem

class JoinTests: FileSystemTest {

  func test_join() {
    self.assertJoin(paths: ["", ""], expected: "")
    self.assertJoin(paths: ["frozen", ""], expected: "frozen")
    self.assertJoin(paths: ["", "frozen"], expected: "frozen")
    self.assertJoin(paths: ["frozen", "elsa"], expected: "frozen/elsa")
    self.assertJoin(paths: ["frozen/", "elsa"], expected: "frozen/elsa")
    self.assertJoin(paths: ["frozen", "elsa", "anna"], expected: "frozen/elsa/anna")
    self.assertJoin(paths: ["frozen/elsa", "anna"], expected: "frozen/elsa/anna")
    self.assertJoin(paths: ["frozen/elsa/", "anna"], expected: "frozen/elsa/anna")
  }

  private func assertJoin(paths: [String],
                          expected: String,
                          file: StaticString = #file,
                          line: UInt = #line) {
    assert(!paths.isEmpty)
    let left = Path(string: paths[0])
    let rest = Array(paths.dropFirst())
    let expectedPath = Path(string: expected)

    let result = self.fileSystem.join(path: left, elements: rest)
    XCTAssertEqual(result,
                   expectedPath,
                   "fileSystem.join(path:elements:)",
                   file: file,
                   line: line)

    if rest.count == 1 {
      let other = paths[1]
      let singleString = self.fileSystem.join(path: left, element: paths[1])
      XCTAssertEqual(singleString,
                     expectedPath,
                     "fileSystem.join(path:element:) - string",
                     file: file,
                     line: line)

      let otherPath = Path(string: other)
      let singlePath = self.fileSystem.join(path: left, element: otherPath)
      XCTAssertEqual(singlePath,
                     expectedPath,
                     "fileSystem.join(path:element:) - path",
                     file: file,
                     line: line)
    }
  }
}
