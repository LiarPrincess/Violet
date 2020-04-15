import XCTest
@testable import VM

class FileSystemTests: XCTestCase {

  // MARK: - Basename

  func test_basename() {
    XCTAssertEqual(self.basename(path: "/frozen/elsa.txt"), "elsa.txt")
    XCTAssertEqual(self.basename(path: "/frozen/.elsa"), ".elsa")
    XCTAssertEqual(self.basename(path: "/frozen/elsa/"), "elsa")
    XCTAssertEqual(self.basename(path: "/frozen/."), ".")
    XCTAssertEqual(self.basename(path: "/frozen/.."), "..")
    XCTAssertEqual(self.basename(path: "/frozen"), "frozen")
    XCTAssertEqual(self.basename(path: "frozen"), "frozen")
    XCTAssertEqual(self.basename(path: "."), ".")
    XCTAssertEqual(self.basename(path: ".."), "..")
    XCTAssertEqual(self.basename(path: "/"), "/")
    XCTAssertEqual(self.basename(path: "//frozen"), "frozen")
    XCTAssertEqual(self.basename(path: ""), "")
  }

  private func basename(path: String) -> String {
    let fs = self.createFileSystem()
    return fs.basename(path: path)
  }

  // MARK: - Dirname

  func test_dirname() {
    XCTAssertEqual(self.dirname(path: "/frozen/elsa.txt"), "/frozen")
    XCTAssertEqual(self.dirname(path: "/frozen/.elsa"), "/frozen")
    XCTAssertEqual(self.dirname(path: "/frozen/elsa/"), "/frozen")
    XCTAssertEqual(self.dirname(path: "/frozen/."), "/frozen")
    XCTAssertEqual(self.dirname(path: "/frozen/.."), "/frozen")
    XCTAssertEqual(self.dirname(path: "/frozen"), "/")
    XCTAssertEqual(self.dirname(path: "frozen"), ".")
    XCTAssertEqual(self.dirname(path: "."), ".")
    XCTAssertEqual(self.dirname(path: ".."), ".")
    XCTAssertEqual(self.dirname(path: "/"), "/")
    XCTAssertEqual(self.dirname(path: "//frozen"), "/")
    XCTAssertEqual(self.dirname(path: ""), ".")
  }

  private func dirname(path: String) -> String {
    let fs = self.createFileSystem()
    return fs.dirname(path: path).path
  }

  // MARK: - Join

  func test_join() {
    let fs = self.createFileSystem()
    XCTAssertEqual(fs.join(paths: "", ""), "")
    XCTAssertEqual(fs.join(paths: "frozen", ""), "frozen")
    XCTAssertEqual(fs.join(paths: "", "frozen"), "frozen")
    XCTAssertEqual(fs.join(paths: "frozen", "elsa"), "frozen/elsa")
    XCTAssertEqual(fs.join(paths: "frozen/", "elsa"), "frozen/elsa")
    XCTAssertEqual(fs.join(paths: "frozen", "elsa", "anna"), "frozen/elsa/anna")
    XCTAssertEqual(fs.join(paths: "frozen/elsa", "anna"), "frozen/elsa/anna")
    XCTAssertEqual(fs.join(paths: "frozen/elsa/", "anna"), "frozen/elsa/anna")
  }

  // MARK: - Helpers

  private func createFileSystem() -> FileSystemImpl {
    return FileSystemImpl(
      bundle: .main,
      fileManager: .default
    )
  }
}
