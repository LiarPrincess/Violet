import Foundation
import VioletCore
import VioletObjects

class FakeReadFileDescriptor: PyFileDescriptorType {

  let raw: Int32

  init(fd: Int32) {
    self.raw = fd
  }

  func readLine(_ py: Py) -> PyResultGen<Data> {
    shouldNotBeCalled()
  }

  func readToEnd(_ py: Py) -> PyResultGen<Data> {
    shouldNotBeCalled()
  }

  func read(_ py: Py, count: Int) -> PyResultGen<Data> {
    shouldNotBeCalled()
  }

  func write<T: DataProtocol>(_ py: Py, data: T) -> PyBaseException? {
    shouldNotBeCalled()
  }

  func flush(_ py: Py) -> PyBaseException? {
    shouldNotBeCalled()
  }

  func offset(_ py: Py) -> PyResultGen<UInt64> {
    shouldNotBeCalled()
  }

  func seekToEnd(_ py: Py) -> PyResultGen<UInt64> {
    shouldNotBeCalled()
  }

  func seek(_ py: Py, offset: UInt64) -> PyBaseException? {
    shouldNotBeCalled()
  }

  func close(_ py: Py) -> PyBaseException? {
    shouldNotBeCalled()
  }
}
