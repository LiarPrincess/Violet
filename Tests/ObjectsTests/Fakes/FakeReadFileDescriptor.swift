import Foundation
import VioletCore
import VioletObjects

class FakeReadFileDescriptor: FileDescriptorType {

  let raw: Int32

  init(fd: Int32) {
    self.raw = fd
  }

  func readLine() -> PyResult<Data> {
    shouldNotBeCalled()
  }

  func readToEnd() -> PyResult<Data> {
    shouldNotBeCalled()
  }

  func read(upToCount count: Int) -> PyResult<Data> {
    shouldNotBeCalled()
  }

  func write<T>(contentsOf data: T) -> PyResult<PyNone> where T: DataProtocol {
    shouldNotBeCalled()
  }

  func flush() -> PyResult<PyNone> {
    shouldNotBeCalled()
  }

  func offset() -> PyResult<UInt64> {
    shouldNotBeCalled()
  }

  func seekToEnd() -> PyResult<UInt64> {
    shouldNotBeCalled()
  }

  func seek(toOffset offset: UInt64) -> PyResult<PyNone> {
    shouldNotBeCalled()
  }

  func close() -> PyResult<PyNone> {
    shouldNotBeCalled()
  }
}
