/// Common things for all of the Python objects.
public protocol PyObjectMixin: CustomStringConvertible {
  /// Pointer to an object.
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

  /// Runtime type of this Python object.
  public var type: PyType {
    let object = self.asObject
    return object.type
  }

  /// [Convenience] Name of the runtime type of this Python object.
  public var typeName: String {
    let type = self.type
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
    let object = self.asObject

    let mirror = object.type.debugFn(self.ptr)
    var result = mirror.swiftType
    result.append("(")
    result.append(self.typeName) // python type

    let hasDescriptionLock = object.flags.isSet(.descriptionLock)
    if hasDescriptionLock {
      result.append(", RECURSIVE ENTRY, ptr: ")
      result.append(String(describing: self.ptr))
      result.append(")")
      return result
    }

    let flagsString = String(describing: object.flags)
    if flagsString != "[]" {
      result.append(", flags: ")
      result.append(flagsString)
    }

    object.flags.set(.descriptionLock)
    defer { object.flags.unset(.descriptionLock) }

    for property in mirror.properties where property.includeInDescription {
      self.append(string: &result, property: property)
    }

    result.append(")")
    return result
  }

  // swiftlint:disable:next cyclomatic_complexity function_body_length
  private func append(string: inout String, property: PyObject.DebugMirror.Property) {
    string.append(", ")
    string.append(property.name)
    string.append(": ")

    // ============
    // === Type ===
    // ============

    // If we go with 'func append(type: PyType)' then Swift 5.3 will fail to compile.
    func appendType(_ type: PyType) {
      string.append(type.name)
    }

    if let type = property.value as? PyType {
      appendType(type)
      return
    }

    if let types = property.value as? [PyType] {
      string.append("[")
      for (index, type) in types.enumerated() {
        if index != 0 {
          string.append(", ")
        }

        appendType(type)
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

    func appendString(_ s: String) {
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
      appendString(s)
      return
    }

    if let s = property.value as? PyString {
      appendString(s.value)
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
        string.append("…")
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
