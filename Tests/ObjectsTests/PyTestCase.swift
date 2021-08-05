import XCTest
import Foundation
import VioletObjects

/// Test case that uses `Py`.
class PyTestCase: XCTestCase {

  var config: PyConfig = {
    var result = PyConfig(
      arguments: Arguments(),
      environment: Environment(),
      executablePath: "executable_path",
      standardInput: FakeReadFileDescriptor(fd: 1),
      standardOutput: FakeWriteFileDescriptor(fd: 2),
      standardError: FakeWriteFileDescriptor(fd: 3)
    )

    // Avoid file system access:
    result.sys.prefix = "prefix"
    result.sys.path = ["path_entry_0", "path_entry_1"]

    return result
  }()

  // swiftlint:disable:next weak_delegate
  var delegate = FakeDelegate()
  var fileSystem = FakeFileSystem()

  // MARK: - Set up

  override func setUp() {
    super.setUp()

    Py.initialize(config: self.config,
                  delegate: self.delegate,
                  fileSystem: self.fileSystem)
  }

  // MARK: - Tear down

  override func tearDown() {
    super.tearDown()
    Py.destroy()
  }
}
