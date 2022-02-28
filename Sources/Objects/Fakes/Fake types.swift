// swiftlint:disable fatal_error_message

public struct PyObject {
  public init(ptr: RawPtr) {}
}

public struct PyType {

  public typealias DebugFn = (RawPtr) -> String
  public typealias DeinitializerFn = (RawPtr) -> Void

  public let name = ""
  public var debugFn: DebugFn { fatalError() }
  public var deinitializer: DeinitializerFn { fatalError() }
}

public struct PyDict {}
public struct PyBaseException {}
