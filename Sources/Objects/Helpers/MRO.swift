import Foundation
import VioletCore

// In CPython:
// Objects -> typeobject.c

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

  // MARK: - Builtin type

  /// Create (trivial) C3 linearisation using given class.
  /// [doc](https://www.python.org/download/releases/2.3/mro/)
  ///
  /// Special overload for builtin types, because during `Py.initialize` we can't
  /// call python methods (and also we exactly know the expected result).
  ///
  /// It will not take into account `self` (which should be 1st in MRO)!
  internal static func linearizeForBuiltinType(baseClass: PyType) -> MRO {
    // Normally we should use 'Py.callMethod(object: type, selector: .mro)',
    // but for builtins we know that they are not overloaded.
    let mro = baseClass.getMRO()
    return MRO(baseClasses: [baseClass], resolutionOrder: mro)
  }

  // MARK: - From single type

  /// Create (trivial) C3 linearisation using given class.
  /// [doc](https://www.python.org/download/releases/2.3/mro/)
  ///
  /// It will not take into account `self` (which should be 1st in MRO)!
  internal static func linearize(baseClass: PyType) -> PyResult<MRO> {
    switch Self.getMro(type: baseClass) {
    case let .value(mro):
      let result = MRO(baseClasses: [baseClass], resolutionOrder: mro)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - From objects

  /// Create C3 linearisation of given base classes.
  /// [doc](https://www.python.org/download/releases/2.3/mro/)
  ///
  /// It will not take into account `self` (which should be 1st in MRO)!
  internal static func linearize(baseClasses: [PyObject]) -> PyResult<MRO> {
    guard let baseTypes = Self.asTypes(objects: baseClasses) else {
      return .typeError("bases must be types")
    }

    return Self.linearize(baseClasses: baseTypes)
  }

  // MARK: - From types

  internal static func linearize(baseClasses: [PyType]) -> PyResult<MRO> {
    // No base classes? Empty MRO.
    if baseClasses.isEmpty {
      return .value(MRO(baseClasses: [], resolutionOrder: []))
    }

    // Fast path: if there is a single base, constructing the MRO is trivial.
    if baseClasses.count == 1 {
      return Self.linearize(baseClass: baseClasses[0])
    }

    // Sanity check.
    if let duplicate = Self.getDuplicateBaseClass(baseClasses) {
      return .typeError("duplicate base class \(duplicate.getQualname())")
    }

    // Get mros to linearise.
    var mros = [[PyType]]()
    for type in baseClasses {
      switch Self.getMro(type: type) {
      case let .value(mro): mros.append(mro)
      case let .error(e): return .error(e)
      }
    }

    mros.append(baseClasses)
    let expectedMroCount = Self.countUniqueTypes(mros: mros)

    // Perform C3 linearisation.
    var result = [PyType]()
    while Self.hasAnyClassRemaining(mros) {
      guard let base = Self.getNextBase(mros) else {
        let msg = "Cannot create a consistent method resolution order (MRO) for bases"
        return .typeError(msg)
      }

      result.append(base)

      // Not the best performance, but we do not expect big MROs.
      for index in 0..<mros.count {
        mros[index].removeAll { $0 === base }
      }
    }

    assert(result.count == expectedMroCount)
    return .value(MRO(baseClasses: baseClasses, resolutionOrder: result))
  }

  private static func getDuplicateBaseClass(_ baseClasses: [PyType]) -> PyType? {
    var visited = Set<ObjectIdentifier>()

    for base in baseClasses {
      let id = ObjectIdentifier(base)

      if visited.contains(id) {
        return base
      }

      visited.insert(id)
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

  private static func countUniqueTypes(mros: [[PyType]]) -> Int {
    var result = 0
    var visited = Set<ObjectIdentifier>()

    for classList in mros {
      for type in classList {
        let id = ObjectIdentifier(type)
        if !visited.contains(id) {
          result += 1
          visited.insert(id)
        }
      }
    }

    return result
  }

  // MARK: - Get type MRO

  private static func getMro(type: PyType) -> PyResult<[PyType]> {
    // If this is just a boring type which has 'Py.types.type' as type
    // then we know exectly what method should be called.
    // For example 'int' type has 'type' set to 'Py.types.type'
    if type.type === Py.types.type {
      // We will end up here in 99% of the cases.
      let result = type.getMRO()
      return .value(result)
    }

    // Otherwise it is a 'type' which is an instance of 'god knows what':
    // >>> class GodKnows(type): pass
    // >>> my_type_is_GodKnows = GodKnows('Princess', (GodKnows,), {})
    // >>> class Elsa(my_type_is_GodKnows): pass
    //
    // That was easy!
    // We should use it instead of 'hello world' when teaching programming...

    let mroObject: PyObject
    switch Py.callMethod(object: type, selector: .mro) {
    case let .value(o):
      mroObject = o
    case let .missingMethod(e),
         let .notCallable(e),
         let .error(e):
      return .error(e)
    }

    let mroEntries: [PyObject]
    switch Py.toArray(iterable: mroObject) {
    case let .value(es):
      mroEntries = es
    case let .error(e):
      return .error(e)
    }

    guard let mro = Self.asTypes(objects: mroEntries) else {
      return .typeError("MRO entries have to be types")
    }

    return .value(mro)
  }

  // swiftlint:disable:next discouraged_optional_collection
  private static func asTypes(objects: [PyObject]) -> [PyType]? {
    var result = [PyType]()
    result.reserveCapacity(objects.count)

    for object in objects {
      switch object as? PyType {
      case .some(let t): result.append(t)
      case .none: return .none
      }
    }

    return result
  }
}
