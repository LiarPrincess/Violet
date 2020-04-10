import Core

// swiftlint:disable line_length

extension Sys {
/*
  // sourcery: pyproperty = abiflags
  /// sys.abiflags
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.abiflags).
  internal var abiFlags: PyObject { }

  // sourcery: pyproperty = base_exec_prefix
  /// sys.base_exec_prefix
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.base_exec_prefix).
  internal var baseExecPrefix: PyObject { }

  // sourcery: pyproperty = base_prefix
  /// sys.base_prefix
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.base_prefix).
  internal var basePrefix: PyObject { }

  // sourcery: pyproperty = byteorder
  /// sys.byteorder
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.byteorder).
  internal var byteOrder: PyObject { }

  // sourcery: pymethod = call_tracing
  /// sys.call_tracing(func, args)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.call_tracing).
  internal func callTracing() -> PyObject { }

  // sourcery: pymethod = _clear_type_cache
  /// sys._clear_type_cache()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._clear_type_cache).
  internal func _clearTypeCache() -> PyObject { }

  // sourcery: pymethod = _current_frames
  /// sys._current_frames()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._current_frames).
  internal func _currentFrames() -> PyObject { }

  // sourcery: pymethod = breakpointhook
  /// sys.breakpointhook()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.breakpointhook).
  internal func breakpointHook() -> PyObject { }

  // sourcery: pymethod = _debugmallocstats
  /// sys._debugmallocstats()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._debugmallocstats).
  internal func _debugMallocStats() -> PyObject { }

  // sourcery: pyproperty = dllhandle
  /// sys.dllhandle
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.dllhandle).
  internal var dllHandle: PyObject { }

  // sourcery: pymethod = displayhook
  /// sys.displayhook(value)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.displayhook).
  internal func displayHook() -> PyObject { }

  // sourcery: pyproperty = dont_write_bytecode
  /// sys.dont_write_bytecode
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.dont_write_bytecode).
  internal var dontWriteBytecode: PyObject { }

  // sourcery: pymethod = excepthook
  /// sys.excepthook(type, value, traceback)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.excepthook).
  internal func exceptHook() -> PyObject { }

  // sourcery: pyproperty = __breakpointhook__
  /// sys.__breakpointhook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__breakpointhook__).
  internal var __breakpointHook__: PyObject { }

  // sourcery: pymethod = exc_info
  /// sys.exc_info()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exc_info).
  internal func exceptionInfo() -> PyObject { }

  // sourcery: pyproperty = exec_prefix
  /// sys.exec_prefix
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exec_prefix).
  internal var execPrefix: PyObject { }

  // sourcery: pyproperty = float_info
  /// sys.float_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.float_info).
  internal var floatInfo: PyObject { }

  // sourcery: pyproperty = float_repr_style
  /// sys.float_repr_style
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.float_repr_style).
  internal var floatReprStyle: PyObject { }

  // sourcery: pymethod = getallocatedblocks
  /// sys.getallocatedblocks()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getallocatedblocks).
  internal func getAllocatedBlocks() -> PyObject { }

  // sourcery: pymethod = getandroidapilevel
  /// sys.getandroidapilevel()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getandroidapilevel).
  internal func getAndroidApiLevel() -> PyObject { }

  // sourcery: pymethod = getcheckinterval
  /// sys.getcheckinterval()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getcheckinterval).
  internal func getCheckInterval() -> PyObject { }

  // sourcery: pymethod = getdlopenflags
  /// sys.getdlopenflags()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getdlopenflags).
  internal func getDlopenFlags() -> PyObject { }

  // sourcery: pymethod = getfilesystemencoding
  /// sys.getfilesystemencoding()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getfilesystemencoding).
  internal func getFileSystemEncoding() -> PyObject { }

  // sourcery: pymethod = getfilesystemencodeerrors
  /// sys.getfilesystemencodeerrors()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getfilesystemencodeerrors).
  internal func getFileSystemEncodeErrors() -> PyObject { }

  // sourcery: pymethod = getrefcount
  /// sys.getrefcount(object)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getrefcount).
  internal func getRefCount() -> PyObject { }

  // sourcery: pymethod = getrecursionlimit
  /// sys.getrecursionlimit()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getrecursionlimit).
  internal func getRecursionLimit() -> PyObject { }

  // sourcery: pymethod = getsizeof
  /// sys.getsizeof(object[, default])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getsizeof).
  internal func getSizeof() -> PyObject { }

  // sourcery: pymethod = getswitchinterval
  /// sys.getswitchinterval()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getswitchinterval).
  internal func getSwitchInterval() -> PyObject { }

  // sourcery: pymethod = _getframe
  /// sys._getframe([depth])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._getframe).
  internal func _getFrame() -> PyObject { }

  // sourcery: pymethod = getprofile
  /// sys.getprofile()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getprofile).
  internal func getProfile() -> PyObject { }

  // sourcery: pymethod = gettrace
  /// sys.gettrace()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.gettrace).
  internal func getTrace() -> PyObject { }

  // sourcery: pymethod = getwindowsversion
  /// sys.getwindowsversion()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getwindowsversion).
  internal func getWindowsVersion() -> PyObject { }

  // sourcery: pymethod = get_asyncgen_hooks
  /// sys.get_asyncgen_hooks()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.get_asyncgen_hooks).
  internal func getAsyncGenHooks() -> PyObject { }

  // sourcery: pymethod = get_coroutine_origin_tracking_depth
  /// sys.get_coroutine_origin_tracking_depth()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.get_coroutine_origin_tracking_depth).
  internal func getCoroutineOriginTrackingDepth() -> PyObject { }

  // sourcery: pymethod = get_coroutine_wrapper
  /// sys.get_coroutine_wrapper()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.get_coroutine_wrapper).
  internal func getCoroutineWrapper() -> PyObject { }

  // sourcery: pyproperty = int_info
  /// sys.int_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.int_info).
  internal var intInfo: PyObject { }

  // sourcery: pyproperty = __interactivehook__
  /// sys.__interactivehook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__interactivehook__).
  internal var __interactivehook__: PyObject { }

  // sourcery: pymethod = is_finalizing
  /// sys.is_finalizing()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.is_finalizing).
  internal func isFinalizing() -> PyObject { }

  // sourcery: pyproperty = last_type
  /// sys.last_type
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.last_type).
  internal var lastType: PyObject { }

  // sourcery: pyproperty = maxsize
  /// sys.maxsize
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.maxsize).
  internal var maxSize: PyObject { }

  // sourcery: pyproperty = maxunicode
  /// sys.maxunicode
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.maxunicode).
  internal var maxUnicode: PyObject { }

  // sourcery: pymethod = setcheckinterval
  /// sys.setcheckinterval(interval)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setcheckinterval).
  internal func setCheckInterval() -> PyObject { }

  // sourcery: pymethod = setdlopenflags
  /// sys.setdlopenflags(n)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setdlopenflags).
  internal func setDlopenFlags() -> PyObject { }

  // sourcery: pymethod = setprofile
  /// sys.setprofile(profilefunc)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setprofile).
  internal func setProfile() -> PyObject { }

  // sourcery: pymethod = setrecursionlimit
  /// sys.setrecursionlimit(limit)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setrecursionlimit).
  internal func setRecursionLimit() -> PyObject { }

  // sourcery: pymethod = setswitchinterval
  /// sys.setswitchinterval(interval)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setswitchinterval).
  internal func setSwitchInterval() -> PyObject { }

  // sourcery: pymethod = settrace
  /// sys.settrace(tracefunc)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.settrace).
  internal func setTrace() -> PyObject { }

  // getwindowsversion

  // sourcery: pymethod = set_asyncgen_hooks
  /// sys.set_asyncgen_hooks(firstiter, finalizer)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.set_asyncgen_hooks).
  internal func setAsyncGenHooks() -> PyObject { }

  // sourcery: pymethod = set_coroutine_origin_tracking_depth
  /// sys.set_coroutine_origin_tracking_depth(depth)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.set_coroutine_origin_tracking_depth).
  internal func setCoroutineOriginTrackingDepth() -> PyObject { }

  // sourcery: pymethod = set_coroutine_wrapper
  /// sys.set_coroutine_wrapper(wrapper)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.set_coroutine_wrapper).
  internal func setCoroutineWrapper() -> PyObject { }

  // sourcery: pymethod = _enablelegacywindowsfsencoding
  /// sys._enablelegacywindowsfsencoding()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._enablelegacywindowsfsencoding).
  internal func _enableLegacyWindowsFSEncoding() -> PyObject { }

  // sourcery: pyproperty = thread_info
  /// sys.thread_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.thread_info).
  internal var threadInfo: PyObject { }

  // sourcery: pyproperty = tracebacklimit
  /// sys.tracebacklimit
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.tracebacklimit).
  internal var tracebackLimit: PyObject { }

  // sourcery: pyproperty = api_version
  /// sys.api_version
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.api_version).
  internal var apiVersion: PyObject { }

  // sourcery: pyproperty = winver
  /// sys.winver
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.winver).
  internal var winver: PyObject { }

  // sourcery: pyproperty = _xoptions
  /// sys._xoptions
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._xoptions).
  internal var _xoptions: PyObject { }
*/
}
