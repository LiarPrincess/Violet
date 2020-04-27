import Foundation
import VioletObjects

class PyFakeFileDescriptor: FileDescriptorType {

  let raw: Int32

  init(fd: Int32) {
    self.raw = fd
  }

  func readToEnd() -> PyResult<Data> {
    unreachable()
  }

  func read(upToCount count: Int) -> PyResult<Data> {
    unreachable()
  }

  func write<T>(contentsOf data: T) -> PyResult<PyNone> where T : DataProtocol {
    unreachable()
  }

  func synchronize() -> PyResult<PyNone> {
    unreachable()
  }

  func offset() -> PyResult<UInt64> {
    unreachable()
  }

  func seekToEnd() -> PyResult<UInt64> {
    unreachable()
  }

  func seek(toOffset offset: UInt64) -> PyResult<PyNone> {
    unreachable()
  }

  func close() -> PyResult<PyNone> {
    unreachable()
  }
}
