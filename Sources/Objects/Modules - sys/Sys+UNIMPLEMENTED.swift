import VioletCore

// swiftlint:disable line_length

extension Sys {
/*
  /// sys.abiflags
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.abiflags).
  internal var abiFlags: PyObject { }

  /// sys.base_exec_prefix
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.base_exec_prefix).
  internal var baseExecPrefix: PyObject { }

  /// sys.base_prefix
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.base_prefix).
  internal var basePrefix: PyObject { }

  /// sys.byteorder
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.byteorder).
  internal var byteOrder: PyObject { }

  /// sys.call_tracing(func, args)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.call_tracing).
  internal func callTracing() -> PyObject { }

  /// sys._clear_type_cache()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._clear_type_cache).
  internal func _clearTypeCache() -> PyObject { }

  /// sys._current_frames()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._current_frames).
  internal func _currentFrames() -> PyObject { }

  /// sys.breakpointhook()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.breakpointhook).
  internal func breakpointHook() -> PyObject { }

  /// sys._debugmallocstats()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._debugmallocstats).
  internal func _debugMallocStats() -> PyObject { }

  /// sys.dllhandle
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.dllhandle).
  internal var dllHandle: PyObject { }

  /// sys.dont_write_bytecode
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.dont_write_bytecode).
  internal var dontWriteBytecode: PyObject { }

  /// sys.__breakpointhook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__breakpointhook__).
  internal var __breakpointHook__: PyObject { }

  /// sys.exc_info()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exc_info).
  internal func exceptionInfo() -> PyObject { }

  /// sys.exec_prefix
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.exec_prefix).
  internal var execPrefix: PyObject { }

  /// sys.float_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.float_info).
  internal var floatInfo: PyObject { }

  /// sys.float_repr_style
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.float_repr_style).
  internal var floatReprStyle: PyObject { }

  /// sys.getallocatedblocks()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getallocatedblocks).
  internal func getAllocatedBlocks() -> PyObject { }

  /// sys.getandroidapilevel()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getandroidapilevel).
  internal func getAndroidApiLevel() -> PyObject { }

  /// sys.getcheckinterval()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getcheckinterval).
  internal func getCheckInterval() -> PyObject { }

  /// sys.getdlopenflags()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getdlopenflags).
  internal func getDlopenFlags() -> PyObject { }

  /// sys.getfilesystemencoding()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getfilesystemencoding).
  internal func getFileSystemEncoding() -> PyObject { }

  /// sys.getfilesystemencodeerrors()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getfilesystemencodeerrors).
  internal func getFileSystemEncodeErrors() -> PyObject { }

  /// sys.getrefcount(object)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getrefcount).
  internal func getRefCount() -> PyObject { }

  /// sys.getsizeof(object[, default])
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getsizeof).
  internal func getSizeof() -> PyObject { }

  /// sys.getswitchinterval()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getswitchinterval).
  internal func getSwitchInterval() -> PyObject { }

  /// sys.getprofile()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getprofile).
  internal func getProfile() -> PyObject { }

  /// sys.gettrace()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.gettrace).
  internal func getTrace() -> PyObject { }

  /// sys.getwindowsversion()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.getwindowsversion).
  internal func getWindowsVersion() -> PyObject { }

  /// sys.get_asyncgen_hooks()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.get_asyncgen_hooks).
  internal func getAsyncGenHooks() -> PyObject { }

  /// sys.get_coroutine_origin_tracking_depth()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.get_coroutine_origin_tracking_depth).
  internal func getCoroutineOriginTrackingDepth() -> PyObject { }

  /// sys.get_coroutine_wrapper()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.get_coroutine_wrapper).
  internal func getCoroutineWrapper() -> PyObject { }

  /// sys.int_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.int_info).
  internal var intInfo: PyObject { }

  /// sys.__interactivehook__
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.__interactivehook__).
  internal var __interactivehook__: PyObject { }

  /// sys.is_finalizing()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.is_finalizing).
  internal func isFinalizing() -> PyObject { }

  /// sys.last_type
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.last_type).
  internal var lastType: PyObject { }

  /// sys.maxunicode
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.maxunicode).
  internal var maxUnicode: PyObject { }

  /// sys.setcheckinterval(interval)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setcheckinterval).
  internal func setCheckInterval() -> PyObject { }

  /// sys.setdlopenflags(n)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setdlopenflags).
  internal func setDlopenFlags() -> PyObject { }

  /// sys.setprofile(profilefunc)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setprofile).
  internal func setProfile() -> PyObject { }

  /// sys.setswitchinterval(interval)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.setswitchinterval).
  internal func setSwitchInterval() -> PyObject { }

  /// sys.settrace(tracefunc)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.settrace).
  internal func setTrace() -> PyObject { }

  // getwindowsversion

  /// sys.set_asyncgen_hooks(firstiter, finalizer)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.set_asyncgen_hooks).
  internal func setAsyncGenHooks() -> PyObject { }

  /// sys.set_coroutine_origin_tracking_depth(depth)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.set_coroutine_origin_tracking_depth).
  internal func setCoroutineOriginTrackingDepth() -> PyObject { }

  /// sys.set_coroutine_wrapper(wrapper)
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.set_coroutine_wrapper).
  internal func setCoroutineWrapper() -> PyObject { }

  /// sys._enablelegacywindowsfsencoding()
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._enablelegacywindowsfsencoding).
  internal func _enableLegacyWindowsFSEncoding() -> PyObject { }

  /// sys.thread_info
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.thread_info).
  internal var threadInfo: PyObject { }

  /// sys.api_version
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.api_version).
  internal var apiVersion: PyObject { }

  /// sys.winver
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys.winver).
  internal var winver: PyObject { }

  /// sys._xoptions
  /// See [this](https://docs.python.org/3.7/library/sys.html#sys._xoptions).
  internal var _xoptions: PyObject { }
*/
}
