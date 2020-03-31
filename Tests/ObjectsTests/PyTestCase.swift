import XCTest
import Objects

// swiftlint:disable weak_delegate

/// Test case that uses `Py`.
class PyTestCase: XCTestCase {

  let arguments = Arguments()
  let environment = Environment()
  let executablePath = "executable_path"

  lazy var config = PyConfig(
    arguments: self.arguments,
    environment: self.environment,
    executablePath: self.executablePath,
    standardInput: PyFakeFileDescriptor(fd: 1),
    standardOutput: PyFakeFileDescriptor(fd: 2),
    standardError: PyFakeFileDescriptor(fd: 3)
  )

  let delegate = PyFakeDelegate()
  let fileSystem = PyFakeFileSystem(cwd: "cwd")

  override func setUp() {
    super.setUp()
    Py.initialize(
      config: self.config,
      delegate: self.delegate,
      fileSystem: self.fileSystem
    )
  }

  override func tearDown() {
    super.tearDown()
    Py.destroy()
  }
}
