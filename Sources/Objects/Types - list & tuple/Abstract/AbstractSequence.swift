/// Mixin with `tuple/list` methods.
///
/// DO NOT use them outside of the `tuple/list` objects!
internal protocol AbstractSequence: PyObjectMixin {

  /// Name of the type.
  /// Used mainly in error messages.
  static var typeName: String { get }

  /// Main requirement.
  var elements: Elements { get }

  /// Create new Python object with specified elements.
  static func newObject(_ py: Py, elements: Elements) -> Self

  /// Convert `object` to this type.
  ///
  /// - For `tuple` it should return `tuple`.
  /// - For `list` it should return `list`.
  static func downcast(_ py: Py, _ object: PyObject) -> Self?

  /// Create an error when the `zelf` argument is not valid.
  static func invalidZelfArgument(_ py: Py,
                                  _ object: PyObject,
                                  _ fnName: String) -> PyResult<PyObject>
}

extension AbstractSequence {

  internal typealias Elements = [PyObject]
  internal typealias Index = Elements.Index
  internal typealias SubSequence = Elements.SubSequence

  internal var isEmpty: Bool {
    return self.elements.isEmpty
  }

  internal var count: Int {
    return self.elements.count
  }
}
