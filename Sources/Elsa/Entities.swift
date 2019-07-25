// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

internal enum Entity {
  case `enum`(Enum)
  case `struct`(Struct)
}

internal struct Struct {
  internal let name: String
  internal let properties: [Property]
}

internal struct Enum {
  internal let name: String
  internal let cases: [EnumCase]
}

internal struct EnumCase {
  internal let name: String
  internal let properties: [Property]
}

internal enum PropertyKind {
  case `default`
  case optional
  case many
}

internal struct Property {
  internal let name: String
  internal let type: String
  internal let kind: PropertyKind
}
