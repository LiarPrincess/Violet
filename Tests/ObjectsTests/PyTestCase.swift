import XCTest
import Foundation
import VioletObjects

/// Test case that uses `Py`.
class PyTestCase: XCTestCase, PyDelegate, PyFileSystem {

  var config: PyConfig = {
    var result = PyConfig(
      arguments: Arguments(),
      environment: Environment(),
      executablePath: "executable_path",
      standardInput: PyFakeFileDescriptor(fd: 1),
      standardOutput: PyFakeFileDescriptor(fd: 2),
      standardError: PyFakeFileDescriptor(fd: 3)
    )

    // Avoid file system access:
    result.sys.prefix = "prefix"
    result.sys.path = ["path_entry_0", "path_entry_1"]

    return result
  }()

  private var isInsideInitialize = false

  // MARK: - Set up

  override func setUp() {
    super.setUp()

    self.isInsideInitialize = true
    Py.initialize(
      config: self.config,
      delegate: self,
      fileSystem: self
    )
    self.isInsideInitialize = false
  }

  // MARK: - Tear down

  override func tearDown() {
    super.tearDown()
    Py.destroy()
  }

  // MARK: - PyDelegate

  var frame: PyFrame? {
    unreachable()
  }

  var currentlyHandledException: PyBaseException? {
    unreachable()
  }

  // swiftlint:disable:next function_parameter_count
  func eval(name: PyString?,
            qualname: PyString?,
            code: PyCode,

            args: [PyObject],
            kwargs: PyDict?,
            defaults: [PyObject],
            kwDefaults: PyDict?,

            globals: PyDict,
            locals: PyDict,
            closure: PyTuple?) -> PyResult<PyObject> {
    unreachable()
  }

  // MARK: - PyFileSystem

  var currentWorkingDirectory = "cwd"

  func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    unreachable()
  }

  func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    unreachable()
  }

  func stat(fd: Int32) -> FileStatResult {
    unreachable()
  }

  func stat(path: String) -> FileStatResult {
    unreachable()
  }

  func listDir(fd: Int32) -> ListDirResult {
    unreachable()
  }

  func listDir(path: String) -> ListDirResult {
    unreachable()
  }

  func read(fd: Int32) -> PyResult<Data> {
    unreachable()
  }

  func read(path: String) -> PyResult<Data> {
    unreachable()
  }

  func basename(path: String) -> String {
    unreachable()
  }

  func dirname(path: String) -> DirnameResult {
    unreachable()
  }

  func join(paths: String...) -> String {
    unreachable()
  }
}
