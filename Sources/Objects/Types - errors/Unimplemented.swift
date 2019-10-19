// In CPython:
// Objects -> exceptions.c
// Lib->test->exception_hierarchy.txt <-- this is amazing
// https://docs.python.org/3.7/c-api/exceptions.html
/*
+-- OSError
  |    +-- BlockingIOError
  |    +-- ChildProcessError
  |    +-- ConnectionError
  |    |    +-- BrokenPipeError
  |    |    +-- ConnectionAbortedError
  |    |    +-- ConnectionRefusedError
  |    |    +-- ConnectionResetError
  |    +-- FileExistsError
  |    +-- FileNotFoundError
  |    +-- InterruptedError
  |    +-- IsADirectoryError
  |    +-- NotADirectoryError
  |    +-- PermissionError
  |    +-- ProcessLookupError
  |    +-- TimeoutError
+-- ValueError
  |    +-- UnicodeError
  |         +-- UnicodeDecodeError
  |         +-- UnicodeEncodeError
  |         +-- UnicodeTranslateError

internal final class PyUnicodeError: PyBaseException {
  internal var encoding: PyObject
  internal var object: PyObject
  internal var start: Py_ssize_t
  internal var end: Py_ssize_t
  internal var reason: PyObject
}

internal final class PyOSError: PyBaseException {
  internal var myerrno: PyObject
  internal var strerror: PyObject
  internal var filename: PyObject
  internal var filename2: PyObject
  internal var written: Py_ssize_t /* only for BlockingIOError, -1 otherwise */
}
*/
