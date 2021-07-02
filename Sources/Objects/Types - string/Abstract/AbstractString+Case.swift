extension AbstractString {

  // MARK: - Lower case

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _lowerCase() -> SwiftType {
    var builder = Builder(capacity: self.elements.count)

    for element in self.elements {
      let mapping = Self._lowercaseMapping(element: element)
      builder.append(contentsOf: mapping)
    }

    let result = builder.finalize()
    return Self._toObject(result: result)
  }

  // MARK: - Upper case

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _upperCase() -> SwiftType {
    var builder = Builder(capacity: self.elements.count)

    for element in self.elements {
      let mapping = Self._uppercaseMapping(element: element)
      builder.append(contentsOf: mapping)
    }

    let result = builder.finalize()
    return Self._toObject(result: result)
  }

  // MARK: - Title case

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _titleCase() -> String {
    var result = ""
    var isPreviousCased = false

    for element in self.elements {
      let scalar = Self._asUnicodeScalar(element: element)
      let properties = scalar.properties

      switch properties.generalCategory {
      case .lowercaseLetter:
        if !isPreviousCased {
          result.append(properties.titlecaseMapping)
        } else {
          result.append(scalar)
        }
        isPreviousCased = true

      case .uppercaseLetter, .titlecaseLetter:
        if isPreviousCased {
          result.append(properties.lowercaseMapping)
        } else {
          result.append(scalar)
        }
        isPreviousCased = true

      default:
        isPreviousCased = false
        result.append(scalar)
      }
    }

    return result
  }

  // MARK: - Swap case

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _swapCase() -> String {
    var result = ""

    for element in self.elements {
      let scalar = Self._asUnicodeScalar(element: element)
      let properties = scalar.properties

      if properties.isLowercase {
        result.append(properties.uppercaseMapping)
      } else if properties.isUppercase {
        result.append(properties.lowercaseMapping)
      } else {
        result.append(scalar)
      }
    }

    return result
  }

  // MARK: - Case fold

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _caseFold() -> String {
    var result = ""

    for element in self.elements {
      let scalar = Self._asUnicodeScalar(element: element)

      if let mapping = Unicode.caseFoldMapping[scalar.value] {
        result.append(mapping)
      } else {
        result.append(scalar)
      }
    }

    return result
  }

  // MARK: - Capitalize

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _capitalize() -> String {
    // Capitalize only the first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    guard let first = self.elements.first else {
      return ""
    }

    let firstScalar = Self._asUnicodeScalar(element: first)
    var result = firstScalar.properties.titlecaseMapping

    for element in self.elements.dropFirst() {
      let scalar = Self._asUnicodeScalar(element: element)
      result.append(contentsOf: scalar.properties.lowercaseMapping)
    }

    return result
  }
}
