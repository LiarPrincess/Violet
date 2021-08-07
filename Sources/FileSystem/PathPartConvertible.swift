/// This object can be used as a part of a `Path`.
///
/// Used inside `FileSystem.join(path:element:)`.
public protocol PathPartConvertible {
  var pathPart: String { get }
}

extension String: PathPartConvertible {
  public var pathPart: String {
    return self
  }
}
