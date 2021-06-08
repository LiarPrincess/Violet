// This file was auto-generated by Elsa from 'opcodes.letitgo.'
// DO NOT EDIT!

import Foundation
import VioletCore

// swiftlint:disable line_length
// swiftlint:disable file_length

extension Instruction {

  /// Instruction with proper typed argument taken from `CodeObject`.
  ///
  /// Can be used for utility functionality (like printing),
  /// but the performance is not adequate for `VM` use.
  public enum Filled: Equatable {
      /// Do nothing code.
      case nop
      /// Removes the top-of-stack (`TOS`) item.
      case popTop
      /// Swaps the two top-most stack items.
      case rotTwo
      /// Lifts second and third stack item one position up,
      /// moves top down to position three.
      case rotThree
      /// Duplicates the reference on top of the stack.
      case dupTop
      /// Duplicates the two references on top of the stack,
      /// leaving them in the same order.
      case dupTopTwo
      /// Implements `TOS = +TOS`.
      case unaryPositive
      /// Implements `TOS = -TOS`.
      case unaryNegative
      /// Implements `TOS = not TOS`.
      case unaryNot
      /// Implements `TOS = ~TOS`.
      case unaryInvert
      /// Implements `TOS = TOS1 ** TOS`.
      case binaryPower
      /// Implements `TOS = TOS1 * TOS`.
      case binaryMultiply
      /// Implements `TOS = TOS1 @ TOS`.
      case binaryMatrixMultiply
      /// Implements `TOS = TOS1 // TOS`.
      case binaryFloorDivide
      /// Implements `TOS = TOS1 / TOS`.
      case binaryTrueDivide
      /// Implements `TOS = TOS1 % TOS`.
      case binaryModulo
      /// Implements `TOS = TOS1 + TOS`.
      case binaryAdd
      /// Implements `TOS = TOS1 - TOS`.
      case binarySubtract
      /// Implements `TOS = TOS1 << TOS`.
      case binaryLShift
      /// Implements `TOS = TOS1 >> TOS`.
      case binaryRShift
      /// Implements `TOS = TOS1 & TOS`.
      case binaryAnd
      /// Implements `TOS = TOS1 ^ TOS`.
      case binaryXor
      /// Implements `TOS = TOS1 \| TOS`.
      case binaryOr
      /// Implements in-place `TOS = TOS1 ** TOS`.
      case inPlacePower
      /// Implements in-place `TOS = TOS1 * TOS`.
      case inPlaceMultiply
      /// Implements in-place `TOS = TOS1 @ TOS`.
      case inPlaceMatrixMultiply
      /// Implements in-place `TOS = TOS1 // TOS`.
      case inPlaceFloorDivide
      /// Implements in-place `TOS = TOS1 / TOS`.
      case inPlaceTrueDivide
      /// Implements in-place `TOS = TOS1 % TOS`.
      case inPlaceModulo
      /// Implements in-place `TOS = TOS1 + TOS`.
      case inPlaceAdd
      /// Implements in-place `TOS = TOS1 - TOS`.
      case inPlaceSubtract
      /// Implements in-place `TOS = TOS1 << TOS`.
      case inPlaceLShift
      /// Implements in-place `TOS = TOS1 >> TOS`.
      case inPlaceRShift
      /// Implements in-place `TOS = TOS1 & TOS`.
      case inPlaceAnd
      /// Implements in-place `TOS = TOS1 ^ TOS`.
      case inPlaceXor
      /// Implements in-place `TOS = TOS1 \| TOS`.
      case inPlaceOr
      /// Performs a comparison operation specified by argument using `TOS` and `TOS1`.
      case compareOp(type: CompareType)
      /// Implements `TOS = GetAwaitable(TOS)`.
      ///
      /// `GetAwaitable(o)` returns:
      /// - `o` if `o` is a coroutine object
      /// - generator object with the `CoIterableCoroutine` flag
      /// - `o.Await`
      case getAwaitable
      /// Implements `TOS = TOS.AIter()`.
      case getAIter
      /// Implements `Push(GetAwaitable(TOS.ANext()))`.
      /// See `GetAwaitable` for details.
      case getANext
      /// Pops `TOS` and yields it from a generator.
      case yieldValue
      /// Pops `TOS` and delegates to it as a subiterator from a generator.
      case yieldFrom
      /// Implements the expression statement for the interactive mode.
      /// `TOS` is removed from the stack and printed.
      /// In non-interactive mode, an expression statement is terminated with `PopTop`.
      case printExpr
      /// Pushes a block for a loop onto the block stack.
      /// The block spans from the current instruction up until `loopEndLabel`.
      case setupLoop(loopEndLabel: CodeObject.Label)
      /// `TOS` is an iterator. Call its `Next()` method.
      /// If this `yields` a new value, push it on the stack (leaving the iterator below it).
      /// If not then `TOS` is popped, and the byte code counter is incremented by delta.
      case forIter(ifEmptyLabel: CodeObject.Label)
      /// Implements `TOS = iter(TOS)`.
      case getIter
      /// If `TOS` is a generator iterator or coroutine object then it is left as is.
      /// Otherwise, implements `TOS = iter(TOS)`.
      case getYieldFromIter
      /// Terminates a loop due to a break statement.
      case `break`
      /// Continues a loop due to a continue statement.
      /// `loopStartLabel` is the address to jump to
      /// (which should be a `ForIter` instruction).
      case `continue`(loopStartLabel: CodeObject.Label)
      /// Creates a tuple consuming `count` items from the stack,
      /// and pushes the resulting tuple onto the stack.
      case buildTuple(elementCount: Int)
      /// Creates a list consuming `count` items from the stack,
      /// and pushes the resulting list onto the stack.
      case buildList(elementCount: Int)
      /// Creates a set consuming `count` items from the stack,
      /// and pushes the resulting set onto the stack.
      case buildSet(elementCount: Int)
      /// Pushes a new dictionary object onto the stack.
      /// Pops `2 * count` items so that the dictionary holds count entries:
      /// {..., `TOS3`: `TOS2`, `TOS1`: `TOS`}.
      case buildMap(elementCount: Int)
      /// The version of `BuildMap` specialized for constant keys.
      /// `elementCount` values are consumed from the stack.
      /// The top element on the stack contains a tuple of keys.
      case buildConstKeyMap(elementCount: Int)
      /// Calls `set.add(TOS1[-i], TOS)`. Container object remains on the stack.
      /// Used to implement set comprehensions.
      case setAdd(relativeStackIndex: Int)
      /// Calls `list.append(TOS[-i], TOS)`. Container object remains on the stack.
      /// Used to implement list comprehensions.
      case listAppend(relativeStackIndex: Int)
      /// Calls `dict.setItem(TOS1[-i], TOS, TOS1)`. Container object remains on the stack.
      /// Used to implement dict comprehensions.
      case mapAdd(relativeStackIndex: Int)
      /// Pops `count` iterables from the stack, joins them in a single tuple,
      /// and pushes the result.
      /// Implements iterable unpacking in tuple displays `(*x, *y, *z)`.
      case buildTupleUnpack(elementCount: Int)
      /// This is similar to `BuildTupleUnpack`, but is used for `f(*x, *y, *z)` call syntax.
      /// The stack item at position `count + 1` should be the corresponding callable `f`.
      case buildTupleUnpackWithCall(elementCount: Int)
      /// This is similar to `BuildTupleUnpack`, but pushes a list instead of tuple.
      /// Implements iterable unpacking in list displays `[*x, *y, *z]`.
      case buildListUnpack(elementCount: Int)
      /// This is similar to `BuildTupleUnpack`, but pushes a set instead of tuple.
      /// Implements iterable unpacking in set displays `{*x, *y, *z}`.
      case buildSetUnpack(elementCount: Int)
      /// Pops count mappings from the stack, merges them into a single dictionary,
      /// and pushes the result.
      /// Implements dictionary unpacking in dictionary displays `{**x, **y, **z}`.
      case buildMapUnpack(elementCount: Int)
      /// This is similar to `BuildMapUnpack`, but is used for `f(**x, **y, **z)` call syntax.
      /// The stack item at position `count + 2` should be the corresponding callable `f`.
      case buildMapUnpackWithCall(elementCount: Int)
      /// Unpacks `TOS` into count individual values,
      /// which are put onto the stack right-to-left.
      case unpackSequence(elementCount: Int)
      /// Implements assignment with a starred target.
      ///
      /// Unpacks an iterable in `TOS` into individual values, where the total number
      /// of values can be smaller than the number of items in the iterable:
      /// one of the new values will be a list of all leftover items.
      ///
      /// The low byte of counts is the number of values before the list value,
      /// the high byte of counts the number of values after it.
      /// The resulting values are put onto the stack right-to-left.
      ///
      /// Use `Instruction.UnpackExArg struct` to handle argument.
      case unpackEx(arg: Instruction.UnpackExArg)
      /// Pushes constant pointed by `index` onto the stack.
      case loadConst(CodeObject.Constant)
      /// Implements `name = TOS`.
      case storeName(name: String)
      /// Pushes the value associated with `name` onto the stack.
      case loadName(name: String)
      /// Implements `del name`.
      case deleteName(name: String)
      /// Implements `TOS.name = TOS1`.
      case storeAttribute(name: String)
      /// Implements `TOS = getAttr(TOS, name)`.
      case loadAttribute(name: String)
      /// Implements `del TOS.name`.
      case deleteAttribute(name: String)
      /// Implements `TOS = TOS1[TOS]`.
      case binarySubscript
      /// Implements `TOS1[TOS] = TOS2`.
      case storeSubscript
      /// Implements `del TOS1[TOS]`.
      case deleteSubscript
      /// Works as `StoreName`, but stores the name as a `global`.
      case storeGlobal(name: String)
      /// Loads the global named `name` onto the stack.
      case loadGlobal(name: String)
      /// Works as `DeleteName`, but deletes a `global` name.
      case deleteGlobal(name: String)
      /// Used for local function variables.
      /// Pushes a reference to the local `names[nameIndex]` onto the stack.
      case loadFast(variable: MangledName)
      /// Used for local function variables.
      /// Stores TOS into the local `names[nameIndex]`.
      case storeFast(variable: MangledName)
      /// Used for local function variables.
      /// Deletes local `names[nameIndex]`.
      case deleteFast(variable: MangledName)
      /// Loads the `cell` contained in slot `index` of the `cell` and `free` variable storage.
      /// Pushes a reference to the object the `cell` contains on the stack.
      case loadCellOrFree(cellOrFree: MangledName)
      /// Stores `TOS` into the `cell` contained in slot `index` of the `cell` and `free` variable storage.
      case storeCellOrFree(cellOrFree: MangledName)
      /// Empties the `cell` contained in slot `index` of the `cell` and `free` variable storage.
      /// Used by the `del` statement.
      case deleteCellOrFree(cellOrFree: MangledName)
      /// Much like `LoadCellOrFree` but first checks the locals dictionary before consulting the `cell`.
      /// This is used for loading free variables in `class` bodies.
      case loadClassCell(cellOrFree: MangledName)
      /// Pushes a new function object on the stack.
      ///
      /// From bottom to top, the consumed stack must consist of values
      /// if the argument carries a specified flag value
      /// - `0x01` - has tuple of default values for positional-only
      ///            and positional-or-keyword parameters in positional order
      /// - `0x02` - has dictionary of keyword-only parameters default values
      /// - `0x04` - has annotation dictionary
      /// - `0x08` - has tuple containing cells for free variables,
      ///            making a closure the code associated with the function (at `TOS1`)
      ///            the qualified name of the function (at `TOS`)
      case makeFunction(flags: FunctionFlags)
      /// Calls a callable object with positional arguments.
      /// `argc` indicates the number of positional arguments.
      ///
      /// Stack layout (1st item means TOS):
      /// - positional arguments, with the right-most argument on top
      /// - callable object to call.
      ///
      /// It will:
      /// 1. pop all arguments and the callable object off the stack
      /// 2. call the callable object with those arguments
      /// 3. push the return value returned by the callable object
      ///
      /// - Note:
      /// This opcode is used only for calls with positional arguments!
      case callFunction(argumentCount: Int)
      /// Calls a callable object with positional (if any) and keyword arguments.
      /// `argumentCount` indicates the total number of positional and keyword arguments.
      ///
      /// Stack layout (1st item means `TOS`):
      /// - tuple of keyword argument names
      /// - keyword arguments in the order corresponding to the tuple
      /// - positional arguments, with the right-most parameter on top
      /// - callable object to call.
      ///
      /// It will:
      /// 1. pop all arguments and the callable object off the stack
      /// 2. call the callable object with those arguments
      /// 3. push the return value returned by the callable object.
      case callFunctionKw(argumentCount: Int)
      /// Calls a callable object with variable set of positional and keyword arguments.
      ///
      /// Stack layout (1st item means `TOS`):
      /// - (if `hasKeywordArguments` is set) mapping object containing keyword arguments
      /// - iterable object containing positional arguments and a callable object to call
      ///
      /// `BuildMapUnpackWithCall` and `BuildTupleUnpackWithCall` can be used for
      /// merging multiple mapping objects and iterables containing arguments.
      ///
      /// It will:
      /// 1. pop all arguments and the callable object off the stack
      /// 2. mapping object and iterable object are each “unpacked” and their
      /// contents is passed in as keyword and positional arguments respectively
      /// 3. call the callable object with those arguments
      /// 4. push the return value returned by the callable object
      case callFunctionEx(hasKeywordArguments: Bool)
      /// Returns with `TOS` to the caller of the function.
      case `return`
      /// Pushes `builtins.BuildClass()` onto the stack.
      /// It is later called by `CallFunction` to construct a class.
      case loadBuildClass
      /// Loads a method named `name` from `TOS` object.
      ///
      /// `TOS` is popped and method and `TOS` are pushed when interpreter can call unbound method directly.
      /// `TOS` will be used as the first argument (`self`) by `CallMethod`.
      /// Otherwise, `NULL` and method is pushed (method is bound method or something else).
      case loadMethod(name: String)
      /// Calls a method.
      /// `argc` is number of positional arguments.
      /// Keyword arguments are not supported.
      ///
      /// This opcode is designed to be used with `LoadMethod`.
      /// Positional arguments are on top of the stack.
      /// Below them, two items described in `LoadMethod` on the stack.
      /// All of them are popped and return value is pushed.
      case callMethod(argumentCount: Int)
      /// Loads all symbols not starting with `_` directly from the module `TOS`
      /// to the local namespace.
      ///
      /// The module is popped after loading all names.
      /// This opcode implements `from module import *`.
      case importStar
      /// Imports the module `name`.
      ///
      /// `TOS` and `TOS1` are popped and provide the `from-list` and `level` arguments of `Import()`.
      /// The module object is pushed onto the stack.
      /// The current namespace is not affected: for a proper import statement,
      /// a subsequent `StoreFast` instruction modifies the namespace.
      case importName(name: String)
      /// Loads the attribute `name` from the module found in `TOS`.
      ///
      /// The resulting object is pushed onto the stack,
      /// to be subsequently stored by a `StoreFast` instruction.
      case importFrom(name: String)
      /// Removes one block from the block stack.
      /// The popped block must be an exception handler block,
      /// as implicitly created when entering an except handler.
      /// In addition to popping extraneous values from the frame stack,
      /// the last three popped values are used to restore the exception state.
      case popExcept
      /// Terminates a `finally` clause.
      /// The interpreter recalls whether the exception has to be re-raised,
      /// or whether the function returns, and continues with the outer-next block.
      case endFinally
      /// Pushes a try block from a try-except clause onto the block stack.
      /// `firstExceptLabel` points to the first except block.
      case setupExcept(firstExceptLabel: CodeObject.Label)
      /// Pushes a try block from a try-except clause onto the block stack.
      /// `finallyStartLabel` points to the finally block.
      case setupFinally(finallyStartLabel: CodeObject.Label)
      /// Raises an exception using one of the 3 forms of the raise statement,
      /// depending on the value of argc:
      /// - 0: raise (re-raise previous exception)
      /// - 1: raise `TOS` (raise exception instance or type at `TOS`)
      /// - 2: raise `TOS1` from `TOS` (raise exception instance or type at `TOS1` with `Cause` set to `TOS`)
      case raiseVarargs(type: RaiseArg)
      /// This opcode performs several operations before a `with` block starts.
      ///
      /// It does following operations:
      /// 1.loads `Exit()` from the context manager and pushes it onto the stack
      /// for later use by `WithCleanup`.
      /// 2. calls `Enter()`
      /// 3. block staring at to `afterBodyLabel` is pushed.
      /// 4. the result of calling the enter method is pushed onto the stack.
      ///
      /// The next opcode will either ignore it (`PopTop`),
      /// or store it in variable (`StoreFast`, `StoreName`, or `UnpackSequence`).
      case setupWith(afterBodyLabel: CodeObject.Label)
      /// Cleans up the stack when a `with` statement block exits.
      ///
      /// `TOS` is the context manager’s `__exit__()` bound method.
      /// Below `TOS` are 1–3 values indicating how/why the finally clause was entered:
      /// - `SECOND = None`
      /// - `(SECOND, THIRD) = (WHY_{RETURN,CONTINUE}), return value`
      /// - `SECOND = WHY_*; no return value below it`
      /// - `(SECOND, THIRD, FOURTH) = exc_info()`
      /// In the last case, `TOS(SECOND, THIRD, FOURTH)` is called,
      /// otherwise `TOS(None, None, None)`.
      /// Pushes `SECOND` and result of the call to the stack.
      case withCleanupStart
      /// Pops exception type and result of `exit` function call from the stack.
      ///
      /// If the stack represents an exception, and the function call returns a `true` value,
      /// this information is “zapped” and replaced with a single `WhySilenced`
      /// to prevent `EndFinally` from re-raising the exception.
      /// (But non-local `goto` will still be resumed.)
      case withCleanupFinish
      /// Resolves `AEnter` and `AExit` from the object on top of the stack.
      /// Pushes `AExit` and result of `AEnter()` to the stack.
      case beforeAsyncWith
      /// Creates a new frame object.
      case setupAsyncWith
      /// Set bytecode counter to target.
      case jumpAbsolute(label: CodeObject.Label)
      /// If `TOS` is `true`, sets the bytecode counter to target. `TOS` is popped.
      case popJumpIfTrue(label: CodeObject.Label)
      /// If `TOS` is `false`, sets the bytecode counter to target. `TOS` is popped.
      case popJumpIfFalse(label: CodeObject.Label)
      /// If `TOS` is `true`, sets the bytecode counter to target and leaves `TOS` on the stack.
      /// Otherwise (`TOS` is false), `TOS` is popped.
      case jumpIfTrueOrPop(label: CodeObject.Label)
      /// If `TOS` is `false`, sets the bytecode counter to target and leaves `TOS` on the stack.
      /// Otherwise (`TOS` is `true`), `TOS` is popped.
      case jumpIfFalseOrPop(label: CodeObject.Label)
      /// Used for implementing formatted literal strings (f-strings).
      ///
      /// (And yes, Swift will pack both payloads in single byte).
      case formatValue(conversion: StringConversion, hasFormat: Bool)
      /// Concatenates `count` strings from the stack
      /// and pushes the resulting string onto the stack.
      case buildString(elementCount: Int)
      /// Checks whether Annotations is defined in `locals()`,
      /// if not it is set up to an empty `dict`.
      ///
      /// This opcode is only emitted if a `class` or `module` body contains variable
      /// annotations statically.
      case setupAnnotations
      /// Removes one block from the block stack.
      /// Per frame, there is a stack of blocks, denoting nested loops, `try` statements, and such.
      case popBlock
      /// Pushes a reference to the cell contained in slot `index`
      /// of the `cell` or `free` variable storage.
      ///
      /// If `index < cellVars.count`: name of the variable is `cellVars[index]`.
      /// otherwise: name is `freeVars[index - cellVars.count]`.
      case loadClosure(cellOrFree: MangledName)
      /// Pushes a slice object on the stack.
      case buildSlice(type: SliceArg)
  }
}
