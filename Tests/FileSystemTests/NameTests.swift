import XCTest
@testable import FileSystem

class NameTests: FileSystemTest {

  // MARK: - Basename

  func test_basename() {
    self.assertBasename(path: "/frozen/elsa.txt", expected: "elsa.txt")
    self.assertBasename(path: "/frozen/.elsa", expected: ".elsa")
    self.assertBasename(path: "/frozen/elsa/", expected: "elsa")
    self.assertBasename(path: "/frozen/.", expected: ".")
    self.assertBasename(path: "/frozen/..", expected: "..")
    self.assertBasename(path: "/frozen", expected: "frozen")
    self.assertBasename(path: "frozen", expected: "frozen")
    self.assertBasename(path: ".", expected: ".")
    self.assertBasename(path: "..", expected: "..")
    self.assertBasename(path: "/", expected: "/")
    self.assertBasename(path: "//frozen", expected: "frozen")
    self.assertBasename(path: "", expected: "")
  }

  private func assertBasename(path: String,
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

  // MARK: - Basename without extension

  func test_basenameWithoutExtension() {
    self.assertBasenameWithoutExtension(path: "elsa.txt", expected: "elsa")
    self.assertBasenameWithoutExtension(path: "/frozen/elsa.txt", expected: "elsa")
    self.assertBasenameWithoutExtension(path: "/frozen/elsa/", expected: "elsa")
    self.assertBasenameWithoutExtension(path: "/frozen/.", expected: ".")
    self.assertBasenameWithoutExtension(path: "/frozen/..", expected: "..")
    self.assertBasenameWithoutExtension(path: ".", expected: ".")
    self.assertBasenameWithoutExtension(path: "..", expected: "..")
    self.assertBasenameWithoutExtension(path: "", expected: "")
  }

  private func assertBasenameWithoutExtension(path: String,
                                              expected: String,
                                              file: StaticString = #file,
                                              line: UInt = #line) {
    let p = Path(string: path)
    let result = self.fileSystem.basenameWithoutExtension(path: p)

    XCTAssertEqual(result,
                   Filename(string: expected),
                   file: file,
                   line: line)
  }

  // MARK: - Dirname

  func test_dirname() {
    self.assertDirname(path: "/frozen/elsa.txt", expected: "/frozen", isTop: false)
    self.assertDirname(path: "/frozen/.elsa", expected: "/frozen", isTop: false)
    self.assertDirname(path: "/frozen/elsa/", expected: "/frozen", isTop: false)
    self.assertDirname(path: "/frozen/.", expected: "/frozen", isTop: false)
    self.assertDirname(path: "/frozen/..", expected: "/frozen", isTop: false)
    self.assertDirname(path: "/frozen", expected: "/", isTop: true)
    self.assertDirname(path: "frozen", expected: ".", isTop: true)
    self.assertDirname(path: ".", expected: ".", isTop: true)
    self.assertDirname(path: "..", expected: ".", isTop: true)
    self.assertDirname(path: "/", expected: "/", isTop: true)
    self.assertDirname(path: "//frozen", expected: "/", isTop: true)
    self.assertDirname(path: "", expected: ".", isTop: true)
  }

  private func assertDirname(path: String,
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
    self.assertExtname(path: "elsa.letitgo", expected: ".letitgo")
    self.assertExtname(path: "frozen/elsa.letitgo", expected: ".letitgo")
    self.assertExtname(path: "frozen", expected: "")
    self.assertExtname(path: ".", expected: "")
    self.assertExtname(path: "..", expected: "")
    self.assertExtname(path: "", expected: "")
  }

  private func assertExtname(path: String,
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
    self.assertAddExt(filename: "elsa", ext: ".letitgo", expected: "elsa.letitgo")
    self.assertAddExt(filename: "elsa", ext: "letitgo", expected: "elsa.letitgo")
    self.assertAddExt(filename: "elsa.frozen",
                      ext: "letitgo",
                      expected: "elsa.frozen.letitgo")
    self.assertAddExt(filename: ".", ext: ".txt", expected: "..txt")
    self.assertAddExt(filename: "..", ext: ".txt", expected: "...txt")
    self.assertAddExt(filename: "", ext: ".txt", expected: ".txt")
  }

  private func assertAddExt(filename: String,
                            ext: String,
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
