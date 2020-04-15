import XCTest
@testable import VM

class FileSystemTests: XCTestCase {

  // MARK: - Basename

  func test_basename() {
    let fs = self.createFileSystem()
    XCTAssertEqual(fs.basename(path: "/frozen/elsa.txt"), "elsa.txt")
    XCTAssertEqual(fs.basename(path: "/frozen/.elsa"), ".elsa")
    XCTAssertEqual(fs.basename(path: "/frozen/elsa/"), "elsa")
    XCTAssertEqual(fs.basename(path: "/frozen/."), ".")
    XCTAssertEqual(fs.basename(path: "/frozen/.."), "..")
    XCTAssertEqual(fs.basename(path: "/frozen"), "frozen")
    XCTAssertEqual(fs.basename(path: "frozen"), "frozen")
    XCTAssertEqual(fs.basename(path: "."), ".")
    XCTAssertEqual(fs.basename(path: ".."), "..")
    XCTAssertEqual(fs.basename(path: "/"), "/")
    XCTAssertEqual(fs.basename(path: "//frozen"), "frozen")
    XCTAssertEqual(fs.basename(path: ""), "")
  }

  // MARK: - Dirname

  func test_dirname() {
    let fs = self.createFileSystem()
    XCTAssertEqual(fs.dirname(path: "/frozen/elsa.txt"), "/frozen")
    XCTAssertEqual(fs.dirname(path: "/frozen/.elsa"), "/frozen")
    XCTAssertEqual(fs.dirname(path: "/frozen/elsa/"), "/frozen")
    XCTAssertEqual(fs.dirname(path: "/frozen/."), "/frozen")
    XCTAssertEqual(fs.dirname(path: "/frozen/.."), "/frozen")
    XCTAssertEqual(fs.dirname(path: "/frozen"), "/")
    XCTAssertEqual(fs.dirname(path: "frozen"), ".")
    XCTAssertEqual(fs.dirname(path: "."), ".")
    XCTAssertEqual(fs.dirname(path: ".."), ".")
    XCTAssertEqual(fs.dirname(path: "/"), "/")
    XCTAssertEqual(fs.dirname(path: "//frozen"), "/")
    XCTAssertEqual(fs.dirname(path: ""), ".")
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
