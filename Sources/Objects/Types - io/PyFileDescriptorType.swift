import Foundation

public protocol PyFileDescriptorType {

  /// Raw descriptor value.
  /// It should be set to `-1` when the file is closed.
  var raw: Int32 { get }

  func readLine(_ py: Py) -> PyResultGen<Data>
  func readToEnd(_ py: Py) -> PyResultGen<Data>
  func read(_ py: Py, count: Int) -> PyResultGen<Data>

  func write<T: DataProtocol>(_ py: Py, data: T) -> PyBaseException?
  func flush(_ py: Py) -> PyBaseException?

  func offset(_ py: Py) -> PyResultGen<UInt64>

  @discardableResult
  func seekToEnd(_ py: Py) -> PyResultGen<UInt64>
  func seek(_ py: Py, offset: UInt64) -> PyBaseException?

  func close(_ py: Py) -> PyBaseException?
}
