import XCTest
import Foundation
import BigInt
import FileSystem
@testable import VioletObjects

/// Test case that uses `Py`.
class PyTestCase: XCTestCase {

  var config: PyConfig = {
    var result = PyConfig(
      arguments: Arguments(),
      environment: Environment(),
      executablePath: Path(string: "EXECUTABLE_PATH"),
      standardInput: FakeReadFileDescriptor(fd: 1),
      standardOutput: FakeWriteFileDescriptor(fd: 2),
      standardError: FakeWriteFileDescriptor(fd: 3)
    )

    // Avoid file system access:
    result.sys.prefix = Path(string: "PREFIX")
    result.sys.path = [
      Path(string: "PATH_ENTRY_0"),
      Path(string: "PATH_ENTRY_1")
    ]

    return result
  }()

  // swiftlint:disable:next weak_delegate
  var delegate = FakeDelegate()
  var fileSystem = FakeFileSystem()

  private var createdPy = [Py]()
  private var destroyedPy = [Py]()

  // MARK: - Set up

  override func setUp() {
    super.setUp()
    self.createdPy = []
    self.destroyedPy = []
  }

  // MARK: - Tear down

  override func tearDown() {
    super.tearDown()

    for py in self.createdPy {
      let wasDestroyed = self.destroyedPy.contains { $0.ptr === py.ptr }
      if !wasDestroyed {
        self.destroyPy(py)
      }
    }
  }

  // MARK: - Py

  func createPy() -> Py {
    let py = Py(config: self.config,
                delegate: self.delegate,
                fileSystem: self.fileSystem)

    self.createdPy.append(py)
    return py
  }

  func destroyPy(_ py: Py) {
    py.destroy()
    self.destroyedPy.append(py)
  }
}
