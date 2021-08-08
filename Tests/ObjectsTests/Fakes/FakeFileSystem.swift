import Foundation
import FileSystem
import VioletCore
import VioletObjects

class FakeFileSystem: PyFileSystem {

  var currentWorkingDirectory = "cwd"

  func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    shouldNotBeCalled()
  }

  func open(path: String, mode: FileMode) -> PyResult<FileDescriptorType> {
    shouldNotBeCalled()
  }

  func stat(fd: Int32) -> PyFileSystem_StatResult {
    shouldNotBeCalled()
  }

  func stat(path: String) -> PyFileSystem_StatResult {
    shouldNotBeCalled()
  }

  func readdir(fd: Int32) -> PyFileSystem_ReaddirResult {
    shouldNotBeCalled()
  }

  func readdir(path: String) -> PyFileSystem_ReaddirResult {
    shouldNotBeCalled()
  }

  func read(fd: Int32) -> PyResult<Data> {
    shouldNotBeCalled()
  }

  func read(path: String) -> PyResult<Data> {
    shouldNotBeCalled()
  }

  func basename(path: String) -> String {
    shouldNotBeCalled()
  }

  func dirname(path: String) -> FileSystem.DirnameResult {
    shouldNotBeCalled()
  }

  func join(paths: String...) -> String {
    shouldNotBeCalled()
  }
}
