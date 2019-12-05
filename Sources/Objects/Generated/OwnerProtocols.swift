import Core

// swiftlint:disable line_length

protocol ArgsGetterOwner { func getArgs() -> PyObject }
protocol ArgsSetterOwner { func setArgs(_ value: PyObject?) -> PyResult<()> }
protocol FdelGetterOwner { func getFDel() -> PyObject }
protocol FgetGetterOwner { func getFGet() -> PyObject }
protocol FsetGetterOwner { func getFSet() -> PyObject }
protocol __abs__Owner { func abs() -> PyObject }
protocol __add__Owner { func add(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __and__Owner { func and(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __base__GetterOwner { func getBase() -> PyType? }
protocol __bases__GetterOwner { func getBases() -> PyTuple }
protocol __bases__SetterOwner { func setBases(_ value: PyObject?) -> PyResult<()> }
protocol __bool__Owner { func asBool() -> Bool }
protocol __call__Owner { func call(args: PyObject, kwargs: PyObject?) -> PyResultOrNot<PyObject> }
protocol __cause__GetterOwner { func getCause() -> PyObject }
protocol __cause__SetterOwner { func setCause(_ value: PyObject?) -> PyResult<()> }
protocol __class__GetterOwner { func getClass() -> PyType }
protocol __code__GetterOwner { func getCode() -> PyCode }
protocol __complex__Owner { func asComplex() -> PyResult<PyComplex> }
protocol __contains__Owner { func contains(_ element: PyObject) -> PyResult<Bool> }
protocol __context__GetterOwner { func getContext() -> PyObject }
protocol __context__SetterOwner { func setContext(_ value: PyObject?) -> PyResult<()> }
protocol __delattr__Owner { func delAttribute(name: PyObject) -> PyResult<PyNone> }
protocol __delete__Owner { func del(object: PyObject) -> PyResult<PyObject> }
protocol __delitem__Owner { func delItem(at index: PyObject) -> PyResult<PyNone> }
protocol __dict__GetterOwner { func getDict() -> Attributes }
protocol __dir__Owner { func dir() -> DirResult }
protocol __divmod__Owner { func divmod(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __doc__GetterOwner { func getDoc() -> PyResult<PyObject> }
protocol __doc__SetterOwner { func setDoc(_ value: PyObject?) -> PyResult<()> }
protocol __eq__Owner { func isEqual(_ other: PyObject) -> PyResultOrNot<Bool> }
protocol __float__Owner { func asFloat() -> PyResult<PyFloat> }
protocol __floordiv__Owner { func floordiv(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __func__Owner { func getFunc() -> PyObject }
protocol __ge__Owner { func isGreaterEqual(_ other: PyObject) -> PyResultOrNot<Bool> }
protocol __get__Owner { func get(object: PyObject) -> PyResult<PyObject> }
protocol __getattribute__Owner { func getAttribute(name: PyObject) -> PyResult<PyObject> }
protocol __getitem__Owner { func getItem(at index: PyObject) -> PyResult<PyObject> }
protocol __gt__Owner { func isGreater(_ other: PyObject) -> PyResultOrNot<Bool> }
protocol __hash__Owner { func hash() -> PyResultOrNot<PyHash> }
protocol __iadd__Owner { func iadd(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __iand__Owner { func iand(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __idivmod__Owner { func idivmod(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __ifloordiv__Owner { func ifloordiv(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __ilshift__Owner { func ilshift(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __imatmul__Owner { func imatmul(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __imod__Owner { func imod(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __imul__Owner { func imul(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __index__Owner { func asIndex() -> BigInt }
protocol __int__Owner { func asInt() -> PyResult<PyInt> }
protocol __invert__Owner { func invert() -> PyObject }
protocol __ior__Owner { func ior(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __ipow__Owner { func ipow(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __irshift__Owner { func irshift(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __isub__Owner { func isub(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __itruediv__Owner { func itruediv(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __ixor__Owner { func ixor(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __le__Owner { func isLessEqual(_ other: PyObject) -> PyResultOrNot<Bool> }
protocol __len__Owner { func getLength() -> BigInt }
protocol __lshift__Owner { func lshift(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __lt__Owner { func isLess(_ other: PyObject) -> PyResultOrNot<Bool> }
protocol __matmul__Owner { func matmul(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __mod__Owner { func mod(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __module__GetterOwner { func getModule() -> PyResult<String> }
protocol __module__SetterOwner { func setModule(_ value: PyObject?) -> PyResult<()> }
protocol __mro__GetterOwner { func getMRO() -> PyTuple }
protocol __mul__Owner { func mul(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __name__GetterOwner { func getName() -> String }
protocol __name__SetterOwner { func setName(_ value: PyObject?) -> PyResult<()> }
protocol __ne__Owner { func isNotEqual(_ other: PyObject) -> PyResultOrNot<Bool> }
protocol __neg__Owner { func negative() -> PyObject }
protocol __new__Owner { static func new(type: PyType, args: [PyObject], kwargs: PyDictData?) -> PyResult<PyObject> }
protocol __or__Owner { func or(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __pos__Owner { func positive() -> PyObject }
protocol __pow__Owner { func pow(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __qualname__GetterOwner { func getQualname() -> String }
protocol __qualname__SetterOwner { func setQualname(_ value: PyObject?) -> PyResult<()> }
protocol __radd__Owner { func radd(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rand__Owner { func rand(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rdivmod__Owner { func rdivmod(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __repr__Owner { func repr() -> PyResult<String> }
protocol __rfloordiv__Owner { func rfloordiv(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rlshift__Owner { func rlshift(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rmatmul__Owner { func rmatmul(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rmod__Owner { func rmod(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rmul__Owner { func rmul(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __ror__Owner { func ror(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __round__Owner { func round(nDigits: PyObject?) -> PyResultOrNot<PyObject> }
protocol __rpow__Owner { func rpow(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rrshift__Owner { func rrshift(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rshift__Owner { func rshift(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rsub__Owner { func rsub(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rtruediv__Owner { func rtruediv(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __rxor__Owner { func rxor(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __self__GetterOwner { func getSelf() -> PyObject }
protocol __self__Owner { func getSelf() -> PyObject }
protocol __set__Owner { func set(object: PyObject, value: PyObject) -> PyResult<PyObject> }
protocol __setattr__Owner { func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> }
protocol __setitem__Owner { func setItem(at index: PyObject, to value: PyObject) -> PyResult<PyNone> }
protocol __str__Owner { func str() -> PyResult<String> }
protocol __sub__Owner { func sub(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __subclasses__Owner { func getSubclasses() -> [PyType] }
protocol __suppress_context__GetterOwner { func getSuppressContext() -> PyObject }
protocol __suppress_context__SetterOwner { func setSuppressContext(_ value: PyObject?) -> PyResult<()> }
protocol __text_signature__GetterOwner { func getTextSignature() -> String? }
protocol __traceback__GetterOwner { func getTraceback() -> PyObject }
protocol __traceback__SetterOwner { func setTraceback(_ value: PyObject?) -> PyResult<()> }
protocol __truediv__Owner { func truediv(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol __trunc__Owner { func trunc() -> PyResult<PyObject> }
protocol __xor__Owner { func xor(_ other: PyObject) -> PyResultOrNot<PyObject> }
protocol addOwner { func add(_ value: PyObject) -> PyResult<PyNone> }
protocol appendOwner { func append(_ element: PyObject) -> PyResult<PyNone> }
protocol capitalizeOwner { func capitalize() -> String }
protocol casefoldOwner { func casefold() -> String }
protocol centerOwner { func center(width: PyObject, fillChar: PyObject?) -> PyResult<String> }
protocol clearOwner { func clear() -> PyResult<PyNone> }
protocol conjugateOwner { func conjugate() -> PyObject }
protocol copyOwner { func copy() -> PyObject }
protocol countOwner { func count(_ element: PyObject) -> PyResult<BigInt> }
protocol countRangedOwner { func count(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<BigInt> }
protocol denominatorOwner { func denominator() -> PyInt }
protocol differenceOwner { func difference(with other: PyObject) -> PyResult<PyObject> }
protocol discardOwner { func discard(_ value: PyObject) -> PyResult<PyNone> }
protocol endswithOwner { func endsWith(_ element: PyObject) -> PyResultOrNot<Bool> }
protocol endswithRangedOwner { func endsWith(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResultOrNot<Bool> }
protocol expandtabsOwner { func expandTabs(tabSize: PyObject?) -> PyResult<String> }
protocol findOwner { func find(_ element: PyObject) -> PyResult<Int> }
protocol findRangedOwner { func find(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<Int> }
protocol getOwner { func get(_ index: PyObject, default: PyObject?) -> PyResult<PyObject> }
protocol imagOwner { func asImag() -> PyObject }
protocol indexOwner { func index(of element: PyObject) -> PyResult<BigInt> }
protocol indexRangedOwner { func index(of element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<BigInt> }
protocol indicesOwner { func indicesInSequence(length: PyObject) -> PyResultOrNot<PyObject> }
protocol intersectionOwner { func intersection(with other: PyObject) -> PyResult<PyObject> }
protocol isalnumOwner { func isAlphaNumeric() -> Bool }
protocol isalphaOwner { func isAlpha() -> Bool }
protocol isasciiOwner { func isAscii() -> Bool }
protocol isdecimalOwner { func isDecimal() -> Bool }
protocol isdigitOwner { func isDigit() -> Bool }
protocol isdisjointOwner { func isDisjoint(with other: PyObject) -> PyResult<Bool> }
protocol isidentifierOwner { func isIdentifier() -> Bool }
protocol islowerOwner { func isLower() -> Bool }
protocol isnumericOwner { func isNumeric() -> Bool }
protocol isprintableOwner { func isPrintable() -> Bool }
protocol isspaceOwner { func isSpace() -> Bool }
protocol issubsetOwner { func isSubset(of other: PyObject) -> PyResult<Bool> }
protocol issupersetOwner { func isSuperset(of other: PyObject) -> PyResult<Bool> }
protocol istitleOwner { func isTitle() -> Bool }
protocol isupperOwner { func isUpper() -> Bool }
protocol ljustOwner { func ljust(width: PyObject, fillChar: PyObject?) -> PyResult<String> }
protocol lowerOwner { func lower() -> String }
protocol lstripOwner { func lstrip(_ chars: PyObject) -> PyResult<String> }
protocol numeratorOwner { func numerator() -> PyInt }
protocol partitionOwner { func partition(separator: PyObject) -> PyResult<PyTuple> }
protocol popitemOwner { func popitem() -> PyResult<PyObject> }
protocol realOwner { func asReal() -> PyObject }
protocol removeOwner { func remove(_ value: PyObject) -> PyResult<PyNone> }
protocol replaceOwner { func replace(old: PyObject, new: PyObject, count: PyObject?) -> PyResult<String> }
protocol rfindOwner { func rfind(_ element: PyObject) -> PyResult<Int> }
protocol rfindRangedOwner { func rfind(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<Int> }
protocol rindexOwner { func rindex(_ element: PyObject) -> PyResult<Int> }
protocol rindexRangedOwner { func rindex(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<Int> }
protocol rjustOwner { func rjust(width: PyObject, fillChar: PyObject?) -> PyResult<String> }
protocol rpartitionOwner { func rpartition(separator: PyObject) -> PyResult<PyTuple> }
protocol rsplitOwner { func rsplit(separator: PyObject?, maxCount: PyObject?) -> PyResult<[String]> }
protocol rstripOwner { func rstrip(_ chars: PyObject) -> PyResult<String> }
protocol setdefaultOwner { func setDefault(_ index: PyObject, default: PyObject?) -> PyResult<PyObject> }
protocol splitOwner { func split(separator: PyObject?, maxCount: PyObject?) -> PyResult<[String]> }
protocol splitlinesOwner { func splitLines(keepEnds: PyObject) -> PyResult<[String]> }
protocol startswithOwner { func startsWith(_ element: PyObject) -> PyResult<Bool> }
protocol startswithRangedOwner { func startsWith(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<Bool> }
protocol stripOwner { func strip(_ chars: PyObject?) -> PyResult<String> }
protocol swapcaseOwner { func swapcase() -> String }
protocol symmetric_differenceOwner { func symmetricDifference(with other: PyObject) -> PyResult<PyObject> }
protocol titleOwner { func title() -> String }
protocol unionOwner { func union(with other: PyObject) -> PyResult<PyObject> }
protocol upperOwner { func upper() -> String }
protocol zfillOwner { func zfill(width: PyObject) -> PyResult<String> }
