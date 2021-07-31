// ==========================================================================================
// Automatically generated from: ./Sources/Objects/Generated/PyType+StaticallyKnownMethods.py
// Use 'make gen' in repository root to regenerate.
// DO NOT EDIT!
// ==========================================================================================

// swiftlint:disable function_body_length
// swiftlint:disable file_length

extension PyType {

  /// Methods stored on `PyType` needed to make `PyStaticCall` work.
  ///
  /// See `PyStaticCall` documentation for more information.
  internal struct StaticallyKnownNotOverriddenMethods {

    // MARK: - Properties

    // All of the function pointers have 16 bytes.
    // They also have an invalid representation that can be used as optional tag.
    // So each of those function wrappers is exactly 16 bytes.

    internal var __repr__: StringConversionWrapper?
    internal var __str__: StringConversionWrapper?

    internal var __hash__: HashWrapper?
    internal var __dir__: DirWrapper?

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
    internal var __call__: CallWrapper?

    internal var __instancecheck__: InstanceCheckWrapper?
    internal var __subclasscheck__: SubclassCheckWrapper?
    internal var __isabstractmethod__: IsAbstractMethodWrapper?

    internal var __pos__: NumericUnaryWrapper?
    internal var __neg__: NumericUnaryWrapper?
    internal var __invert__: NumericUnaryWrapper?
    internal var __abs__: NumericUnaryWrapper?
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

    // MARK: - Init

    // We need 'init' without params, because we also have other 'init'.
    internal init() {
      self.__repr__ = nil
      self.__str__ = nil

      self.__hash__ = nil
      self.__dir__ = nil

      self.__eq__ = nil
      self.__ne__ = nil
      self.__lt__ = nil
      self.__le__ = nil
      self.__gt__ = nil
      self.__ge__ = nil

      self.__bool__ = nil
      self.__int__ = nil
      self.__float__ = nil
      self.__complex__ = nil
      self.__index__ = nil

      self.__getattr__ = nil
      self.__getattribute__ = nil
      self.__setattr__ = nil
      self.__delattr__ = nil

      self.__getitem__ = nil
      self.__setitem__ = nil
      self.__delitem__ = nil

      self.__iter__ = nil
      self.__next__ = nil
      self.__len__ = nil
      self.__contains__ = nil
      self.__reversed__ = nil
      self.keys = nil

      self.__del__ = nil
      self.__call__ = nil

      self.__instancecheck__ = nil
      self.__subclasscheck__ = nil
      self.__isabstractmethod__ = nil

      self.__pos__ = nil
      self.__neg__ = nil
      self.__invert__ = nil
      self.__abs__ = nil
      self.__trunc__ = nil
      self.__round__ = nil

      self.__add__ = nil
      self.__and__ = nil
      self.__divmod__ = nil
      self.__floordiv__ = nil
      self.__lshift__ = nil
      self.__matmul__ = nil
      self.__mod__ = nil
      self.__mul__ = nil
      self.__or__ = nil
      self.__rshift__ = nil
      self.__sub__ = nil
      self.__truediv__ = nil
      self.__xor__ = nil

      self.__radd__ = nil
      self.__rand__ = nil
      self.__rdivmod__ = nil
      self.__rfloordiv__ = nil
      self.__rlshift__ = nil
      self.__rmatmul__ = nil
      self.__rmod__ = nil
      self.__rmul__ = nil
      self.__ror__ = nil
      self.__rrshift__ = nil
      self.__rsub__ = nil
      self.__rtruediv__ = nil
      self.__rxor__ = nil

      self.__iadd__ = nil
      self.__iand__ = nil
      self.__idivmod__ = nil
      self.__ifloordiv__ = nil
      self.__ilshift__ = nil
      self.__imatmul__ = nil
      self.__imod__ = nil
      self.__imul__ = nil
      self.__ior__ = nil
      self.__irshift__ = nil
      self.__isub__ = nil
      self.__itruediv__ = nil
      self.__ixor__ = nil

      self.__pow__ = nil
      self.__rpow__ = nil
      self.__ipow__ = nil
    }

    // MARK: - Init MRO

    /// Special init for heap types (types created on-the-fly,
    /// for example by 'class' statement).
    ///
    /// We can't just use 'base' type, because each type has a different method
    /// resolution order (MRO) and we have to respect this.
    internal init(
      mroWithoutCurrentlyCreatedType mro: MRO,
      dictForCurrentlyCreatedType dict: PyDict
    ) {
      self = StaticallyKnownNotOverriddenMethods()

      // We need to start from the back (the most base type, probably 'object').
      for type in mro.resolutionOrder.reversed() {
        self.removeOverriddenMethods(from: type.__dict__)
        self.copyMethods(from: type.staticMethods)
      }

      self.removeOverriddenMethods(from: dict)
    }

