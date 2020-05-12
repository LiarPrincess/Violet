#define SimpleExtendsException(EXCBASE, EXCNAME, EXCDOC) \
static PyTypeObject _PyExc_ ## EXCNAME = { \
    PyVarObject_HEAD_INIT(NULL, 0) \
    # EXCNAME, \
    sizeof(PyBaseExceptionObject), \
    0, (destructor)BaseException_dealloc, 0, 0, 0, 0, 0, 0, 0, \
    0, 0, 0, 0, 0, 0, 0, \
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC, \
    PyDoc_STR(EXCDOC),
    (traverseproc)BaseException_traverse, \
    (inquiry)BaseException_clear,
    0,
    0,
    0,
    0,
    0,
    0,
    0,
    &_ ## EXCBASE, \
    0, 0, 0, offsetof(PyBaseExceptionObject, dict), \
    (initproc)BaseException_init, 0, BaseException_new,\
}; \
PyObject *PyExc_ ## EXCNAME = (PyObject *)&_PyExc_ ## EXCNAME

#define MiddlingExtendsException(EXCBASE, EXCNAME, EXCSTORE, EXCDOC) \
    static PyTypeObject _PyExc_ ## EXCNAME = { \
    PyVarObject_HEAD_INIT(NULL, 0) \
    # EXCNAME, \
    sizeof(Py ## EXCSTORE ## Object), \
    0, (destructor)EXCSTORE ## _dealloc, 0, 0, 0, 0, 0, 0, 0, 0, 0, \
    0, 0, 0, 0, 0, \
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC, \
    PyDoc_STR(EXCDOC),
    (traverseproc)EXCSTORE ## _traverse, \
    (inquiry)EXCSTORE ## _clear
    0
    0
    0
    0
    0
    0
    0
    &_ ## EXCBASE, \
    0, 0, 0, offsetof(Py ## EXCSTORE ## Object, dict), \
    (initproc)EXCSTORE ## _init, 0, 0, \
}; \
PyObject *PyExc_ ## EXCNAME = (PyObject *)&_PyExc_ ## EXCNAME

#define ComplexExtendsException(EXCBASE, EXCNAME, EXCSTORE, EXCNEW, \
                                EXCMETHODS, EXCMEMBERS, EXCGETSET, \
                                EXCSTR, EXCDOC) \
    static PyTypeObject _PyExc_ ## EXCNAME = { \
    PyVarObject_HEAD_INIT(NULL, 0) \
    # EXCNAME, \
    sizeof(Py ## EXCSTORE ## Object), 0, \
    (destructor)EXCSTORE ## _dealloc, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, \
    (reprfunc)EXCSTR, 0, 0, 0, \
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC, \
    PyDoc_STR(EXCDOC),
    (traverseproc)EXCSTORE ## _traverse, \
    (inquiry)EXCSTORE ## _clear
    0
    0
    0
    0
    EXCMETHODS, \
    EXCMEMBERS,
    EXCGETSET,
    &_ ## EXCBASE, \
    0, 0, 0,
    offsetof(Py ## EXCSTORE ## Object, dict), \
    (initproc)EXCSTORE ## _init,
    0,
    EXCNEW,\
}; \
PyObject *PyExc_ ## EXCNAME = (PyObject *)&_PyExc_ ## EXCNAME


#define SimpleExtendsException(EXCBASE,       EXCNAME,             EXCDOC)
SimpleExtendsException(PyExc_BaseException,   Exception,           "Common base class for all non-exit exceptions.");
SimpleExtendsException(PyExc_Exception,       TypeError,           "Inappropriate argument type.");
SimpleExtendsException(PyExc_Exception,       StopAsyncIteration,  "Signal the end from iterator.__anext__().");
SimpleExtendsException(PyExc_BaseException,   GeneratorExit,       "Request that a generator exit.");
SimpleExtendsException(PyExc_BaseException,   KeyboardInterrupt,   "Program interrupted by user.");
SimpleExtendsException(PyExc_Exception,       EOFError,            "Read beyond end of file.");
SimpleExtendsException(PyExc_Exception,       RuntimeError,        "Unspecified run-time error.");
SimpleExtendsException(PyExc_RuntimeError,    RecursionError,      "Recursion limit exceeded.");
SimpleExtendsException(PyExc_RuntimeError,    NotImplementedError, "Method or function hasn't been implemented yet.");
SimpleExtendsException(PyExc_Exception,       NameError,           "Name not found globally.");
SimpleExtendsException(PyExc_NameError,       UnboundLocalError,   "Local name referenced but not bound to a value.");
SimpleExtendsException(PyExc_Exception,       AttributeError,      "Attribute not found.");
SimpleExtendsException(PyExc_Exception,       LookupError,         "Base class for lookup errors.");
SimpleExtendsException(PyExc_LookupError,     IndexError,          "Sequence index out of range.");
SimpleExtendsException(PyExc_Exception,       ValueError,          "Inappropriate argument value (of correct type).");
SimpleExtendsException(PyExc_ValueError,      UnicodeError,        "Unicode related error.");
SimpleExtendsException(PyExc_Exception,       AssertionError,      "Assertion failed.");
SimpleExtendsException(PyExc_Exception,       ArithmeticError,     "Base class for arithmetic errors.");
SimpleExtendsException(PyExc_ArithmeticError, FloatingPointError,  "Floating point operation failed.");
SimpleExtendsException(PyExc_ArithmeticError, OverflowError,       "Result too large to be represented.");
SimpleExtendsException(PyExc_ArithmeticError, ZeroDivisionError,   "Second argument to a division or modulo operation was zero.");
SimpleExtendsException(PyExc_Exception,       SystemError,         "Internal error in the Python interpreter.\n\nPlease report this to the Python maintainer, along with the traceback,\nthe Python version, and the hardware/OS platform and version.");
SimpleExtendsException(PyExc_Exception,       ReferenceError,      "Weak ref proxy used after referent went away.");
SimpleExtendsException(PyExc_Exception,       BufferError,         "Buffer error.")
SimpleExtendsException(PyExc_Exception,       Warning,             "Base class for warning categories.");
SimpleExtendsException(PyExc_Warning,         UserWarning,         "Base class for warnings generated by user code.");
SimpleExtendsException(PyExc_Warning,         DeprecationWarning,  "Base class for warnings about deprecated features.");
SimpleExtendsException(PyExc_Warning,         PendingDeprecationWarning, "Base class for warnings about features which will be deprecated\nin the future.");
SimpleExtendsException(PyExc_Warning,         SyntaxWarning,   "Base class for warnings about dubious syntax.");
SimpleExtendsException(PyExc_Warning,         RuntimeWarning,  "Base class for warnings about dubious runtime behavior.");
SimpleExtendsException(PyExc_Warning,         FutureWarning,   "Base class for warnings about constructs that will change semantically\nin the future.");
SimpleExtendsException(PyExc_Warning,         ImportWarning,   "Base class for warnings about probable mistakes in module imports");
SimpleExtendsException(PyExc_Warning,         UnicodeWarning,  "Base class for warnings about Unicode related problems, mostly\nrelated to conversion problems.");
SimpleExtendsException(PyExc_Warning,         BytesWarning,    "Base class for warnings about bytes and buffer related problems, mostly\nrelated to conversion from str or comparing to str.");
SimpleExtendsException(PyExc_Warning,         ResourceWarning, "Base class for warnings about resource usage.");

#define MiddlingExtendsException(EXCBASE,        EXCNAME,                EXCSTORE,    EXCDOC)
MiddlingExtendsException(PyExc_ImportError,      ModuleNotFoundError,    ImportError, "Module not found.");
MiddlingExtendsException(PyExc_OSError,          BlockingIOError,        OSError,     "I/O operation would block.");
MiddlingExtendsException(PyExc_OSError,          ConnectionError,        OSError,     "Connection error.");
MiddlingExtendsException(PyExc_OSError,          ChildProcessError,      OSError,     "Child process error.");
MiddlingExtendsException(PyExc_ConnectionError,  BrokenPipeError,        OSError,     "Broken pipe.");
MiddlingExtendsException(PyExc_ConnectionError,  ConnectionAbortedError, OSError,     "Connection aborted.");
MiddlingExtendsException(PyExc_ConnectionError,  ConnectionRefusedError, OSError,     "Connection refused.");
MiddlingExtendsException(PyExc_ConnectionError,  ConnectionResetError,   OSError,     "Connection reset.");
MiddlingExtendsException(PyExc_OSError,          FileExistsError,        OSError,     "File already exists.");
MiddlingExtendsException(PyExc_OSError,          FileNotFoundError,      OSError,     "File not found.");
MiddlingExtendsException(PyExc_OSError,          IsADirectoryError,      OSError,     "Operation doesn't work on directories.");
MiddlingExtendsException(PyExc_OSError,          NotADirectoryError,     OSError,     "Operation only works on directories.");
MiddlingExtendsException(PyExc_OSError,          InterruptedError,       OSError,     "Interrupted by signal.");
MiddlingExtendsException(PyExc_OSError,          PermissionError,        OSError,     "Not enough permissions.");
MiddlingExtendsException(PyExc_OSError,          ProcessLookupError,     OSError,     "Process not found.");
MiddlingExtendsException(PyExc_OSError,          TimeoutError,           OSError,     "Timeout expired.");
MiddlingExtendsException(PyExc_SyntaxError,      IndentationError,       SyntaxError, "Improper indentation.");
MiddlingExtendsException(PyExc_IndentationError, TabError,               SyntaxError, "Improper mixture of spaces and tabs.");

#define ComplexExtendsException(EXCBASE,     EXCNAME,       EXCSTORE,      EXCNEW,      EXCMETHODS,          EXCMEMBERS,            EXCGETSET,      EXCSTR,          EXCDOC)
ComplexExtendsException(PyExc_Exception,     StopIteration, StopIteration, 0,           0,                   StopIteration_members, 0,              0,               "Signal the end from iterator.__next__().");
ComplexExtendsException(PyExc_BaseException, SystemExit,    SystemExit,    0,           0,                   SystemExit_members,    0,              0,               "Request to exit from the interpreter.");
ComplexExtendsException(PyExc_Exception,     ImportError,   ImportError,   0,           ImportError_methods, ImportError_members,   0,              ImportError_str, "Import can't find module, or can't find name in module.");
ComplexExtendsException(PyExc_Exception,     OSError,       OSError,       OSError_new, OSError_methods,     OSError_members,       OSError_getset, OSError_str,     "Base class for I/O related errors.");
ComplexExtendsException(PyExc_Exception,     SyntaxError,   SyntaxError,   0,           0,                   SyntaxError_members,   0,              SyntaxError_str, "Invalid syntax.");
ComplexExtendsException(PyExc_LookupError,   KeyError,      BaseException, 0,           0,                   0,                     0,              KeyError_str,    "Mapping key not found.");
+ Unicode thingies












/*
*    KeyError extends LookupError
*/

static PyObject *
KeyError_str(PyBaseExceptionObject *self)
{
    /* If args is a tuple of exactly one item, apply repr to args[0].
    This is done so that e.g. the exception raised by {}[''] prints
        KeyError: ''
    rather than the confusing
        KeyError
    alone.  The downside is that if KeyError is raised with an explanatory
    string, that string will be displayed in quotes.  Too bad.
    If args is anything else, use the default BaseException__str__().
    */
    if (PyTuple_GET_SIZE(self->args) == 1) {
        return PyObject_Repr(PyTuple_GET_ITEM(self->args, 0));
    }
    return BaseException_str(self);
}














/*
*    StopIteration extends Exception
*/

typedef struct {
    PyException_HEAD
    PyObject *value;
} PyStopIterationObject;

static PyMemberDef StopIteration_members[] = {
    {"value", T_OBJECT, offsetof(PyStopIterationObject, value), 0, PyDoc_STR("generator return value")},
    {NULL}  /* Sentinel */
};

static int
StopIteration_init(PyStopIterationObject *self, PyObject *args, PyObject *kwds)
{
    Py_ssize_t size = PyTuple_GET_SIZE(args);
    PyObject *value;

    if (BaseException_init((PyBaseExceptionObject *)self, args, kwds) == -1)
        return -1;
    Py_CLEAR(self->value);
    if (size > 0)
        value = PyTuple_GET_ITEM(args, 0);
    else
        value = Py_None;
    Py_INCREF(value);
    self->value = value;
    return 0;
}

/*
*    SystemExit extends BaseException
*/

typedef struct {
    PyException_HEAD
    PyObject *code;
} PySystemExitObject;

static PyMemberDef SystemExit_members[] = {
    {"code", T_OBJECT, offsetof(PySystemExitObject, code), 0, PyDoc_STR("exception code")},
    {NULL}  /* Sentinel */
};

static int
SystemExit_init(PySystemExitObject *self, PyObject *args, PyObject *kwds)
{
    Py_ssize_t size = PyTuple_GET_SIZE(args);

    if (BaseException_init((PyBaseExceptionObject *)self, args, kwds) == -1)
        return -1;

    if (size == 0)
        return 0;

    if (size == 1) {
        Py_INCREF(PyTuple_GET_ITEM(args, 0));
        Py_XSETREF(self->code, PyTuple_GET_ITEM(args, 0));
    }
    else { /* size > 1 */
        Py_INCREF(args);
        Py_XSETREF(self->code, args);
    }

    return 0;
}













/*
*    ImportError extends Exception
*/

typedef struct {
    PyException_HEAD
    PyObject *msg;
    PyObject *name;
    PyObject *path;
} PyImportErrorObject;

static int
ImportError_init(PyImportErrorObject *self, PyObject *args, PyObject *kwds)
{
    static char *kwlist[] = {"name", "path", 0};
    PyObject *empty_tuple;
    PyObject *msg = NULL;
    PyObject *name = NULL;
    PyObject *path = NULL;

    if (BaseException_init((PyBaseExceptionObject *)self, args, NULL) == -1)
        return -1;

    empty_tuple = PyTuple_New(0);
    if (!empty_tuple)
        return -1;

    if (!PyArg_ParseTupleAndKeywords(empty_tuple, kwds, "|$OO:ImportError", kwlist,
                                    &name, &path)) {
        Py_DECREF(empty_tuple);
        return -1;
    }
    Py_DECREF(empty_tuple);

    Py_XINCREF(name);
    Py_XSETREF(self->name, name);

    Py_XINCREF(path);
    Py_XSETREF(self->path, path);



    if (PyTuple_GET_SIZE(args) == 1) {
        msg = PyTuple_GET_ITEM(args, 0);
        Py_INCREF(msg);
    }
    Py_XSETREF(self->msg, msg);

    return 0;
}

static PyObject *
ImportError_str(PyImportErrorObject *self)
{
    if (self->msg && PyUnicode_CheckExact(self->msg)) {
        Py_INCREF(self->msg);
        return self->msg;
    }
    else {
        return BaseException_str((PyBaseExceptionObject *)self);
    }
}

static PyMemberDef ImportError_members[] = {
    {"msg", T_OBJECT, offsetof(PyImportErrorObject, msg), 0, PyDoc_STR("exception message")},
    {"name", T_OBJECT, offsetof(PyImportErrorObject, name), 0, PyDoc_STR("module name")},
    {"path", T_OBJECT, offsetof(PyImportErrorObject, path), 0, PyDoc_STR("module path")},
    {NULL}  /* Sentinel */
};














/*
*    SyntaxError extends Exception
*/

typedef struct {
    PyException_HEAD
    PyObject *msg;
    PyObject *filename;
    PyObject *lineno;
    PyObject *offset;
    PyObject *text;
    PyObject *print_file_and_line;
} PySyntaxErrorObject;

/* Helper function to customize error message for some syntax errors */
static int _report_missing_parentheses(PySyntaxErrorObject *self);

static int
SyntaxError_init(PySyntaxErrorObject *self, PyObject *args, PyObject *kwds)
{
    PyObject *info = NULL;
    Py_ssize_t lenargs = PyTuple_GET_SIZE(args);

    if (BaseException_init((PyBaseExceptionObject *)self, args, kwds) == -1)
        return -1;

    if (lenargs >= 1) {
        Py_INCREF(PyTuple_GET_ITEM(args, 0));
        Py_XSETREF(self->msg, PyTuple_GET_ITEM(args, 0));
    }

    if (lenargs == 2) {
        info = PyTuple_GET_ITEM(args, 1);
        info = PySequence_Tuple(info);
        if (!info)
            return -1;

        if (PyTuple_GET_SIZE(info) != 4) {
            /* not a very good error message, but it's what Python 2.4 gives */
            PyErr_SetString(PyExc_IndexError, "tuple index out of range");
            Py_DECREF(info);
            return -1;
        }

        Py_INCREF(PyTuple_GET_ITEM(info, 0));
        Py_XSETREF(self->filename, PyTuple_GET_ITEM(info, 0));

        Py_INCREF(PyTuple_GET_ITEM(info, 1));
        Py_XSETREF(self->lineno, PyTuple_GET_ITEM(info, 1));

        Py_INCREF(PyTuple_GET_ITEM(info, 2));
        Py_XSETREF(self->offset, PyTuple_GET_ITEM(info, 2));

        Py_INCREF(PyTuple_GET_ITEM(info, 3));
        Py_XSETREF(self->text, PyTuple_GET_ITEM(info, 3));

        Py_DECREF(info);

        /*
        * Issue #21669: Custom error for 'print' & 'exec' as statements
        *
        * Only applies to SyntaxError instances, not to subclasses such
        * as TabError or IndentationError (see issue #31161)
        */
        if ((PyObject*)Py_TYPE(self) == PyExc_SyntaxError &&
                self->text && PyUnicode_Check(self->text) &&
                _report_missing_parentheses(self) < 0) {
            return -1;
        }
    }
    return 0;
}

/* This is called "my_basename" instead of just "basename" to avoid name
conflicts with glibc; basename is already prototyped if _GNU_SOURCE is
defined, and Python does define that. */
static PyObject*
my_basename(PyObject *name)
{
    Py_ssize_t i, size, offset;
    int kind;
    void *data;

    if (PyUnicode_READY(name))
        return NULL;
    kind = PyUnicode_KIND(name);
    data = PyUnicode_DATA(name);
    size = PyUnicode_GET_LENGTH(name);
    offset = 0;
    for(i=0; i < size; i++) {
        if (PyUnicode_READ(kind, data, i) == SEP)
            offset = i + 1;
    }
    if (offset != 0)
        return PyUnicode_Substring(name, offset, size);
    else {
        Py_INCREF(name);
        return name;
    }
}


static PyObject *
SyntaxError_str(PySyntaxErrorObject *self)
{
    int have_lineno = 0;
    PyObject *filename;
    PyObject *result;
    /* Below, we always ignore overflow errors, just printing -1.
    Still, we cannot allow an OverflowError to be raised, so
    we need to call PyLong_AsLongAndOverflow. */
    int overflow;

    /* XXX -- do all the additional formatting with filename and
    lineno here */

    if (self->filename && PyUnicode_Check(self->filename)) {
        filename = my_basename(self->filename);
        if (filename == NULL)
            return NULL;
    } else {
        filename = NULL;
    }
    have_lineno = (self->lineno != NULL) && PyLong_CheckExact(self->lineno);

    if (!filename && !have_lineno)
        return PyObject_Str(self->msg ? self->msg : Py_None);

    if (filename && have_lineno)
        result = PyUnicode_FromFormat("%S (%U, line %ld)",
                self->msg ? self->msg : Py_None,
                filename,
                PyLong_AsLongAndOverflow(self->lineno, &overflow));
    else if (filename)
        result = PyUnicode_FromFormat("%S (%U)",
                self->msg ? self->msg : Py_None,
                filename);
    else /* only have_lineno */
        result = PyUnicode_FromFormat("%S (line %ld)",
                self->msg ? self->msg : Py_None,
                PyLong_AsLongAndOverflow(self->lineno, &overflow));
    Py_XDECREF(filename);
    return result;
}

static PyMemberDef SyntaxError_members[] = {
    {"msg", T_OBJECT, offsetof(PySyntaxErrorObject, msg), 0, PyDoc_STR("exception msg")},
    {"filename", T_OBJECT, offsetof(PySyntaxErrorObject, filename), 0, PyDoc_STR("exception filename")},
    {"lineno", T_OBJECT, offsetof(PySyntaxErrorObject, lineno), 0, PyDoc_STR("exception lineno")},
    {"offset", T_OBJECT, offsetof(PySyntaxErrorObject, offset), 0, PyDoc_STR("exception offset")},
    {"text", T_OBJECT, offsetof(PySyntaxErrorObject, text), 0, PyDoc_STR("exception text")},
    {"print_file_and_line", T_OBJECT, offsetof(PySyntaxErrorObject, print_file_and_line), 0, PyDoc_STR("exception print_file_and_line")},
    {NULL}  /* Sentinel */
};














/*
 *    OSError extends Exception
 */

typedef struct {
    PyException_HEAD
    PyObject *myerrno;
    PyObject *strerror;
    PyObject *filename;
    PyObject *filename2;
#ifdef MS_WINDOWS
    PyObject *winerror;
#endif
    Py_ssize_t written;   /* only for BlockingIOError, -1 otherwise */
} PyOSErrorObject;

#ifdef MS_WINDOWS
#include "errmap.h"
#endif

/* Where a function has a single filename, such as open() or some
 * of the os module functions, PyErr_SetFromErrnoWithFilename() is
 * called, giving a third argument which is the filename.  But, so
 * that old code using in-place unpacking doesn't break, e.g.:
 *
 * except OSError, (errno, strerror):
 *
 * we hack args so that it only contains two items.  This also
 * means we need our own __str__() which prints out the filename
 * when it was supplied.
 *
 * (If a function has two filenames, such as rename(), symlink(),
 * or copy(), PyErr_SetFromErrnoWithFilenameObjects() is called,
 * which allows passing in a second filename.)
 */

/* This function doesn't cleanup on error, the caller should */
static int
oserror_parse_args(PyObject **p_args,
                   PyObject **myerrno, PyObject **strerror,
                   PyObject **filename, PyObject **filename2
#ifdef MS_WINDOWS
                   , PyObject **winerror
#endif
                  )
{
    Py_ssize_t nargs;
    PyObject *args = *p_args;
#ifndef MS_WINDOWS
    /*
     * ignored on non-Windows platforms,
     * but parsed so OSError has a consistent signature
     */
    PyObject *_winerror = NULL;
    PyObject **winerror = &_winerror;
#endif /* MS_WINDOWS */

    nargs = PyTuple_GET_SIZE(args);

    if (nargs >= 2 && nargs <= 5) {
        if (!PyArg_UnpackTuple(args, "OSError", 2, 5,
                               myerrno, strerror,
                               filename, winerror, filename2))
            return -1;
#ifdef MS_WINDOWS
        if (*winerror && PyLong_Check(*winerror)) {
            long errcode, winerrcode;
            PyObject *newargs;
            Py_ssize_t i;

            winerrcode = PyLong_AsLong(*winerror);
            if (winerrcode == -1 && PyErr_Occurred())
                return -1;
            /* Set errno to the corresponding POSIX errno (overriding
               first argument).  Windows Socket error codes (>= 10000)
               have the same value as their POSIX counterparts.
            */
            if (winerrcode < 10000)
                errcode = winerror_to_errno(winerrcode);
            else
                errcode = winerrcode;
            *myerrno = PyLong_FromLong(errcode);
            if (!*myerrno)
                return -1;
            newargs = PyTuple_New(nargs);
            if (!newargs)
                return -1;
            PyTuple_SET_ITEM(newargs, 0, *myerrno);
            for (i = 1; i < nargs; i++) {
                PyObject *val = PyTuple_GET_ITEM(args, i);
                Py_INCREF(val);
                PyTuple_SET_ITEM(newargs, i, val);
            }
            Py_DECREF(args);
            args = *p_args = newargs;
        }
#endif /* MS_WINDOWS */
    }

    return 0;
}

static int
oserror_init(PyOSErrorObject *self, PyObject **p_args,
             PyObject *myerrno, PyObject *strerror,
             PyObject *filename, PyObject *filename2
#ifdef MS_WINDOWS
             , PyObject *winerror
#endif
             )
{
    PyObject *args = *p_args;
    Py_ssize_t nargs = PyTuple_GET_SIZE(args);

    /* self->filename will remain Py_None otherwise */
    if (filename && filename != Py_None) {
        if (Py_TYPE(self) == (PyTypeObject *) PyExc_BlockingIOError &&
            PyNumber_Check(filename)) {
            /* BlockingIOError's 3rd argument can be the number of
             * characters written.
             */
            self->written = PyNumber_AsSsize_t(filename, PyExc_ValueError);
            if (self->written == -1 && PyErr_Occurred())
                return -1;
        }
        else {
            Py_INCREF(filename);
            self->filename = filename;

            if (filename2 && filename2 != Py_None) {
                Py_INCREF(filename2);
                self->filename2 = filename2;
            }

            if (nargs >= 2 && nargs <= 5) {
                /* filename, filename2, and winerror are removed from the args tuple
                   (for compatibility purposes, see test_exceptions.py) */
                PyObject *subslice = PyTuple_GetSlice(args, 0, 2);
                if (!subslice)
                    return -1;

                Py_DECREF(args);  /* replacing args */
                *p_args = args = subslice;
            }
        }
    }
    Py_XINCREF(myerrno);
    self->myerrno = myerrno;

    Py_XINCREF(strerror);
    self->strerror = strerror;

#ifdef MS_WINDOWS
    Py_XINCREF(winerror);
    self->winerror = winerror;
#endif

    /* Steals the reference to args */
    Py_XSETREF(self->args, args);
    *p_args = args = NULL;

    return 0;
}

static PyObject *
OSError_new(PyTypeObject *type, PyObject *args, PyObject *kwds);
static int
OSError_init(PyOSErrorObject *self, PyObject *args, PyObject *kwds);

static int
oserror_use_init(PyTypeObject *type)
{
    /* When __init__ is defined in an OSError subclass, we want any
       extraneous argument to __new__ to be ignored.  The only reasonable
       solution, given __new__ takes a variable number of arguments,
       is to defer arg parsing and initialization to __init__.

       But when __new__ is overridden as well, it should call our __new__
       with the right arguments.

       (see http://bugs.python.org/issue12555#msg148829 )
    */
    if (type->tp_init != (initproc) OSError_init &&
        type->tp_new == (newfunc) OSError_new) {
        assert((PyObject *) type != PyExc_OSError);
        return 1;
    }
    return 0;
}

static PyObject *
OSError_new(PyTypeObject *type, PyObject *args, PyObject *kwds)
{
    PyOSErrorObject *self = NULL;
    PyObject *myerrno = NULL, *strerror = NULL;
    PyObject *filename = NULL, *filename2 = NULL;
#ifdef MS_WINDOWS
    PyObject *winerror = NULL;
#endif

    Py_INCREF(args);

    if (!oserror_use_init(type)) {
        if (!_PyArg_NoKeywords(type->tp_name, kwds))
            goto error;

        if (oserror_parse_args(&args, &myerrno, &strerror,
                               &filename, &filename2
#ifdef MS_WINDOWS
                               , &winerror
#endif
            ))
            goto error;

        if (myerrno && PyLong_Check(myerrno) &&
            errnomap && (PyObject *) type == PyExc_OSError) {
            PyObject *newtype;
            newtype = PyDict_GetItem(errnomap, myerrno);
            if (newtype) {
                assert(PyType_Check(newtype));
                type = (PyTypeObject *) newtype;
            }
            else if (PyErr_Occurred())
                goto error;
        }
    }

    self = (PyOSErrorObject *) type->tp_alloc(type, 0);
    if (!self)
        goto error;

    self->dict = NULL;
    self->traceback = self->cause = self->context = NULL;
    self->written = -1;

    if (!oserror_use_init(type)) {
        if (oserror_init(self, &args, myerrno, strerror, filename, filename2
#ifdef MS_WINDOWS
                         , winerror
#endif
            ))
            goto error;
    }
    else {
        self->args = PyTuple_New(0);
        if (self->args == NULL)
            goto error;
    }

    Py_XDECREF(args);
    return (PyObject *) self;

error:
    Py_XDECREF(args);
    Py_XDECREF(self);
    return NULL;
}

static int
OSError_init(PyOSErrorObject *self, PyObject *args, PyObject *kwds)
{
    PyObject *myerrno = NULL, *strerror = NULL;
    PyObject *filename = NULL, *filename2 = NULL;
#ifdef MS_WINDOWS
    PyObject *winerror = NULL;
#endif

    if (!oserror_use_init(Py_TYPE(self)))
        /* Everything already done in OSError_new */
        return 0;

    if (!_PyArg_NoKeywords(Py_TYPE(self)->tp_name, kwds))
        return -1;

    Py_INCREF(args);
    if (oserror_parse_args(&args, &myerrno, &strerror, &filename, &filename2
#ifdef MS_WINDOWS
                           , &winerror
#endif
        ))
        goto error;

    if (oserror_init(self, &args, myerrno, strerror, filename, filename2
#ifdef MS_WINDOWS
                     , winerror
#endif
        ))
        goto error;

    return 0;

error:
    Py_DECREF(args);
    return -1;
}

static int
OSError_clear(PyOSErrorObject *self)
{
    Py_CLEAR(self->myerrno);
    Py_CLEAR(self->strerror);
    Py_CLEAR(self->filename);
    Py_CLEAR(self->filename2);
#ifdef MS_WINDOWS
    Py_CLEAR(self->winerror);
#endif
    return BaseException_clear((PyBaseExceptionObject *)self);
}

static void
OSError_dealloc(PyOSErrorObject *self)
{
    _PyObject_GC_UNTRACK(self);
    OSError_clear(self);
    Py_TYPE(self)->tp_free((PyObject *)self);
}

static int
OSError_traverse(PyOSErrorObject *self, visitproc visit,
        void *arg)
{
    Py_VISIT(self->myerrno);
    Py_VISIT(self->strerror);
    Py_VISIT(self->filename);
    Py_VISIT(self->filename2);
#ifdef MS_WINDOWS
    Py_VISIT(self->winerror);
#endif
    return BaseException_traverse((PyBaseExceptionObject *)self, visit, arg);
}

static PyObject *
OSError_str(PyOSErrorObject *self)
{
#define OR_NONE(x) ((x)?(x):Py_None)
#ifdef MS_WINDOWS
    /* If available, winerror has the priority over myerrno */
    if (self->winerror && self->filename) {
        if (self->filename2) {
            return PyUnicode_FromFormat("[WinError %S] %S: %R -> %R",
                                        OR_NONE(self->winerror),
                                        OR_NONE(self->strerror),
                                        self->filename,
                                        self->filename2);
        } else {
            return PyUnicode_FromFormat("[WinError %S] %S: %R",
                                        OR_NONE(self->winerror),
                                        OR_NONE(self->strerror),
                                        self->filename);
        }
    }
    if (self->winerror && self->strerror)
        return PyUnicode_FromFormat("[WinError %S] %S",
                                    self->winerror ? self->winerror: Py_None,
                                    self->strerror ? self->strerror: Py_None);
#endif
    if (self->filename) {
        if (self->filename2) {
            return PyUnicode_FromFormat("[Errno %S] %S: %R -> %R",
                                        OR_NONE(self->myerrno),
                                        OR_NONE(self->strerror),
                                        self->filename,
                                        self->filename2);
        } else {
            return PyUnicode_FromFormat("[Errno %S] %S: %R",
                                        OR_NONE(self->myerrno),
                                        OR_NONE(self->strerror),
                                        self->filename);
        }
    }
    if (self->myerrno && self->strerror)
        return PyUnicode_FromFormat("[Errno %S] %S",
                                    self->myerrno, self->strerror);
    return BaseException_str((PyBaseExceptionObject *)self);
}

static PyObject *
OSError_reduce(PyOSErrorObject *self)
{
    PyObject *args = self->args;
    PyObject *res = NULL, *tmp;

    /* self->args is only the first two real arguments if there was a
     * file name given to OSError. */
    if (PyTuple_GET_SIZE(args) == 2 && self->filename) {
        Py_ssize_t size = self->filename2 ? 5 : 3;
        args = PyTuple_New(size);
        if (!args)
            return NULL;

        tmp = PyTuple_GET_ITEM(self->args, 0);
        Py_INCREF(tmp);
        PyTuple_SET_ITEM(args, 0, tmp);

        tmp = PyTuple_GET_ITEM(self->args, 1);
        Py_INCREF(tmp);
        PyTuple_SET_ITEM(args, 1, tmp);

        Py_INCREF(self->filename);
        PyTuple_SET_ITEM(args, 2, self->filename);

        if (self->filename2) {
            /*
             * This tuple is essentially used as OSError(*args).
             * So, to recreate filename2, we need to pass in
             * winerror as well.
             */
            Py_INCREF(Py_None);
            PyTuple_SET_ITEM(args, 3, Py_None);

            /* filename2 */
            Py_INCREF(self->filename2);
            PyTuple_SET_ITEM(args, 4, self->filename2);
        }
    } else
        Py_INCREF(args);

    if (self->dict)
        res = PyTuple_Pack(3, Py_TYPE(self), args, self->dict);
    else
        res = PyTuple_Pack(2, Py_TYPE(self), args);
    Py_DECREF(args);
    return res;
}

static PyObject *
OSError_written_get(PyOSErrorObject *self, void *context)
{
    if (self->written == -1) {
        PyErr_SetString(PyExc_AttributeError, "characters_written");
        return NULL;
    }
    return PyLong_FromSsize_t(self->written);
}

static int
OSError_written_set(PyOSErrorObject *self, PyObject *arg, void *context)
{
    Py_ssize_t n;
    n = PyNumber_AsSsize_t(arg, PyExc_ValueError);
    if (n == -1 && PyErr_Occurred())
        return -1;
    self->written = n;
    return 0;
}

static PyMemberDef OSError_members[] = {
    {"errno", T_OBJECT, offsetof(PyOSErrorObject, myerrno), 0,
        PyDoc_STR("POSIX exception code")},
    {"strerror", T_OBJECT, offsetof(PyOSErrorObject, strerror), 0,
        PyDoc_STR("exception strerror")},
    {"filename", T_OBJECT, offsetof(PyOSErrorObject, filename), 0,
        PyDoc_STR("exception filename")},
    {"filename2", T_OBJECT, offsetof(PyOSErrorObject, filename2), 0,
        PyDoc_STR("second exception filename")},
#ifdef MS_WINDOWS
    {"winerror", T_OBJECT, offsetof(PyOSErrorObject, winerror), 0,
        PyDoc_STR("Win32 exception code")},
#endif
    {NULL}  /* Sentinel */
};

static PyMethodDef OSError_methods[] = {
    {"__reduce__", (PyCFunction)OSError_reduce, METH_NOARGS},
    {NULL}
};

static PyGetSetDef OSError_getset[] = {
    {"characters_written", (getter) OSError_written_get,
                           (setter) OSError_written_set, NULL},
    {NULL}
};












typedef struct {
    PyException_HEAD
    PyObject *encoding;
    PyObject *object;
    Py_ssize_t start;
    Py_ssize_t end;
    PyObject *reason;
} PyUnicodeErrorObject;

/*
 *    UnicodeError extends ValueError
 */

SimpleExtendsException(PyExc_ValueError, UnicodeError,
                       "Unicode related error.");

static PyObject *
get_string(PyObject *attr, const char *name)
{
    if (!attr) {
        PyErr_Format(PyExc_TypeError, "%.200s attribute not set", name);
        return NULL;
    }

    if (!PyBytes_Check(attr)) {
        PyErr_Format(PyExc_TypeError, "%.200s attribute must be bytes", name);
        return NULL;
    }
    Py_INCREF(attr);
    return attr;
}

static PyObject *
get_unicode(PyObject *attr, const char *name)
{
    if (!attr) {
        PyErr_Format(PyExc_TypeError, "%.200s attribute not set", name);
        return NULL;
    }

    if (!PyUnicode_Check(attr)) {
        PyErr_Format(PyExc_TypeError,
                     "%.200s attribute must be unicode", name);
        return NULL;
    }
    Py_INCREF(attr);
    return attr;
}

static int
set_unicodefromstring(PyObject **attr, const char *value)
{
    PyObject *obj = PyUnicode_FromString(value);
    if (!obj)
        return -1;
    Py_XSETREF(*attr, obj);
    return 0;
}

PyObject *
PyUnicodeEncodeError_GetEncoding(PyObject *exc)
{
    return get_unicode(((PyUnicodeErrorObject *)exc)->encoding, "encoding");
}

PyObject *
PyUnicodeDecodeError_GetEncoding(PyObject *exc)
{
    return get_unicode(((PyUnicodeErrorObject *)exc)->encoding, "encoding");
}

PyObject *
PyUnicodeEncodeError_GetObject(PyObject *exc)
{
    return get_unicode(((PyUnicodeErrorObject *)exc)->object, "object");
}

PyObject *
PyUnicodeDecodeError_GetObject(PyObject *exc)
{
    return get_string(((PyUnicodeErrorObject *)exc)->object, "object");
}

PyObject *
PyUnicodeTranslateError_GetObject(PyObject *exc)
{
    return get_unicode(((PyUnicodeErrorObject *)exc)->object, "object");
}

int
PyUnicodeEncodeError_GetStart(PyObject *exc, Py_ssize_t *start)
{
    Py_ssize_t size;
    PyObject *obj = get_unicode(((PyUnicodeErrorObject *)exc)->object,
                                "object");
    if (!obj)
        return -1;
    *start = ((PyUnicodeErrorObject *)exc)->start;
    size = PyUnicode_GET_LENGTH(obj);
    if (*start<0)
        *start = 0; /*XXX check for values <0*/
    if (*start>=size)
        *start = size-1;
    Py_DECREF(obj);
    return 0;
}


int
PyUnicodeDecodeError_GetStart(PyObject *exc, Py_ssize_t *start)
{
    Py_ssize_t size;
    PyObject *obj = get_string(((PyUnicodeErrorObject *)exc)->object, "object");
    if (!obj)
        return -1;
    size = PyBytes_GET_SIZE(obj);
    *start = ((PyUnicodeErrorObject *)exc)->start;
    if (*start<0)
        *start = 0;
    if (*start>=size)
        *start = size-1;
    Py_DECREF(obj);
    return 0;
}


int
PyUnicodeTranslateError_GetStart(PyObject *exc, Py_ssize_t *start)
{
    return PyUnicodeEncodeError_GetStart(exc, start);
}


int
PyUnicodeEncodeError_SetStart(PyObject *exc, Py_ssize_t start)
{
    ((PyUnicodeErrorObject *)exc)->start = start;
    return 0;
}


int
PyUnicodeDecodeError_SetStart(PyObject *exc, Py_ssize_t start)
{
    ((PyUnicodeErrorObject *)exc)->start = start;
    return 0;
}


int
PyUnicodeTranslateError_SetStart(PyObject *exc, Py_ssize_t start)
{
    ((PyUnicodeErrorObject *)exc)->start = start;
    return 0;
}


int
PyUnicodeEncodeError_GetEnd(PyObject *exc, Py_ssize_t *end)
{
    Py_ssize_t size;
    PyObject *obj = get_unicode(((PyUnicodeErrorObject *)exc)->object,
                                "object");
    if (!obj)
        return -1;
    *end = ((PyUnicodeErrorObject *)exc)->end;
    size = PyUnicode_GET_LENGTH(obj);
    if (*end<1)
        *end = 1;
    if (*end>size)
        *end = size;
    Py_DECREF(obj);
    return 0;
}


int
PyUnicodeDecodeError_GetEnd(PyObject *exc, Py_ssize_t *end)
{
    Py_ssize_t size;
    PyObject *obj = get_string(((PyUnicodeErrorObject *)exc)->object, "object");
    if (!obj)
        return -1;
    size = PyBytes_GET_SIZE(obj);
    *end = ((PyUnicodeErrorObject *)exc)->end;
    if (*end<1)
        *end = 1;
    if (*end>size)
        *end = size;
    Py_DECREF(obj);
    return 0;
}


int
PyUnicodeTranslateError_GetEnd(PyObject *exc, Py_ssize_t *start)
{
    return PyUnicodeEncodeError_GetEnd(exc, start);
}


int
PyUnicodeEncodeError_SetEnd(PyObject *exc, Py_ssize_t end)
{
    ((PyUnicodeErrorObject *)exc)->end = end;
    return 0;
}


int
PyUnicodeDecodeError_SetEnd(PyObject *exc, Py_ssize_t end)
{
    ((PyUnicodeErrorObject *)exc)->end = end;
    return 0;
}


int
PyUnicodeTranslateError_SetEnd(PyObject *exc, Py_ssize_t end)
{
    ((PyUnicodeErrorObject *)exc)->end = end;
    return 0;
}

PyObject *
PyUnicodeEncodeError_GetReason(PyObject *exc)
{
    return get_unicode(((PyUnicodeErrorObject *)exc)->reason, "reason");
}


PyObject *
PyUnicodeDecodeError_GetReason(PyObject *exc)
{
    return get_unicode(((PyUnicodeErrorObject *)exc)->reason, "reason");
}


PyObject *
PyUnicodeTranslateError_GetReason(PyObject *exc)
{
    return get_unicode(((PyUnicodeErrorObject *)exc)->reason, "reason");
}


int
PyUnicodeEncodeError_SetReason(PyObject *exc, const char *reason)
{
    return set_unicodefromstring(&((PyUnicodeErrorObject *)exc)->reason,
                                 reason);
}


int
PyUnicodeDecodeError_SetReason(PyObject *exc, const char *reason)
{
    return set_unicodefromstring(&((PyUnicodeErrorObject *)exc)->reason,
                                 reason);
}


int
PyUnicodeTranslateError_SetReason(PyObject *exc, const char *reason)
{
    return set_unicodefromstring(&((PyUnicodeErrorObject *)exc)->reason,
                                 reason);
}


static int
UnicodeError_clear(PyUnicodeErrorObject *self)
{
    Py_CLEAR(self->encoding);
    Py_CLEAR(self->object);
    Py_CLEAR(self->reason);
    return BaseException_clear((PyBaseExceptionObject *)self);
}

static void
UnicodeError_dealloc(PyUnicodeErrorObject *self)
{
    _PyObject_GC_UNTRACK(self);
    UnicodeError_clear(self);
    Py_TYPE(self)->tp_free((PyObject *)self);
}

static int
UnicodeError_traverse(PyUnicodeErrorObject *self, visitproc visit, void *arg)
{
    Py_VISIT(self->encoding);
    Py_VISIT(self->object);
    Py_VISIT(self->reason);
    return BaseException_traverse((PyBaseExceptionObject *)self, visit, arg);
}

static PyMemberDef UnicodeError_members[] = {
    {"encoding", T_OBJECT, offsetof(PyUnicodeErrorObject, encoding), 0,
        PyDoc_STR("exception encoding")},
    {"object", T_OBJECT, offsetof(PyUnicodeErrorObject, object), 0,
        PyDoc_STR("exception object")},
    {"start", T_PYSSIZET, offsetof(PyUnicodeErrorObject, start), 0,
        PyDoc_STR("exception start")},
    {"end", T_PYSSIZET, offsetof(PyUnicodeErrorObject, end), 0,
        PyDoc_STR("exception end")},
    {"reason", T_OBJECT, offsetof(PyUnicodeErrorObject, reason), 0,
        PyDoc_STR("exception reason")},
    {NULL}  /* Sentinel */
};


/*
 *    UnicodeEncodeError extends UnicodeError
 */

static int
UnicodeEncodeError_init(PyObject *self, PyObject *args, PyObject *kwds)
{
    PyUnicodeErrorObject *err;

    if (BaseException_init((PyBaseExceptionObject *)self, args, kwds) == -1)
        return -1;

    err = (PyUnicodeErrorObject *)self;

    Py_CLEAR(err->encoding);
    Py_CLEAR(err->object);
    Py_CLEAR(err->reason);

    if (!PyArg_ParseTuple(args, "UUnnU",
                          &err->encoding, &err->object,
                          &err->start, &err->end, &err->reason)) {
        err->encoding = err->object = err->reason = NULL;
        return -1;
    }

    Py_INCREF(err->encoding);
    Py_INCREF(err->object);
    Py_INCREF(err->reason);

    return 0;
}

static PyObject *
UnicodeEncodeError_str(PyObject *self)
{
    PyUnicodeErrorObject *uself = (PyUnicodeErrorObject *)self;
    PyObject *result = NULL;
    PyObject *reason_str = NULL;
    PyObject *encoding_str = NULL;

    if (!uself->object)
        /* Not properly initialized. */
        return PyUnicode_FromString("");

    /* Get reason and encoding as strings, which they might not be if
       they've been modified after we were constructed. */
    reason_str = PyObject_Str(uself->reason);
    if (reason_str == NULL)
        goto done;
    encoding_str = PyObject_Str(uself->encoding);
    if (encoding_str == NULL)
        goto done;

    if (uself->start < PyUnicode_GET_LENGTH(uself->object) && uself->end == uself->start+1) {
        Py_UCS4 badchar = PyUnicode_ReadChar(uself->object, uself->start);
        const char *fmt;
        if (badchar <= 0xff)
            fmt = "'%U' codec can't encode character '\\x%02x' in position %zd: %U";
        else if (badchar <= 0xffff)
            fmt = "'%U' codec can't encode character '\\u%04x' in position %zd: %U";
        else
            fmt = "'%U' codec can't encode character '\\U%08x' in position %zd: %U";
        result = PyUnicode_FromFormat(
            fmt,
            encoding_str,
            (int)badchar,
            uself->start,
            reason_str);
    }
    else {
        result = PyUnicode_FromFormat(
            "'%U' codec can't encode characters in position %zd-%zd: %U",
            encoding_str,
            uself->start,
            uself->end-1,
            reason_str);
    }
done:
    Py_XDECREF(reason_str);
    Py_XDECREF(encoding_str);
    return result;
}

static PyTypeObject _PyExc_UnicodeEncodeError = {
    PyVarObject_HEAD_INIT(NULL, 0)
    "UnicodeEncodeError",
    sizeof(PyUnicodeErrorObject), 0,
    (destructor)UnicodeError_dealloc, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    (reprfunc)UnicodeEncodeError_str, 0, 0, 0,
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC,
    PyDoc_STR("Unicode encoding error."), (traverseproc)UnicodeError_traverse,
    (inquiry)UnicodeError_clear, 0, 0, 0, 0, 0, UnicodeError_members,
    0, &_PyExc_UnicodeError, 0, 0, 0, offsetof(PyUnicodeErrorObject, dict),
    (initproc)UnicodeEncodeError_init, 0, BaseException_new,
};
PyObject *PyExc_UnicodeEncodeError = (PyObject *)&_PyExc_UnicodeEncodeError;

PyObject *
PyUnicodeEncodeError_Create(
    const char *encoding, const Py_UNICODE *object, Py_ssize_t length,
    Py_ssize_t start, Py_ssize_t end, const char *reason)
{
    return PyObject_CallFunction(PyExc_UnicodeEncodeError, "su#nns",
                                 encoding, object, length, start, end, reason);
}


/*
 *    UnicodeDecodeError extends UnicodeError
 */

static int
UnicodeDecodeError_init(PyObject *self, PyObject *args, PyObject *kwds)
{
    PyUnicodeErrorObject *ude;

    if (BaseException_init((PyBaseExceptionObject *)self, args, kwds) == -1)
        return -1;

    ude = (PyUnicodeErrorObject *)self;

    Py_CLEAR(ude->encoding);
    Py_CLEAR(ude->object);
    Py_CLEAR(ude->reason);

    if (!PyArg_ParseTuple(args, "UOnnU",
                          &ude->encoding, &ude->object,
                          &ude->start, &ude->end, &ude->reason)) {
             ude->encoding = ude->object = ude->reason = NULL;
             return -1;
    }

    Py_INCREF(ude->encoding);
    Py_INCREF(ude->object);
    Py_INCREF(ude->reason);

    if (!PyBytes_Check(ude->object)) {
        Py_buffer view;
        if (PyObject_GetBuffer(ude->object, &view, PyBUF_SIMPLE) != 0)
            goto error;
        Py_XSETREF(ude->object, PyBytes_FromStringAndSize(view.buf, view.len));
        PyBuffer_Release(&view);
        if (!ude->object)
            goto error;
    }
    return 0;

error:
    Py_CLEAR(ude->encoding);
    Py_CLEAR(ude->object);
    Py_CLEAR(ude->reason);
    return -1;
}

static PyObject *
UnicodeDecodeError_str(PyObject *self)
{
    PyUnicodeErrorObject *uself = (PyUnicodeErrorObject *)self;
    PyObject *result = NULL;
    PyObject *reason_str = NULL;
    PyObject *encoding_str = NULL;

    if (!uself->object)
        /* Not properly initialized. */
        return PyUnicode_FromString("");

    /* Get reason and encoding as strings, which they might not be if
       they've been modified after we were constructed. */
    reason_str = PyObject_Str(uself->reason);
    if (reason_str == NULL)
        goto done;
    encoding_str = PyObject_Str(uself->encoding);
    if (encoding_str == NULL)
        goto done;

    if (uself->start < PyBytes_GET_SIZE(uself->object) && uself->end == uself->start+1) {
        int byte = (int)(PyBytes_AS_STRING(((PyUnicodeErrorObject *)self)->object)[uself->start]&0xff);
        result = PyUnicode_FromFormat(
            "'%U' codec can't decode byte 0x%02x in position %zd: %U",
            encoding_str,
            byte,
            uself->start,
            reason_str);
    }
    else {
        result = PyUnicode_FromFormat(
            "'%U' codec can't decode bytes in position %zd-%zd: %U",
            encoding_str,
            uself->start,
            uself->end-1,
            reason_str
            );
    }
done:
    Py_XDECREF(reason_str);
    Py_XDECREF(encoding_str);
    return result;
}

static PyTypeObject _PyExc_UnicodeDecodeError = {
    PyVarObject_HEAD_INIT(NULL, 0)
    "UnicodeDecodeError",
    sizeof(PyUnicodeErrorObject), 0,
    (destructor)UnicodeError_dealloc, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    (reprfunc)UnicodeDecodeError_str, 0, 0, 0,
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC,
    PyDoc_STR("Unicode decoding error."), (traverseproc)UnicodeError_traverse,
    (inquiry)UnicodeError_clear, 0, 0, 0, 0, 0, UnicodeError_members,
    0, &_PyExc_UnicodeError, 0, 0, 0, offsetof(PyUnicodeErrorObject, dict),
    (initproc)UnicodeDecodeError_init, 0, BaseException_new,
};
PyObject *PyExc_UnicodeDecodeError = (PyObject *)&_PyExc_UnicodeDecodeError;

PyObject *
PyUnicodeDecodeError_Create(
    const char *encoding, const char *object, Py_ssize_t length,
    Py_ssize_t start, Py_ssize_t end, const char *reason)
{
    return PyObject_CallFunction(PyExc_UnicodeDecodeError, "sy#nns",
                                 encoding, object, length, start, end, reason);
}


/*
 *    UnicodeTranslateError extends UnicodeError
 */

static int
UnicodeTranslateError_init(PyUnicodeErrorObject *self, PyObject *args,
                           PyObject *kwds)
{
    if (BaseException_init((PyBaseExceptionObject *)self, args, kwds) == -1)
        return -1;

    Py_CLEAR(self->object);
    Py_CLEAR(self->reason);

    if (!PyArg_ParseTuple(args, "UnnU",
                          &self->object,
                          &self->start, &self->end, &self->reason)) {
        self->object = self->reason = NULL;
        return -1;
    }

    Py_INCREF(self->object);
    Py_INCREF(self->reason);

    return 0;
}


static PyObject *
UnicodeTranslateError_str(PyObject *self)
{
    PyUnicodeErrorObject *uself = (PyUnicodeErrorObject *)self;
    PyObject *result = NULL;
    PyObject *reason_str = NULL;

    if (!uself->object)
        /* Not properly initialized. */
        return PyUnicode_FromString("");

    /* Get reason as a string, which it might not be if it's been
       modified after we were constructed. */
    reason_str = PyObject_Str(uself->reason);
    if (reason_str == NULL)
        goto done;

    if (uself->start < PyUnicode_GET_LENGTH(uself->object) && uself->end == uself->start+1) {
        Py_UCS4 badchar = PyUnicode_ReadChar(uself->object, uself->start);
        const char *fmt;
        if (badchar <= 0xff)
            fmt = "can't translate character '\\x%02x' in position %zd: %U";
        else if (badchar <= 0xffff)
            fmt = "can't translate character '\\u%04x' in position %zd: %U";
        else
            fmt = "can't translate character '\\U%08x' in position %zd: %U";
        result = PyUnicode_FromFormat(
            fmt,
            (int)badchar,
            uself->start,
            reason_str
        );
    } else {
        result = PyUnicode_FromFormat(
            "can't translate characters in position %zd-%zd: %U",
            uself->start,
            uself->end-1,
            reason_str
            );
    }
done:
    Py_XDECREF(reason_str);
    return result;
}

static PyTypeObject _PyExc_UnicodeTranslateError = {
    PyVarObject_HEAD_INIT(NULL, 0)
    "UnicodeTranslateError",
    sizeof(PyUnicodeErrorObject), 0,
    (destructor)UnicodeError_dealloc, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    (reprfunc)UnicodeTranslateError_str, 0, 0, 0,
    Py_TPFLAGS_DEFAULT | Py_TPFLAGS_BASETYPE | Py_TPFLAGS_HAVE_GC,
    PyDoc_STR("Unicode translation error."), (traverseproc)UnicodeError_traverse,
    (inquiry)UnicodeError_clear, 0, 0, 0, 0, 0, UnicodeError_members,
    0, &_PyExc_UnicodeError, 0, 0, 0, offsetof(PyUnicodeErrorObject, dict),
    (initproc)UnicodeTranslateError_init, 0, BaseException_new,
};
PyObject *PyExc_UnicodeTranslateError = (PyObject *)&_PyExc_UnicodeTranslateError;

/* Deprecated. */
PyObject *
PyUnicodeTranslateError_Create(
    const Py_UNICODE *object, Py_ssize_t length,
    Py_ssize_t start, Py_ssize_t end, const char *reason)
{
    return PyObject_CallFunction(PyExc_UnicodeTranslateError, "u#nns",
                                 object, length, start, end, reason);
}

PyObject *
_PyUnicodeTranslateError_Create(
    PyObject *object,
    Py_ssize_t start, Py_ssize_t end, const char *reason)
{
    return PyObject_CallFunction(PyExc_UnicodeTranslateError, "Onns",
                                 object, start, end, reason);
}
