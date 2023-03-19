//===--- BigInt+Extensions.swift ------------------------------*- swift -*-===//
//
// This source file is part of the Swift Numerics open source project
//
// Copyright (c) 2023 Apple Inc. and the Swift Numerics project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//

import BigInt

extension BigInt {

  internal typealias Word = Words.Element

  internal init(isPositive: Bool, magnitude: [BigIntPrototype.Word]) {
    let p = BigIntPrototype(isPositive: isPositive, magnitude: magnitude)
    self = p.create()
  }

  internal init(_ sign: BigIntPrototype.Sign, magnitude: BigIntPrototype.Word) {
    let p = BigIntPrototype(sign, magnitude: magnitude)
    self = p.create()
  }

  internal init(_ sign: BigIntPrototype.Sign, magnitude: [BigIntPrototype.Word]) {
    let p = BigIntPrototype(sign, magnitude: magnitude)
    self = p.create()
  }
}
