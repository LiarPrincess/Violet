import ArgumentParser
import SwiftSyntax

// MARK: - Access modifiers

public enum AccessModifier: String, RawRepresentable, ExpressibleByArgument {
  case `private`
  case `fileprivate`
  case `internal`
  case `public`
  case open
}

public struct GetSetAccessModifiers {
  // It is possible to have 'set' without 'get'!
  //   private(set) let elsa: String
  // means that 'get' is internal
  public let get: AccessModifier?
  public let set: AccessModifier?
}

// MARK: - Non access modifiers

/// Modifier that is not an access modifier
///
/// https://docs.swift.org/swift-book/ReferenceManual/Declarations.html#ID381
public enum Modifier: String {
  case `class`
  case convenience
  case dynamic
  case indirect
  case final
  case lazy
  case mutating
  case nonmutating
  case optional
  case override
  case required
  case `static`
  case unowned
  /// case unowned(safe)
  case unownedSafe
  /// case unowned(unsafe)
  case unownedUnsafe
  case weak
}

internal enum ParseModifiers {

  // MARK: - Parse single

  internal enum SingleResult {
    /// set
    case accessModifier(AccessModifier)
    /// private(set)
    case setAccessModifier(AccessModifier)
    case operatorKind(Operator.Kind)
    case modifier(Modifier)
  }

  internal static func single(_ node: DeclModifierSyntax) -> SingleResult {
    let text = node.name.text.trimmed
    // detailText = 'set' inside 'private(set)'
    let detailText = node.detail?.text.trimmed

    if let value = AccessModifier(rawValue: text) {
      switch detailText {
      case .none:
        return .accessModifier(value)
      case .some(let detailText):
        assert(detailText == "set")
        return .setAccessModifier(value)
      }
    }

    if let value = Operator.Kind(rawValue: text) {
      return .operatorKind(value)
    }

    if let value = Modifier(rawValue: text) {
      // Only 'unowned(safe)' or 'unowned(unsafe)' can have 'detailText'
      switch detailText {
      case .none:
        return .modifier(value)
      case .some("safe"):
        assert(value == .unowned)
        return .modifier(.unownedSafe)
      case .some("unsafe"):
        assert(value == .unowned)
        return .modifier(.unownedUnsafe)
      case .some(let detailText):
        trap("Unknown '\(text)' modifier detail: '\(detailText)'")
      }
    }

    trap("Unknown modifier: '\(text)'!")
  }

  // MARK: - Parse list

  internal struct ListResult {
    internal fileprivate(set) var access: GetSetAccessModifiers?
    internal fileprivate(set) var operatorKind: Operator.Kind?
    internal fileprivate(set) var values = [Modifier]()
  }

  internal static func list(_ node: ModifierListSyntax?) -> ListResult {
    var result = ListResult()

    guard let node = node else {
      return result
    }

    for modifier in node {
      let oldAccessGet = result.access?.get
      let oldAccessSet = result.access?.set

      switch Self.single(modifier) {
      case let .accessModifier(value):
        assert(oldAccessGet == nil)
        result.access = GetSetAccessModifiers(get: value, set: oldAccessSet)
      case let .setAccessModifier(value):
        assert(oldAccessSet == nil)
        result.access = GetSetAccessModifiers(get: oldAccessGet, set: value)
      case let .operatorKind(value):
        assert(result.operatorKind == nil)
        result.operatorKind = value
      case let .modifier(value):
        result.values.append(value)
      }
    }

    return result
  }
}