    private mutating func copyMethods(from other: StaticallyKnownNotOverriddenMethods) {
      self.__repr__ = other.__repr__ ?? self.__repr__
      self.__str__ = other.__str__ ?? self.__str__

      self.__hash__ = other.__hash__ ?? self.__hash__
      self.__dir__ = other.__dir__ ?? self.__dir__

      self.__eq__ = other.__eq__ ?? self.__eq__
      self.__ne__ = other.__ne__ ?? self.__ne__
      self.__lt__ = other.__lt__ ?? self.__lt__
      self.__le__ = other.__le__ ?? self.__le__
      self.__gt__ = other.__gt__ ?? self.__gt__
      self.__ge__ = other.__ge__ ?? self.__ge__

      self.__bool__ = other.__bool__ ?? self.__bool__
      self.__int__ = other.__int__ ?? self.__int__
      self.__float__ = other.__float__ ?? self.__float__
      self.__complex__ = other.__complex__ ?? self.__complex__
      self.__index__ = other.__index__ ?? self.__index__

      self.__getattr__ = other.__getattr__ ?? self.__getattr__
      self.__getattribute__ = other.__getattribute__ ?? self.__getattribute__
      self.__setattr__ = other.__setattr__ ?? self.__setattr__
      self.__delattr__ = other.__delattr__ ?? self.__delattr__

      self.__getitem__ = other.__getitem__ ?? self.__getitem__
      self.__setitem__ = other.__setitem__ ?? self.__setitem__
      self.__delitem__ = other.__delitem__ ?? self.__delitem__

      self.__iter__ = other.__iter__ ?? self.__iter__
      self.__next__ = other.__next__ ?? self.__next__
      self.__len__ = other.__len__ ?? self.__len__
      self.__contains__ = other.__contains__ ?? self.__contains__
      self.__reversed__ = other.__reversed__ ?? self.__reversed__
      self.keys = other.keys ?? self.keys

      self.__del__ = other.__del__ ?? self.__del__
      self.__call__ = other.__call__ ?? self.__call__

      self.__instancecheck__ = other.__instancecheck__ ?? self.__instancecheck__
      self.__subclasscheck__ = other.__subclasscheck__ ?? self.__subclasscheck__
      self.__isabstractmethod__ = other.__isabstractmethod__ ?? self.__isabstractmethod__

      self.__pos__ = other.__pos__ ?? self.__pos__
      self.__neg__ = other.__neg__ ?? self.__neg__
      self.__invert__ = other.__invert__ ?? self.__invert__
      self.__abs__ = other.__abs__ ?? self.__abs__
      self.__trunc__ = other.__trunc__ ?? self.__trunc__
      self.__round__ = other.__round__ ?? self.__round__

      self.__add__ = other.__add__ ?? self.__add__
      self.__and__ = other.__and__ ?? self.__and__
      self.__divmod__ = other.__divmod__ ?? self.__divmod__
      self.__floordiv__ = other.__floordiv__ ?? self.__floordiv__
      self.__lshift__ = other.__lshift__ ?? self.__lshift__
      self.__matmul__ = other.__matmul__ ?? self.__matmul__
      self.__mod__ = other.__mod__ ?? self.__mod__
      self.__mul__ = other.__mul__ ?? self.__mul__
      self.__or__ = other.__or__ ?? self.__or__
      self.__rshift__ = other.__rshift__ ?? self.__rshift__
      self.__sub__ = other.__sub__ ?? self.__sub__
      self.__truediv__ = other.__truediv__ ?? self.__truediv__
      self.__xor__ = other.__xor__ ?? self.__xor__

      self.__radd__ = other.__radd__ ?? self.__radd__
      self.__rand__ = other.__rand__ ?? self.__rand__
      self.__rdivmod__ = other.__rdivmod__ ?? self.__rdivmod__
      self.__rfloordiv__ = other.__rfloordiv__ ?? self.__rfloordiv__
      self.__rlshift__ = other.__rlshift__ ?? self.__rlshift__
      self.__rmatmul__ = other.__rmatmul__ ?? self.__rmatmul__
      self.__rmod__ = other.__rmod__ ?? self.__rmod__
      self.__rmul__ = other.__rmul__ ?? self.__rmul__
      self.__ror__ = other.__ror__ ?? self.__ror__
      self.__rrshift__ = other.__rrshift__ ?? self.__rrshift__
      self.__rsub__ = other.__rsub__ ?? self.__rsub__
      self.__rtruediv__ = other.__rtruediv__ ?? self.__rtruediv__
      self.__rxor__ = other.__rxor__ ?? self.__rxor__

      self.__iadd__ = other.__iadd__ ?? self.__iadd__
      self.__iand__ = other.__iand__ ?? self.__iand__
      self.__idivmod__ = other.__idivmod__ ?? self.__idivmod__
      self.__ifloordiv__ = other.__ifloordiv__ ?? self.__ifloordiv__
      self.__ilshift__ = other.__ilshift__ ?? self.__ilshift__
      self.__imatmul__ = other.__imatmul__ ?? self.__imatmul__
      self.__imod__ = other.__imod__ ?? self.__imod__
      self.__imul__ = other.__imul__ ?? self.__imul__
      self.__ior__ = other.__ior__ ?? self.__ior__
      self.__irshift__ = other.__irshift__ ?? self.__irshift__
      self.__isub__ = other.__isub__ ?? self.__isub__
      self.__itruediv__ = other.__itruediv__ ?? self.__itruediv__
      self.__ixor__ = other.__ixor__ ?? self.__ixor__

      self.__pow__ = other.__pow__ ?? self.__pow__
      self.__rpow__ = other.__rpow__ ?? self.__rpow__
      self.__ipow__ = other.__ipow__ ?? self.__ipow__
    }

