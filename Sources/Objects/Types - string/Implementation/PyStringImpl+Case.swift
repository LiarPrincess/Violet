
// MARK: - Case

extension PyStringImpl {

  internal func titleCasedString() -> String {
    var result = ""
    var isPreviousCased = false

    for element in self.scalars {
      let scalar = Self.toUnicodeScalar(element)
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

  internal func swapCaseString() -> String {
    var result = ""
    for element in self.scalars {
      let scalar = Self.toUnicodeScalar(element)
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

  internal func caseFoldString() -> String {
    var result = ""
    for element in self.scalars {
      let scalar = Self.toUnicodeScalar(element)
      if let mapping = Unicode.caseFoldMapping[scalar.value] {
        result.append(mapping)
      } else {
        result.append(scalar)
      }
    }
    return result
  }

  internal func capitalizeString() -> String {
    // Capitalize only first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    guard let first = self.scalars.first else {
      return ""
    }

    let firstScalar = Self.toUnicodeScalar(first)
    var result = firstScalar.properties.titlecaseMapping

    for element in self.scalars.dropFirst() {
      let scalar = Self.toUnicodeScalar(element)
      result.append(contentsOf: scalar.properties.lowercaseMapping)
    }

    return result
  }
}
