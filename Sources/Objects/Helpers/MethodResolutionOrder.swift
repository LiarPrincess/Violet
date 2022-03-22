import Foundation
import VioletCore

// cSpell:ignore typeobject mros

// In CPython:
// Objects -> typeobject.c

/// Method Resolution Order
public struct MethodResolutionOrder {

  internal let baseClasses: [PyType]
  internal let resolutionOrder: [PyType]

  // 'private' so that the only way to create MRO is to go through
  // one of our static methods.
  private init(baseClasses: [PyType], resolutionOrder: [PyType]) {
    assert(baseClasses.allSatisfy { b in resolutionOrder.contains { $0 === b } })
    self.baseClasses = baseClasses
    self.resolutionOrder = resolutionOrder
  }

  // MARK: - From single type

  internal typealias Result = PyResultGen<MethodResolutionOrder>

  /// Create (trivial) C3 linearization using given class.
  /// [doc](https://www.python.org/download/releases/2.3/mro/)
  ///
  /// It will not take into account `self` (which should be 1st in MRO)!
  internal static func linearize(_ py: Py, baseClass: PyType) -> Result {
    switch Self.getMro(py, type: baseClass) {
    case let .value(mro):
      let result = MethodResolutionOrder(baseClasses: [baseClass], resolutionOrder: mro)
      return .value(result)
    case let .error(e):
      return .error(e)
    }
  }

  // MARK: - From objects

  /// Create C3 linearization of given base classes.
  /// [doc](https://www.python.org/download/releases/2.3/mro/)
  ///
  /// It will not take into account `self` (which should be 1st in MRO)!
  internal static func linearize(_ py: Py, baseClasses: [PyObject]) -> Result {
    guard let baseTypes = Self.asTypes(py, objects: baseClasses) else {
      return .typeError(py, message: "bases must be types")
    }

    return Self.linearize(py, baseClasses: baseTypes)
  }

  // MARK: - From types

  internal static func linearize(_ py: Py, baseClasses: [PyType]) -> Result {
    // No base classes? Empty MRO.
    if baseClasses.isEmpty {
      let mro = MethodResolutionOrder(baseClasses: [], resolutionOrder: [])
      return .value(mro)
    }

    // Fast path: if there is a single base, constructing the MRO is trivial.
    if baseClasses.count == 1 {
      return Self.linearize(py, baseClass: baseClasses[0])
    }

    // Sanity check.
    if let duplicate = Self.getDuplicateBaseClass(baseClasses) {
      let qualname = duplicate.getQualnameString()
      return .typeError(py, message: "duplicate base class \(qualname)")
    }

    // Get mros to linearize.
    var mros = [[PyType]]()
    for type in baseClasses {
      switch Self.getMro(py, type: type) {
      case let .value(mro): mros.append(mro)
      case let .error(e): return .error(e)
      }
    }

    mros.append(baseClasses)
    let expectedMroCount = Self.countUniqueTypes(mros: mros)

    // Perform C3 linearization.
    var result = [PyType]()
    while Self.hasAnyClassRemaining(mros) {
      guard let base = Self.getNextBase(mros) else {
        let msg = "Cannot create a consistent method resolution order (MRO) for bases"
        return .typeError(py, message: msg)
      }

      result.append(base)

      // Not the best performance, but we do not expect big MROs.
      for index in 0..<mros.count {
        mros[index].removeAll { $0 === base }
      }
    }

    assert(result.count == expectedMroCount)
    let mro = MethodResolutionOrder(baseClasses: baseClasses, resolutionOrder: result)
    return .value(mro)
  }

  private static func getDuplicateBaseClass(_ baseClasses: [PyType]) -> PyType? {
    var visited = Set<Int>()

    for base in baseClasses {
      let id = Int(bitPattern: base.ptr)

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
    var visited = Set<Int>()

    for classList in mros {
      for type in classList {
        let id = Int(bitPattern: type.ptr)

        if !visited.contains(id) {
          result += 1
          visited.insert(id)
        }
      }
    }

    return result
  }

  // MARK: - Get type MRO

  private static func getMro(_ py: Py, type: PyType) -> PyResultGen<[PyType]> {
    // If this is just a boring type which has 'Py.types.type' as type
    // then we know exactly what method should be called.
    // For example 'int' type has 'type' set to 'Py.types.type'
    if type.type === py.types.type {
      // We will end up here in the 99% of the cases.
      return .value(type.mro)
    }

    // Otherwise it is a 'type' which is an instance of 'god knows what':
    // >>> class GodKnows(type): pass
    // >>> my_type_is_GodKnows = GodKnows('Princess', (GodKnows,), {})
    // >>> class Elsa(my_type_is_GodKnows): pass
    //
    // That was easy!
    // We should use it instead of 'hello world' when teaching programming…

    let mroObject: PyObject
    switch py.callMethod(object: type.asObject, selector: .mro) {
    case let .value(o):
      mroObject = o
    case let .missingMethod(e),
         let .notCallable(e),
         let .error(e):
      return .error(e)
    }

    let mroEntries: [PyObject]
    switch py.toArray(iterable: mroObject) {
    case let .value(es):
      mroEntries = es
    case let .error(e):
      return .error(e)
    }

    guard let mro = Self.asTypes(py, objects: mroEntries) else {
      return .typeError(py, message: "MRO entries have to be types")
    }

    return .value(mro)
  }

  // swiftlint:disable:next discouraged_optional_collection
  private static func asTypes(_ py: Py, objects: [PyObject]) -> [PyType]? {
    var result = [PyType]()
    result.reserveCapacity(objects.count)

    for object in objects {
      switch py.cast.asType(object) {
      case .some(let t): result.append(t)
      case .none: return .none
      }
    }

    return result
  }
}