    private mutating func removeOverriddenMethods(from dict: PyDict) {
      for entry in dict.elements {
        let key = entry.key.object
        guard let string = PyCast.asString(key) else {
          continue
        }

        // All of the methods have ASCII name, so we can just use Swift definition
        // of equality.
        switch string.value {
        case "__repr__": self.__repr__ = nil
        case "__str__": self.__str__ = nil

        case "__hash__": self.__hash__ = nil
        case "__dir__": self.__dir__ = nil

        case "__eq__": self.__eq__ = nil
        case "__ne__": self.__ne__ = nil
        case "__lt__": self.__lt__ = nil
        case "__le__": self.__le__ = nil
        case "__gt__": self.__gt__ = nil
        case "__ge__": self.__ge__ = nil

        case "__bool__": self.__bool__ = nil
        case "__int__": self.__int__ = nil
        case "__float__": self.__float__ = nil
        case "__complex__": self.__complex__ = nil
        case "__index__": self.__index__ = nil

        case "__getattr__": self.__getattr__ = nil
        case "__getattribute__": self.__getattribute__ = nil
        case "__setattr__": self.__setattr__ = nil
        case "__delattr__": self.__delattr__ = nil

        case "__getitem__": self.__getitem__ = nil
        case "__setitem__": self.__setitem__ = nil
        case "__delitem__": self.__delitem__ = nil

        case "__iter__": self.__iter__ = nil
        case "__next__": self.__next__ = nil
        case "__len__": self.__len__ = nil
        case "__contains__": self.__contains__ = nil
        case "__reversed__": self.__reversed__ = nil
        case "keys": self.keys = nil

        case "__del__": self.__del__ = nil
        case "__call__": self.__call__ = nil

        case "__instancecheck__": self.__instancecheck__ = nil
        case "__subclasscheck__": self.__subclasscheck__ = nil
        case "__isabstractmethod__": self.__isabstractmethod__ = nil

        case "__pos__": self.__pos__ = nil
        case "__neg__": self.__neg__ = nil
        case "__invert__": self.__invert__ = nil
        case "__abs__": self.__abs__ = nil
        case "__trunc__": self.__trunc__ = nil
        case "__round__": self.__round__ = nil

        case "__add__": self.__add__ = nil
        case "__and__": self.__and__ = nil
        case "__divmod__": self.__divmod__ = nil
        case "__floordiv__": self.__floordiv__ = nil
        case "__lshift__": self.__lshift__ = nil
        case "__matmul__": self.__matmul__ = nil
        case "__mod__": self.__mod__ = nil
        case "__mul__": self.__mul__ = nil
        case "__or__": self.__or__ = nil
        case "__rshift__": self.__rshift__ = nil
        case "__sub__": self.__sub__ = nil
        case "__truediv__": self.__truediv__ = nil
        case "__xor__": self.__xor__ = nil

        case "__radd__": self.__radd__ = nil
        case "__rand__": self.__rand__ = nil
        case "__rdivmod__": self.__rdivmod__ = nil
        case "__rfloordiv__": self.__rfloordiv__ = nil
        case "__rlshift__": self.__rlshift__ = nil
        case "__rmatmul__": self.__rmatmul__ = nil
        case "__rmod__": self.__rmod__ = nil
        case "__rmul__": self.__rmul__ = nil
        case "__ror__": self.__ror__ = nil
        case "__rrshift__": self.__rrshift__ = nil
        case "__rsub__": self.__rsub__ = nil
        case "__rtruediv__": self.__rtruediv__ = nil
        case "__rxor__": self.__rxor__ = nil

        case "__iadd__": self.__iadd__ = nil
        case "__iand__": self.__iand__ = nil
        case "__idivmod__": self.__idivmod__ = nil
        case "__ifloordiv__": self.__ifloordiv__ = nil
        case "__ilshift__": self.__ilshift__ = nil
        case "__imatmul__": self.__imatmul__ = nil
        case "__imod__": self.__imod__ = nil
        case "__imul__": self.__imul__ = nil
        case "__ior__": self.__ior__ = nil
        case "__irshift__": self.__irshift__ = nil
        case "__isub__": self.__isub__ = nil
        case "__itruediv__": self.__itruediv__ = nil
        case "__ixor__": self.__ixor__ = nil

        case "__pow__": self.__pow__ = nil
        case "__rpow__": self.__rpow__ = nil
        case "__ipow__": self.__ipow__ = nil
        default: break
        }
      }
    }

    // MARK: - Copy

    internal func copy() -> StaticallyKnownNotOverriddenMethods {
      // We are struct, so this is trivial.
      // If we ever change it to reference type, then we just need to change
      // this method.
      return self
    }
  }
}
