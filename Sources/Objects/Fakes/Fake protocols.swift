import Foundation

public struct FunctionWrapper { }

internal protocol HasCustomGetMethod {
  func getMethod(_ py: Py,
                 selector: PyString,
                 allowsCallableFromDict: Bool) -> Py.GetMethodResult
}

internal protocol AbstractBuiltinFunction {}
