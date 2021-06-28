import Foundation

extension StringImplementation {

  // MARK: - Lower case

  internal static func lowerCase(scalars: UnicodeScalars) -> String {
    var result = ""

    for scalar in scalars {
      let cased =  scalar.properties.lowercaseMapping
      result.append(contentsOf: cased)
    }

    return result
  }

  // MARK: - Upper case

  internal static func upperCase(scalars: UnicodeScalars) -> String {
    var result = ""

    for scalar in scalars {
      let cased =  scalar.properties.uppercaseMapping
      result.append(contentsOf: cased)
    }

    return result
  }

  // MARK: - Title case

  internal static func titleCase(scalars: UnicodeScalars) -> String {
    return self.titleCase(collection: scalars)
  }

  internal static func titleCase(data: Data) -> Data {
    let string = self.titleCase(collection: data)
    return Self.toData(string: string)
  }

  private static func titleCase<C: Collection>(
    collection: C
  ) -> String where C.Element: UnicodeScalarConvertible {
    var result = ""
    var isPreviousCased = false

    for element in collection {
      let scalar = element.asUnicodeScalar
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

  internal static func swapCase(scalars: UnicodeScalars) -> String {
    return self.swapCase(collection: scalars)
  }

  internal static func swapCase(data: Data) -> Data {
    let string = self.swapCase(collection: data)
    return Self.toData(string: string)
  }

  private static func swapCase<C: Collection>(
    collection: C
  ) -> String where C.Element: UnicodeScalarConvertible {
    var result = ""

    for element in collection {
      let scalar = element.asUnicodeScalar
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

  internal static func caseFold(scalars: UnicodeScalars) -> String {
    return self.caseFold(collection: scalars)
  }

  private static func caseFold<C: Collection>(
    collection: C
  ) -> String where C.Element: UnicodeScalarConvertible {
    var result = ""

    for element in collection {
      let scalar = element.asUnicodeScalar

      if let mapping = Unicode.caseFoldMapping[scalar.value] {
        result.append(mapping)
      } else {
        result.append(scalar)
      }
    }

    return result
  }

  // MARK: - Capitalize

  internal static func capitalize(scalars: UnicodeScalars) -> String {
    return self.capitalize(collection: scalars)
  }

  internal static func capitalize(data: Data) -> Data {
    let string = self.capitalize(collection: data)
    return Self.toData(string: string)
  }

  private static func capitalize<C: Collection>(
    collection: C
  ) -> String where C.Element: UnicodeScalarConvertible {
    // Capitalize only the first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    guard let first = collection.first else {
      return ""
    }

    let firstScalar = first.asUnicodeScalar
    var result = firstScalar.properties.titlecaseMapping

    for element in collection.dropFirst() {
      let scalar = element.asUnicodeScalar
      result.append(contentsOf: scalar.properties.lowercaseMapping)
    }

    return result
  }
}
