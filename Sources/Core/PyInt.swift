// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/.

// https://docs.python.org/3/reference/lexical_analysis.html#integer-literals
// There is no limit for the length of integer literals apart
// from what can be stored in available memory.

/// Int64 because we don't have BigInt support.
/// Range: <-Int64.max, Int64.max> due to '-' being unary operator.
public typealias PyInt = Int64
