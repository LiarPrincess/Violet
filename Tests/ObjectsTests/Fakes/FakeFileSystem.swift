import Foundation
import FileSystem
import VioletCore
import VioletObjects

class FakeFileSystem: PyFileSystem {

  var currentWorkingDirectory = Path(string: "cwd")

  func open(fd: Int32, mode: FileMode) -> PyResult<FileDescriptorType> {
    shouldNotBeCalled()
  }

  func open(path: Path, mode: FileMode) -> PyResult<FileDescriptorType> {
    shouldNotBeCalled()
  }

  func stat(fd: Int32) -> PyFileSystemStatResult {
    shouldNotBeCalled()
  }

  func stat(path: Path) -> PyFileSystemStatResult {
    shouldNotBeCalled()
  }

  func readdir(fd: Int32) -> PyFileSystemReaddirResult {
    shouldNotBeCalled()
  }

  func readdir(path: Path) -> PyFileSystemReaddirResult {
    shouldNotBeCalled()
  }

  func read(fd: Int32) -> PyResult<Data> {
    shouldNotBeCalled()
  }

  func read(path: Path) -> PyResult<Data> {
    shouldNotBeCalled()
  }

  func basename(path: Path) -> Filename {
    shouldNotBeCalled()
  }

  func dirname(path: Path) -> FileSystem.DirnameResult {
    shouldNotBeCalled()
  }

  func join(path: Path, element: PathPartConvertible) -> Path {
    shouldNotBeCalled()
  }

  func join<T: PathPartConvertible>(path: Path, elements: T...) -> Path {
    shouldNotBeCalled()
  }

  func join<T: PathPartConvertible>(path: Path, elements: [T]) -> Path {
    shouldNotBeCalled()
  }
}
