import Objects
import Foundation

extension PyInstance {

  internal func newOSError(errno: Int32) -> PyOSError? {
    guard let cStr = strerror(errno) else {
      return nil
    }

    let msg = String(cString: cStr)
    return Py.newOSError(msg: msg)
  }
}
