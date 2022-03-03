import Foundation

public struct FunctionWrapper { }

internal protocol HasCustomGetMethod {
  func getMethod(_ py: Py,
                 selector: PyString,
                 allowsCallableFromDict: Bool) -> Py.GetMethodResult
}

internal protocol AbstractSequence {}
internal protocol AbstractDictViewIterator {}
internal protocol AbstractDictView {}
internal protocol AbstractSet {}
internal protocol AbstractString {}
internal protocol AbstractBytes {}
internal protocol AbstractBuiltinFunction {}
