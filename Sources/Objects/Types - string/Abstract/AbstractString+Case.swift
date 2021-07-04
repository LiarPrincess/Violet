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
  internal func _titleCase() -> SwiftType {
    var builder = Builder(capacity: self.elements.count)
    var isPreviousCased = false

    for element in self.elements {
      if isPreviousCased {
        let mapping = Self._lowercaseMapping(element: element)
        builder.append(contentsOf: mapping)
      } else {
        let mapping = Self._titlecaseMapping(element: element)
        builder.append(contentsOf: mapping)
      }

      isPreviousCased = Self._isCased(element: element)
    }

    let result = builder.finalize()
    return Self._toObject(result: result)
  }

  // MARK: - Swap case

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _swapCase() -> SwiftType {
    var builder = Builder(capacity: self.elements.count)

    for element in self.elements {
      let isCased = Self._isCased(element: element)

      if isCased && Self._isLower(element: element) {
        let mapping = Self._uppercaseMapping(element: element)
        builder.append(contentsOf: mapping)
      } else if isCased && Self._isUpper(element: element) {
        let mapping = Self._lowercaseMapping(element: element)
        builder.append(contentsOf: mapping)
      } else {
        // (is not cased OR is cased but not lower or upper)
        builder.append(element: element)
      }
    }

    let result = builder.finalize()
    return Self._toObject(result: result)
  }

  // MARK: - Capitalize

  /// DO NOT USE! This is a part of `AbstractString` implementation.
  internal func _capitalize() -> SwiftType {
    // Capitalize only the first scalar:
    // list("e\u0301".capitalize()) -> ['E', '́']

    var builder = Builder(capacity: self.elements.count)

    guard let first = self.elements.first else {
      let result = builder.finalize()
      return Self._toObject(result: result)
    }

    let firstUpper = Self._uppercaseMapping(element: first)
    builder.append(contentsOf: firstUpper)

    for element in self.elements.dropFirst() {
      let mapping = Self._lowercaseMapping(element: element)
      builder.append(contentsOf: mapping)
    }

    let result = builder.finalize()
    return Self._toObject(result: result)
  }
}
