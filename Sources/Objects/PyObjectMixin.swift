/// Common things for all of the Python objects.
public protocol PyObjectMixin: CustomStringConvertible {
  /// Pointer to and object.
  ///
  /// Each object starts with the same fields as `PyObject`.
  var ptr: RawPtr { get }
}

extension PyObjectMixin {

  // MARK: - Header

  /// [Convenience] Convert this object to `PyObject`.
  public var asObject: PyObject {
    return PyObject(ptr: self.ptr)
  }

  /// [Convenience] Name of the runtime type of this Python object.
  public var typeName: String {
    let object = self.asObject
    let type = object.type
    return type.name
  }

  // MARK: - Repr

  /// This flag is used to control infinite recursion
  /// in `repr`, `str`, `print` etc.
  internal var hasReprLock: Bool {
    let object = self.asObject
    return object.flags.isSet(.reprLock)
  }

  /// Set, execute `body` and then unset `reprLock` flag
  /// (the one that is used to control recursion in `repr`, `str`, `print` etc).
  internal func withReprLock<T>(body: () -> T) -> T {
    let object = self.asObject

    // We do not need 'defer' because 'body' is not throwing
    object.flags.set(.reprLock)
    let result = body()
    object.flags.unset(.reprLock)
    return result
  }

  // MARK: - Description

  public var description: String {
    let ptr = self.ptr
    let object = PyObject(ptr: ptr)
    let type = object.type
    let mirror = type.debugFn(self.ptr)

    var result = mirror.swiftType
    result.append("(")
    result.append(self.typeName) // python type

    let flagsString = String(describing: object.flags)
    if flagsString != "[]" {
      result.append(", flags: ")
      result.append(flagsString)
    }

    let hasDescriptionLock = object.flags.isSet(.descriptionLock)
    if hasDescriptionLock {
      result.append(", RECURSIVE ENTRY)")
      return result
    }

    object.flags.set(.descriptionLock)
    defer { object.flags.unset(.descriptionLock) }

    for property in mirror.properties where property.includeInShortDescription {
      self.append(string: &result, property: property)
    }

    result.append(")")
    return result
  }

  private func append(string: inout String, property: PyObject.DebugMirror.Property) {
    string.append(", ")
    string.append(property.name)
    string.append(": ")

    // ============
    // === Type ===
    // ============

    func append(type: PyType) {
      string.append(type.name)
    }

    if let type = property.value as? PyType {
      append(type: type)
      return
    }

    if let optionalType = property.value as? Optional<PyType> {
      if let type = optionalType {
        append(type: type)
      } else {
        string.append("nil")
      }
      return
    }

    if let types = property.value as? Array<PyType> {
      string.append("[")
      for (index, type) in types.enumerated() {
        if index != 0 {
          string.append(", ")
        }

        append(type: type)
      }

      string.append("]")
      return
    }

    // ===========
    // === Int ===
    // ===========

    if let int = property.value as? PyInt {
      string.append(String(describing: int.value))
      return
    }

    // ==============
    // === String ===
    // ==============

    func append(string s: String) {
      // This will not work on optional string, but whatever.
      string.append("'")

      var index = 0
      for char in s {
        switch char {
        case "\n": string.append("\\n")
        default: string.append(char)
        }

        index += 1
        if index == 50 {
          string.append("...")
          break
        }
      }

      string.append("'")
    }

    if let s = property.value as? String {
      append(string: s)
      return
    }

    if let s = property.value as? PyString {
      append(string: s.value)
      return
    }

    // =============
    // === Array ===
    // =============

    if let array = property.value as? [PyObject] {
      let maxCount = 5

      string.append("[")
      for (index, object) in array.prefix(maxCount).enumerated() {
        if index != 0 {
          string.append(", ")
        }

        let objectString = String(describing: object)
        string.append(objectString)
      }

      if array.count >= maxCount {
        string.append("...")
      }

      string.append("]")
      return
    }

    // =============
    // === Other ===
    // =============

    let description = String(describing: property.value)

    if description.starts(with: "Optional(") {
      // Remove 'Optional(' prefix and ')' suffix.
      let startIndex = description.index(description.startIndex, offsetBy: 9)
      let endIndex = description.index(description.endIndex, offsetBy: -1)
      string.append(contentsOf: description[startIndex..<endIndex])
      return
    }

    string.append(description)
  }
}
