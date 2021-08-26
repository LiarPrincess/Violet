import XCTest
@testable import FileSystem

class NameTests: FileSystemTest {

  // MARK: - Basename

  func test_basename() {
    self.assertBasename("", expected: "")
    self.assertBasename(".", expected: ".")
    self.assertBasename("..", expected: "..")
    self.assertBasename("/", expected: "/")
    self.assertBasename("///", expected: "/")

    self.assertBasename("frozen", expected: "frozen")
    self.assertBasename("frozen/", expected: "frozen")
    self.assertBasename("frozen//", expected: "frozen")
    self.assertBasename("frozen/.", expected: ".")
    self.assertBasename("frozen/..", expected: "..")
    self.assertBasename("frozen/elsa", expected: "elsa")
    self.assertBasename("frozen/elsa.txt", expected: "elsa.txt")
    self.assertBasename("frozen/elsa/", expected: "elsa")
    self.assertBasename("frozen/elsa//", expected: "elsa")

    self.assertBasename("/frozen", expected: "frozen")
    self.assertBasename("/frozen/", expected: "frozen")
    self.assertBasename("/frozen//", expected: "frozen")
    self.assertBasename("/frozen/.", expected: ".")
    self.assertBasename("/frozen/..", expected: "..")
    self.assertBasename("/frozen/elsa", expected: "elsa")
    self.assertBasename("/frozen/elsa.txt", expected: "elsa.txt")
    self.assertBasename("/frozen/elsa/", expected: "elsa")
    self.assertBasename("/frozen/elsa//", expected: "elsa")

    self.assertBasename("//frozen", expected: "frozen")
  }

  private func assertBasename(_ path: String,
                              expected: String,
                              file: StaticString = #file,
                              line: UInt = #line) {
    let p = Path(string: path)
    let result = self.fileSystem.basename(path: p)

    XCTAssertEqual(result,
                   Filename(string: expected),
                   file: file,
                   line: line)
  }

  // MARK: - Basename without ext

  func test_basenameWithoutExt() {
    self.assertBasenameWithoutExt("elsa.txt", expected: "elsa")
    self.assertBasenameWithoutExt("/frozen/elsa.txt", expected: "elsa")
    self.assertBasenameWithoutExt("/frozen/elsa/", expected: "elsa")
    self.assertBasenameWithoutExt("/frozen/.", expected: ".")
    self.assertBasenameWithoutExt("/frozen/..", expected: "..")
    self.assertBasenameWithoutExt(".", expected: ".")
    self.assertBasenameWithoutExt("..", expected: "..")
    self.assertBasenameWithoutExt("", expected: "")
  }

  private func assertBasenameWithoutExt(_ path: String,
                                        expected: String,
                                        file: StaticString = #file,
                                        line: UInt = #line) {
    let p = Path(string: path)
    let result = self.fileSystem.basenameWithoutExt(path: p)

    XCTAssertEqual(result,
                   Filename(string: expected),
                   file: file,
                   line: line)
  }

  // MARK: - Dirname

  func test_dirname() {
    self.assertDirname("", expected: ".", isTop: true)
    self.assertDirname(".", expected: ".", isTop: true)
    self.assertDirname("..", expected: ".", isTop: true)
    self.assertDirname("/", expected: "/", isTop: true)
    self.assertDirname("///", expected: "/", isTop: true)

    self.assertDirname("frozen", expected: ".", isTop: true)
    self.assertDirname("frozen/", expected: ".", isTop: true)
    self.assertDirname("frozen//", expected: ".", isTop: true)
    self.assertDirname("frozen/.", expected: "frozen", isTop: false)
    self.assertDirname("frozen/..", expected: "frozen", isTop: false)
    self.assertDirname("frozen/elsa", expected: "frozen", isTop: false)
    self.assertDirname("frozen/elsa.txt", expected: "frozen", isTop: false)
    self.assertDirname("frozen/elsa/", expected: "frozen", isTop: false)
    self.assertDirname("frozen/elsa//", expected: "frozen", isTop: false)

    self.assertDirname("/frozen", expected: "/", isTop: true)
    self.assertDirname("/frozen/", expected: "/", isTop: true)
    self.assertDirname("/frozen//", expected: "/", isTop: true)
    self.assertDirname("/frozen/.", expected: "/frozen", isTop: false)
    self.assertDirname("/frozen/..", expected: "/frozen", isTop: false)
    self.assertDirname("/frozen/elsa", expected: "/frozen", isTop: false)
    self.assertDirname("/frozen/elsa.txt", expected: "/frozen", isTop: false)
    self.assertDirname("/frozen/elsa/", expected: "/frozen", isTop: false)
    self.assertDirname("/frozen/elsa//", expected: "/frozen", isTop: false)

    self.assertDirname("//frozen", expected: "/", isTop: true)
  }

  private func assertDirname(_ path: String,
                             expected: String,
                             isTop: Bool,
                             file: StaticString = #file,
                             line: UInt = #line) {
    let p = Path(string: path)
    let result = self.fileSystem.dirname(path: p)

    XCTAssertEqual(result.path,
                   Path(string: expected),
                   "Path",
                   file: file,
                   line: line)

    XCTAssertEqual(result.isTop,
                   isTop,
                   "is Top",
                   file: file,
                   line: line)
  }

  // MARK: - Extname

  func test_extname() {
    self.assertExtname("elsa.letitgo", expected: ".letitgo")
    self.assertExtname("frozen/elsa.letitgo", expected: ".letitgo")
    self.assertExtname("frozen", expected: "")
    self.assertExtname(".", expected: "")
    self.assertExtname("..", expected: "")
    self.assertExtname("", expected: "")
  }

  private func assertExtname(_ path: String,
                             expected: String,
                             file: StaticString = #file,
                             line: UInt = #line) {
    let p = Path(string: path)
    let result = self.fileSystem.extname(path: p)

    XCTAssertEqual(result,
                   expected,
                   "Path",
                   file: file,
                   line: line)

    let isNested = path.contains("/")
    if !isNested {
      let filename = Filename(string: path)
      let filenameResult = self.fileSystem.extname(filename: filename)

      XCTAssertEqual(filenameResult,
                     expected,
                     "Path",
                     file: file,
                     line: line)
    }
  }

  // MARK: - Add ext

  func test_addExt() {
    self.assertAddExt("elsa", ".letitgo", expected: "elsa.letitgo")
    self.assertAddExt("elsa", "letitgo", expected: "elsa.letitgo")
    self.assertAddExt("elsa.frozen", "letitgo", expected: "elsa.frozen.letitgo")
    self.assertAddExt(".", ".txt", expected: "..txt")
    self.assertAddExt("..", ".txt", expected: "...txt")
    self.assertAddExt("", ".txt", expected: ".txt")
  }

  private func assertAddExt(_ filename: String,
                            _ ext: String,
                            expected: String,
                            file: StaticString = #file,
                            line: UInt = #line) {
    let f = Filename(string: filename)
    let filenameResult = self.fileSystem.addExt(filename: f, ext: ext)

    XCTAssertEqual(filenameResult,
                   Filename(string: expected),
                   "Filename",
                   file: file,
                   line: line)

    let p = Path(string: filename)
    let pathResult = self.fileSystem.addExt(path: p, ext: ext)

    XCTAssertEqual(pathResult,
                   Path(string: expected),
                   "Path",
                   file: file,
                   line: line)
  }
}
