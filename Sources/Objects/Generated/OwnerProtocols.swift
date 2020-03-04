import Core

// swiftlint:disable line_length

protocol __new__Owner {
  static func pyNew(type: PyType, args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject>
}

protocol __init__Owner {
  associatedtype Zelf: PyObject
  static func pyInit(zelf: Zelf, args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone>
}

protocol ArgsGetterOwner { func getArgs() -> PyTuple }
protocol ArgsSetterOwner { func setArgs(_ value: PyObject?) -> PyResult<()> }
protocol Co_ArgcountGetterOwner { func getArgCount() -> Int }
protocol Co_FilenameGetterOwner { func getFilename() -> PyString }
protocol Co_FirstlinenoGetterOwner { func getFirstLineNo() -> Int }
protocol Co_KwonlyargcountGetterOwner { func getKwOnlyArgCount() -> Int }
protocol Co_NameGetterOwner { func getName() -> PyString }
protocol Co_NlocalsGetterOwner { func getNLocals() -> Int }
protocol DenominatorGetterOwner { func denominator() -> PyInt }
protocol F_BackGetterOwner { func getBack() -> PyObject }
protocol F_BuiltinsGetterOwner { func getBuiltins() -> PyDict }
protocol F_CodeGetterOwner { func getCode() -> PyCode }
protocol F_GlobalsGetterOwner { func getGlobals() -> PyDict }
protocol F_LastiGetterOwner { func getLasti() -> Int }
protocol F_LinenoGetterOwner { func getLineno() -> Int }
protocol F_LocalsGetterOwner { func getLocals() -> PyDict }
protocol FdelGetterOwner { func getFDel() -> PyObject }
protocol FgetGetterOwner { func getFGet() -> PyObject }
protocol FsetGetterOwner { func getFSet() -> PyObject }
protocol ImagGetterOwner { func asImag() -> PyObject }
protocol NumeratorGetterOwner { func numerator() -> PyInt }
protocol RealGetterOwner { func asReal() -> PyObject }
protocol StartGetterOwner { func getStart() -> PyObject }
protocol StepGetterOwner { func getStep() -> PyObject }
protocol StopGetterOwner { func getStop() -> PyObject }
protocol __abs__Owner { func abs() -> PyObject }
protocol __add__Owner { func add(_ other: PyObject) -> PyResult<PyObject> }
protocol __and__Owner { func and(_ other: PyObject) -> PyResult<PyObject> }
protocol __annotations__GetterOwner { func getAnnotations() -> PyObject }
protocol __base__GetterOwner { func getBase() -> PyType? }
protocol __bases__GetterOwner { func getBases() -> PyTuple }
protocol __bases__SetterOwner { func setBases(_ value: PyObject?) -> PyResult<()> }
protocol __bool__Owner { func asBool() -> Bool }
protocol __call__Owner { func call(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> }
protocol __cause__GetterOwner { func getCause() -> PyObject? }
protocol __cause__SetterOwner { func setCause(_ value: PyObject?) -> PyResult<()> }
protocol __ceil__Owner { func ceil() -> PyObject }
protocol __class__GetterOwner { func getClass() -> PyType }
protocol __closure__GetterOwner { func getClosure() -> PyObject }
protocol __code__GetterOwner { func getCode() -> PyCode }
protocol __complex__Owner { func asComplex() -> PyObject }
protocol __contains__Owner { func contains(_ element: PyObject) -> PyResult<Bool> }
protocol __context__GetterOwner { func getContext() -> PyBaseException? }
protocol __context__SetterOwner { func setContext(_ value: PyObject?) -> PyResult<()> }
protocol __defaults__GetterOwner { func getDefaults() -> PyObject }
protocol __del__Owner { func del() -> PyResult<PyNone> }
protocol __delattr__Owner { func delAttribute(name: PyObject) -> PyResult<PyNone> }
protocol __delete__Owner { func del(object: PyObject) -> PyResult<PyObject> }
protocol __delitem__Owner { func delItem(at index: PyObject) -> PyResult<PyNone> }
protocol __dict__GetterOwner { func getDict() -> PyDict }
protocol __dir__Owner { func dir() -> DirResult }
protocol __divmod__Owner { func divmod(_ other: PyObject) -> PyResult<PyObject> }
protocol __doc__GetterOwner { func getDoc() -> PyResult<PyObject> }
protocol __doc__SetterOwner { func setDoc(_ value: PyObject?) -> PyResult<()> }
protocol __eq__Owner { func isEqual(_ other: PyObject) -> CompareResult }
protocol __float__Owner { func asFloat() -> PyResult<PyFloat> }
protocol __floor__Owner { func floor() -> PyObject }
protocol __floordiv__Owner { func floordiv(_ other: PyObject) -> PyResult<PyObject> }
protocol __func__GetterOwner { func getFunc() -> PyObject }
protocol __func__Owner { func getFunc() -> PyFunction }
protocol __ge__Owner { func isGreaterEqual(_ other: PyObject) -> CompareResult }
protocol __get__Owner { func get(object: PyObject, type: PyObject) -> PyResult<PyObject> }
protocol __getattribute__Owner { func getAttribute(name: PyObject) -> PyResult<PyObject> }
protocol __getitem__Owner { func getItem(at index: PyObject) -> PyResult<PyObject> }
protocol __globals__GetterOwner { func getGlobals() -> PyDict }
protocol __gt__Owner { func isGreater(_ other: PyObject) -> CompareResult }
protocol __hash__Owner { func hash() -> HashResult }
protocol __iadd__Owner { func iadd(_ other: PyObject) -> PyResult<PyObject> }
protocol __iand__Owner { func iand(_ other: PyObject) -> PyResult<PyObject> }
protocol __ifloordiv__Owner { func ifloordiv(_ other: PyObject) -> PyResult<PyObject> }
protocol __ilshift__Owner { func ilshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __imatmul__Owner { func imatmul(_ other: PyObject) -> PyResult<PyObject> }
protocol __imod__Owner { func imod(_ other: PyObject) -> PyResult<PyObject> }
protocol __imul__Owner { func imul(_ other: PyObject) -> PyResult<PyObject> }
protocol __index__Owner { func asIndex() -> BigInt }
protocol __instancecheck__Owner { func isType(of object: PyObject) -> Bool }
protocol __int__Owner { func asInt() -> PyResult<PyInt> }
protocol __invert__Owner { func invert() -> PyObject }
protocol __ior__Owner { func ior(_ other: PyObject) -> PyResult<PyObject> }
protocol __ipow__Owner { func ipow(_ other: PyObject) -> PyResult<PyObject> }
protocol __irshift__Owner { func irshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __isabstractmethod__Owner { func isAbstractMethod() -> PyResult<Bool> }
protocol __isub__Owner { func isub(_ other: PyObject) -> PyResult<PyObject> }
protocol __iter__Owner { func iter() -> PyObject }
protocol __itruediv__Owner { func itruediv(_ other: PyObject) -> PyResult<PyObject> }
protocol __ixor__Owner { func ixor(_ other: PyObject) -> PyResult<PyObject> }
protocol __kwdefaults__GetterOwner { func getKeywordDefaults() -> PyObject }
protocol __le__Owner { func isLessEqual(_ other: PyObject) -> CompareResult }
protocol __len__Owner { func getLength() -> BigInt }
protocol __lshift__Owner { func lshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __lt__Owner { func isLess(_ other: PyObject) -> CompareResult }
protocol __matmul__Owner { func matmul(_ other: PyObject) -> PyResult<PyObject> }
protocol __mod__Owner { func mod(_ other: PyObject) -> PyResult<PyObject> }
protocol __module__GetterOwner { func getModule() -> PyResult<String> }
protocol __module__SetterOwner { func setModule(_ value: PyObject?) -> PyResult<()> }
protocol __mro__GetterOwner { func getMRO() -> PyTuple }
protocol __mul__Owner { func mul(_ other: PyObject) -> PyResult<PyObject> }
protocol __name__GetterOwner { func getName() -> PyString }
protocol __name__GetterOwner { func getName() -> String }
protocol __name__SetterOwner { func setName(_ value: PyObject?) -> PyResult<()> }
protocol __ne__Owner { func isNotEqual(_ other: PyObject) -> CompareResult }
protocol __neg__Owner { func negative() -> PyObject }
protocol __next__Owner { func next() -> PyResult<PyObject> }
protocol __or__Owner { func or(_ other: PyObject) -> PyResult<PyObject> }
protocol __pos__Owner { func positive() -> PyObject }
protocol __pow__Owner { func pow(exp: PyObject, mod: PyObject?) -> PyResult<PyObject> }
protocol __qualname__GetterOwner { func getQualname() -> PyString }
protocol __qualname__GetterOwner { func getQualname() -> String }
protocol __qualname__SetterOwner { func setQualname(_ value: PyObject?) -> PyResult<()> }
protocol __radd__Owner { func radd(_ other: PyObject) -> PyResult<PyObject> }
protocol __rand__Owner { func rand(_ other: PyObject) -> PyResult<PyObject> }
protocol __rdivmod__Owner { func rdivmod(_ other: PyObject) -> PyResult<PyObject> }
protocol __reduce__Owner { func reduce() -> String }
protocol __repr__Owner { func repr() -> PyResult<String> }
protocol __reversed__Owner { func reversed() -> PyObject }
protocol __rfloordiv__Owner { func rfloordiv(_ other: PyObject) -> PyResult<PyObject> }
protocol __rlshift__Owner { func rlshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __rmatmul__Owner { func rmatmul(_ other: PyObject) -> PyResult<PyObject> }
protocol __rmod__Owner { func rmod(_ other: PyObject) -> PyResult<PyObject> }
protocol __rmul__Owner { func rmul(_ other: PyObject) -> PyResult<PyObject> }
protocol __ror__Owner { func ror(_ other: PyObject) -> PyResult<PyObject> }
protocol __round__Owner { func round(nDigits: PyObject?) -> PyResult<PyObject> }
protocol __rpow__Owner { func rpow(base: PyObject, mod: PyObject?) -> PyResult<PyObject> }
protocol __rrshift__Owner { func rrshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __rshift__Owner { func rshift(_ other: PyObject) -> PyResult<PyObject> }
protocol __rsub__Owner { func rsub(_ other: PyObject) -> PyResult<PyObject> }
protocol __rtruediv__Owner { func rtruediv(_ other: PyObject) -> PyResult<PyObject> }
protocol __rxor__Owner { func rxor(_ other: PyObject) -> PyResult<PyObject> }
protocol __self__GetterOwner { func getSelf() -> PyObject }
protocol __self__Owner { func getSelf() -> PyObject }
protocol __self_class__GetterOwner { func getSelfClass() -> PyObject }
protocol __set__Owner { func set(object: PyObject, value: PyObject) -> PyResult<PyObject> }
protocol __setattr__Owner { func setAttribute(name: PyObject, value: PyObject?) -> PyResult<PyNone> }
protocol __setitem__Owner { func setItem(at index: PyObject, to value: PyObject) -> PyResult<PyNone> }
protocol __str__Owner { func str() -> PyResult<String> }
protocol __sub__Owner { func sub(_ other: PyObject) -> PyResult<PyObject> }
protocol __subclasscheck__Owner { func isSubtype(of object: PyObject) -> PyResult<Bool> }
protocol __subclasses__Owner { func getSubclasses() -> [PyType] }
protocol __suppress_context__GetterOwner { func getSuppressContext() -> PyBool }
protocol __suppress_context__SetterOwner { func setSuppressContext(_ value: PyObject?) -> PyResult<()> }
protocol __text_signature__GetterOwner { func getTextSignature() -> String? }
protocol __thisclass__GetterOwner { func getThisClass() -> PyObject }
protocol __traceback__GetterOwner { func getTraceback() -> PyObject? }
protocol __traceback__SetterOwner { func setTraceback(_ value: PyObject?) -> PyResult<()> }
protocol __truediv__Owner { func truediv(_ other: PyObject) -> PyResult<PyObject> }
protocol __trunc__Owner { func trunc() -> PyObject }
protocol __xor__Owner { func xor(_ other: PyObject) -> PyResult<PyObject> }
protocol addOwner { func add(_ value: PyObject) -> PyResult<PyNone> }
protocol appendOwner { func append(_ element: PyObject) -> PyResult<PyNone> }
protocol bit_lengthOwner { func bitLength() -> PyObject }
protocol clearOwner { func clear() -> PyNone }
protocol closeOwner { func close() -> PyResult<PyNone> }
protocol closedOwner { func isClosed() -> Bool }
protocol conjugateOwner { func conjugate() -> PyObject }
protocol copyOwner { func copy() -> PyObject }
protocol countOwner { func count(_ element: PyObject) -> PyResult<BigInt> }
protocol countRangedOwner { func count(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<BigInt> }
protocol differenceOwner { func difference(with other: PyObject) -> PyResult<PyObject> }
protocol discardOwner { func discard(_ value: PyObject) -> PyResult<PyNone> }
protocol endswithOwner { func endsWith(_ element: PyObject) -> PyResult<Bool> }
protocol endswithRangedOwner { func endsWith(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<Bool> }
protocol extendOwner { func extend(iterable: PyObject) -> PyResult<PyNone> }
protocol findOwner { func find(_ element: PyObject) -> PyResult<BigInt> }
protocol findRangedOwner { func find(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<BigInt> }
protocol getOwner { func getWithDefault(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> }
protocol indexOwner { func index(of element: PyObject) -> PyResult<BigInt> }
protocol indexRangedOwner { func index(of element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<BigInt> }
protocol indicesOwner { func indicesInSequence(length: PyObject) -> PyResult<PyObject> }
protocol insertOwner { func insert(at index: PyObject, item: PyObject) -> PyResult<PyNone> }
protocol intersectionOwner { func intersection(with other: PyObject) -> PyResult<PyObject> }
protocol is_integerOwner { func isInteger() -> PyBool }
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
protocol itemsOwner { func items() -> PyObject }
protocol keysOwner { func keys() -> PyObject }
protocol partitionOwner { func partition(separator: PyObject) -> PyResult<PyTuple> }
protocol popitemOwner { func popItem() -> PyResult<PyObject> }
protocol readOwner { func read(size: PyObject) -> PyResult<PyString> }
protocol readableOwner { func isReadable() -> Bool }
protocol removeOwner { func remove(_ value: PyObject) -> PyResult<PyNone> }
protocol reverseOwner { func reverse() -> PyResult<PyNone> }
protocol rfindOwner { func rfind(_ element: PyObject) -> PyResult<BigInt> }
protocol rfindRangedOwner { func rfind(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<BigInt> }
protocol rindexOwner { func rindex(_ element: PyObject) -> PyResult<BigInt> }
protocol rindexRangedOwner { func rindex(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<BigInt> }
protocol rpartitionOwner { func rpartition(separator: PyObject) -> PyResult<PyTuple> }
protocol setdefaultOwner { func setWithDefault(args: [PyObject], kwargs: PyDict?) -> PyResult<PyObject> }
protocol sortOwner { func sort(args: [PyObject], kwargs: PyDict?) -> PyResult<PyNone> }
protocol startswithOwner { func startsWith(_ element: PyObject) -> PyResult<Bool> }
protocol startswithRangedOwner { func startsWith(_ element: PyObject, start: PyObject?, end: PyObject?) -> PyResult<Bool> }
protocol symmetric_differenceOwner { func symmetricDifference(with other: PyObject) -> PyResult<PyObject> }
protocol unionOwner { func union(with other: PyObject) -> PyResult<PyObject> }
protocol valuesOwner { func values() -> PyObject }
protocol writableOwner { func isWritable() -> Bool }
protocol writeOwner { func write(object: PyObject) -> PyResult<PyNone> }
