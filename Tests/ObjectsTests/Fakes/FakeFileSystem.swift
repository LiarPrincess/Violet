import Foundation
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

  func listdir(fd: Int32) -> PyFileSystem_ListdirResult {
    shouldNotBeCalled()
  }

  func listdir(path: String) -> PyFileSystem_ListdirResult {
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

  func dirname(path: String) -> PyFileSystem_DirnameResult {
    shouldNotBeCalled()
  }

  func join(paths: String...) -> String {
    shouldNotBeCalled()
  }
}
