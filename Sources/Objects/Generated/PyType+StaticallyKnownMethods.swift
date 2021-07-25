// ==========================================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyType+StaticallyKnownMethods.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ==========================================================================================

extension PyType {

  /// Methods stored on `PyType` needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  internal struct StaticallyKnownNotOverriddenMethods {

    // MARK: - Properties

    // All of the function pointers have 16 bytes.
    // They also have invalid representation that can be used as optional tag.
    // So each of those function wrappers is exactly 16 bytes.

    internal var __repr__: StringConversionWrapper?
    internal var __str__: StringConversionWrapper?

    internal var __hash__: HashWrapper?

    internal var __eq__: ComparisonWrapper?
    internal var __ne__: ComparisonWrapper?
    internal var __lt__: ComparisonWrapper?
    internal var __le__: ComparisonWrapper?
    internal var __gt__: ComparisonWrapper?
    internal var __ge__: ComparisonWrapper?

    internal var __bool__: AsBoolWrapper?
    internal var __int__: AsIntWrapper?
    internal var __float__: AsFloatWrapper?
    internal var __complex__: AsComplexWrapper?
    internal var __index__: AsIndexWrapper?

    internal var __getattr__: GetAttributeWrapper?
    internal var __getattribute__: GetAttributeWrapper?
    internal var __setattr__: SetAttributeWrapper?
    internal var __delattr__: DelAttributeWrapper?

    internal var __getitem__: GetItemWrapper?
    internal var __setitem__: SetItemWrapper?
    internal var __delitem__: DelItemWrapper?

    internal var __iter__: IterWrapper?
    internal var __next__: NextWrapper?
    internal var __len__: GetLengthWrapper?
    internal var __contains__: ContainsWrapper?
    internal var __reversed__: ReversedWrapper?
    internal var keys: KeysWrapper?

    internal var __del__: DelWrapper?
    internal var __dir__: DirWrapper?
    internal var __call__: CallWrapper?

    internal var __instancecheck__: InstanceCheckWrapper?
    internal var __subclasscheck__: SubclassCheckWrapper?
    internal var __isabstractmethod__: IsAbstractMethodWrapper?

    internal var __pos__: NumericUnaryWrapper?
    internal var __neg__: NumericUnaryWrapper?
    internal var __abs__: NumericUnaryWrapper?
    internal var __invert__: NumericUnaryWrapper?
    internal var __trunc__: NumericTruncWrapper?
    internal var __round__: NumericRoundWrapper?

    internal var __add__: NumericBinaryWrapper?
    internal var __and__: NumericBinaryWrapper?
    internal var __divmod__: NumericBinaryWrapper?
    internal var __floordiv__: NumericBinaryWrapper?
    internal var __lshift__: NumericBinaryWrapper?
    internal var __matmul__: NumericBinaryWrapper?
    internal var __mod__: NumericBinaryWrapper?
    internal var __mul__: NumericBinaryWrapper?
    internal var __or__: NumericBinaryWrapper?
    internal var __rshift__: NumericBinaryWrapper?
    internal var __sub__: NumericBinaryWrapper?
    internal var __truediv__: NumericBinaryWrapper?
    internal var __xor__: NumericBinaryWrapper?

    internal var __radd__: NumericBinaryWrapper?
    internal var __rand__: NumericBinaryWrapper?
    internal var __rdivmod__: NumericBinaryWrapper?
    internal var __rfloordiv__: NumericBinaryWrapper?
    internal var __rlshift__: NumericBinaryWrapper?
    internal var __rmatmul__: NumericBinaryWrapper?
    internal var __rmod__: NumericBinaryWrapper?
    internal var __rmul__: NumericBinaryWrapper?
    internal var __ror__: NumericBinaryWrapper?
    internal var __rrshift__: NumericBinaryWrapper?
    internal var __rsub__: NumericBinaryWrapper?
    internal var __rtruediv__: NumericBinaryWrapper?
    internal var __rxor__: NumericBinaryWrapper?

    internal var __iadd__: NumericBinaryWrapper?
    internal var __iand__: NumericBinaryWrapper?
    internal var __idivmod__: NumericBinaryWrapper?
    internal var __ifloordiv__: NumericBinaryWrapper?
    internal var __ilshift__: NumericBinaryWrapper?
    internal var __imatmul__: NumericBinaryWrapper?
    internal var __imod__: NumericBinaryWrapper?
    internal var __imul__: NumericBinaryWrapper?
    internal var __ior__: NumericBinaryWrapper?
    internal var __irshift__: NumericBinaryWrapper?
    internal var __isub__: NumericBinaryWrapper?
    internal var __itruediv__: NumericBinaryWrapper?
    internal var __ixor__: NumericBinaryWrapper?

    internal var __pow__: NumericPowWrapper?
    internal var __rpow__: NumericPowWrapper?
    internal var __ipow__: NumericPowWrapper?

    // MARK: - Copy

    internal func copy() -> StaticallyKnownNotOverriddenMethods {
      // We are struct, so this is trivial.
      // If we ever change it to reference type, then we just need to change
      // this method.
      return self
    }
  }
}

