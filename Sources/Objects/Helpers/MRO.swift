// TODO: Do we have custom mro? (mro_invoke(PyTypeObject *type))
internal enum LinearizationResult {
  case value(MRO)
  case typeError(String)
  case valueError(String)
}

/// Method Resolution Order
internal struct MRO {
  internal let baseClasses: [PyType]
  internal let resolutionOrder: [PyType]

  // 'private' so that the only way to create MRO is to go through
  // one of our static methods.
  private init(baseClasses: [PyType], resolutionOrder: [PyType]) {
    assert(baseClasses.allSatisfy { b in resolutionOrder.contains { $0 === b } })
    self.baseClasses = baseClasses
    self.resolutionOrder = resolutionOrder
  }

  /// Create (trivial) C3 linearisation using given class.
  /// [doc](https://www.python.org/download/releases/2.3/mro/)
  ///
  /// It will not take into account `self` (which should be 1st in MRO)!
  internal static func linearize(baseClass: PyType) -> MRO {
    let mro = baseClass.getMRORaw()
    return MRO(baseClasses: [baseClass], resolutionOrder: mro)
  }

  /// Create C3 linearisation of given base classes.
  /// /// [doc](https://www.python.org/download/releases/2.3/mro/)
  ///
  /// It will not take into account `self` (which should be 1st in MRO)!
  internal static func linearize(baseClasses: [PyObject]) -> LinearizationResult {
    guard let baseTypes = asPyTypes(baseClasses) else {
      return .typeError("bases must be types")
    }

    return MRO.linearize(baseClasses: baseTypes)
  }

  internal static func linearize(baseClasses: [PyType]) -> LinearizationResult {
    // No base classes? Empty MRO.
    if baseClasses.isEmpty {
      return .value(MRO(baseClasses: [], resolutionOrder: []))
    }

    // Fast path: if there is a single base, constructing the MRO is trivial.
    if baseClasses.count == 1 {
      return .value(MRO.linearize(baseClass: baseClasses[0]))
    }

    // Sanity check.
    if let duplicate = MRO.getDuplicateBaseClass(baseClasses) {
      return .typeError("duplicate base class \(duplicate.getQualname())")
    }

    // Perform C3 linearisation.
    var result = [PyType]()
    let mros = baseClasses.map { $0.getMRORaw() } + [baseClasses]

    while hasAnyClassRemaining(mros) {
      guard let base = getNextBase(mros) else {
        let msg = "Cannot create a consistent method resolution order (MRO) for bases"
        return .valueError(msg)
      }

      result.append(base)

      // Not the best performance, but that does not matter.
      for var m in mros {
        m.removeAll { $0 === base }
      }
    }

    return .value(MRO(baseClasses: baseClasses, resolutionOrder: result))
  }

  // swiftlint:disable:next discouraged_optional_collection
  private static func asPyTypes(_ baseClasses: [PyObject]) -> [PyType]? {
    var result = [PyType]()
    for base in baseClasses {
      switch base as? PyType {
      case let .some(t): result.append(t)
      case .none: return .none
      }
    }
    return result
  }

  private static func getDuplicateBaseClass(_ baseClasses: [PyType]) -> PyType? {
    // This is quadratic, but we don't expect many (>100) base classes.
    for (index, base) in baseClasses.enumerated() {
      let upToCurrent = baseClasses[0..<index]

      let isDuplicate = upToCurrent.contains { $0 === base }
      if isDuplicate {
        return base
      }
    }

    return nil
  }

  private static func hasAnyClassRemaining(_ mros: [[PyType]]) -> Bool {
    return mros.contains { classList in classList.any }
  }

  private static func getNextBase(_ mros: [[PyType]]) -> PyType? {
    for baseClassMro in mros {
      // Check if we have already fully processed this list
      guard let head = baseClassMro.first else {
        continue
      }

      // Check if this class is in any tail
      let isInAnyTail = mros.contains { classList in
        let tail = classList.dropFirst()
        return tail.contains { $0 === head }
      }

      if isInAnyTail {
        continue
      }

      return head
    }

    return nil
  }
}
