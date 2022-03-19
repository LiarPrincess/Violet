import Foundation
import VioletCore
import VioletObjects

class FakeWriteFileDescriptor: FileDescriptorType {

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

  func write<T: DataProtocol>(contentsOf data: T) -> PyBaseException? {
    shouldNotBeCalled()
  }

  func flush() -> PyBaseException? {
    shouldNotBeCalled()
  }

  func offset() -> PyResult<UInt64> {
    shouldNotBeCalled()
  }

  func seekToEnd() -> PyResult<UInt64> {
    shouldNotBeCalled()
  }

  func seek(toOffset offset: UInt64) -> PyBaseException? {
    shouldNotBeCalled()
  }

  func close() -> PyBaseException? {
    shouldNotBeCalled()
  }
}
