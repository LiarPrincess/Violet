import Foundation

internal protocol HasCustomGetMethod {
  func getMethod(_ py: Py,
                 selector: PyString,
                 allowsCallableFromDict: Bool) -> Py.GetMethodResult
}
