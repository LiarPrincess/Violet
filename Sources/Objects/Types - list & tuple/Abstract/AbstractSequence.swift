/* MARKER
/// Mixin with `tuple/list` methods.
///
/// All of the methods/properties should be prefixed with `_`.
/// DO NOT use them outside of the `tuple/list` objects!
internal protocol AbstractSequence: PyObject {

  /// Name of the type.
  /// Used mainly in error messages.
  static var _pythonTypeName: String { get }

  /// Main requirement.
  var elements: Elements { get }

  /// Create new Python object with specified elements.
  ///
  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  static func _toSelf(elements: Elements) -> Self

  /// Convert `object` to this type.
  ///
  /// - For `tuple` it should return `tuple`.
  /// - For `list` it should return `list`.
  ///
  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  static func _asSelf(object: PyObject) -> Self?
}

extension AbstractSequence {

  internal typealias Elements = [PyObject]
  internal typealias Index = Elements.Index
  internal typealias SubSequence = Elements.SubSequence

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal var _isEmpty: Bool {
    return self.elements.isEmpty
  }

  /// DO NOT USE! This is a part of `AbstractSequence` implementation.
  internal var _length: Int {
    return self.elements.count
  }
}

*/